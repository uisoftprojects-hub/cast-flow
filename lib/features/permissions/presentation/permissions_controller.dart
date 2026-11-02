import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/app_providers.dart';
import '../domain/app_permission.dart';

class FakePermissionService implements PermissionService {
  FakePermissionService(this._mode);

  final PreviewMode Function() _mode;

  @override
  Future<PermissionStatus> request(AppPermission permission) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    return _mode() == PreviewMode.error ? PermissionStatus.denied : PermissionStatus.granted;
  }
}

final permissionServiceProvider = Provider<PermissionService>(
  (ref) => FakePermissionService(() => ref.read(previewModeProvider)),
);

class PermissionsController extends Notifier<Map<AppPermission, PermissionStatus>> {
  @override
  Map<AppPermission, PermissionStatus> build() => {
        for (final p in AppPermission.values) p: PermissionStatus.notRequested,
      };

  Future<void> request(AppPermission p) async {
    state = {...state, p: PermissionStatus.requesting};
    final result = await ref.read(permissionServiceProvider).request(p);
    state = {...state, p: result};
  }

  Future<void> requestAll() async {
    for (final p in AppPermission.values) {
      if (state[p] != PermissionStatus.granted) await request(p);
    }
  }
}

final permissionsProvider =
    NotifierProvider<PermissionsController, Map<AppPermission, PermissionStatus>>(PermissionsController.new);
