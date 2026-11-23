// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malay (`ms`).
class AppLocalizationsMs extends AppLocalizations {
  AppLocalizationsMs([String locale = 'ms']) : super(locale);

  @override
  String get networkRequiredTitle => 'Tidak disambungkan ke Wi-Fi';

  @override
  String get networkRequiredMessage =>
      'Telefon dan TV anda mesti berada dalam rangkaian Wi-Fi yang sama untuk cast.';

  @override
  String get openWifiSettings => 'Buka Tetapan Wi-Fi';

  @override
  String get useMobileHotspot => 'Gunakan Hotspot Mudah Alih';

  @override
  String get hotspotInstruction =>
      'Sambungkan LCD/TV anda ke hotspot mudah alih anda.';

  @override
  String get hotspotStep1 => 'Hidupkan hotspot mudah alih';

  @override
  String get hotspotStep2 => 'Sambungkan TV anda kepadanya';

  @override
  String get hotspotStep3 => 'Kembali ke aplikasi';

  @override
  String get openHotspotSettings => 'Buka Tetapan Hotspot';

  @override
  String get hotspotAutoCheck =>
      'Kami akan menyemak semula secara automatik apabila anda kembali.';

  @override
  String get hotspotDetected => 'Hotspot dihidupkan. Mencari TV anda…';

  @override
  String get searchingDevices => 'Mencari peranti berdekatan...';

  @override
  String get waitingForTvOnHotspot =>
      'Menunggu TV anda menyertai hotspot anda…';

  @override
  String get usingHotspot => 'Menggunakan hotspot mudah alih anda';

