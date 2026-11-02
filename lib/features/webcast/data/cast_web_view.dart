import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Events from the native browser view (see CastWebView.kt).
abstract interface class CastWebListener {
  void onNavigated(String url, int token, {required bool canGoBack, required bool canGoForward});
  void onHistory({required bool canGoBack, required bool canGoForward});
  void onProgress(int value);
  void onTitle(String title, int token);
  void onFinished(String url, String title, int token);

  /// A media request seen by shouldInterceptRequest.
  void onResource(String url, Map<String, String> headers, int token, {required bool probe});

  /// A <video>/<source> reported by the injected script.
  void onDom(Map<String, Object?> report, int token);
  void onDrm(int token);
}

/// Drives one native WebView instance.
class CastWebController {
  CastWebController(this.listener);

  final CastWebListener listener;
  MethodChannel? _channel;
  String? _pending;

  bool get isAttached => _channel != null;

  void _attach(int id) {
    _channel = MethodChannel('castflow/webview_$id')..setMethodCallHandler(_handle);
    if (_pending != null) loadUrl(_pending!);
    _pending = null;
  }

  void _detach() {
    _channel?.setMethodCallHandler(null);
    _channel = null;
  }

  Future<void> _invoke(String method, [Map<String, Object?>? args]) async {
    try {
      await _channel?.invokeMethod<void>(method, args);
    } on PlatformException catch (e) {
      debugPrint('webview $method failed: $e');
    } on MissingPluginException {
      // View already disposed.
    }
  }

  Future<void> loadUrl(String url) async {
    if (_channel == null) {
      _pending = url;
      return;
    }
    await _invoke('loadUrl', {'url': url});
  }

  Future<void> back() => _invoke('back');
  Future<void> forward() => _invoke('forward');
  Future<void> reload() => _invoke('reload');
  Future<void> pauseVideos() => _invoke('pauseVideos');
  Future<void> rescan() => _invoke('rescan');

  Future<Object?> _handle(MethodCall call) async {
    final a = (call.arguments as Map?)?.cast<String, Object?>() ?? const {};
    final token = (a['token'] as int?) ?? -1;
    switch (call.method) {
      case 'navigated':
        listener.onNavigated(
          a['url'] as String,
          token,
          canGoBack: a['canGoBack'] == true,
          canGoForward: a['canGoForward'] == true,
        );
      case 'history':
        listener.onHistory(canGoBack: a['canGoBack'] == true, canGoForward: a['canGoForward'] == true);
      case 'progress':
        listener.onProgress((a['value'] as int?) ?? 100);
      case 'title':
        listener.onTitle((a['title'] as String?) ?? '', token);
      case 'finished':
        listener.onFinished(a['url'] as String, (a['title'] as String?) ?? '', token);
      case 'resource':
        listener.onResource(a['url'] as String, _headers(a['headers']), token, probe: a['probe'] == true);
      case 'dom':
        listener.onDom({...a, 'headers': _headers(a['headers'])}, token);
      case 'drm':
        listener.onDrm(token);
    }
    return null;
  }

  static Map<String, String> _headers(Object? raw) =>
      raw is Map ? {for (final e in raw.entries) '${e.key}': '${e.value}'} : const {};
}

/// The native Android WebView embedded in Flutter.
class CastWebView extends StatefulWidget {
  const CastWebView({super.key, required this.controller, required this.initialUrl});

  final CastWebController controller;
  final String initialUrl;

  static bool get supported => !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  @override
  State<CastWebView> createState() => _CastWebViewState();
}

class _CastWebViewState extends State<CastWebView> {
  @override
  void dispose() {
    widget.controller._detach();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AndroidView(
      viewType: 'castflow/webview',
      creationParams: {'url': widget.initialUrl},
      creationParamsCodec: const StandardMessageCodec(),
      onPlatformViewCreated: widget.controller._attach,
      // Let the page scroll, pinch and swipe itself.
      gestureRecognizers: {Factory<EagerGestureRecognizer>(EagerGestureRecognizer.new)},
    );
  }
}
