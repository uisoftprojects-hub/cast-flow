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
  mute('Mute');

  const RemoteCommand(this.label);
  final String label;

  static const navigation = {up, down, left, right, ok};
  static const playback = {playPause, previous, next, rewind, fastForward};
  static const sound = {volumeUp, volumeDown, mute};
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
  },
  // Android TV (paired) and Samsung (paired) have the full key set.
  DeviceType.smartTv: {...RemoteCommand.values},
  DeviceType.miracast: {},
};

extension DeviceCapabilities on CastDevice {
  Set<RemoteCommand> get capabilities => receiverCapabilities[type] ?? const {};
  bool supports(RemoteCommand c) => capabilities.contains(c);
}
