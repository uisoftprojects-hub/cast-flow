// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get networkRequiredTitle => 'Tidak terhubung ke Wi-Fi';

  @override
  String get networkRequiredMessage =>
      'Ponsel dan TV harus berada di jaringan Wi-Fi yang sama untuk melakukan cast.';

  @override
  String get openWifiSettings => 'Buka pengaturan Wi-Fi';

  @override
  String get useMobileHotspot => 'Gunakan hotspot seluler';

  @override
  String get hotspotInstruction =>
      'Hubungkan TV ke hotspot seluler ponsel Anda.';

  @override
  String get hotspotStep1 => 'Aktifkan hotspot seluler';

  @override
  String get hotspotStep2 => 'Hubungkan TV Anda ke hotspot';

  @override
  String get hotspotStep3 => 'Kembali ke aplikasi';

  @override
  String get openHotspotSettings => 'Buka pengaturan hotspot';

  @override
  String get hotspotAutoCheck =>
      'Kami akan memeriksa lagi secara otomatis saat Anda kembali.';

  @override
  String get hotspotDetected => 'Hotspot aktif. Mencari TV Anda…';

  @override
  String get searchingDevices => 'Mencari perangkat di sekitar...';

  @override
  String get waitingForTvOnHotspot => 'Menunggu TV Anda bergabung ke hotspot…';

  @override
  String get usingHotspot => 'Menggunakan hotspot seluler Anda';

  @override
  String devicesFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count perangkat ditemukan',
      one: '1 perangkat ditemukan',
    );
    return '$_temp0';
  }

  @override
  String get retry => 'Coba lagi';

  @override
  String get scanAgain => 'Pindai lagi';

  @override
  String get isolationTitle => 'TV tidak merespons';

  @override
  String get isolationHint =>
      'Sebuah perangkat bergabung ke hotspot Anda tetapi tidak merespons. Hotspot mungkin memblokir lalu lintas antarperangkat (isolasi klien). Matikan di pengaturan hotspot atau gunakan jaringan Wi-Fi.';

  @override
  String get connecting => 'Menghubungkan…';

  @override
  String get connected => 'Terhubung';

  @override
  String get connectionFailed => 'Tidak dapat terhubung';

  @override
  String get connectFailedHint =>
      'Pastikan ponsel dan TV berada di jaringan yang sama, lalu coba lagi.';

  @override
  String get hotspotConnectHint =>
      'Hotspot Anda mungkin memblokir lalu lintas antarperangkat. Periksa pengaturan isolasi klien.';

  @override
  String get networkLostTitle => 'Koneksi jaringan terputus';

  @override
  String get networkLostMessage =>
      'Sambungkan lagi ke Wi-Fi atau hotspot, lalu hubungkan kembali ke TV.';

  @override
  String get reconnect => 'Hubungkan ulang';

  @override
  String reconnectTo(String name) {
    return 'Hubungkan ulang ke $name';
  }

  @override
  String get tapToReconnect => 'Ketuk untuk menghubungkan ulang';

  @override
  String get pairingRequired => 'Pemasangan diperlukan';

  @override
  String get pairingEnterCode => 'Masukkan kode yang ditampilkan di TV Anda.';

  @override
  String get pairingApproveOnTv =>
      'Lihat TV Anda dan ketuk Izinkan untuk melanjutkan.';

  @override
  String get connect => 'Hubungkan';

  @override
  String get cancel => 'Batal';

  @override
  String get pairingIncorrectCode => 'Kode salah. Coba lagi.';

  @override
  String get pairingTimedOut => 'Waktu pemasangan habis';

  @override
  String get tryAgain => 'Coba lagi';

  @override
  String get pairingDeclined => 'TV menolak koneksi';

  @override
  String pairingTooManyAttempts(int seconds) {
    return 'Terlalu banyak kode salah. Tunggu $seconds dtk, lalu minta kode baru.';
  }

  @override
  String get pairingCooldownOver => 'Anda bisa meminta kode baru sekarang.';

  @override
  String get pairingRequestNewCode => 'Minta kode baru';

  @override
  String get pairingNetworkLost =>
      'Jaringan terputus saat pemasangan. Sambungkan lagi ke Wi-Fi dan coba lagi.';

  @override
  String get pairingFailed => 'Tidak dapat memasangkan dengan TV.';

  @override
  String pairingCodeField(int length) {
    return 'Kode pemasangan, $length karakter';
  }

  @override
  String pairingCodeBox(int index, int total) {
    return 'Kotak kode $index dari $total';
  }

  @override
  String get pairingEmptyBox => 'kosong';

  @override
  String get pairingPaired => 'Terpasang';

  @override
  String get forgetDevice => 'Lupakan perangkat';

  @override
  String forgetDeviceMessage(String name) {
    return '$name harus dipasangkan lagi lain kali.';
  }

  @override
  String get forget => 'Lupakan';

  @override
  String get castVideo => 'Cast video';

  @override
  String castVideoCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count video ditemukan. Cast video',
      one: '1 video ditemukan. Cast video',
    );
    return '$_temp0';
  }

  @override
  String get noVideoYet => 'Belum ada video di halaman ini.';

  @override
  String get videoFound => 'Video ditemukan';

  @override
  String get videoFoundMessage => 'Putar di TV Anda.';

  @override
  String get castAction => 'Cast';

  @override
  String get dismiss => 'Tutup';

  @override
  String videosFound(int count) {
    return 'Video ditemukan ($count)';
  }

  @override
  String get castToTv => 'Cast ke TV';

  @override
  String get protectedVideo => 'Dilindungi, tidak bisa di-cast';

  @override
  String get videoThumbnail => 'Gambar mini video';

  @override
  String castingTo(String device) {
    return 'Cast ke $device';
  }

  @override
  String get stopCasting => 'Hentikan cast';

  @override
  String get play => 'Putar';

  @override
  String get pause => 'Jeda';

  @override
  String get volume => 'Volume';

  @override
  String get seekPosition => 'Posisi pemutaran';

  @override
  String get showControls => 'Tampilkan kontrol';

  @override
  String get hideControls => 'Sembunyikan kontrol';

  @override
  String get formatUnsupportedTitle => 'Format tidak didukung';

  @override
  String formatUnsupported(String device, String format) {
    return '$device tidak dapat memutar video $format. Coba video lain di halaman ini atau gunakan cermin layar.';
  }

  @override
  String get videoExpired =>
      'Tautan video ini kedaluwarsa. Muat ulang halaman dan coba lagi.';

  @override
  String get refreshingVideo => 'Mengambil tautan video baru…';

  @override
  String get browserBack => 'Kembali';

  @override
  String get browserForward => 'Maju';

  @override
  String get browserStartPage => 'Halaman awal';

  @override
  String get browserReload => 'Muat ulang';

  @override
  String get ok => 'OK';

  @override
  String get home => 'Beranda';

  @override
  String get devices => 'Perangkat';

  @override
  String get history => 'Riwayat';

  @override
  String get settings => 'Pengaturan';

  @override
  String get goodMorning => 'Selamat pagi';

  @override
  String get goodAfternoon => 'Selamat siang';

  @override
  String get goodEvening => 'Selamat malam';

  @override
  String get couldntOpenTheLink => 'Tidak dapat membuka tautan.';

  @override
  String get castflowLogo => 'Logo CastFlow';

  @override
  String get somethingWentWrong => 'Terjadi kesalahan';

  @override
  String get weCouldntLoadThis =>
      'Tidak dapat memuat ini sekarang. Silakan coba lagi.';

  @override
  String get apps => 'Aplikasi';

  @override
  String open(Object name) {
    return 'Buka $name';
  }

  @override
  String get smartTv => 'Smart TV';

  @override
  String get chromecast => 'Chromecast';

  @override
  String get fireTv => 'Fire TV';

  @override
  String get roku => 'Roku';

  @override
  String get dlnaRenderer => 'DLNA renderer';

  @override
  String get miracast => 'Miracast';

  @override
  String get up => 'Atas';

  @override
  String get down => 'Bawah';

  @override
  String get left => 'Kiri';

  @override
  String get right => 'Kanan';

  @override
  String get menu => 'Menu';

  @override
  String get input => 'Input';

  @override
  String get playPause => 'Putar / Jeda';

  @override
  String get previous => 'Sebelumnya';

  @override
  String get next => 'Berikutnya';

  @override
  String get rewind => 'Mundur';

  @override
  String get volumeUp => 'Volume naik';

  @override
  String get volumeDown => 'Volume turun';

  @override
  String get mute => 'Bisu';

  @override
  String connectedTo(Object name) {
    return 'Terhubung ke $name';
  }

  @override
  String get chooseADevice => 'Pilih perangkat';

  @override
  String get connectionGuide => 'Panduan koneksi';

  @override
  String get lookingForTvsOn => 'Mencari TV di Wi-Fi Anda';

  @override
  String foundSoFar(Object found) {
    return '$found ditemukan sejauh ini';
  }

  @override
  String deviceFound(Object found, Object value) {
    return '$found perangkat ditemukan';
  }

  @override
  String get disconnect => 'Putuskan';

  @override
  String signalOf4(Object level) {
    return 'Sinyal $level dari 4';
  }

  @override
  String get connecting2 => 'Menghubungkan';

  @override
  String get theTvRemoteNeeds =>
      'Remote TV memerlukan TV yang terhubung. Pilih satu di bawah.';

  @override
  String get connectToATv => 'Hubungkan ke TV untuk melanjutkan.';

  @override
  String get findingTvs => 'Mencari TV…';

  @override
  String get makeSureYourTv => 'Pastikan TV Anda menyala';

  @override
  String get notConnected => 'Tidak terhubung';

  @override
  String get tapToFindYour => 'Ketuk untuk mencari TV Anda';

  @override
  String get connectionFailed2 => 'Koneksi gagal';

  @override
  String tapToManageDevices(Object label) {
    return '$label. Ketuk untuk mengelola perangkat';
  }

  @override
  String get joinTheSameWi => 'Gabung ke Wi-Fi yang sama';

  @override
  String get connectYourPhoneAnd =>
      'Hubungkan ponsel dan TV ke jaringan Wi-Fi yang sama.';

  @override
  String get turnOnCastingOn => 'Aktifkan cast di TV Anda';

  @override
  String get enableScreenMirroringMiracast =>
      'Aktifkan Cermin Layar, Miracast, atau Google Cast di pengaturan TV.';

  @override
  String get scanForDevices => 'Pindai perangkat';

  @override
  String get openDevicesInCastflow =>
      'Buka Perangkat di CastFlow dan tunggu beberapa detik hingga TV Anda muncul.';

  @override
  String get tapConnect => 'Ketuk Hubungkan';

  @override
  String get acceptThePromptOn =>
      'Terima permintaan di TV Anda jika muncul. Selesai!';

  @override
  String get howToConnect => 'Cara menghubungkan';

  @override
  String get fourQuickStepsTo => 'Empat langkah cepat menuju layar besar.';

  @override
  String get gotIt => 'Mengerti';

  @override
  String step(Object number, Object title, Object body) {
    return 'Langkah $number. $title. $body';
  }

  @override
  String get homeWiFi => 'Wi-Fi rumah';

  @override
  String get router => 'Router';

  @override
  String get settingsConnection => 'Pengaturan › Koneksi';

  @override
  String get inputHdmi1 => 'Input: HDMI 1';

  @override
  String get screenMirroring => 'Cermin Layar';

  @override
  String get networkHomeWiFi => 'Jaringan: Wi-Fi rumah';

  @override
  String get livingRoomTv => 'TV ruang tamu';

  @override
  String get allowCastflowToConnect => 'Izinkan CastFlow terhubung?';

  @override
  String get deny => 'Tolak';

  @override
  String get allow => 'Izinkan';

  @override
  String get yourTv => 'TV Anda';

  @override
  String get findYourTv => 'Temukan TV Anda';

  @override
  String connectTo(Object name) {
    return 'Hubungkan ke $name';
  }

  @override
  String connected2(Object label) {
    return 'Terhubung · $label';
  }

  @override
  String get openTvRemote => 'Buka remote TV';

  @override
  String get sameWiFiNetwork => 'Jaringan Wi-Fi yang sama';

  @override
  String get yourPhoneAndTv =>
      'Ponsel dan TV harus terhubung ke Wi-Fi yang sama.';

  @override
  String get tvIsOnAnd => 'TV menyala dan siap';

  @override
  String get turnOnScreenMirroring =>
      'Aktifkan Cermin Layar, Cast, atau Miracast di TV.';

  @override
  String get noVpnOrGuest => 'Tanpa VPN atau jaringan tamu';

  @override
  String get vpnsAndGuestIsolated =>
      'VPN dan Wi-Fi tamu / terisolasi menyembunyikan perangkat satu sama lain.';

  @override
  String get localNetworkAccess => 'Akses jaringan lokal';

  @override
  String get allowCastflowToFind =>
      'Izinkan CastFlow menemukan perangkat di jaringan Anda saat diminta.';

  @override
  String get noTvFound => 'TV tidak ditemukan';

  @override
  String get checkThatYourPhone =>
      'Pastikan ponsel dan TV terhubung ke Wi-Fi yang sama, lalu pindai lagi.';

  @override
  String get noWiFiRouter => 'Tidak punya router Wi-Fi? Gunakan hotspot Anda';

  @override
  String searchingForTvsFound(Object length) {
    return 'Mencari TV. $length ditemukan.';
  }

  @override
  String tvsFound(Object length) {
    return '$length TV ditemukan';
  }

  @override
  String get connectToYourTv => 'Hubungkan ke TV Anda';

  @override
  String get connectYourPhoneAndTv =>
      'Hubungkan ponsel dan TV ke jaringan Wi-Fi yang sama.';

  @override
  String get turnOnTheTv => 'Nyalakan TV dan buka input Cermin Layar / Cast.';

  @override
  String get tapTheConnectionBar =>
      'Ketuk bilah koneksi di Beranda untuk mencari TV Anda.';

  @override
  String get tapConnectAndAccept =>
      'Ketuk Hubungkan dan terima permintaan di TV jika muncul.';

  @override
  String get mirrorYourScreen => 'Cerminkan layar Anda';

  @override
  String get connectToYourTvFirst => 'Hubungkan ke TV Anda terlebih dahulu.';

  @override
  String get openScreenMirroringFrom => 'Buka Cermin Layar dari Beranda.';

  @override
  String get pickAQualityAnd => 'Pilih kualitas dan ketuk Mulai.';

  @override
  String get allowScreenCaptureWhen =>
      'Izinkan tangkapan layar saat Android meminta.';

  @override
  String get castPhotosVideosMusic => 'Cast foto, video & musik';

  @override
  String get openPhotosVideosOr => 'Buka Foto, Video, atau Musik di Beranda.';

  @override
  String get pickWhatYouWant => 'Pilih yang ingin ditampilkan.';

  @override
  String get itPlaysOnThe =>
      'Diputar di TV; kendalikan dari ponsel atau notifikasi.';

  @override
  String get useTheTvRemote => 'Gunakan remote TV';

  @override
  String get openTvRemoteOn => 'Buka Remote TV di Beranda.';

  @override
  String get useTheDPad =>
      'Gunakan D-pad atau geser di touchpad untuk bergerak, ketuk OK untuk memilih.';

  @override
  String get buttonsATvDoesnt =>
      'Tombol yang tidak didukung TV berwarna abu-abu.';

  @override
  String get castFromTheWeb => 'Cast dari web & aplikasi';

  @override
  String get tapTheBrowserBar =>
      'Ketuk bilah browser atau aplikasi di Beranda.';

  @override
  String get playAVideoOn => 'Putar video di situs.';

  @override
  String get tapCastThisVideo =>
      'Ketuk “Cast video ini” untuk mengirimnya ke TV.';

  @override
  String get screenMirroringHelp => 'Bantuan cermin layar';

  @override
  String get connectYourPhoneTo => 'Hubungkan ponsel ke Wi-Fi.';

  @override
  String get onTheTvOpen =>
      'Di TV, buka Pengaturan → Jaringan dan gabung ke Wi-Fi yang sama.';

  @override
  String get guestOrOfficeNetworks =>
      'Jaringan tamu atau kantor sering memblokir cermin layar; gunakan Wi-Fi rumah atau hotspot ponsel.';

  @override
  String get turnOffVpn => 'Matikan VPN';

  @override
  String get aVpnHidesYour => 'VPN menyembunyikan TV Anda dari ponsel.';

  @override
  String get pauseOrDisconnectYour =>
      'Jeda atau putuskan aplikasi VPN sebelum memulai.';

  @override
  String get youCanTurnIt => 'Anda bisa menyalakannya lagi setelah selesai.';

  @override
  String get turnOnMirroringOn => 'Aktifkan cermin di TV';

  @override
  String get samsungLgAndMost =>
      'Samsung, LG, dan sebagian besar TV Android menerima cermin layar secara otomatis.';

  @override
  String get otherTvsOpenInput =>
      'TV lain: buka Input / Sumber dan pilih Cermin Layar atau Miracast.';

  @override
  String get keepTheTvOn => 'Biarkan TV di layar itu selagi ponsel terhubung.';

  @override
  String get tapStartAndPick => 'Ketuk Mulai dan pilih TV Anda';

  @override
  String get tapStartOnThe => 'Ketuk Mulai di layar Cermin Layar.';

  @override
  String get androidOpensSmartView =>
      'Android membuka Smart View / Cast. Ketuk TV Anda di daftar.';

  @override
  String get ifTheTvAsks =>
      'Jika TV meminta, pilih Izinkan atau masukkan PIN yang tampil di layar.';

  @override
  String get youreMirroring => 'Anda sedang mencerminkan layar';

  @override
  String get everythingOnYourPhone =>
      'Semua yang ada di ponsel kini tampil di TV.';

  @override
  String get turnThePhoneSideways =>
      'Putar ponsel ke samping untuk video dan game layar penuh.';

  @override
  String get toStopTapStop =>
      'Untuk berhenti, ketuk Berhenti atau gunakan notifikasi cast.';

  @override
  String get vpn => 'VPN';

  @override
  String get off => 'Mati';

  @override
  String get hdmi1 => 'HDMI 1';

  @override
  String get hdmi2 => 'HDMI 2';

  @override
  String get smartView => 'Smart View';

  @override
  String get bedroomTv => 'TV kamar tidur';

  @override
  String get officeDisplay => 'Layar kantor';

  @override
  String get clearHistory => 'Hapus riwayat?';

  @override
  String get thisRemovesEverythingYouve =>
      'Ini menghapus semua yang pernah Anda cast dari daftar ini.';

  @override
  String get clear => 'Hapus';

  @override
  String get clearHistory2 => 'Hapus riwayat';

  @override
  String get noHistoryYet => 'Belum ada riwayat';

  @override
  String get everythingYouCastWill =>
      'Semua yang Anda cast akan tercantum di sini agar mudah ditemukan lagi.';

  @override
  String get today => 'Hari ini';

  @override
  String get yesterday => 'Kemarin';

  @override
  String get earlier => 'Sebelumnya';

  @override
  String get swipeAnItemTo => 'Geser item untuk menghapusnya';

  @override
  String get delete => 'Hapus';

  @override
  String removed(Object title) {
    return '“$title” dihapus';
  }

  @override
  String get undo => 'Urungkan';

  @override
  String get photos => 'Foto';

  @override
  String get albums => 'Album';

  @override
  String get videos => 'Video';

  @override
  String get gallery => 'Galeri';

  @override
  String get music => 'Musik';

  @override
  String get songs => 'Lagu';

  @override
  String get media => 'Media';

  @override
  String get browseTheWeb => 'Jelajahi web';

  @override
  String get goPro => 'Beralih ke Pro';

  @override
  String cast(Object title) {
    return 'Cast $title';
  }

  @override
  String get screenMirroringStartMirroring =>
      'Cermin Layar. Mulai mencerminkan';

  @override
  String readyToMirrorTo(Object device) {
    return 'Siap mencerminkan ke $device';
  }

  @override
  String get showYourPhoneOn => 'Tampilkan ponsel Anda di TV secara real time.';

  @override
  String get startMirroring => 'Mulai Cermin Layar';

  @override
  String get tvRemote => 'Remote TV';

  @override
  String get controlYourTv => 'Kendalikan TV Anda';

  @override
  String get youtubeMore => 'YouTube & lainnya';

  @override
  String get openTheBrowser => 'Buka browser';

  @override
  String get searchOrTypeA => 'Cari atau ketik situs web';

  @override
  String get howToConnectOpen => 'Cara menghubungkan. Buka panduan visual';

  @override
  String get visualGuideForEvery => 'Panduan visual untuk setiap fitur';

  @override
  String get language => 'Bahasa';

  @override
  String get done => 'Selesai';

  @override
  String get enterAValidHttp =>
      'Masukkan tautan http(s) atau rtsp yang valid, mis. URL .m3u8 atau .mp4.';

  @override
  String get linkStream => 'Stream tautan';

  @override
  String get iptvLinkCast => 'IPTV / Cast tautan';

  @override
  String get castALink => 'Cast tautan';

  @override
  String get pasteADirectVideo =>
      'Tempel URL video langsung, M3U8, atau stream IPTV.';

  @override
  String get paste => 'Tempel';

  @override
  String get castLink => 'Cast tautan';

  @override
  String get allowAccessToYour =>
      'Izinkan akses ke media Anda untuk melakukan cast. Anda dapat mengubahnya di Pengaturan.';

  @override
  String get video => 'Video';

  @override
  String get castMusic => 'Cast musik';

  @override
  String get noMusicFound => 'Musik tidak ditemukan';

  @override
  String get addSongsToYour =>
      'Tambahkan lagu ke ponsel dan lagu akan muncul di sini.';

  @override
  String get shuffle => 'Acak';

  @override
  String get playAll => 'Putar semua';

  @override
  String photo(Object formatShortDate) {
    return 'Foto · $formatShortDate';
  }

  @override
  String get photo2 => 'Foto';

  @override
  String get castPhotos => 'Cast foto';

  @override
  String get select => 'Pilih';

  @override
  String get noPhotosHere => 'Tidak ada foto di sini';

  @override
  String get photosYouTakeOr =>
      'Foto yang Anda ambil atau simpan akan muncul di album ini.';

  @override
  String photos2(Object name, Object count) {
    return '$name, $count foto';
  }

  @override
  String photoFrom(Object formatShortDate) {
    return 'Foto dari $formatShortDate';
  }

  @override
  String get allPhotos => 'Semua foto';

  @override
  String get slideshow => 'Slideshow';

  @override
  String get interval => 'Interval';

  @override
  String get transition => 'Transisi';

  @override
  String get fade => 'Memudar';

  @override
  String get slide => 'Geser';

  @override
  String get zoom => 'Zoom';

  @override
  String get startSlideshow => 'Mulai slideshow';

  @override
  String get castVideos => 'Cast video';

  @override
  String get noVideosYet => 'Belum ada video';

  @override
  String get videosYouRecordOr =>
      'Video yang Anda rekam atau unduh akan muncul di sini, siap di-cast.';

  @override
  String video2(Object resolution) {
    return 'Video · $resolution';
  }

  @override
  String cast2(Object title, Object formatDuration) {
    return '$title, $formatDuration. Cast';
  }

  @override
  String get tv => 'TV';

  @override
  String get screenMirroringSession => 'Sesi cermin layar';

  @override
  String get mirroringDidntStartTap =>
      'Cermin layar tidak dimulai. Ketuk Mulai lagi dan pilih TV Anda di daftar.';

  @override
  String get openSmartViewOr =>
      'Buka Smart View atau Cast dari pengaturan cepat ponsel untuk mencerminkan.';

  @override
  String get quality => 'Kualitas';

  @override
  String get adjustsToYourWi =>
      'Menyesuaikan dengan Wi-Fi Anda untuk gambar paling mulus.';

  @override
  String upToLowerIt(Object label) {
    return 'Hingga $label. Turunkan jika gambar tersendat.';
  }

  @override
  String get stillNeedHelp => 'Butuh bantuan?';

  @override
  String get startingScreenMirroring => 'Memulai cermin layar…';

  @override
  String mirroringTo(Object value) {
    return 'Mencerminkan ke $value';
  }

  @override
  String get stopping => 'Menghentikan…';

  @override
  String get readyToMirror => 'Siap mencerminkan';

  @override
  String get beforeYouStart => 'Sebelum memulai';

  @override
  String get phoneAndTvAre => 'Ponsel dan TV berada di Wi-Fi yang sama';

  @override
  String get noVpnIsConnected => 'Tidak ada VPN yang terhubung di ponsel';

  @override
  String get tvIsOnWith => 'TV menyala dengan Cermin Layar aktif';

  @override
  String get phoneIsCloseTo => 'Ponsel dekat dengan TV';

  @override
  String get stopMirroring => 'Hentikan cermin';

  @override
  String get startMirroring2 => 'Mulai cermin';

  @override
  String get stop => 'Berhenti';

  @override
  String get start => 'Mulai';

  @override
  String get duration => 'Durasi';

  @override
  String get adIsLoading => 'Iklan sedang dimuat';

  @override
  String get ad => 'Iklan';

  @override
  String get mirrorYourScreenTo => 'Cerminkan layar ke TV mana pun';

  @override
  String get showYourPhoneOnThe =>
      'Tampilkan ponsel di layar besar dengan satu ketukan — tanpa kabel, tanpa ribet.';

  @override
  String get shareMemoriesWithThe =>
      'Bagikan kenangan ke seluruh ruangan dan tetap pegang kendali dari ponsel.';

  @override
  String get castFromWebApps => 'Cast dari web & aplikasi';

  @override
  String get sendVideosFromYoutube =>
      'Kirim video dari YouTube, Facebook, dan situs apa pun langsung ke TV Anda.';

  @override
  String pageOf(Object value, Object length) {
    return 'Halaman $value dari $length';
  }

  @override
  String get getStarted => 'Mulai';

  @override
  String get localNetwork => 'Jaringan lokal';

  @override
  String get findTvsAndStreaming =>
      'Temukan TV dan perangkat streaming di Wi-Fi Anda.';

  @override
  String get notifications => 'Notifikasi';

  @override
  String get showCastingControlsWhile =>
      'Tampilkan kontrol cast saat Anda memakai aplikasi lain.';

  @override
  String get photosVideosMusic => 'Foto, video & musik';

  @override
  String get pickWhatYouWantTo =>
      'Pilih yang ingin di-cast dari galeri dan pustaka Anda.';

  @override
  String get screenCapture => 'Tangkapan layar';

  @override
  String get mirrorYourScreenYoull =>
      'Cerminkan layar Anda. Anda akan mengonfirmasi setiap sesi.';

  @override
  String get webVideo => 'Video web';

  @override
  String get link => 'Tautan';

  @override
  String get screenMirroring2 => 'Cermin layar';

  @override
  String nowCastingOpenRemote(Object title) {
    return 'Sedang cast $title. Buka remote';
  }

  @override
  String castingTo2(Object value) {
    return 'Cast ke $value';
  }

  @override
  String get nowCasting => 'Sedang cast';

  @override
  String get nothingIsCasting => 'Tidak ada yang di-cast';

  @override
  String get pickAPhotoVideo =>
      'Pilih foto, video, lagu, atau video web untuk dikirim ke TV Anda.';

  @override
  String get backToHome => 'Kembali ke beranda';

  @override
  String slide2(Object formatDuration) {
    return 'Slide $formatDuration';
  }

  @override
  String get back10Seconds => 'Mundur 10 detik';

  @override
  String get forward10Seconds => 'Maju 10 detik';

  @override
  String get tvVolume => 'Volume TV';

  @override
  String tvVolumePercent(Object round) {
    return 'Volume TV $round persen';
  }

  @override
  String get upNext => 'Berikutnya';

  @override
  String get addPhotos => 'Tambah foto';

  @override
  String get addVideos => 'Tambah video';

  @override
  String get nothingElseInThe => 'Tidak ada lagi di antrean.';

  @override
  String play2(Object title) {
    return 'Putar $title';
  }

  @override
  String get unknownDevice => 'Perangkat tidak dikenal';

  @override
  String get perWeek => 'per minggu';

  @override
  String get perYear => 'per tahun';

  @override
  String get payOnce => 'bayar sekali';

  @override
  String get wirelessScreenMirroring => 'Cermin layar nirkabel';

  @override
  String get castVideosPhotosMusic => 'Cast video, foto & musik';

  @override
  String get fullTvRemoteControl => 'Kendali remote TV lengkap';

  @override
  String get worksWithAllMajor => 'Bekerja dengan semua TV utama';

  @override
  String get smoothLagFreeStreaming => 'Streaming mulus tanpa lag';

  @override
  String get noAds => 'Tanpa iklan';

  @override
  String get welcomeToCastflowPro => 'Selamat datang di CastFlow Pro!';

  @override
  String get purchaseCancelled => 'Pembelian dibatalkan.';

  @override
  String get purchasePendingProUnlocks =>
      'Pembelian tertunda. Pro akan aktif begitu toko mengonfirmasinya.';

  @override
  String get purchaseFailedPleaseTry => 'Pembelian gagal. Silakan coba lagi.';

  @override
  String get theStoreIsntAvailable => 'Toko tidak tersedia saat ini.';

  @override
  String get close => 'Tutup';

  @override
  String get goProWithCastflow => 'JADI PRO DENGAN CASTFLOW';

  @override
  String get unlockEveryFeature => 'Buka semua fitur';

  @override
  String get renewsAutomaticallyUntilCancelled =>
      'Diperpanjang otomatis hingga dibatalkan.';

  @override
  String get oneTimePurchaseNo => 'Pembelian sekali bayar. Tanpa langganan.';

  @override
  String get continueAction => 'Lanjutkan';

  @override
  String get privacyPolicy => 'Kebijakan Privasi';

  @override
  String get termsAndConditions => 'Syarat dan Ketentuan';

  @override
  String get cancelAnytime => 'Batalkan kapan saja';

  @override
  String get loadingPrice => 'Memuat harga…';

  @override
  String get pricesUnavailableTapTo =>
      'Harga tidak tersedia · Ketuk untuk mencoba lagi';

  @override
  String get noPlansAvailableRight => 'Tidak ada paket tersedia saat ini.';

  @override
  String get weekly => 'Mingguan';

  @override
  String get yearly => 'Tahunan';

  @override
  String get lifetime => 'Seumur hidup';

  @override
  String get bestValue => 'Paling hemat';

  @override
  String get disconnectFromTv => 'Putuskan dari TV?';

  @override
  String get thisStopsWhatIs =>
      'Ini menghentikan apa yang sedang diputar atau dicerminkan.';

  @override
  String get useTouchpad => 'Gunakan touchpad';

  @override
  String get useDPad => 'Gunakan D-pad';

  @override
  String receiversDontAcceptRemote(Object label) {
    return 'Penerima $label tidak menerima perintah remote.';
  }

  @override
  String someButtonsAreUnavailable(Object label) {
    return 'Beberapa tombol tidak tersedia di $label.';
  }

  @override
  String get idle => 'SIAGA';

  @override
  String get playing => 'MEMUTAR';

  @override
  String get paused => 'DIJEDA';

  @override
  String get noTvConnected => 'Tidak ada TV terhubung';

  @override
  String get mute2 => 'BISU';

  @override
  String vol(Object volume) {
    return 'VOL $volume';
  }

  @override
  String get noTvConnectedTap =>
      'Tidak ada TV terhubung. Ketuk untuk memilih perangkat';

  @override
  String get tapToChooseA => 'Ketuk untuk memilih perangkat';

  @override
  String isntSupportedBy(Object label, Object label2) {
    return '$label tidak didukung oleh $label2';
  }

  @override
  String get touchpadSwipeToMove =>
      'Touchpad. Geser untuk bergerak, ketuk untuk memilih.';

  @override
  String get swipeToMoveTap => 'Geser untuk bergerak · Ketuk untuk memilih';

  @override
  String get navigationIsntSupportedBy => 'Navigasi tidak didukung oleh TV ini';

  @override
  String get vol2 => 'VOL';

  @override
  String get auto => 'Otomatis';

  @override
  String get automatic => 'Otomatis';

  @override
  String get googleCastFirst => 'Google Cast dulu';

  @override
  String get dlnaUpnpFirst => 'DLNA / UPnP dulu';

  @override
  String get miracastFirst => 'Miracast dulu';

  @override
  String get tvOnly => 'TV saja';

  @override
  String get phoneAndTv => 'Ponsel dan TV';

  @override
  String get phoneOnly => 'Ponsel saja';

  @override
  String get touchpad => 'Touchpad';

  @override
  String get doMyPhoneAnd => 'Apakah ponsel dan TV harus di Wi-Fi yang sama?';

  @override
  String get yesDiscoveryAndCasting =>
      'Ya. Penemuan dan cast tetap di jaringan lokal Anda, jadi keduanya harus di Wi-Fi yang sama (nama band yang mirip bisa jadi jaringan berbeda).';

  @override
  String get myRouterHasAp => 'Router saya punya “isolasi AP / klien”';

  @override
  String get isolationBlocksDevicesFrom =>
      'Isolasi mencegah perangkat saling melihat. Matikan di pengaturan router, atau gunakan jaringan non-tamu.';

  @override
  String get findingYourTv => 'Menemukan TV Anda';

  @override
  String get myTvDoesntAppear => 'TV saya tidak muncul di daftar';

  @override
  String get turnOnCastingScreen =>
      'Aktifkan cast / cermin layar di TV, bangunkan dari siaga, lalu ketuk Pindai ulang. Izinkan izin Jaringan Lokal jika diminta.';

  @override
  String get onlySomeDevicesShow => 'Hanya sebagian perangkat yang muncul';

  @override
  String get olderTvsMayNeed =>
      'TV lama mungkin memerlukan pembaruan firmware. TV Miracast hanya muncul saat input “Cermin Layar” terbuka.';

  @override
  String get connectionFailsOrTimes => 'Koneksi gagal atau waktu habis';

  @override
  String get restartTheTvApp =>
      'Mulai ulang aplikasi TV atau TV, dekatkan ke router, dan terima permintaan apa pun di layar TV.';

  @override
  String get itKeepsReconnectingTo => 'Terus terhubung ke TV lama';

  @override
  String get turnOffAutoConnect =>
      'Matikan “Hubungkan otomatis ke TV terakhir” di Pengaturan → Cast.';

  @override
  String get mirroringIsLaggy => 'Cermin layar patah-patah';

  @override
  String get chooseALowerQuality =>
      'Pilih kualitas lebih rendah (720p atau 480p), tutup aplikasi berat, dan gunakan jaringan Wi-Fi 5 GHz.';

  @override
  String get thePictureIsRotated => 'Gambar terputar atau terpotong';

  @override
  String get toggleAutoRotateOn =>
      'Aktifkan/nonaktifkan Putar otomatis di layar Cermin Layar.';

  @override
  String get sound => 'Suara';

  @override
  String get thereIsNoSound => 'Tidak ada suara di TV';

  @override
  String get makeSureAudioIs =>
      'Pastikan Audio aktif di Cermin Layar dan periksa Pengaturan → Cast → Output audio. Sebagian penerima tidak mendukung audio ponsel.';

  @override
  String get tvRemote2 => 'Remote TV';

  @override
  String get someRemoteButtonsAre => 'Beberapa tombol remote berwarna abu-abu';

  @override
  String get eachReceiverSupportsDifferent =>
      'Setiap penerima mendukung perintah berbeda. Chromecast dan DLNA hanya mendukung pemutaran dan volume; Miracast tidak punya saluran remote.';

  @override
  String get canCastflowTurnMy =>
      'Bisakah CastFlow menyalakan TV atau mengganti input?';

  @override
  String get onlyOnTvsThat =>
      'Hanya pada TV yang membuka perintah itu lewat jaringan. Tombol yang tidak didukung dinonaktifkan, bukan berpura-pura berfungsi.';

  @override
  String get helpFaq => 'Bantuan & FAQ';

  @override
  String get stepByStepConnection => 'Panduan koneksi langkah demi langkah';

  @override
  String androidSdk(Object release, Object sdkInt) {
    return 'Android $release (SDK $sdkInt)';
  }

  @override
  String get noEmailAppFound => 'Aplikasi email tidak ditemukan.';

  @override
  String get enjoyingCastflow => 'Suka CastFlow?';

  @override
  String get sorryToHearThat => 'Maaf mendengarnya';

  @override
  String get thanksHowCanWe => 'Terima kasih! Bagaimana kami bisa lebih baik?';

  @override
  String get wereGladYouLike => 'Kami senang Anda menyukainya!';

  @override
  String get youMadeOurDay => 'Anda membuat hari kami!';

  @override
  String get tapToExit => 'Ketuk untuk keluar';

  @override
  String get selectARating => 'Pilih peringkat';

  @override
  String get sendFeedback => 'Kirim masukan';

  @override
  String get rateUs => 'Beri nilai kami';

  @override
  String get rateYourExperienceBefore =>
      'Beri nilai pengalaman Anda sebelum pergi.';

  @override
  String get tapAStarTo => 'Ketuk bintang untuk menilai CastFlow.';

  @override
  String get general => 'Umum';

  @override
  String get english => 'English';

  @override
  String get defaultQuality => 'Kualitas default';

  @override
  String get autoConnectToLast => 'Hubungkan otomatis ke TV terakhir';

  @override
  String get hapticFeedback => 'Umpan balik haptik';

  @override
  String get clearCastingHistory => 'Hapus riwayat cast';

  @override
  String get clearCastingHistory2 => 'Hapus riwayat cast?';

  @override
  String get onlyCastflowsListIs =>
      'Hanya daftar CastFlow yang dihapus. Media di ponsel tidak pernah dihapus.';

  @override
  String get appearance => 'Tampilan';

  @override
  String get light => 'Terang';

  @override
  String get dark => 'Gelap';

  @override
  String get system => 'Sistem';

  @override
  String get aboutSupport => 'Tentang & dukungan';

  @override
  String get rateApp => 'Nilai aplikasi';

  @override
  String get feedback => 'Masukan';

  @override
  String get termsConditions => 'Syarat & Ketentuan';

  @override
  String get version => 'Versi';

  @override
  String get castflowProIsActive => 'CastFlow Pro aktif';

  @override
  String get upgradeToPremium => 'Tingkatkan ke Premium';

  @override
  String get castflowPremium => 'CastFlow Premium';

  @override
  String get thanksForYourSupport =>
      'Terima kasih atas dukungan Anda. Nikmati cast tanpa iklan.';

  @override
  String get noAds1080pMirroring =>
      'Tanpa iklan, cermin 1080p & cast tanpa batas';

  @override
  String get upgrade => 'Tingkatkan';

  @override
  String get mirrorCastBeautifullySimple =>
      'Cermin & cast, sederhana dan indah';

  @override
  String get thisActionMayContain => 'Tindakan ini mungkin berisi iklan';

  @override
  String get webCast => 'Cast web';

  @override
  String get castThisVideo => 'Cast video ini';

  @override
  String get searchOrTypeAWeb => 'Cari atau ketik alamat web';

  @override
  String get removeBookmark => 'Hapus penanda';

  @override
  String get bookmark => 'Penanda';

  @override
  String get quickAccess => 'Akses cepat';

  @override
  String open2(Object title) {
    return 'Buka $title';
  }

  @override
  String get bookmarks => 'Penanda';

  @override
  String get noBookmarks => 'Tidak ada penanda';

  @override
  String get tapTheBookmarkIcon =>
      'Ketuk ikon penanda di bilah alamat untuk menyimpan halaman.';

  @override
  String get noHistory => 'Tidak ada riwayat';

  @override
  String get pagesYouVisitShow => 'Halaman yang Anda kunjungi muncul di sini.';

  @override
  String get remove => 'Hapus';

  @override
  String resultOn(Object value, Object host) {
    return 'Hasil $value di $host';
  }

  @override
  String get aSimulatedPageResult => 'Hasil halaman simulasi';

  @override
  String get videosOnThisPage => 'Video di halaman ini';

  @override
  String get pickOneToSend => 'Pilih satu untuk dikirim ke TV Anda.';

  @override
  String get onboardHotspotTitle => 'Tidak ada Wi-Fi? Pakai hotspot';

  @override
  String get onboardHotspotBody =>
      'Nyalakan hotspot ponsel dan hubungkan TV ke sana. Transmisi berjalan sama seperti di Wi-Fi.';

  @override
  String get stillCantFindTitle => 'Masih belum menemukan TV?';

  @override
  String get stillCantFindBody => 'Hubungkan TV ke hotspot ponsel Anda:';

  @override
  String get hotspotStep4 => 'Ketuk Coba lagi lalu pilih TV dari daftar';

  @override
  String get castOverHotspot =>
      'Tidak ada Wi-Fi? Transmisikan lewat hotspot ponsel:';

  @override
  String get queue => 'Antrean';

  @override
  String get addMusic => 'Tambah musik';

  @override
  String get connectWithWifi => 'Hubungkan dengan Wi-Fi';

  @override
  String get continueWithHotspot => 'Lanjutkan dengan hotspot';

  @override
  String get noWifiAlertMessage =>
      'Anda sedang memakai data seluler. Hubungkan ponsel dan TV ke Wi-Fi yang sama, atau nyalakan hotspot ponsel lalu sambungkan TV ke hotspot itu.';
}