  @override
  String devicesFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count peranti ditemui',
      one: '1 peranti ditemui',
    );
    return '$_temp0';
  }

  @override
  String get retry => 'Cuba semula';

  @override
  String get scanAgain => 'Imbas semula';

  @override
  String get isolationTitle => 'TV tidak bertindak balas';

  @override
  String get isolationHint =>
      'Satu peranti menyertai hotspot anda tetapi tidak bertindak balas. Hotspot anda mungkin menyekat trafik antara peranti (pengasingan klien). Matikannya dalam tetapan hotspot, atau gunakan rangkaian Wi-Fi.';

  @override
  String get connecting => 'Menyambung…';

  @override
  String get connected => 'Disambungkan';

  @override
  String get connectionFailed => 'Tidak dapat menyambung';

  @override
  String get connectFailedHint =>
      'Pastikan telefon dan TV anda berada dalam rangkaian yang sama, kemudian cuba lagi.';

  @override
  String get hotspotConnectHint =>
      'Hotspot anda mungkin menyekat trafik antara peranti. Semak tetapan pengasingan klien.';

  @override
  String get networkLostTitle => 'Sambungan rangkaian terputus';

  @override
  String get networkLostMessage =>
      'Sambung semula ke Wi-Fi atau hotspot anda, kemudian sambung semula ke TV anda.';

  @override
  String get reconnect => 'Sambung semula';

  @override
  String reconnectTo(String name) {
    return 'Sambung semula ke $name';
  }

  @override
  String get tapToReconnect => 'Ketik untuk sambung semula';

  @override
  String get pairingRequired => 'Pemasangan diperlukan';

  @override
  String get pairingEnterCode => 'Masukkan kod yang dipaparkan pada TV anda.';

  @override
  String get pairingApproveOnTv =>
      'Lihat TV anda dan ketik Benarkan untuk meneruskan.';

  @override
  String get connect => 'Sambung';

  @override
  String get cancel => 'Batal';

  @override
  String get pairingIncorrectCode => 'Kod salah. Cuba lagi.';

  @override
  String get pairingTimedOut => 'Pemasangan tamat masa';

  @override
  String get tryAgain => 'Cuba lagi';

  @override
  String get pairingDeclined => 'TV menolak sambungan';

  @override
  String pairingTooManyAttempts(int seconds) {
    return 'Terlalu banyak kod salah. Tunggu $seconds s, kemudian minta kod baharu.';
  }

  @override
  String get pairingCooldownOver => 'Anda boleh meminta kod baharu sekarang.';

  @override
  String get pairingRequestNewCode => 'Minta kod baharu';

  @override
  String get pairingNetworkLost =>
      'Rangkaian terputus semasa pemasangan. Sambung semula ke Wi-Fi dan cuba lagi.';

  @override
  String get pairingFailed => 'Tidak dapat dipasangkan dengan TV.';

  @override
  String pairingCodeField(int length) {
    return 'Kod pemasangan, $length aksara';
  }

  @override
  String pairingCodeBox(int index, int total) {
    return 'Kotak kod $index daripada $total';
  }

  @override
  String get pairingEmptyBox => 'kosong';

  @override
  String get pairingPaired => 'Dipasangkan';

  @override
  String get forgetDevice => 'Lupakan peranti';

  @override
  String forgetDeviceMessage(String name) {
    return '$name perlu dipasangkan semula pada kali berikutnya.';
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
      other: '$count video ditemui. Cast video',
      one: '1 video ditemui. Cast video',
    );
    return '$_temp0';
  }

  @override
  String get noVideoYet => 'Belum ada video ditemui pada halaman ini.';

  @override
  String get videoFound => 'Video ditemui';

  @override
  String get videoFoundMessage => 'Mainkannya pada TV anda.';

  @override
  String get castAction => 'Cast';

  @override
  String get dismiss => 'Tutup';

  @override
  String videosFound(int count) {
    return 'Video ditemui ($count)';
  }

  @override
  String get castToTv => 'Cast ke TV';

  @override
  String get protectedVideo => 'Dilindungi, tidak boleh di-cast';

  @override
  String get videoThumbnail => 'Imej kecil video';

  @override
  String castingTo(String device) {
    return 'Cast ke $device';
  }

  @override
  String get stopCasting => 'Henti cast';

  @override
  String get play => 'Main';

  @override
  String get pause => 'Jeda';

  @override
  String get volume => 'Kelantangan';

  @override
  String get seekPosition => 'Kedudukan main balik';

  @override
  String get showControls => 'Tunjukkan kawalan';

  @override
  String get hideControls => 'Sembunyikan kawalan';

  @override
  String get formatUnsupportedTitle => 'Format tidak disokong';

  @override
  String formatUnsupported(String device, String format) {
    return '$device tidak dapat memainkan video $format. Cuba video lain pada halaman ini, atau gunakan pencerminan skrin.';
  }

  @override
  String get videoExpired =>
      'Pautan video ini telah tamat tempoh. Muat semula halaman dan cuba lagi.';

  @override
  String get refreshingVideo => 'Mendapatkan pautan video baharu…';

  @override
  String get browserBack => 'Kembali';

  @override
  String get browserForward => 'Ke hadapan';

  @override
  String get browserStartPage => 'Halaman permulaan';

  @override
  String get browserReload => 'Muat semula';

  @override
  String get ok => 'OK';

  @override
  String get home => 'Utama';

  @override
  String get devices => 'Peranti';

  @override
  String get history => 'Sejarah';

  @override
  String get settings => 'Tetapan';

  @override
  String get goodMorning => 'Selamat pagi';

  @override
  String get goodAfternoon => 'Selamat tengah hari';

  @override
  String get goodEvening => 'Selamat petang';

  @override
  String get couldntOpenTheLink => 'Tidak dapat membuka pautan.';

  @override
  String get castflowLogo => 'Logo Cast ke TV';

  @override
  String get somethingWentWrong => 'Sesuatu telah berlaku';

  @override
  String get weCouldntLoadThis =>
      'Kami tidak dapat memuatkan ini sekarang. Sila cuba lagi.';

  @override
  String get apps => 'Aplikasi';

  @override
  String open(Object name) {
    return 'Buka $name';
  }

  @override
  String get smartTv => 'TV Pintar';

  @override
  String get chromecast => 'Chromecast';

  @override
  String get fireTv => 'Fire TV';

  @override
  String get roku => 'Roku';

  @override
  String get dlnaRenderer => 'Pemapar DLNA';

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
  String get playPause => 'Main / Jeda';

  @override
  String get previous => 'Sebelumnya';

  @override
  String get next => 'Seterusnya';

  @override
  String get rewind => 'Undur';

  @override
  String get volumeUp => 'Naikkan kelantangan';

  @override
  String get volumeDown => 'Perlahankan kelantangan';

  @override
  String get mute => 'Senyap';

  @override
  String connectedTo(Object name) {
    return 'Disambungkan ke $name';
  }

  @override
  String get chooseADevice => 'Pilih peranti';

  @override
  String get connectionGuide => 'Panduan sambungan';

  @override
  String get lookingForTvsOn => 'Mencari TV pada Wi-Fi anda';

  @override
  String foundSoFar(Object found) {
    return '$found ditemui setakat ini';
  }

  @override
  String deviceFound(Object found, Object value) {
    return '$found peranti$value ditemui';
  }

  @override
  String get disconnect => 'Putuskan sambungan';

  @override
  String signalOf4(Object level) {
    return 'Isyarat $level daripada 4';
  }

  @override
  String get connecting2 => 'Menyambung';

  @override
  String get theTvRemoteNeeds =>
      'Alat kawalan jauh TV memerlukan TV yang disambungkan. Pilih satu di bawah.';

  @override
  String get connectToATv => 'Sambung ke TV untuk meneruskan.';

  @override
  String get findingTvs => 'Mencari TV…';

  @override
  String get makeSureYourTv => 'Pastikan TV anda dihidupkan';

  @override
  String get notConnected => 'Tidak disambungkan';

  @override
  String get tapToFindYour => 'Ketik untuk mencari TV anda';

  @override
  String get connectionFailed2 => 'Sambungan gagal';

  @override
  String tapToManageDevices(Object label) {
    return '$label. Ketik untuk mengurus peranti';
  }

  @override
  String get joinTheSameWi => 'Sertai Wi-Fi yang sama';

  @override
  String get connectYourPhoneAnd =>
      'Sambungkan telefon dan TV anda ke rangkaian Wi-Fi yang sama.';

  @override
  String get turnOnCastingOn => 'Hidupkan cast pada TV anda';

  @override
  String get enableScreenMirroringMiracast =>
      'Dayakan Pencerminan Skrin, Miracast atau Google Cast dalam tetapan TV.';

  @override
  String get scanForDevices => 'Imbas peranti';

  @override
  String get openDevicesInCastflow =>
      'Buka Peranti dalam Cast ke TV dan tunggu beberapa saat sehingga TV anda muncul.';

  @override
  String get tapConnect => 'Ketik Sambung';

  @override
  String get acceptThePromptOn =>
      'Terima gesaan pada TV anda jika ada. Itu sahaja!';

  @override
  String get howToConnect => 'Cara menyambung';

  @override
  String get fourQuickStepsTo => 'Empat langkah pantas untuk ke skrin besar.';

  @override
  String get gotIt => 'Faham';

  @override
  String step(Object number, Object title, Object body) {
    return 'Langkah $number. $title. $body';
  }

  @override
  String get homeWiFi => 'Wi-Fi rumah';

  @override
  String get router => 'Penghala';

  @override
  String get settingsConnection => 'Tetapan › Sambungan';

  @override
  String get inputHdmi1 => 'Input: HDMI 1';

  @override
  String get screenMirroring => 'Pencerminan Skrin';

  @override
  String get networkHomeWiFi => 'Rangkaian: Wi-Fi rumah';

  @override
  String get livingRoomTv => 'TV Ruang Tamu';

  @override
  String get allowCastflowToConnect => 'Benarkan Cast ke TV menyambung?';

  @override
  String get deny => 'Tolak';

  @override
  String get allow => 'Benarkan';

  @override
  String get yourTv => 'TV anda';

  @override
  String get findYourTv => 'Cari TV anda';

  @override
  String connectTo(Object name) {
    return 'Sambung ke $name';
  }

  @override
  String connected2(Object label) {
    return 'Disambungkan · $label';
  }

  @override
  String get openTvRemote => 'Buka alat kawalan jauh TV';

  @override
  String get sameWiFiNetwork => 'Rangkaian Wi-Fi yang sama';

  @override
  String get yourPhoneAndTv =>
      'Telefon dan TV anda mesti disambungkan ke Wi-Fi yang sama.';

  @override
  String get tvIsOnAnd => 'TV dihidupkan dan sedia';

  @override
  String get turnOnScreenMirroring =>
      'Hidupkan Pencerminan Skrin, Cast atau Miracast pada TV.';

  @override
  String get noVpnOrGuest => 'Tiada VPN atau rangkaian tetamu';

  @override
  String get vpnsAndGuestIsolated =>
      'VPN dan Wi-Fi tetamu / terasing menyembunyikan peranti antara satu sama lain.';

  @override
  String get localNetworkAccess => 'Akses rangkaian tempatan';

  @override
  String get allowCastflowToFind =>
      'Benarkan Cast ke TV mencari peranti pada rangkaian anda apabila diminta.';

  @override
  String get noTvFound => 'Tiada TV ditemui';

  @override
  String get checkThatYourPhone =>
      'Semak bahawa telefon dan TV anda disambungkan ke Wi-Fi yang sama, kemudian imbas semula.';

  @override
  String get noWiFiRouter => 'Tiada penghala Wi-Fi? Gunakan hotspot anda';

  @override
  String searchingForTvsFound(Object length) {
    return 'Mencari TV. $length ditemui.';
  }

  @override
  String tvsFound(Object length) {
    return '$length TV ditemui';
  }

  @override
  String get connectToYourTv => 'Sambung ke TV anda';

  @override
  String get connectYourPhoneAndTv =>
      'Sambungkan telefon dan TV anda ke rangkaian Wi-Fi yang sama.';

  @override
  String get turnOnTheTv =>
      'Hidupkan TV dan buka input Pencerminan Skrin / Cast.';

  @override
  String get tapTheConnectionBar =>
      'Ketik bar sambungan di Utama untuk mencari TV anda.';

  @override
  String get tapConnectAndAccept =>
      'Ketik Sambung dan terima gesaan pada TV jika ada.';

  @override
  String get mirrorYourScreen => 'Cerminkan skrin anda';

  @override
  String get connectToYourTvFirst => 'Sambung ke TV anda dahulu.';

  @override
  String get openScreenMirroringFrom => 'Buka Pencerminan Skrin dari Utama.';

  @override
  String get pickAQualityAnd => 'Pilih kualiti dan ketik Mula.';

  @override
  String get allowScreenCaptureWhen =>
      'Benarkan tangkapan skrin apabila Android bertanya.';

  @override
  String get castPhotosVideosMusic => 'Cast foto, video & muzik';

  @override
  String get openPhotosVideosOr => 'Buka Foto, Video atau Muzik di Utama.';

  @override
  String get pickWhatYouWant => 'Pilih apa yang anda mahu tunjukkan.';

  @override
  String get itPlaysOnThe =>
      'Ia dimainkan pada TV; kawal daripada telefon anda atau pemberitahuan.';

  @override
  String get useTheTvRemote => 'Gunakan alat kawalan jauh TV';

  @override
  String get openTvRemoteOn => 'Buka Alat Kawalan Jauh TV di Utama.';

  @override
  String get useTheDPad =>
      'Gunakan D-pad atau leret pada pad sentuh untuk bergerak, ketik OK untuk memilih.';

  @override
  String get buttonsATvDoesnt => 'Butang yang tidak disokong TV dikelabukan.';

  @override
  String get castFromTheWeb => 'Cast daripada web & aplikasi';

  @override
  String get tapTheBrowserBar => 'Ketik bar pelayar atau aplikasi di Utama.';

  @override
  String get playAVideoOn => 'Mainkan video pada laman.';

  @override
  String get tapCastThisVideo =>
      'Ketik “Cast video ini” untuk menghantarnya ke TV anda.';

  @override
  String get screenMirroringHelp => 'Bantuan pencerminan skrin';

  @override
  String get connectYourPhoneTo => 'Sambungkan telefon anda ke Wi-Fi.';

  @override
  String get onTheTvOpen =>
      'Pada TV, buka Tetapan → Rangkaian dan sertai Wi-Fi yang sama.';

  @override
  String get guestOrOfficeNetworks =>
      'Rangkaian tetamu atau pejabat sering menyekat pencerminan; gunakan Wi-Fi rumah anda atau hotspot telefon anda.';

  @override
  String get turnOffVpn => 'Matikan VPN';

  @override
  String get aVpnHidesYour =>
      'VPN menyembunyikan TV anda daripada telefon anda.';

  @override
  String get pauseOrDisconnectYour =>
      'Jeda atau putuskan sambungan aplikasi VPN anda sebelum bermula.';

  @override
  String get youCanTurnIt =>
      'Anda boleh menghidupkannya semula apabila selesai.';

  @override
  String get turnOnMirroringOn => 'Hidupkan pencerminan pada TV';

  @override
  String get samsungLgAndMost =>
      'Samsung, LG dan kebanyakan TV Android menerima pencerminan secara automatik.';

  @override
  String get otherTvsOpenInput =>
      'TV lain: buka Input / Sumber dan pilih Pencerminan Skrin atau Miracast.';

  @override
  String get keepTheTvOn =>
      'Kekalkan TV pada skrin itu semasa telefon anda menyambung.';

  @override
  String get tapStartAndPick => 'Ketik Mula dan pilih TV anda';

  @override
  String get tapStartOnThe => 'Ketik Mula pada skrin Pencerminan Skrin.';

  @override
  String get androidOpensSmartView =>
      'Android membuka Smart View / Cast. Ketik TV anda dalam senarai.';

  @override
  String get ifTheTvAsks =>
      'Jika TV bertanya, pilih Benarkan atau masukkan PIN yang dipaparkan pada skrin.';

  @override
  String get youreMirroring => 'Anda sedang mencerminkan';

  @override
  String get everythingOnYourPhone =>
      'Semua yang ada pada telefon anda kini dipaparkan pada TV.';

  @override
  String get turnThePhoneSideways =>
      'Pusingkan telefon secara mendatar untuk video dan permainan skrin penuh.';

  @override
  String get toStopTapStop =>
      'Untuk berhenti, ketik Henti atau gunakan pemberitahuan cast.';

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
  String get bedroomTv => 'TV Bilik Tidur';

  @override
  String get officeDisplay => 'Paparan pejabat';

  @override
  String get clearHistory => 'Kosongkan sejarah?';

  @override
  String get thisRemovesEverythingYouve =>
      'Ini mengalih keluar semua yang anda cast daripada senarai ini.';

  @override
  String get clear => 'Kosongkan';

  @override
  String get clearHistory2 => 'Kosongkan sejarah';

  @override
  String get noHistoryYet => 'Belum ada sejarah';

  @override
  String get everythingYouCastWill =>
      'Semua yang anda cast akan disenaraikan di sini supaya anda boleh menemuinya semula.';

  @override
  String get today => 'Hari ini';

  @override
  String get yesterday => 'Semalam';

  @override
  String get earlier => 'Lebih awal';

  @override
  String get swipeAnItemTo => 'Leret item untuk mengalih keluarnya';

  @override
  String get delete => 'Padam';

  @override
  String removed(Object title) {
    return '“$title” dialih keluar';
  }

  @override
  String get undo => 'Buat asal';

  @override
  String get photos => 'Foto';

  @override
  String get albums => 'Album';

  @override
  String get videos => 'Video';

  @override
  String get gallery => 'Galeri';

  @override
  String get music => 'Muzik';

  @override
  String get songs => 'Lagu';

  @override
  String get media => 'Media';

  @override
  String get browseTheWeb => 'Layari web';

  @override
  String get goPro => 'Dapatkan Pro';

  @override
  String cast(Object title) {
    return 'Cast $title';
  }

  @override
  String get screenMirroringStartMirroring =>
      'Pencerminan Skrin. Mula mencerminkan';

  @override
  String readyToMirrorTo(Object device) {
    return 'Sedia untuk mencerminkan ke $device';
  }

  @override
  String get showYourPhoneOn =>
      'Tunjukkan telefon anda pada TV secara masa nyata.';

  @override
  String get startMirroring => 'Mula Mencerminkan';

  @override
  String get tvRemote => 'Alat Kawalan Jauh TV';

  @override
  String get controlYourTv => 'Kawal TV anda';

  @override
  String get youtubeMore => 'YouTube & lagi';

  @override
  String get openTheBrowser => 'Buka pelayar';

  @override
  String get searchOrTypeA => 'Cari atau taip laman web';

  @override
  String get howToConnectOpen => 'Cara menyambung. Buka panduan visual';

  @override
  String get visualGuideForEvery => 'Panduan visual untuk setiap ciri';

  @override
  String get language => 'Bahasa';

  @override
  String get done => 'Selesai';

  @override
  String get enterAValidHttp =>
      'Masukkan pautan http(s) atau rtsp yang sah, cth. URL .m3u8 atau .mp4.';

  @override
  String get linkStream => 'Strim pautan';

  @override
  String get iptvLinkCast => 'IPTV / Cast Pautan';

  @override
  String get castALink => 'Cast pautan';

  @override
  String get pasteADirectVideo =>
      'Tampal URL video terus, M3U8 atau strim IPTV.';

  @override
  String get paste => 'Tampal';

  @override
  String get castLink => 'Cast pautan';

  @override
  String get allowAccessToYour =>
      'Benarkan akses kepada media anda untuk cast. Anda boleh menukarnya dalam Tetapan.';

  @override
  String get video => 'Video';

  @override
  String get castMusic => 'Cast Muzik';

  @override
  String get noMusicFound => 'Tiada muzik ditemui';

  @override
  String get addSongsToYour =>
      'Tambah lagu ke telefon anda dan ia akan dipaparkan di sini.';

  @override
  String get shuffle => 'Rawak';

  @override
  String get playAll => 'Main semua';

  @override
  String photo(Object formatShortDate) {
    return 'Foto · $formatShortDate';
  }

  @override
  String get photo2 => 'Foto';

  @override
  String get castPhotos => 'Cast Foto';

  @override
  String get select => 'Pilih';

  @override
  String get noPhotosHere => 'Tiada foto di sini';

  @override
  String get photosYouTakeOr =>
      'Foto yang anda ambil atau simpan akan dipaparkan dalam album ini.';

  @override
  String photos2(Object name, Object count) {
    return '$name, $count foto';
  }

  @override
  String photoFrom(Object formatShortDate) {
    return 'Foto daripada $formatShortDate';
  }

  @override
  String get allPhotos => 'Semua foto';

  @override
  String get slideshow => 'Tayangan slaid';

  @override
  String get interval => 'Sela';

  @override
  String get transition => 'Peralihan';

  @override
  String get fade => 'Pudar';

  @override
  String get slide => 'Gelongsor';

  @override
  String get zoom => 'Zum';

  @override
  String get startSlideshow => 'Mula tayangan slaid';

  @override
  String get castVideos => 'Cast Video';

  @override
  String get noVideosYet => 'Belum ada video';

  @override
  String get videosYouRecordOr =>
      'Video yang anda rakam atau muat turun akan dipaparkan di sini, sedia untuk di-cast.';

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
  String get screenMirroringSession => 'Sesi pencerminan skrin';

  @override
  String get mirroringDidntStartTap =>
      'Pencerminan tidak bermula. Ketik Mula semula dan pilih TV anda dalam senarai.';

  @override
  String get openSmartViewOr =>
      'Buka Smart View atau Cast daripada tetapan pantas telefon anda untuk mencerminkan.';

  @override
  String get quality => 'Kualiti';

  @override
  String get adjustsToYourWi =>
      'Menyesuaikan dengan Wi-Fi anda untuk gambar paling lancar.';

  @override
  String upToLowerIt(Object label) {
    return 'Sehingga $label. Turunkan jika gambar tersekat-sekat.';
  }

  @override
  String get stillNeedHelp => 'Masih perlukan bantuan?';

  @override
  String get startingScreenMirroring => 'Memulakan pencerminan skrin…';

  @override
  String mirroringTo(Object value) {
    return 'Mencerminkan ke $value';
  }

  @override
  String get stopping => 'Menghentikan…';

  @override
  String get readyToMirror => 'Sedia untuk mencerminkan';

  @override
  String get beforeYouStart => 'Sebelum anda bermula';

  @override
  String get phoneAndTvAre => 'Telefon dan TV berada pada Wi-Fi yang sama';

  @override
  String get noVpnIsConnected => 'Tiada VPN disambungkan pada telefon anda';

  @override
  String get tvIsOnWith => 'TV dihidupkan dengan Pencerminan Skrin didayakan';

  @override
  String get phoneIsCloseTo => 'Telefon dekat dengan TV';

  @override
  String get stopMirroring => 'Henti mencerminkan';

  @override
  String get startMirroring2 => 'Mula mencerminkan';

  @override
  String get stop => 'Henti';

  @override
  String get start => 'Mula';

  @override
  String get duration => 'Tempoh';

  @override
  String get adIsLoading => 'Iklan sedang dimuatkan';

  @override
  String get ad => 'Iklan';

  @override
  String get mirrorYourScreenTo => 'Cerminkan skrin anda ke mana-mana TV';

  @override
  String get showYourPhoneOnThe =>
      'Tunjukkan telefon anda pada skrin besar dengan satu ketikan — tanpa kabel, tanpa kerumitan.';

  @override
  String get shareMemoriesWithThe =>
      'Kongsi kenangan dengan seluruh bilik dan kekalkan kawalan daripada telefon anda.';

  @override
  String get castFromWebApps => 'Cast daripada web & aplikasi';

  @override
  String get sendVideosFromYoutube =>
      'Hantar video daripada YouTube, Facebook dan mana-mana laman web terus ke TV anda.';

  @override
  String pageOf(Object value, Object length) {
    return 'Halaman $value daripada $length';
  }

  @override
  String get getStarted => 'Mulakan';

  @override
  String get localNetwork => 'Rangkaian Tempatan';

  @override
  String get findTvsAndStreaming =>
      'Cari TV dan peranti penstriman pada Wi-Fi anda.';

  @override
  String get notifications => 'Pemberitahuan';

  @override
  String get showCastingControlsWhile =>
      'Tunjukkan kawalan cast semasa anda menggunakan aplikasi lain.';

  @override
  String get photosVideosMusic => 'Foto, Video & Muzik';

  @override
  String get pickWhatYouWantTo =>
      'Pilih apa yang anda mahu cast daripada galeri dan pustaka anda.';

  @override
  String get screenCapture => 'Tangkapan Skrin';

  @override
  String get mirrorYourScreenYoull =>
      'Cerminkan skrin anda. Anda akan mengesahkan setiap sesi.';

  @override
  String get webVideo => 'Video web';

  @override
  String get link => 'Pautan';

  @override
  String get screenMirroring2 => 'Pencerminan skrin';

  @override
  String nowCastingOpenRemote(Object title) {
    return 'Sedang cast $title. Buka alat kawalan jauh';
  }

  @override
  String castingTo2(Object value) {
    return 'Cast ke $value';
  }

  @override
  String get nowCasting => 'Sedang cast';

  @override
  String get nothingIsCasting => 'Tiada apa yang di-cast';

  @override
  String get pickAPhotoVideo =>
      'Pilih foto, video, lagu atau video web untuk menghantarnya ke TV anda.';

  @override
  String get backToHome => 'Kembali ke utama';

  @override
  String slide2(Object formatDuration) {
    return 'Slaid $formatDuration';
  }

  @override
  String get back10Seconds => 'Undur 10 saat';

  @override
  String get forward10Seconds => 'Maju 10 saat';

  @override
  String get tvVolume => 'Kelantangan TV';

  @override
  String tvVolumePercent(Object round) {
    return 'Kelantangan TV $round peratus';
  }

  @override
  String get upNext => 'Seterusnya';

  @override
  String get addPhotos => 'Tambah foto';

  @override
  String get addVideos => 'Tambah video';

  @override
  String get nothingElseInThe => 'Tiada lagi dalam baris gilir.';

  @override
  String play2(Object title) {
    return 'Main $title';
  }

  @override
  String get unknownDevice => 'Peranti tidak diketahui';

  @override
  String get perWeek => 'seminggu';

  @override
  String get perYear => 'setahun';

  @override
  String get payOnce => 'bayar sekali';

  @override
  String get wirelessScreenMirroring => 'Pencerminan skrin tanpa wayar';

  @override
  String get castVideosPhotosMusic => 'Cast video, foto & muzik';

  @override
  String get fullTvRemoteControl => 'Kawalan jauh TV penuh';

  @override
  String get worksWithAllMajor => 'Berfungsi dengan semua TV utama';

  @override
  String get smoothLagFreeStreaming => 'Penstriman lancar tanpa lag';

  @override
  String get noAds => 'Tiada iklan';

  @override
  String get welcomeToCastflowPro => 'Selamat datang ke Cast ke TV Pro!';

  @override
  String get purchaseCancelled => 'Pembelian dibatalkan.';

  @override
  String get purchasePendingProUnlocks =>
      'Pembelian belum selesai. Pro dibuka sebaik sahaja kedai mengesahkannya.';

  @override
  String get purchaseFailedPleaseTry => 'Pembelian gagal. Sila cuba lagi.';

  @override
  String get theStoreIsntAvailable => 'Kedai tidak tersedia sekarang.';

  @override
  String get close => 'Tutup';

  @override
  String get goProWithCastflow => 'DAPATKAN PRO DENGAN CAST KE TV';

  @override
  String get unlockEveryFeature => 'Buka semua ciri';

  @override
  String get renewsAutomaticallyUntilCancelled =>
      'Diperbaharui secara automatik sehingga dibatalkan.';

  @override
  String get oneTimePurchaseNo => 'Pembelian sekali. Tiada langganan.';

  @override
  String get continueAction => 'Teruskan';

  @override
  String get privacyPolicy => 'Dasar Privasi';

  @override
  String get termsAndConditions => 'Terma dan Syarat';

  @override
  String get cancelAnytime => 'Batal pada bila-bila masa';

  @override
  String get loadingPrice => 'Memuatkan harga…';

  @override
  String get pricesUnavailableTapTo =>
      'Harga tidak tersedia · Ketik untuk cuba lagi';

  @override
  String get noPlansAvailableRight => 'Tiada pelan tersedia sekarang.';

  @override
  String get weekly => 'Mingguan';

  @override
  String get yearly => 'Tahunan';

  @override
  String get lifetime => 'Seumur hidup';

  @override
  String get bestValue => 'Nilai terbaik';

  @override
  String get disconnectFromTv => 'Putuskan sambungan daripada TV?';

  @override
  String get thisStopsWhatIs =>
      'Ini menghentikan apa yang sedang dimainkan atau dicerminkan.';

  @override
  String get useTouchpad => 'Gunakan pad sentuh';

  @override
  String get useDPad => 'Gunakan D-pad';

  @override
  String receiversDontAcceptRemote(Object label) {
    return 'Penerima $label tidak menerima arahan kawalan jauh.';
  }

  @override
  String someButtonsAreUnavailable(Object label) {
    return 'Sesetengah butang tidak tersedia pada $label.';
  }

  @override
  String get idle => 'SEKAT';

  @override
  String get playing => 'MEMAIN';

  @override
  String get paused => 'DIJEDA';

  @override
  String get noTvConnected => 'Tiada TV disambungkan';

  @override
  String get mute2 => 'SENYAP';

  @override
  String vol(Object volume) {
    return 'VOL $volume';
  }

  @override
  String get noTvConnectedTap =>
      'Tiada TV disambungkan. Ketik untuk memilih peranti';

  @override
  String get tapToChooseA => 'Ketik untuk memilih peranti';

  @override
  String isntSupportedBy(Object label, Object label2) {
    return '$label tidak disokong oleh $label2';
  }

  @override
  String get touchpadSwipeToMove =>
      'Pad sentuh. Leret untuk bergerak, ketik untuk memilih.';

  @override
  String get swipeToMoveTap => 'Leret untuk bergerak · Ketik untuk memilih';

  @override
  String get navigationIsntSupportedBy => 'Navigasi tidak disokong oleh TV ini';

  @override
  String get vol2 => 'VOL';

  @override
  String get auto => 'Auto';

  @override
  String get automatic => 'Automatik';

  @override
  String get googleCastFirst => 'Google Cast dahulu';

  @override
  String get dlnaUpnpFirst => 'DLNA / UPnP dahulu';

  @override
  String get miracastFirst => 'Miracast dahulu';

  @override
  String get tvOnly => 'TV sahaja';

  @override
  String get phoneAndTv => 'Telefon dan TV';

  @override
  String get phoneOnly => 'Telefon sahaja';

  @override
  String get touchpad => 'Pad sentuh';

  @override
  String get doMyPhoneAnd =>
      'Adakah telefon dan TV saya memerlukan Wi-Fi yang sama?';

  @override
  String get yesDiscoveryAndCasting =>
      'Ya. Penemuan dan cast kekal pada rangkaian tempatan anda, jadi kedua-duanya mesti berada pada Wi-Fi yang sama (nama jalur yang sama masih boleh menjadi rangkaian berbeza).';

  @override
  String get myRouterHasAp => 'Penghala saya ada “pengasingan AP / klien”';

  @override
  String get isolationBlocksDevicesFrom =>
      'Pengasingan menghalang peranti daripada melihat satu sama lain. Matikannya dalam tetapan penghala, atau gunakan rangkaian bukan tetamu.';

  @override
  String get findingYourTv => 'Mencari TV anda';

  @override
  String get myTvDoesntAppear => 'TV saya tidak muncul dalam senarai';

  @override
  String get turnOnCastingScreen =>
      'Hidupkan cast / pencerminan skrin pada TV, bangunkannya daripada siap sedia, kemudian ketik Imbas semula. Benarkan kebenaran Rangkaian Tempatan jika diminta.';

  @override
  String get onlySomeDevicesShow => 'Hanya sesetengah peranti dipaparkan';

  @override
  String get olderTvsMayNeed =>
      'TV lama mungkin memerlukan kemas kini perisian tegar. TV Miracast hanya muncul semasa input “Pencerminan Skrin” dibuka.';

  @override
  String get connectionFailsOrTimes => 'Sambungan gagal atau tamat masa';

  @override
  String get restartTheTvApp =>
      'Mulakan semula aplikasi TV atau TV, dekati penghala, dan terima sebarang gesaan pada skrin TV.';

  @override
  String get itKeepsReconnectingTo => 'Ia terus menyambung semula ke TV lama';

  @override
  String get turnOffAutoConnect =>
      'Matikan “Auto-sambung ke TV terakhir” dalam Tetapan → Cast.';

  @override
  String get mirroringIsLaggy => 'Pencerminan tersekat-sekat';

  @override
  String get chooseALowerQuality =>
      'Pilih kualiti lebih rendah (720p atau 480p), tutup aplikasi berat dan gunakan rangkaian Wi-Fi 5 GHz.';

  @override
  String get thePictureIsRotated => 'Gambar diputar atau dipotong';

  @override
  String get toggleAutoRotateOn =>
      'Hidupkan Autoputar pada skrin Pencerminan Skrin.';

  @override
  String get sound => 'Bunyi';

  @override
  String get thereIsNoSound => 'Tiada bunyi pada TV';

  @override
  String get makeSureAudioIs =>
      'Pastikan Audio dihidupkan dalam Pencerminan Skrin dan semak Tetapan → Cast → Output audio. Sesetengah penerima tidak menyokong audio telefon.';

  @override
  String get tvRemote2 => 'Alat kawalan jauh TV';

  @override
  String get someRemoteButtonsAre =>
      'Sesetengah butang kawalan jauh dikelabukan';

  @override
  String get eachReceiverSupportsDifferent =>
      'Setiap penerima menyokong arahan berbeza. Chromecast dan DLNA hanya menyokong main balik dan kelantangan; Miracast tidak mempunyai saluran kawalan jauh.';

  @override
  String get canCastflowTurnMy =>
      'Bolehkah Cast ke TV menghidupkan TV saya atau menukar input?';

  @override
  String get onlyOnTvsThat =>
      'Hanya pada TV yang mendedahkan arahan tersebut melalui rangkaian. Butang yang tidak disokong dilumpuhkan dan bukan berpura-pura berfungsi.';

  @override
  String get helpFaq => 'Bantuan & Soalan Lazim';

  @override
  String get stepByStepConnection => 'Panduan sambungan langkah demi langkah';

  @override
  String androidSdk(Object release, Object sdkInt) {
    return 'Android $release (SDK $sdkInt)';
  }

  @override
  String get noEmailAppFound => 'Tiada aplikasi e-mel ditemui.';

  @override
  String get enjoyingCastflow => 'Menyukai Cast ke TV?';

  @override
  String get sorryToHearThat => 'Maaf mendengarnya';

  @override
  String get thanksHowCanWe =>
      'Terima kasih! Bagaimana kami boleh menambah baik?';

  @override
  String get wereGladYouLike => 'Kami gembira anda menyukainya!';

  @override
  String get youMadeOurDay => 'Anda menceriakan hari kami!';

  @override
  String get tapToExit => 'Ketik untuk keluar';

  @override
  String get selectARating => 'Pilih penilaian';

  @override
  String get sendFeedback => 'Hantar maklum balas';

  @override
  String get rateUs => 'Nilai kami';

  @override
  String get rateYourExperienceBefore =>
      'Nilaikan pengalaman anda sebelum anda pergi.';

  @override
  String get tapAStarTo => 'Ketik bintang untuk menilai Cast ke TV.';

  @override
  String get general => 'Umum';

  @override
  String get english => 'Inggeris';

  @override
  String get defaultQuality => 'Kualiti lalai';

  @override
  String get autoConnectToLast => 'Auto-sambung ke TV terakhir';

  @override
  String get appearance => 'Penampilan';

  @override
  String get light => 'Cerah';

  @override
  String get dark => 'Gelap';

  @override
  String get system => 'Sistem';

  @override
  String get aboutSupport => 'Perihal & sokongan';

  @override
  String get rateApp => 'Nilai aplikasi';

  @override
  String get feedback => 'Maklum balas';

  @override
  String get termsConditions => 'Terma & Syarat';

  @override
  String get version => 'Versi';

  @override
  String get castflowProIsActive => 'Cast ke TV Pro aktif';

  @override
  String get upgradeToPremium => 'Naik taraf ke Premium';

  @override
  String get castflowPremium => 'Cast ke TV Premium';

  @override
  String get thanksForYourSupport =>
      'Terima kasih atas sokongan anda. Nikmati cast tanpa iklan.';

  @override
  String get noAds1080pMirroring =>
      'Tiada iklan, pencerminan 1080p & cast tanpa had';

  @override
  String get upgrade => 'Naik taraf';

  @override
  String get mirrorCastBeautifullySimple => 'Cermin & cast, cantik dan mudah';

  @override
  String get thisActionMayContain => 'Tindakan ini mungkin mengandungi iklan';

  @override
  String get webCast => 'Cast Web';

  @override
  String get castThisVideo => 'Cast video ini';

  @override
  String get searchOrTypeAWeb => 'Cari atau taip alamat web';

  @override
  String get removeBookmark => 'Alih keluar penanda buku';

  @override
  String get bookmark => 'Penanda buku';

  @override
  String get quickAccess => 'Akses pantas';

  @override
  String open2(Object title) {
    return 'Buka $title';
  }

  @override
  String get bookmarks => 'Penanda buku';

  @override
  String get noBookmarks => 'Tiada penanda buku';

  @override
  String get tapTheBookmarkIcon =>
      'Ketik ikon penanda buku dalam bar alamat untuk menyimpan halaman.';

  @override
  String get noHistory => 'Tiada sejarah';

  @override
  String get pagesYouVisitShow =>
      'Halaman yang anda lawati dipaparkan di sini.';

  @override
  String get remove => 'Alih keluar';

  @override
  String resultOn(Object value, Object host) {
    return 'Hasil $value pada $host';
  }

  @override
  String get aSimulatedPageResult => 'Hasil halaman simulasi';

  @override
  String get videosOnThisPage => 'Video pada halaman ini';

  @override
  String get pickOneToSend => 'Pilih satu untuk dihantar ke TV anda.';

  @override
  String get onboardHotspotTitle => 'Tiada Wi-Fi? Gunakan hotspot anda';

  @override
  String get onboardHotspotBody =>
      'Hidupkan hotspot telefon anda dan sambungkan TV anda kepadanya. Cast berfungsi sama seperti pada Wi-Fi.';

  @override
  String get stillCantFindTitle => 'Masih tidak menemui TV anda?';

  @override
  String get stillCantFindBody =>
      'Sebaliknya sambungkan TV anda ke hotspot telefon anda:';

  @override
  String get hotspotStep4 =>
      'Ketik Cuba semula dan pilih TV anda daripada senarai';

  @override
  String get castOverHotspot =>
      'Tiada Wi-Fi? Cast melalui hotspot telefon anda:';

  @override
  String get queue => 'Baris gilir';

  @override
  String get addMusic => 'Tambah muzik';

  @override
  String get connectWithWifi => 'Sambung dengan Wi-Fi';

  @override
  String get continueWithHotspot => 'Teruskan dengan hotspot';

  @override
  String get noWifiAlertMessage =>
      'Anda menggunakan data mudah alih. Sambungkan telefon dan TV anda ke Wi-Fi yang sama, atau hidupkan hotspot telefon anda dan sertainya daripada TV.';

  @override
  String get checkingNetwork => 'Menyemak rangkaian...';

  @override
  String get discoveryStopped => 'Penemuan dihentikan';

  @override
  String get discoveryStoppedHint =>
      'Penemuan dihentikan. Ketik cari untuk mencari peranti berdekatan.';

  @override
  String get search => 'Cari';

  @override
  String get permissionNeededToDiscover =>
      'Kebenaran lokasi diperlukan untuk menemui peranti pada Wi-Fi.';

  @override
  String get locationServicesDisabled => 'Perkhidmatan Lokasi Dilumpuhkan';

  @override
  String get openLocationSettings => 'Buka Tetapan Lokasi';

  @override
  String get openAppSettings => 'Buka Tetapan Aplikasi';

  @override
  String get subscriptionExpired => 'Langganan anda telah tamat tempoh.';

  @override
  String get noPurchasesFound => 'Tiada pembelian terdahulu ditemui.';

  @override
  String get restore => 'Pulihkan';

  @override
  String get permissionNeeded => 'Kebenaran Diperlukan';

  @override
  String get permissionBlockedInSettings => 'Kebenaran Disekat dalam Tetapan';

  @override
  String get grantPermission => 'Berikan Kebenaran';

  @override
  String get checkAgain => 'Semak Semula';

  @override
  String get appName => 'Cast ke TV';

  @override
  String get allowPermission => 'Benarkan Kebenaran';

  @override
  String get openSettings => 'Buka Tetapan';

  @override
  String get noNetworkMessage =>
      'Hidupkan Wi-Fi (rangkaian yang sama dengan TV), atau kongsi hotspot telefon dan sambungkan TV kepadanya.';

  @override
  String get turnOnWifi => 'Hidupkan Wi-Fi';

  @override
  String get waitingForNetwork =>
      'Kami akan mula mencari TV anda sebaik sahaja anda bersambung.';

  @override
  String get howHotspotWorks =>
      'Bagaimana penghantaran melalui hotspot berfungsi?';

  @override
  String get preparingForTv => 'Menyediakan untuk TV anda…';

  @override
  String convertingForTv(int percent) {
    return 'Menukar untuk TV anda… $percent%';
  }

  @override
  String get lookingForTvsOnHotspot => 'Mencari TV pada hotspot anda';

  @override
  String get noInternetConnection =>
      'Tiada sambungan internet. Semak sambungan anda dan cuba lagi.';

  @override
  String get convertingToTvFormat => 'Menukar kepada format TV anda';

  @override
  String get playMode => 'Mod main';

  @override
  String get playModeOnce => 'Main sekali';

  @override
  String get playModeAutoplay => 'Main automatik';

  @override
  String get playModeRepeatAll => 'Ulang semua';

  @override
  String get playModeRepeatOne => 'Ulang satu';

  @override
  String convertingExplain(Object from, Object to) {
    return 'TV anda tidak dapat memainkan $from secara terus, jadi ia ditukar kepada $to.';
  }

  @override
  String get convertingKeepOpen =>
      'Biarkan aplikasi terbuka. Ia akan bermula sendiri pada TV anda apabila siap.';

  @override
  String get checkingTvFormats =>
      'Menyemak apa yang boleh dimainkan oleh TV anda…';

  @override
  String convertingTimeLeft(Object time) {
    return 'Kira-kira $time lagi';
  }
}
