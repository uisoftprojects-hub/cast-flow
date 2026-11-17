import 'cast_device.dart';

/// Commands the TV remote can send.
enum RemoteCommand {
  up('Up'),
  down('Down'),
  left('Left'),
  right('Right'),
  ok('OK'),
  back('Back'),
  home('Home'),
  menu('Menu'),
  input('Input'),
  playPause('Play / Pause'),
  previous('Previous'),
  next('Next'),
  rewind('Rewind'),
  fastForward('Forward'),
  volumeUp('Volume up'),
  volumeDown('Volume down'),
  mute('Mute'),
  channelUp('Channel up'),
  channelDown('Channel down');

  const RemoteCommand(this.label);
  final String label;

  static const navigation = {up, down, left, right, ok};
  static const playback = {playPause, previous, next, rewind, fastForward};
  static const sound = {volumeUp, volumeDown, mute};
  static const channel = {channelUp, channelDown};

  /// Keys that only a TV's own key protocol can send (not DLNA or Cast).
  static const keys = {...navigation, back, home, menu, input, ...channel};
}

/// Which remote commands each receiver protocol actually exposes. Unsupported
/// commands are disabled in the UI instead of pretending to work.
///
/// - Google Cast: media session + volume only, no key events.
/// - DLNA/UPnP: AVTransport (play/seek/next) + RenderingControl (volume).
/// - Roku ECP: full key set (Input only on Roku TVs).
/// - Fire TV / smart TVs (Tizen, webOS, Android TV): full key set.
/// - Miracast: a display sink with no control channel.
const receiverCapabilities = <DeviceType, Set<RemoteCommand>>{
  // No key channel implemented for these, so the remote does not pretend.
  DeviceType.chromecast: {},
  DeviceType.dlna: {},
  DeviceType.fireTv: {},
  DeviceType.roku: {
    ...RemoteCommand.navigation,
    RemoteCommand.back,
    RemoteCommand.home,
    RemoteCommand.menu,
    RemoteCommand.input,
    ...RemoteCommand.playback,
    ...RemoteCommand.sound,
    ...RemoteCommand.channel,
  },
  // Android TV (paired) and Samsung (paired) have the full key set.
  DeviceType.smartTv: {...RemoteCommand.values},
  DeviceType.miracast: {},
};

/// Commands each detected protocol really sends (see NetworkRemoteService).
/// Decided by the protocol the TV answered, so an unlisted brand gets exactly
/// what its TV supports.
const protocolCapabilities = <RemoteProtocol, Set<RemoteCommand>>{
  RemoteProtocol.roku: {
    ...RemoteCommand.navigation,
    RemoteCommand.back,
    RemoteCommand.home,
    RemoteCommand.menu,
    RemoteCommand.input,
    ...RemoteCommand.playback,
    ...RemoteCommand.sound,
    ...RemoteCommand.channel,
  },
  RemoteProtocol.androidTv: {...RemoteCommand.values},
  RemoteProtocol.samsung: {...RemoteCommand.values},
  // LG: arrows/OK/Back/Home/Menu/Mute via the pointer socket, volume and
  // seek via ssap:// requests. No input switch or track skip.
  RemoteProtocol.lg: {
    ...RemoteCommand.navigation,
    RemoteCommand.back,
    RemoteCommand.home,
    RemoteCommand.menu,
    RemoteCommand.rewind,
    RemoteCommand.fastForward,
    ...RemoteCommand.sound,
    ...RemoteCommand.channel,
  },
  // DLNA: AVTransport (play/pause, next/previous, ±10 s seek) and
  // RenderingControl (volume, mute). No navigation keys exist in DLNA.
  RemoteProtocol.dlna: {
    RemoteCommand.playPause,
    RemoteCommand.previous,
    RemoteCommand.next,
    RemoteCommand.rewind,
    RemoteCommand.fastForward,
    ...RemoteCommand.sound,
  },
};

extension DeviceCapabilities on CastDevice {
  /// A probed device is judged by its protocol; an unprobed one (saved before
  /// probing existed, tests) falls back to its type.
  Set<RemoteCommand> get capabilities {
    if (protocol == null) return receiverCapabilities[type] ?? const {};
    final base = protocolCapabilities[protocol]!;
    // A smart TV that showed only DLNA/Cast (its Android TV remote service was
    // off when it was probed) may still take every key through that service when
    // it is on, so all buttons are offered and the key ones are tried on demand
    // (with a clear message when the service is off).
    if (protocol == RemoteProtocol.dlna && type == DeviceType.smartTv) return {...RemoteCommand.values};
    return base;
  }
  bool supports(RemoteCommand c) => capabilities.contains(c);

  /// The probed protocol, or a best guess from type/port for devices that were
  /// never probed (old saved devices).
  RemoteProtocol? get effectiveProtocol {
    if (protocol != null) return protocol;
    if (type == DeviceType.roku) return RemoteProtocol.roku;
    if (type != DeviceType.smartTv) return null;
    final m = (model ?? '').toLowerCase();
    if (port == 6466) return RemoteProtocol.androidTv;
    if (port == 8001 || port == 8002 || m.contains('samsung')) return RemoteProtocol.samsung;
    if (port == 3000 || port == 3001 || m.startsWith('lg')) return RemoteProtocol.lg;
    return null;
  }
}
