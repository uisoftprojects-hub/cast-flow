// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get networkRequiredTitle => 'Немає з’єднання з Wi-Fi';

  @override
  String get networkRequiredMessage =>
      'Телефон і телевізор мають бути в одній мережі Wi-Fi для трансляції.';

  @override
  String get openWifiSettings => 'Відкрити налаштування Wi-Fi';

  @override
  String get useMobileHotspot => 'Використати мобільну точку доступу';

  @override
  String get hotspotInstruction =>
      'Підключіть телевізор до мобільної точки доступу.';

  @override
  String get hotspotStep1 => 'Увімкніть мобільну точку доступу';

  @override
  String get hotspotStep2 => 'Підключіть до неї телевізор';

  @override
  String get hotspotStep3 => 'Поверніться до застосунку';

  @override
  String get openHotspotSettings => 'Відкрити налаштування точки доступу';

  @override
  String get hotspotAutoCheck =>
      'Ми автоматично перевіримо ще раз, коли ви повернетеся.';

  @override
  String get hotspotDetected => 'Точку доступу ввімкнено. Шукаємо телевізор…';

  @override
  String get searchingDevices => 'Пошук пристроїв поблизу...';

  @override
  String get waitingForTvOnHotspot =>
      'Очікуємо, поки телевізор приєднається до точки доступу…';

  @override
  String get usingHotspot => 'Використовується мобільна точка доступу';

  @override
  String devicesFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Знайдено $count пристрою',
      many: 'Знайдено $count пристроїв',
      few: 'Знайдено $count пристрої',
      one: 'Знайдено 1 пристрій',
    );
    return '$_temp0';
  }

  @override
  String get retry => 'Повторити';

  @override
  String get scanAgain => 'Сканувати знову';

  @override
  String get isolationTitle => 'Телевізор не відповідає';

  @override
  String get isolationHint =>
      'Пристрій приєднався до точки доступу, але не відповідає. Точка доступу може блокувати трафік між пристроями (ізоляція клієнтів). Вимкніть це в налаштуваннях точки доступу або скористайтеся мережею Wi-Fi.';

  @override
  String get connecting => 'Підключення…';

  @override
  String get connected => 'Підключено';

  @override
  String get connectionFailed => 'Не вдалося підключитися';

  @override
  String get connectFailedHint =>
      'Переконайтеся, що телефон і телевізор в одній мережі, і спробуйте ще раз.';

  @override
  String get hotspotConnectHint =>
      'Точка доступу може блокувати трафік між пристроями. Перевірте налаштування ізоляції клієнтів.';

  @override
  String get networkLostTitle => 'Мережеве з’єднання втрачено';

  @override
  String get networkLostMessage =>
      'Знову підключіться до Wi-Fi або точки доступу, а потім до телевізора.';

  @override
  String get reconnect => 'Підключити знову';

  @override
  String reconnectTo(String name) {
    return 'Підключити знову до $name';
  }

  @override
  String get tapToReconnect => 'Торкніться, щоб підключити знову';

  @override
  String get pairingRequired => 'Потрібне сполучення';

  @override
  String get pairingEnterCode => 'Введіть код, який показано на телевізорі.';

  @override
  String get pairingApproveOnTv =>
      'Подивіться на телевізор і торкніться «Дозволити», щоб продовжити.';

  @override
  String get connect => 'Підключити';

  @override
  String get cancel => 'Скасувати';

  @override
  String get pairingIncorrectCode => 'Невірний код. Спробуйте ще раз.';

  @override
  String get pairingTimedOut => 'Час сполучення минув';

  @override
  String get tryAgain => 'Спробувати ще раз';

  @override
  String get pairingDeclined => 'Телевізор відхилив підключення';

  @override
  String pairingTooManyAttempts(int seconds) {
    return 'Забагато невірних кодів. Зачекайте $seconds с і запросіть новий код.';
  }

  @override
  String get pairingCooldownOver => 'Тепер можна запросити новий код.';

  @override
  String get pairingRequestNewCode => 'Запросити новий код';

  @override
  String get pairingNetworkLost =>
      'Мережу втрачено під час сполучення. Знову підключіться до Wi-Fi і спробуйте ще раз.';

  @override
  String get pairingFailed => 'Не вдалося зв’язати з телевізором.';

  @override
  String pairingCodeField(int length) {
    return 'Код сполучення, символів: $length';
  }

  @override
  String pairingCodeBox(int index, int total) {
    return 'Поле коду $index з $total';
  }

  @override
  String get pairingEmptyBox => 'порожньо';

  @override
  String get pairingPaired => 'Сполучено';

  @override
  String get forgetDevice => 'Забути пристрій';

  @override
  String forgetDeviceMessage(String name) {
    return '$name потрібно буде сполучити знову наступного разу.';
  }

  @override
  String get forget => 'Забути';

  @override
  String get castVideo => 'Транслювати відео';

  @override
  String castVideoCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Знайдено $count відео. Транслювати відео',
      many: 'Знайдено $count відео. Транслювати відео',
      few: 'Знайдено $count відео. Транслювати відео',
      one: 'Знайдено 1 відео. Транслювати відео',
    );
    return '$_temp0';
  }

  @override
  String get noVideoYet => 'На цій сторінці ще немає відео.';

  @override
  String get videoFound => 'Знайдено відео';

  @override
  String get videoFoundMessage => 'Відтворіть його на телевізорі.';

  @override
  String get castAction => 'Транслювати';

  @override
  String get dismiss => 'Закрити';

  @override
  String videosFound(int count) {
    return 'Знайдено відео ($count)';
  }

  @override
  String get castToTv => 'Трансляція на ТБ';

  @override
  String get protectedVideo => 'Захищене, не можна транслювати';

  @override
  String get videoThumbnail => 'Мініатюра відео';

  @override
  String castingTo(String device) {
    return 'Трансляція на $device';
  }

  @override
  String get stopCasting => 'Зупинити трансляцію';

  @override
  String get play => 'Відтворити';

  @override
  String get pause => 'Пауза';

  @override
  String get volume => 'Гучність';

  @override
  String get seekPosition => 'Позиція відтворення';

  @override
  String get showControls => 'Показати елементи керування';

  @override
  String get hideControls => 'Сховати елементи керування';

  @override
  String get formatUnsupportedTitle => 'Формат не підтримується';

  @override
  String formatUnsupported(String device, String format) {
    return '$device не може відтворювати відео $format. Спробуйте інше відео на цій сторінці або скористайтеся дзеркалюванням екрана.';
  }

  @override
  String get videoExpired =>
      'Посилання на відео застаріло. Перезавантажте сторінку й спробуйте ще раз.';

  @override
  String get refreshingVideo => 'Отримуємо нове посилання на відео…';

  @override
  String get browserBack => 'Назад';

  @override
  String get browserForward => 'Вперед';

  @override
  String get browserStartPage => 'Початкова сторінка';

  @override
  String get browserReload => 'Оновити';

  @override
  String get ok => 'OK';

  @override
  String get home => 'Головна';

  @override
  String get devices => 'Пристрої';

  @override
  String get history => 'Історія';

  @override
  String get settings => 'Налаштування';

  @override
  String get goodMorning => 'Доброго ранку';

  @override
  String get goodAfternoon => 'Добрий день';

  @override
  String get goodEvening => 'Добрий вечір';

  @override
  String get couldntOpenTheLink => 'Не вдалося відкрити посилання.';

  @override
  String get castflowLogo => 'Логотип Трансляції на ТБ';

  @override
  String get somethingWentWrong => 'Щось пішло не так';

  @override
  String get weCouldntLoadThis =>
      'Зараз не вдалося це завантажити. Спробуйте ще раз.';

  @override
  String get apps => 'Застосунки';

  @override
  String open(Object name) {
    return 'Відкрити $name';
  }

  @override
  String get smartTv => 'Смарт-ТБ';

  @override
  String get chromecast => 'Chromecast';

  @override
  String get fireTv => 'Fire TV';

  @override
  String get roku => 'Roku';

  @override
  String get dlnaRenderer => 'Рендерер DLNA';

  @override
  String get miracast => 'Miracast';

  @override
  String get up => 'Вгору';

  @override
  String get down => 'Вниз';

  @override
  String get left => 'Вліво';

  @override
  String get right => 'Вправо';

  @override
  String get menu => 'Меню';

  @override
  String get input => 'Джерело';

  @override
  String get playPause => 'Відтворення / Пауза';

  @override
  String get previous => 'Попередній';

  @override
  String get next => 'Наступний';

  @override
  String get rewind => 'Перемотати назад';

  @override
  String get volumeUp => 'Гучніше';

  @override
  String get volumeDown => 'Тихіше';

  @override
  String get mute => 'Вимкнути звук';

  @override
  String connectedTo(Object name) {
    return 'Підключено до $name';
  }

  @override
  String get chooseADevice => 'Виберіть пристрій';

  @override
  String get connectionGuide => 'Посібник із підключення';

  @override
  String get lookingForTvsOn => 'Пошук телевізорів у вашій мережі Wi-Fi';

  @override
  String foundSoFar(Object found) {
    return 'Поки що знайдено: $found';
  }

  @override
  String deviceFound(Object found, Object value) {
    return 'Знайдено пристроїв: $found$value';
  }

  @override
  String get disconnect => 'Відключити';

  @override
  String signalOf4(Object level) {
    return 'Сигнал $level із 4';
  }

  @override
  String get connecting2 => 'Підключення';

  @override
  String get theTvRemoteNeeds =>
      'Для пульта потрібен підключений телевізор. Виберіть його нижче.';

  @override
  String get connectToATv => 'Підключіться до телевізора, щоб продовжити.';

  @override
  String get findingTvs => 'Пошук телевізорів…';

  @override
  String get makeSureYourTv => 'Переконайтеся, що телевізор увімкнено';

  @override
  String get notConnected => 'Не підключено';

  @override
  String get tapToFindYour => 'Торкніться, щоб знайти телевізор';

  @override
  String get connectionFailed2 => 'Не вдалося підключитися';

  @override
  String tapToManageDevices(Object label) {
    return '$label. Торкніться, щоб керувати пристроями';
  }

  @override
  String get joinTheSameWi => 'Приєднайтеся до тієї самої мережі Wi-Fi';

  @override
  String get connectYourPhoneAnd =>
      'Підключіть телефон і телевізор до однієї мережі Wi-Fi.';

  @override
  String get turnOnCastingOn => 'Увімкніть трансляцію на телевізорі';

  @override
  String get enableScreenMirroringMiracast =>
      'Увімкніть дзеркалювання екрана, Miracast або Google Cast у налаштуваннях телевізора.';

  @override
  String get scanForDevices => 'Пошук пристроїв';

  @override
  String get openDevicesInCastflow =>
      'Відкрийте «Пристрої» в застосунку Трансляція на ТБ і зачекайте кілька секунд, поки з’явиться телевізор.';

  @override
  String get tapConnect => 'Торкніться «Підключити»';

  @override
  String get acceptThePromptOn =>
      'Прийміть запит на телевізорі, якщо він з’явиться. Це все!';

  @override
  String get howToConnect => 'Як підключитися';

  @override
  String get fourQuickStepsTo => 'Чотири швидкі кроки до великого екрана.';

  @override
  String get gotIt => 'Зрозуміло';

  @override
  String step(Object number, Object title, Object body) {
    return 'Крок $number. $title. $body';
  }

  @override
  String get homeWiFi => 'Домашній Wi-Fi';

  @override
  String get router => 'Роутер';

  @override
  String get settingsConnection => 'Налаштування › Підключення';

  @override
  String get inputHdmi1 => 'Джерело: HDMI 1';

  @override
  String get screenMirroring => 'Дзеркалювання екрана';

  @override
  String get networkHomeWiFi => 'Мережа: домашній Wi-Fi';

  @override
  String get livingRoomTv => 'Телевізор у вітальні';

  @override
  String get allowCastflowToConnect =>
      'Дозволити Трансляції на ТБ підключитися?';

  @override
  String get deny => 'Заборонити';

  @override
  String get allow => 'Дозволити';

  @override
  String get yourTv => 'Ваш телевізор';

  @override
  String get findYourTv => 'Знайдіть телевізор';

  @override
  String connectTo(Object name) {
    return 'Підключитися до $name';
  }

  @override
  String connected2(Object label) {
    return 'Підключено · $label';
  }

  @override
  String get openTvRemote => 'Відкрити пульт ТБ';

  @override
  String get sameWiFiNetwork => 'Та сама мережа Wi-Fi';

  @override
  String get yourPhoneAndTv =>
      'Телефон і телевізор мають бути підключені до однієї мережі Wi-Fi.';

  @override
  String get tvIsOnAnd => 'Телевізор увімкнено й він готовий';

  @override
  String get turnOnScreenMirroring =>
      'Увімкніть дзеркалювання екрана, Cast або Miracast на телевізорі.';

  @override
  String get noVpnOrGuest => 'Без VPN і гостьової мережі';

  @override
  String get vpnsAndGuestIsolated =>
      'VPN та гостьові/ізольовані мережі Wi-Fi приховують пристрої один від одного.';

  @override
  String get localNetworkAccess => 'Доступ до локальної мережі';

  @override
  String get allowCastflowToFind =>
      'Дозвольте Трансляції на ТБ знаходити пристрої у вашій мережі, коли з’явиться запит.';

  @override
  String get noTvFound => 'Телевізор не знайдено';

  @override
  String get checkThatYourPhone =>
      'Перевірте, чи телефон і телевізор підключені до однієї мережі Wi-Fi, і скануйте знову.';

  @override
  String get noWiFiRouter =>
      'Немає роутера Wi-Fi? Скористайтеся точкою доступу';

  @override
  String searchingForTvsFound(Object length) {
    return 'Пошук телевізорів. Знайдено: $length.';
  }

  @override
  String tvsFound(Object length) {
    return 'Знайдено телевізорів: $length';
  }

  @override
  String get connectToYourTv => 'Підключіться до телевізора';

  @override
  String get connectYourPhoneAndTv =>
      'Підключіть телефон і телевізор до однієї мережі Wi-Fi.';

  @override
  String get turnOnTheTv =>
      'Увімкніть телевізор і відкрийте вхід «Дзеркалювання екрана» / Cast.';

  @override
  String get tapTheConnectionBar =>
      'Торкніться панелі підключення на головному екрані, щоб знайти телевізор.';

  @override
  String get tapConnectAndAccept =>
      'Торкніться «Підключити» й прийміть запит на телевізорі, якщо він з’явиться.';

  @override
  String get mirrorYourScreen => 'Дзеркальте екран';

  @override
  String get connectToYourTvFirst => 'Спочатку підключіться до телевізора.';

  @override
  String get openScreenMirroringFrom =>
      'Відкрийте «Дзеркалювання екрана» на головному екрані.';

  @override
  String get pickAQualityAnd => 'Виберіть якість і торкніться «Почати».';

  @override
  String get allowScreenCaptureWhen =>
      'Дозвольте захоплення екрана, коли Android запитає.';

  @override
  String get castPhotosVideosMusic => 'Транслюйте фото, відео та музику';

  @override
  String get openPhotosVideosOr =>
      'Відкрийте «Фото», «Відео» або «Музика» на головному екрані.';

  @override
  String get pickWhatYouWant => 'Виберіть, що показати.';

  @override
  String get itPlaysOnThe =>
      'Воно відтворюється на телевізорі; керуйте з телефона або зі сповіщення.';

  @override
  String get useTheTvRemote => 'Користуйтеся пультом ТБ';

  @override
  String get openTvRemoteOn => 'Відкрийте «Пульт ТБ» на головному екрані.';

  @override
  String get useTheDPad =>
      'Користуйтеся D-pad або проводьте пальцем по тачпаду, щоб рухатися, і торкайтеся OK, щоб вибрати.';

  @override
  String get buttonsATvDoesnt =>
      'Кнопки, які телевізор не підтримує, виділено сірим.';

  @override
  String get castFromTheWeb => 'Транслюйте з вебу та застосунків';

  @override
  String get tapTheBrowserBar =>
      'Торкніться панелі браузера або застосунку на головному екрані.';

  @override
  String get playAVideoOn => 'Відтворіть відео на сайті.';

  @override
  String get tapCastThisVideo =>
      'Торкніться «Транслювати це відео», щоб надіслати його на телевізор.';

  @override
  String get screenMirroringHelp => 'Довідка з дзеркалювання екрана';

  @override
  String get connectYourPhoneTo => 'Підключіть телефон до Wi-Fi.';

  @override
  String get onTheTvOpen =>
      'На телевізорі відкрийте «Налаштування» → «Мережа» й приєднайтеся до тієї самої мережі Wi-Fi.';

  @override
  String get guestOrOfficeNetworks =>
      'Гостьові або офісні мережі часто блокують дзеркалювання; користуйтеся домашнім Wi-Fi або точкою доступу телефона.';

  @override
  String get turnOffVpn => 'Вимкніть VPN';

  @override
  String get aVpnHidesYour => 'VPN приховує телевізор від телефона.';

  @override
  String get pauseOrDisconnectYour =>
      'Призупиніть або вимкніть застосунок VPN перед початком.';

  @override
  String get youCanTurnIt => 'Ви зможете знову ввімкнути його, коли закінчите.';

  @override
  String get turnOnMirroringOn => 'Увімкніть дзеркалювання на телевізорі';

  @override
  String get samsungLgAndMost =>
      'Samsung, LG і більшість телевізорів Android приймають дзеркалювання автоматично.';

  @override
  String get otherTvsOpenInput =>
      'Інші телевізори: відкрийте «Вхід / Джерело» та виберіть «Дзеркалювання екрана» або Miracast.';

  @override
  String get keepTheTvOn =>
      'Залиште телевізор на цьому екрані, поки телефон підключається.';

  @override
  String get tapStartAndPick => 'Торкніться «Почати» та виберіть телевізор';

  @override
  String get tapStartOnThe => 'Торкніться «Почати» на екрані дзеркалювання.';

  @override
  String get androidOpensSmartView =>
      'Android відкриває Smart View / Cast. Торкніться свого телевізора в списку.';

  @override
  String get ifTheTvAsks =>
      'Якщо телевізор запитає, виберіть «Дозволити» або введіть PIN-код з екрана.';

  @override
  String get youreMirroring => 'Ви дзеркалите екран';

  @override
  String get everythingOnYourPhone =>
      'Усе з вашого телефона тепер показується на телевізорі.';

  @override
  String get turnThePhoneSideways =>
      'Поверніть телефон горизонтально для відео та ігор на весь екран.';

  @override
  String get toStopTapStop =>
      'Щоб зупинити, торкніться «Зупинити» або скористайтеся сповіщенням про трансляцію.';

  @override
  String get vpn => 'VPN';

  @override
  String get off => 'Вимк.';

  @override
  String get hdmi1 => 'HDMI 1';

  @override
  String get hdmi2 => 'HDMI 2';

  @override
  String get smartView => 'Smart View';

  @override
  String get bedroomTv => 'Телевізор у спальні';

  @override
  String get officeDisplay => 'Офісний екран';

  @override
  String get clearHistory => 'Очистити історію?';

  @override
  String get thisRemovesEverythingYouve =>
      'Це видалить усе, що ви транслювали, з цього списку.';

  @override
  String get clear => 'Очистити';

  @override
  String get clearHistory2 => 'Очистити історію';

  @override
  String get noHistoryYet => 'Історії ще немає';

  @override
  String get everythingYouCastWill =>
      'Усе, що ви транслюєте, буде тут, щоб ви могли знайти це знову.';

  @override
  String get today => 'Сьогодні';

  @override
  String get yesterday => 'Учора';

  @override
  String get earlier => 'Раніше';

  @override
  String get swipeAnItemTo => 'Проведіть по елементу, щоб видалити його';

  @override
  String get delete => 'Видалити';

  @override
  String removed(Object title) {
    return 'Видалено «$title»';
  }

  @override
  String get undo => 'Скасувати';

  @override
  String get photos => 'Фото';

  @override
  String get albums => 'Альбоми';

  @override
  String get videos => 'Відео';

  @override
  String get gallery => 'Галерея';

  @override
  String get music => 'Музика';

  @override
  String get songs => 'Пісні';

  @override
  String get media => 'Медіа';

  @override
  String get browseTheWeb => 'Перегляд вебу';

  @override
  String get goPro => 'Перейти на Pro';

  @override
  String cast(Object title) {
    return 'Транслювати $title';
  }

  @override
  String get screenMirroringStartMirroring =>
      'Дзеркалювання екрана. Почати дзеркалювання';

  @override
  String readyToMirrorTo(Object device) {
    return 'Готово до дзеркалювання на $device';
  }

  @override
  String get showYourPhoneOn =>
      'Показуйте екран телефона на телевізорі в реальному часі.';

  @override
  String get startMirroring => 'Почати дзеркалювання';

  @override
  String get tvRemote => 'Пульт ТБ';

  @override
  String get controlYourTv => 'Керуйте телевізором';

  @override
  String get youtubeMore => 'YouTube та інше';

  @override
  String get openTheBrowser => 'Відкрити браузер';

  @override
  String get searchOrTypeA => 'Шукайте або введіть адресу сайту';

  @override
  String get howToConnectOpen =>
      'Як підключитися. Відкрити візуальний посібник';

  @override
  String get visualGuideForEvery => 'Візуальний посібник для кожної функції';

  @override
  String get language => 'Мова';

  @override
  String get done => 'Готово';

  @override
  String get enterAValidHttp =>
      'Введіть дійсне посилання http(s) або rtsp, наприклад URL .m3u8 чи .mp4.';

  @override
  String get linkStream => 'Потік за посиланням';

  @override
  String get iptvLinkCast => 'IPTV / Трансляція посилання';

  @override
  String get castALink => 'Транслювати посилання';

  @override
  String get pasteADirectVideo =>
      'Вставте пряме посилання на відео, M3U8 або потік IPTV.';

  @override
  String get paste => 'Вставити';

  @override
  String get castLink => 'Транслювати посилання';

  @override
  String get allowAccessToYour =>
      'Дозвольте доступ до медіа, щоб транслювати їх. Це можна змінити в налаштуваннях.';

  @override
  String get video => 'Відео';

  @override
  String get castMusic => 'Транслювати музику';

  @override
  String get noMusicFound => 'Музику не знайдено';

  @override
  String get addSongsToYour =>
      'Додайте пісні на телефон, і вони з’являться тут.';

  @override
  String get shuffle => 'Перемішати';

  @override
  String get playAll => 'Відтворити все';

  @override
  String photo(Object formatShortDate) {
    return 'Фото · $formatShortDate';
  }

  @override
  String get photo2 => 'Фото';

  @override
  String get castPhotos => 'Транслювати фото';

  @override
  String get select => 'Вибрати';

  @override
  String get noPhotosHere => 'Тут немає фото';

  @override
  String get photosYouTakeOr =>
      'Фото, які ви робите чи зберігаєте, з’являтимуться в цьому альбомі.';

  @override
  String photos2(Object name, Object count) {
    return '$name, фото: $count';
  }

  @override
  String photoFrom(Object formatShortDate) {
    return 'Фото від $formatShortDate';
  }

  @override
  String get allPhotos => 'Усі фото';

  @override
  String get slideshow => 'Слайдшоу';

  @override
  String get interval => 'Інтервал';

  @override
  String get transition => 'Перехід';

  @override
  String get fade => 'Згасання';

  @override
  String get slide => 'Зсув';

  @override
  String get zoom => 'Масштаб';

  @override
  String get startSlideshow => 'Почати слайдшоу';

  @override
  String get castVideos => 'Транслювати відео';

  @override
  String get noVideosYet => 'Відео ще немає';

  @override
  String get videosYouRecordOr =>
      'Відео, які ви записуєте чи завантажуєте, з’являтимуться тут, готові до трансляції.';

  @override
  String video2(Object resolution) {
    return 'Відео · $resolution';
  }

  @override
  String cast2(Object title, Object formatDuration) {
    return '$title, $formatDuration. Транслювати';
  }

  @override
  String get tv => 'ТБ';

  @override
  String get screenMirroringSession => 'Сеанс дзеркалювання екрана';

  @override
  String get mirroringDidntStartTap =>
      'Дзеркалювання не почалося. Торкніться «Почати» ще раз і виберіть телевізор у списку.';

  @override
  String get openSmartViewOr =>
      'Відкрийте Smart View або Cast у швидких налаштуваннях телефона для дзеркалювання.';

  @override
  String get quality => 'Якість';

  @override
  String get adjustsToYourWi =>
      'Підлаштовується під ваш Wi-Fi для найплавнішого зображення.';

  @override
  String upToLowerIt(Object label) {
    return 'До $label. Знизьте, якщо зображення смикається.';
  }

  @override
  String get stillNeedHelp => 'Потрібна допомога?';

  @override
  String get startingScreenMirroring => 'Запуск дзеркалювання екрана…';

  @override
  String mirroringTo(Object value) {
    return 'Дзеркалювання на $value';
  }

  @override
  String get stopping => 'Зупинка…';

  @override
  String get readyToMirror => 'Готово до дзеркалювання';

  @override
  String get beforeYouStart => 'Перед початком';

  @override
  String get phoneAndTvAre => 'Телефон і телевізор в одній мережі Wi-Fi';

  @override
  String get noVpnIsConnected => 'На телефоні не підключено VPN';

  @override
  String get tvIsOnWith =>
      'Телевізор увімкнено, дзеркалювання екрана ввімкнено';

  @override
  String get phoneIsCloseTo => 'Телефон близько до телевізора';

  @override
  String get stopMirroring => 'Зупинити дзеркалювання';

  @override
  String get startMirroring2 => 'Почати дзеркалювання';

  @override
  String get stop => 'Зупинити';

  @override
  String get start => 'Почати';

  @override
  String get duration => 'Тривалість';

  @override
  String get adIsLoading => 'Реклама завантажується';

  @override
  String get ad => 'Реклама';

  @override
  String get mirrorYourScreenTo => 'Дзеркальте екран на будь-який телевізор';

  @override
  String get showYourPhoneOnThe =>
      'Покажіть телефон на великому екрані одним дотиком — без кабелів і клопоту.';

  @override
  String get shareMemoriesWithThe =>
      'Діліться спогадами з усією кімнатою й керуйте з телефона.';

  @override
  String get castFromWebApps => 'Транслюйте з вебу та застосунків';

  @override
  String get sendVideosFromYoutube =>
      'Надсилайте відео з YouTube, Facebook і будь-якого сайту прямо на телевізор.';

  @override
  String pageOf(Object value, Object length) {
    return 'Сторінка $value із $length';
  }

  @override
  String get getStarted => 'Почати';

  @override
  String get localNetwork => 'Локальна мережа';

  @override
  String get findTvsAndStreaming =>
      'Знаходьте телевізори та стрімінгові пристрої у своїй мережі Wi-Fi.';

  @override
  String get notifications => 'Сповіщення';

  @override
  String get showCastingControlsWhile =>
      'Показувати елементи керування трансляцією, поки ви користуєтеся іншими застосунками.';

  @override
  String get photosVideosMusic => 'Фото, відео та музика';

  @override
  String get pickWhatYouWantTo =>
      'Виберіть, що транслювати з галереї та медіатеки.';

  @override
  String get screenCapture => 'Захоплення екрана';

  @override
  String get mirrorYourScreenYoull =>
      'Дзеркальте екран. Ви підтверджуватимете кожен сеанс.';

  @override
  String get webVideo => 'Веб-відео';

  @override
  String get link => 'Посилання';

  @override
  String get screenMirroring2 => 'Дзеркалювання екрана';

  @override
  String nowCastingOpenRemote(Object title) {
    return 'Зараз транслюється $title. Відкрити пульт';
  }

  @override
  String castingTo2(Object value) {
    return 'Трансляція на $value';
  }

  @override
  String get nowCasting => 'Зараз транслюється';

  @override
  String get nothingIsCasting => 'Нічого не транслюється';

  @override
  String get pickAPhotoVideo =>
      'Виберіть фото, відео, пісню або веб-відео, щоб надіслати на телевізор.';

  @override
  String get backToHome => 'Назад на головну';

  @override
  String slide2(Object formatDuration) {
    return 'Слайд $formatDuration';
  }

  @override
  String get back10Seconds => 'Назад на 10 секунд';

  @override
  String get forward10Seconds => 'Вперед на 10 секунд';

  @override
  String get tvVolume => 'Гучність ТБ';

  @override
  String tvVolumePercent(Object round) {
    return 'Гучність ТБ: $round відсотків';
  }

  @override
  String get upNext => 'Далі';

  @override
  String get addPhotos => 'Додати фото';

  @override
  String get addVideos => 'Додати відео';

  @override
  String get nothingElseInThe => 'У черзі більше нічого немає.';

  @override
  String play2(Object title) {
    return 'Відтворити $title';
  }

  @override
  String get unknownDevice => 'Невідомий пристрій';

  @override
  String get perWeek => 'на тиждень';

  @override
  String get perYear => 'на рік';

  @override
  String get payOnce => 'одноразова оплата';

  @override
  String get wirelessScreenMirroring => 'Бездротове дзеркалювання екрана';

  @override
  String get castVideosPhotosMusic => 'Транслюйте відео, фото та музику';

  @override
  String get fullTvRemoteControl => 'Повноцінний пульт ТБ';

  @override
  String get worksWithAllMajor => 'Працює з усіма провідними телевізорами';

  @override
  String get smoothLagFreeStreaming => 'Плавна трансляція без затримок';

  @override
  String get noAds => 'Без реклами';

  @override
  String get welcomeToCastflowPro => 'Ласкаво просимо до Трансляції на ТБ Pro!';

  @override
  String get purchaseCancelled => 'Покупку скасовано.';

  @override
  String get purchasePendingProUnlocks =>
      'Покупка очікує. Pro розблокується, щойно магазин підтвердить її.';

  @override
  String get purchaseFailedPleaseTry => 'Покупка не вдалася. Спробуйте ще раз.';

  @override
  String get theStoreIsntAvailable => 'Магазин зараз недоступний.';

  @override
  String get close => 'Закрити';

  @override
  String get goProWithCastflow => 'ПЕРЕЙДІТЬ НА PRO З ТРАНСЛЯЦІЄЮ НА ТБ';

  @override
  String get unlockEveryFeature => 'Розблокуйте всі функції';

  @override
  String get renewsAutomaticallyUntilCancelled =>
      'Автоматично поновлюється, доки не скасуєте.';

  @override
  String get oneTimePurchaseNo => 'Одноразова покупка. Без підписки.';

  @override
  String get continueAction => 'Продовжити';

  @override
  String get privacyPolicy => 'Політика конфіденційності';

  @override
  String get termsAndConditions => 'Умови користування';

  @override
  String get cancelAnytime => 'Скасуйте будь-коли';

  @override
  String get loadingPrice => 'Завантаження ціни…';

  @override
  String get pricesUnavailableTapTo =>
      'Ціни недоступні · Торкніться, щоб повторити';

  @override
  String get noPlansAvailableRight => 'Зараз немає доступних планів.';

  @override
  String get weekly => 'Щотижня';

  @override
  String get yearly => 'Щороку';

  @override
  String get lifetime => 'Назавжди';

  @override
  String get bestValue => 'Найвигідніше';

  @override
  String get disconnectFromTv => 'Відключитися від телевізора?';

  @override
  String get thisStopsWhatIs =>
      'Це зупинить те, що зараз відтворюється або дзеркалиться.';

  @override
  String get useTouchpad => 'Використати тачпад';

  @override
  String get useDPad => 'Використати D-pad';

  @override
  String receiversDontAcceptRemote(Object label) {
    return 'Приймачі $label не приймають команди пульта.';
  }

  @override
  String someButtonsAreUnavailable(Object label) {
    return 'Деякі кнопки недоступні на $label.';
  }

  @override
  String get idle => 'ПРОСТІЙ';

  @override
  String get playing => 'ВІДТВОРЕННЯ';

  @override
  String get paused => 'ПАУЗА';

  @override
  String get noTvConnected => 'ТБ не підключено';

  @override
  String get mute2 => 'БЕЗ ЗВУКУ';

  @override
  String vol(Object volume) {
    return 'ГУЧН. $volume';
  }

  @override
  String get noTvConnectedTap =>
      'ТБ не підключено. Торкніться, щоб вибрати пристрій';

  @override
  String get tapToChooseA => 'Торкніться, щоб вибрати пристрій';

  @override
  String isntSupportedBy(Object label, Object label2) {
    return '$label не підтримується пристроєм $label2';
  }

  @override
  String get touchpadSwipeToMove =>
      'Тачпад. Проведіть, щоб рухатися, торкніться, щоб вибрати.';

  @override
  String get swipeToMoveTap =>
      'Проведіть, щоб рухатися · Торкніться, щоб вибрати';

  @override
  String get navigationIsntSupportedBy =>
      'Цей телевізор не підтримує навігацію';

  @override
  String get vol2 => 'ГУЧН.';

  @override
  String get auto => 'Авто';

  @override
  String get automatic => 'Автоматично';

  @override
  String get googleCastFirst => 'Спочатку Google Cast';

  @override
  String get dlnaUpnpFirst => 'Спочатку DLNA / UPnP';

  @override
  String get miracastFirst => 'Спочатку Miracast';

  @override
  String get tvOnly => 'Лише ТБ';

  @override
  String get phoneAndTv => 'Телефон і ТБ';

  @override
  String get phoneOnly => 'Лише телефон';

  @override
  String get touchpad => 'Тачпад';

  @override
  String get doMyPhoneAnd =>
      'Чи потрібен телефону й телевізору той самий Wi-Fi?';

  @override
  String get yesDiscoveryAndCasting =>
      'Так. Пошук і трансляція працюють у вашій локальній мережі, тому обидва пристрої мають бути в одному Wi-Fi (однакові назви діапазонів усе одно можуть бути різними мережами).';

  @override
  String get myRouterHasAp => 'У мого роутера є «ізоляція AP / клієнтів»';

  @override
  String get isolationBlocksDevicesFrom =>
      'Ізоляція не дозволяє пристроям бачити один одного. Вимкніть її в налаштуваннях роутера або скористайтеся негостьовою мережею.';

  @override
  String get findingYourTv => 'Пошук телевізора';

  @override
  String get myTvDoesntAppear => 'Мого телевізора немає в списку';

  @override
  String get turnOnCastingScreen =>
      'Увімкніть трансляцію / дзеркалювання екрана на телевізорі, виведіть його з режиму очікування й торкніться «Сканувати знову». Дайте дозвіл «Локальна мережа», якщо буде запит.';

  @override
  String get onlySomeDevicesShow => 'З’являються лише деякі пристрої';

  @override
  String get olderTvsMayNeed =>
      'Старішим телевізорам може знадобитися оновлення прошивки. Телевізори Miracast з’являються, лише поки відкрито їхній вхід «Дзеркалювання екрана».';

  @override
  String get connectionFailsOrTimes =>
      'Підключення не вдається або перевищено час очікування';

  @override
  String get restartTheTvApp =>
      'Перезапустіть застосунок на телевізорі або сам телевізор, підійдіть ближче до роутера й прийміть будь-який запит на екрані телевізора.';

  @override
  String get itKeepsReconnectingTo =>
      'Постійно підключається до старого телевізора';

  @override
  String get turnOffAutoConnect =>
      'Вимкніть «Автопідключення до останнього ТБ» у Налаштування → Трансляція.';

  @override
  String get mirroringIsLaggy => 'Дзеркалювання гальмує';

  @override
  String get chooseALowerQuality =>
      'Виберіть нижчу якість (720p або 480p), закрийте важкі застосунки й використовуйте мережу Wi-Fi 5 ГГц.';

  @override
  String get thePictureIsRotated => 'Зображення повернуте або обрізане';

  @override
  String get toggleAutoRotateOn =>
      'Увімкніть автоповорот на екрані дзеркалювання.';

  @override
  String get sound => 'Звук';

  @override
  String get thereIsNoSound => 'На телевізорі немає звуку';

  @override
  String get makeSureAudioIs =>
      'Переконайтеся, що звук увімкнено в дзеркалюванні екрана, і перевірте Налаштування → Трансляція → Вихід звуку. Деякі приймачі не підтримують звук із телефона.';

  @override
  String get tvRemote2 => 'Пульт ТБ';

  @override
  String get someRemoteButtonsAre => 'Деякі кнопки пульта виділено сірим';

  @override
  String get eachReceiverSupportsDifferent =>
      'Кожен приймач підтримує різні команди. Chromecast і DLNA підтримують лише відтворення та гучність; Miracast не має каналу пульта.';

  @override
  String get canCastflowTurnMy =>
      'Чи може Трансляція на ТБ вмикати телевізор або змінювати джерела?';

  @override
  String get onlyOnTvsThat =>
      'Лише на телевізорах, які відкривають ці команди через мережу. Непідтримувані кнопки вимкнені, а не вдають, що працюють.';

  @override
  String get helpFaq => 'Довідка та поширені запитання';

  @override
  String get stepByStepConnection => 'Покроковий посібник із підключення';

  @override
  String androidSdk(Object release, Object sdkInt) {
    return 'Android $release (SDK $sdkInt)';
  }

  @override
  String get noEmailAppFound => 'Не знайдено поштового застосунку.';

  @override
  String get enjoyingCastflow => 'Подобається Трансляція на ТБ?';

  @override
  String get sorryToHearThat => 'Шкода це чути';

  @override
  String get thanksHowCanWe => 'Дякуємо! Як нам покращитися?';

  @override
  String get wereGladYouLike => 'Раді, що вам подобається!';

  @override
  String get youMadeOurDay => 'Ви зробили наш день!';

  @override
  String get tapToExit => 'Торкніться, щоб вийти';

  @override
  String get selectARating => 'Виберіть оцінку';

  @override
  String get sendFeedback => 'Надіслати відгук';

  @override
  String get rateUs => 'Оцініть нас';

  @override
  String get rateYourExperienceBefore => 'Оцініть свій досвід, перш ніж піти.';

  @override
  String get tapAStarTo => 'Торкніться зірки, щоб оцінити Трансляцію на ТБ.';

  @override
  String get general => 'Загальні';

  @override
  String get english => 'Англійська';

  @override
  String get defaultQuality => 'Якість за замовчуванням';

  @override
  String get autoConnectToLast => 'Автопідключення до останнього ТБ';

  @override
  String get appearance => 'Вигляд';

  @override
  String get light => 'Світла';

  @override
  String get dark => 'Темна';

  @override
  String get system => 'Системна';

  @override
  String get aboutSupport => 'Про застосунок і підтримка';

  @override
  String get rateApp => 'Оцінити застосунок';

  @override
  String get feedback => 'Відгук';

  @override
  String get termsConditions => 'Умови користування';

  @override
  String get version => 'Версія';

  @override
  String get castflowProIsActive => 'Трансляція на ТБ Pro активна';

  @override
  String get upgradeToPremium => 'Перейти на Premium';

  @override
  String get castflowPremium => 'Трансляція на ТБ Premium';

  @override
  String get thanksForYourSupport =>
      'Дякуємо за підтримку. Насолоджуйтеся трансляцією без реклами.';

  @override
  String get noAds1080pMirroring =>
      'Без реклами, дзеркалювання 1080p і необмежена трансляція';

  @override
  String get upgrade => 'Оновити';

  @override
  String get mirrorCastBeautifullySimple =>
      'Дзеркалюйте й транслюйте — красиво просто';

  @override
  String get thisActionMayContain => 'Ця дія може містити рекламу';

  @override
  String get webCast => 'Веб-трансляція';

  @override
  String get castThisVideo => 'Транслювати це відео';

  @override
  String get searchOrTypeAWeb => 'Шукайте або введіть веб-адресу';

  @override
  String get removeBookmark => 'Видалити закладку';

  @override
  String get bookmark => 'Закладка';

  @override
  String get quickAccess => 'Швидкий доступ';

  @override
  String open2(Object title) {
    return 'Відкрити $title';
  }

  @override
  String get bookmarks => 'Закладки';

  @override
  String get noBookmarks => 'Немає закладок';

  @override
  String get tapTheBookmarkIcon =>
      'Торкніться значка закладки в адресному рядку, щоб зберегти сторінку.';

  @override
  String get noHistory => 'Немає історії';

  @override
  String get pagesYouVisitShow =>
      'Сторінки, які ви відвідуєте, з’являтимуться тут.';

  @override
  String get remove => 'Видалити';

  @override
  String resultOn(Object value, Object host) {
    return 'Результат $value на $host';
  }

  @override
  String get aSimulatedPageResult => 'Імітований результат сторінки';

  @override
  String get videosOnThisPage => 'Відео на цій сторінці';

  @override
  String get pickOneToSend => 'Виберіть одне, щоб надіслати на телевізор.';

  @override
  String get onboardHotspotTitle => 'Немає Wi-Fi? Скористайтеся точкою доступу';

  @override
  String get onboardHotspotBody =>
      'Увімкніть точку доступу на телефоні й підключіть до неї телевізор. Трансляція працює так само, як через Wi-Fi.';

  @override
  String get stillCantFindTitle => 'Досі не знаходите телевізор?';

  @override
  String get stillCantFindBody =>
      'Натомість підключіть телевізор до точки доступу телефона:';

  @override
  String get hotspotStep4 =>
      'Торкніться «Повторити» й виберіть телевізор зі списку';

  @override
  String get castOverHotspot =>
      'Немає Wi-Fi? Транслюйте через точку доступу телефона:';

  @override
  String get queue => 'Черга';

  @override
  String get addMusic => 'Додати музику';

  @override
  String get connectWithWifi => 'Підключитися через Wi-Fi';

  @override
  String get continueWithHotspot => 'Продовжити з точкою доступу';

  @override
  String get noWifiAlertMessage =>
      'Ви користуєтеся мобільним інтернетом. Підключіть телефон і телевізор до однієї мережі Wi-Fi або ввімкніть точку доступу телефона й приєднайте до неї телевізор.';

  @override
  String get checkingNetwork => 'Перевірка мережі...';

  @override
  String get discoveryStopped => 'Пошук зупинено';

  @override
  String get discoveryStoppedHint =>
      'Пошук зупинено. Торкніться «Пошук», щоб знайти пристрої поблизу.';

  @override
  String get search => 'Пошук';

  @override
  String get permissionNeededToDiscover =>
      'Для пошуку пристроїв у Wi-Fi потрібен дозвіл на геолокацію.';

  @override
  String get locationServicesDisabled => 'Служби геолокації вимкнено';

  @override
  String get openLocationSettings => 'Відкрити налаштування геолокації';

  @override
  String get openAppSettings => 'Відкрити налаштування застосунку';

  @override
  String get subscriptionExpired => 'Термін дії вашої підписки закінчився.';

  @override
  String get noPurchasesFound => 'Попередніх покупок не знайдено.';

  @override
  String get restore => 'Відновити';

  @override
  String get permissionNeeded => 'Потрібен дозвіл';

  @override
  String get permissionBlockedInSettings =>
      'Дозвіл заблоковано в налаштуваннях';

  @override
  String get grantPermission => 'Надати дозвіл';

  @override
  String get checkAgain => 'Перевірити ще раз';

  @override
  String get appName => 'Трансляція на ТБ';

  @override
  String get allowPermission => 'Дозволити';

  @override
  String get openSettings => 'Відкрити налаштування';

  @override
  String get noNetworkMessage =>
      'Увімкніть Wi-Fi (ту саму мережу, що й у телевізора) або роздайте точку доступу з телефона й під\'єднайте до неї телевізор.';

  @override
  String get turnOnWifi => 'Увімкнути Wi-Fi';

  @override
  String get waitingForNetwork =>
      'Ми почнемо шукати телевізор, щойно ви під\'єднаєтеся.';

  @override
  String get howHotspotWorks => 'Як працює трансляція через точку доступу?';

  @override
  String get preparingForTv => 'Підготовка для телевізора…';

  @override
  String convertingForTv(int percent) {
    return 'Конвертація для телевізора… $percent%';
  }

  @override
  String get lookingForTvsOnHotspot =>
      'Пошук телевізорів у вашій точці доступу';

  @override
  String get noInternetConnection =>
      'Немає підключення до інтернету. Перевірте з\'єднання й спробуйте ще раз.';

  @override
  String get convertingToTvFormat => 'Конвертація у формат вашого телевізора';

  @override
  String get playMode => 'Режим відтворення';

  @override
  String get playModeOnce => 'Відтворити раз';

  @override
  String get playModeAutoplay => 'Автовідтворення';

  @override
  String get playModeRepeatAll => 'Повторювати все';

  @override
  String get playModeRepeatOne => 'Повторювати один';

  @override
  String convertingExplain(Object from, Object to) {
    return 'Телевізор не може напряму відтворити $from, тому файл конвертується в $to.';
  }

  @override
  String get convertingKeepOpen =>
      'Не закривайте застосунок. Відтворення розпочнеться на телевізорі саме, щойно все буде готово.';

  @override
  String get checkingTvFormats =>
      'Перевіряємо, що вміє відтворювати телевізор…';

  @override
  String convertingTimeLeft(Object time) {
    return 'Залишилось близько $time';
  }
}
