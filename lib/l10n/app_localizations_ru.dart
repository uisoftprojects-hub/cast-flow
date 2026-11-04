// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get networkRequiredTitle => 'Нет подключения к Wi-Fi';

  @override
  String get networkRequiredMessage =>
      'Телефон и телевизор должны быть в одной сети Wi-Fi для трансляции.';

  @override
  String get openWifiSettings => 'Открыть настройки Wi-Fi';

  @override
  String get useMobileHotspot => 'Использовать точку доступа';

  @override
  String get hotspotInstruction =>
      'Подключите телевизор к точке доступа телефона.';

  @override
  String get hotspotStep1 => 'Включите точку доступа';

  @override
  String get hotspotStep2 => 'Подключите к ней телевизор';

  @override
  String get hotspotStep3 => 'Вернитесь в приложение';

  @override
  String get openHotspotSettings => 'Открыть настройки точки доступа';

  @override
  String get hotspotAutoCheck =>
      'Когда вы вернётесь, мы автоматически проверим снова.';

  @override
  String get hotspotDetected => 'Точка доступа включена. Ищем ваш телевизор…';

  @override
  String get searchingDevices => 'Поиск устройств поблизости...';

  @override
  String get waitingForTvOnHotspot =>
      'Ожидаем подключения телевизора к вашей точке доступа…';

  @override
  String get usingHotspot => 'Используется точка доступа телефона';

  @override
  String devicesFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Найдено $count устройства',
      many: 'Найдено $count устройств',
      few: 'Найдено $count устройства',
      one: 'Найдено 1 устройство',
    );
    return '$_temp0';
  }

  @override
  String get retry => 'Повторить';

  @override
  String get scanAgain => 'Сканировать снова';

  @override
  String get isolationTitle => 'Телевизор не отвечает';

  @override
  String get isolationHint =>
      'Устройство подключилось к вашей точке доступа, но не отвечает. Возможно, точка доступа блокирует связь между устройствами (изоляция клиентов). Отключите это в настройках точки доступа или используйте сеть Wi-Fi.';

  @override
  String get connecting => 'Подключение…';

  @override
  String get connected => 'Подключено';

  @override
  String get connectionFailed => 'Не удалось подключиться';

  @override
  String get connectFailedHint =>
      'Убедитесь, что телефон и телевизор в одной сети, и повторите попытку.';

  @override
  String get hotspotConnectHint =>
      'Возможно, точка доступа блокирует связь между устройствами. Проверьте настройку изоляции клиентов.';

  @override
  String get networkLostTitle => 'Сетевое соединение потеряно';

  @override
  String get networkLostMessage =>
      'Подключитесь снова к Wi-Fi или точке доступа, затем переподключитесь к телевизору.';

  @override
  String get reconnect => 'Переподключить';

  @override
  String reconnectTo(String name) {
    return 'Переподключиться к $name';
  }

  @override
  String get tapToReconnect => 'Нажмите для повторного подключения';

  @override
  String get pairingRequired => 'Требуется сопряжение';

  @override
  String get pairingEnterCode => 'Введите код, показанный на телевизоре.';

  @override
  String get pairingApproveOnTv =>
      'Посмотрите на телевизор и нажмите «Разрешить», чтобы продолжить.';

  @override
  String get connect => 'Подключить';

  @override
  String get cancel => 'Отмена';

  @override
  String get pairingIncorrectCode => 'Неверный код. Повторите попытку.';

  @override
  String get pairingTimedOut => 'Время сопряжения истекло';

  @override
  String get tryAgain => 'Повторить';

  @override
  String get pairingDeclined => 'Телевизор отклонил подключение';

  @override
  String pairingTooManyAttempts(int seconds) {
    return 'Слишком много неверных кодов. Подождите $seconds с и запросите новый код.';
  }

  @override
  String get pairingCooldownOver => 'Теперь можно запросить новый код.';

  @override
  String get pairingRequestNewCode => 'Запросить новый код';

  @override
  String get pairingNetworkLost =>
      'Сеть пропала во время сопряжения. Подключитесь к Wi-Fi и повторите.';

  @override
  String get pairingFailed => 'Не удалось выполнить сопряжение с телевизором.';

  @override
  String pairingCodeField(int length) {
    return 'Код сопряжения, символов: $length';
  }

  @override
  String pairingCodeBox(int index, int total) {
    return 'Поле $index из $total';
  }

  @override
  String get pairingEmptyBox => 'пусто';

  @override
  String get pairingPaired => 'Сопряжено';

  @override
  String get forgetDevice => 'Забыть устройство';

  @override
  String forgetDeviceMessage(String name) {
    return 'В следующий раз $name придётся сопрягать заново.';
  }

  @override
  String get forget => 'Забыть';

  @override
  String get castVideo => 'Транслировать видео';

  @override
  String castVideoCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Найдено $count видео. Транслировать видео',
      many: 'Найдено $count видео. Транслировать видео',
      few: 'Найдено $count видео. Транслировать видео',
      one: 'Найдено 1 видео. Транслировать видео',
    );
    return '$_temp0';
  }

  @override
  String get noVideoYet => 'На этой странице пока нет видео.';

  @override
  String get videoFound => 'Найдено видео';

  @override
  String get videoFoundMessage => 'Воспроизведите на телевизоре.';

  @override
  String get castAction => 'Трансляция';

  @override
  String get dismiss => 'Закрыть';

  @override
  String videosFound(int count) {
    return 'Найдено видео ($count)';
  }

  @override
  String get castToTv => 'Транслировать на ТВ';

  @override
  String get protectedVideo => 'Защищено, трансляция невозможна';

  @override
  String get videoThumbnail => 'Миниатюра видео';

  @override
  String castingTo(String device) {
    return 'Трансляция на $device';
  }

  @override
  String get stopCasting => 'Остановить трансляцию';

  @override
  String get play => 'Воспроизвести';

  @override
  String get pause => 'Пауза';

  @override
  String get volume => 'Громкость';

  @override
  String get seekPosition => 'Позиция воспроизведения';

  @override
  String get showControls => 'Показать элементы управления';

  @override
  String get hideControls => 'Скрыть элементы управления';

  @override
  String get formatUnsupportedTitle => 'Формат не поддерживается';

  @override
  String formatUnsupported(String device, String format) {
    return '$device не воспроизводит видео $format. Попробуйте другое видео на этой странице или используйте зеркалирование экрана.';
  }

  @override
  String get videoExpired =>
      'Ссылка на видео устарела. Перезагрузите страницу и повторите.';

  @override
  String get refreshingVideo => 'Получаем новую ссылку на видео…';

  @override
  String get browserBack => 'Назад';

  @override
  String get browserForward => 'Вперёд';

  @override
  String get browserStartPage => 'Стартовая страница';

  @override
  String get browserReload => 'Обновить';

  @override
  String get ok => 'ОК';

  @override
  String get home => 'Главная';

  @override
  String get devices => 'Устройства';

  @override
  String get history => 'История';

  @override
  String get settings => 'Настройки';

  @override
  String get goodMorning => 'Доброе утро';

  @override
  String get goodAfternoon => 'Добрый день';

  @override
  String get goodEvening => 'Добрый вечер';

  @override
  String get couldntOpenTheLink => 'Не удалось открыть ссылку.';

  @override
  String get castflowLogo => 'Логотип CastFlow';

  @override
  String get somethingWentWrong => 'Что-то пошло не так';

  @override
  String get weCouldntLoadThis =>
      'Сейчас не удалось загрузить. Повторите попытку.';

  @override
  String get apps => 'Приложения';

  @override
  String open(Object name) {
    return 'Открыть $name';
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
  String get up => 'Вверх';

  @override
  String get down => 'Вниз';

  @override
  String get left => 'Влево';

  @override
  String get right => 'Вправо';

  @override
  String get menu => 'Меню';

  @override
  String get input => 'Вход';

  @override
  String get playPause => 'Воспроизведение / пауза';

  @override
  String get previous => 'Назад';

  @override
  String get next => 'Далее';

  @override
  String get rewind => 'Перемотка назад';

  @override
  String get volumeUp => 'Громче';

  @override
  String get volumeDown => 'Тише';

  @override
  String get mute => 'Без звука';

  @override
  String connectedTo(Object name) {
    return 'Подключено к $name';
  }

  @override
  String get chooseADevice => 'Выберите устройство';

  @override
  String get connectionGuide => 'Руководство по подключению';

  @override
  String get lookingForTvsOn => 'Поиск телевизоров в вашей сети Wi-Fi';

  @override
  String foundSoFar(Object found) {
    return 'Найдено пока: $found';
  }

  @override
  String deviceFound(Object found, Object value) {
    return 'Найдено устройств: $found';
  }

  @override
  String get disconnect => 'Отключить';

  @override
  String signalOf4(Object level) {
    return 'Сигнал $level из 4';
  }

  @override
  String get connecting2 => 'Подключение';

  @override
  String get theTvRemoteNeeds =>
      'Для пульта нужен подключённый телевизор. Выберите его ниже.';

  @override
  String get connectToATv => 'Подключитесь к телевизору, чтобы продолжить.';

  @override
  String get findingTvs => 'Поиск телевизоров…';

  @override
  String get makeSureYourTv => 'Убедитесь, что телевизор включён';

  @override
  String get notConnected => 'Не подключено';

  @override
  String get tapToFindYour => 'Нажмите, чтобы найти телевизор';

  @override
  String get connectionFailed2 => 'Ошибка подключения';

  @override
  String tapToManageDevices(Object label) {
    return '$label. Нажмите для управления устройствами';
  }

  @override
  String get joinTheSameWi => 'Подключитесь к той же сети Wi-Fi';

  @override
  String get connectYourPhoneAnd =>
      'Подключите телефон и телевизор к одной сети Wi-Fi.';

  @override
  String get turnOnCastingOn => 'Включите трансляцию на телевизоре';

  @override
  String get enableScreenMirroringMiracast =>
      'Включите «Зеркалирование экрана», Miracast или Google Cast в настройках телевизора.';

  @override
  String get scanForDevices => 'Поиск устройств';

  @override
  String get openDevicesInCastflow =>
      'Откройте «Устройства» в CastFlow и подождите несколько секунд, пока появится телевизор.';

  @override
  String get tapConnect => 'Нажмите «Подключить»';

  @override
  String get acceptThePromptOn =>
      'Подтвердите запрос на телевизоре, если он появится. Готово!';

  @override
  String get howToConnect => 'Как подключиться';

  @override
  String get fourQuickStepsTo =>
      'Четыре простых шага, чтобы выйти на большой экран.';

  @override
  String get gotIt => 'Понятно';

  @override
  String step(Object number, Object title, Object body) {
    return 'Шаг $number. $title. $body';
  }

  @override
  String get homeWiFi => 'Домашний Wi-Fi';

  @override
  String get router => 'Роутер';

  @override
  String get settingsConnection => 'Настройки › Подключение';

  @override
  String get inputHdmi1 => 'Вход: HDMI 1';

  @override
  String get screenMirroring => 'Зеркалирование экрана';

  @override
  String get networkHomeWiFi => 'Сеть: домашний Wi-Fi';

  @override
  String get livingRoomTv => 'Телевизор в гостиной';

  @override
  String get allowCastflowToConnect => 'Разрешить CastFlow подключиться?';

  @override
  String get deny => 'Запретить';

  @override
  String get allow => 'Разрешить';

  @override
  String get yourTv => 'Ваш телевизор';

  @override
  String get findYourTv => 'Найдите свой телевизор';

  @override
  String connectTo(Object name) {
    return 'Подключиться к $name';
  }

  @override
  String connected2(Object label) {
    return 'Подключено · $label';
  }

  @override
  String get openTvRemote => 'Открыть пульт ТВ';

  @override
  String get sameWiFiNetwork => 'Одна сеть Wi-Fi';

  @override
  String get yourPhoneAndTv =>
      'Телефон и телевизор должны быть подключены к одной сети Wi-Fi.';

  @override
  String get tvIsOnAnd => 'Телевизор включён и готов';

  @override
  String get turnOnScreenMirroring =>
      'Включите «Зеркалирование экрана», Cast или Miracast на телевизоре.';

  @override
  String get noVpnOrGuest => 'Без VPN и гостевой сети';

  @override
  String get vpnsAndGuestIsolated =>
      'VPN и гостевой или изолированный Wi-Fi скрывают устройства друг от друга.';

  @override
  String get localNetworkAccess => 'Доступ к локальной сети';

  @override
  String get allowCastflowToFind =>
      'Разрешите CastFlow искать устройства в вашей сети, когда он попросит.';

  @override
  String get noTvFound => 'Телевизор не найден';

  @override
  String get checkThatYourPhone =>
      'Проверьте, что телефон и телевизор в одной сети Wi-Fi, и сканируйте снова.';

  @override
  String get noWiFiRouter => 'Нет роутера Wi-Fi? Используйте точку доступа';

  @override
  String searchingForTvsFound(Object length) {
    return 'Поиск телевизоров. Найдено: $length.';
  }

  @override
  String tvsFound(Object length) {
    return 'Найдено телевизоров: $length';
  }

  @override
  String get connectToYourTv => 'Подключитесь к телевизору';

  @override
  String get connectYourPhoneAndTv =>
      'Подключите телефон и телевизор к одной сети Wi-Fi.';

  @override
  String get turnOnTheTv =>
      'Включите телевизор и откройте вход «Зеркалирование экрана» / Cast.';

  @override
  String get tapTheConnectionBar =>
      'Нажмите панель подключения на главной, чтобы найти телевизор.';

  @override
  String get tapConnectAndAccept =>
      'Нажмите «Подключить» и подтвердите запрос на телевизоре, если он появится.';

  @override
  String get mirrorYourScreen => 'Зеркалирование экрана';

  @override
  String get connectToYourTvFirst => 'Сначала подключитесь к телевизору.';

  @override
  String get openScreenMirroringFrom =>
      'Откройте «Зеркалирование экрана» на главной.';

  @override
  String get pickAQualityAnd => 'Выберите качество и нажмите «Старт».';

  @override
  String get allowScreenCaptureWhen =>
      'Разрешите захват экрана, когда Android спросит.';

  @override
  String get castPhotosVideosMusic => 'Трансляция фото, видео и музыки';

  @override
  String get openPhotosVideosOr =>
      'Откройте «Фото», «Видео» или «Музыку» на главной.';

  @override
  String get pickWhatYouWant => 'Выберите, что показать.';

  @override
  String get itPlaysOnThe =>
      'Воспроизводится на телевизоре; управляйте с телефона или из уведомления.';

  @override
  String get useTheTvRemote => 'Используйте пульт ТВ';

  @override
  String get openTvRemoteOn => 'Откройте «Пульт ТВ» на главной.';

  @override
  String get useTheDPad =>
      'Двигайтесь кнопками-стрелками или свайпом по тачпаду, выбирайте кнопкой OK.';

  @override
  String get buttonsATvDoesnt =>
      'Кнопки, которые телевизор не поддерживает, неактивны.';

  @override
  String get castFromTheWeb => 'Трансляция из интернета и приложений';

  @override
  String get tapTheBrowserBar =>
      'Нажмите строку браузера или приложение на главной.';

  @override
  String get playAVideoOn => 'Запустите видео на сайте.';

  @override
  String get tapCastThisVideo =>
      'Нажмите «Транслировать это видео», чтобы отправить его на телевизор.';

  @override
  String get screenMirroringHelp => 'Справка по зеркалированию экрана';

  @override
  String get connectYourPhoneTo => 'Подключите телефон к Wi-Fi.';

  @override
  String get onTheTvOpen =>
      'На телевизоре откройте Настройки → Сеть и подключитесь к той же сети Wi-Fi.';

  @override
  String get guestOrOfficeNetworks =>
      'Гостевые и офисные сети часто блокируют зеркалирование; используйте домашний Wi-Fi или точку доступа телефона.';

  @override
  String get turnOffVpn => 'Отключите VPN';

  @override
  String get aVpnHidesYour => 'VPN скрывает телевизор от телефона.';

  @override
  String get pauseOrDisconnectYour =>
      'Приостановите или отключите приложение VPN перед началом.';

  @override
  String get youCanTurnIt => 'Потом его можно включить снова.';

  @override
  String get turnOnMirroringOn => 'Включите зеркалирование на телевизоре';

  @override
  String get samsungLgAndMost =>
      'Samsung, LG и большинство телевизоров Android принимают зеркалирование автоматически.';

  @override
  String get otherTvsOpenInput =>
      'Другие телевизоры: откройте «Вход / Источник» и выберите «Зеркалирование экрана» или Miracast.';

  @override
  String get keepTheTvOn =>
      'Держите телевизор на этом экране, пока телефон подключается.';

  @override
  String get tapStartAndPick => 'Нажмите «Старт» и выберите телевизор';

  @override
  String get tapStartOnThe => 'Нажмите «Старт» на экране зеркалирования.';

  @override
  String get androidOpensSmartView =>
      'Android откроет Smart View / Cast. Нажмите свой телевизор в списке.';

  @override
  String get ifTheTvAsks =>
      'Если телевизор спросит, выберите «Разрешить» или введите PIN-код с экрана.';

  @override
  String get youreMirroring => 'Вы транслируете экран';

  @override
  String get everythingOnYourPhone =>
      'Всё с вашего телефона теперь показывается на телевизоре.';

  @override
  String get turnThePhoneSideways =>
      'Поверните телефон для полноэкранных видео и игр.';

  @override
  String get toStopTapStop =>
      'Чтобы остановить, нажмите «Стоп» или используйте уведомление.';

  @override
  String get vpn => 'VPN';

  @override
  String get off => 'Выкл.';

  @override
  String get hdmi1 => 'HDMI 1';

  @override
  String get hdmi2 => 'HDMI 2';

  @override
  String get smartView => 'Smart View';

  @override
  String get bedroomTv => 'Телевизор в спальне';

  @override
  String get officeDisplay => 'Экран в офисе';

  @override
  String get clearHistory => 'Очистить историю?';

  @override
  String get thisRemovesEverythingYouve =>
      'Это удалит из списка всё, что вы транслировали.';

  @override
  String get clear => 'Очистить';

  @override
  String get clearHistory2 => 'Очистить историю';

  @override
  String get noHistoryYet => 'Истории пока нет';

  @override
  String get everythingYouCastWill =>
      'Всё, что вы транслируете, появится здесь, чтобы вы могли найти это снова.';

  @override
  String get today => 'Сегодня';

  @override
  String get yesterday => 'Вчера';

  @override
  String get earlier => 'Ранее';

  @override
  String get swipeAnItemTo => 'Смахните элемент, чтобы удалить';

  @override
  String get delete => 'Удалить';

  @override
  String removed(Object title) {
    return 'Удалено: «$title»';
  }

  @override
  String get undo => 'Отменить';

  @override
  String get photos => 'Фото';

  @override
  String get albums => 'Альбомы';

  @override
  String get videos => 'Видео';

  @override
  String get gallery => 'Галерея';

  @override
  String get music => 'Музыка';

  @override
  String get songs => 'Песни';

  @override
  String get media => 'Медиа';

  @override
  String get browseTheWeb => 'Интернет';

  @override
  String get goPro => 'Перейти на Pro';

  @override
  String cast(Object title) {
    return 'Транслировать $title';
  }

  @override
  String get screenMirroringStartMirroring =>
      'Зеркалирование экрана. Начать зеркалирование';

  @override
  String readyToMirrorTo(Object device) {
    return 'Готово к зеркалированию на $device';
  }

  @override
  String get showYourPhoneOn =>
      'Показывайте экран телефона на телевизоре в реальном времени.';

  @override
  String get startMirroring => 'Начать зеркалирование';

  @override
  String get tvRemote => 'Пульт ТВ';

  @override
  String get controlYourTv => 'Управляйте телевизором';

  @override
  String get youtubeMore => 'YouTube и другое';

  @override
  String get openTheBrowser => 'Открыть браузер';

  @override
  String get searchOrTypeA => 'Введите запрос или адрес сайта';

  @override
  String get howToConnectOpen =>
      'Как подключиться. Открыть наглядное руководство';

  @override
  String get visualGuideForEvery => 'Наглядное руководство по каждой функции';

  @override
  String get language => 'Язык';

  @override
  String get done => 'Готово';

  @override
  String get enterAValidHttp =>
      'Введите корректную ссылку http(s) или rtsp, например URL .m3u8 или .mp4.';

  @override
  String get linkStream => 'Трансляция по ссылке';

  @override
  String get iptvLinkCast => 'IPTV / трансляция ссылки';

  @override
  String get castALink => 'Транслировать ссылку';

  @override
  String get pasteADirectVideo =>
      'Вставьте прямую ссылку на видео, M3U8 или поток IPTV.';

  @override
  String get paste => 'Вставить';

  @override
  String get castLink => 'Транслировать ссылку';

  @override
  String get allowAccessToYour =>
      'Разрешите доступ к медиафайлам, чтобы их транслировать. Это можно изменить в настройках.';

  @override
  String get video => 'Видео';

  @override
  String get castMusic => 'Транслировать музыку';

  @override
  String get noMusicFound => 'Музыка не найдена';

  @override
  String get addSongsToYour =>
      'Добавьте песни на телефон, и они появятся здесь.';

  @override
  String get shuffle => 'Перемешать';

  @override
  String get playAll => 'Играть все';

  @override
  String photo(Object formatShortDate) {
    return 'Фото · $formatShortDate';
  }

  @override
  String get photo2 => 'Фото';

  @override
  String get castPhotos => 'Транслировать фото';

  @override
  String get select => 'Выбрать';

  @override
  String get noPhotosHere => 'Здесь нет фото';

  @override
  String get photosYouTakeOr =>
      'Фото, которые вы снимете или сохраните, появятся в этом альбоме.';

  @override
  String photos2(Object name, Object count) {
    return '$name, фото: $count';
  }

  @override
  String photoFrom(Object formatShortDate) {
    return 'Фото от $formatShortDate';
  }

  @override
  String get allPhotos => 'Все фото';

  @override
  String get slideshow => 'Слайд-шоу';

  @override
  String get interval => 'Интервал';

  @override
  String get transition => 'Переход';

  @override
  String get fade => 'Затухание';

  @override
  String get slide => 'Сдвиг';

  @override
  String get zoom => 'Масштаб';

  @override
  String get startSlideshow => 'Запустить слайд-шоу';

  @override
  String get castVideos => 'Транслировать видео';

  @override
  String get noVideosYet => 'Видео пока нет';

  @override
  String get videosYouRecordOr =>
      'Видео, которые вы запишете или скачаете, появятся здесь, готовые к трансляции.';

  @override
  String video2(Object resolution) {
    return 'Видео · $resolution';
  }

  @override
  String cast2(Object title, Object formatDuration) {
    return '$title, $formatDuration. Транслировать';
  }

  @override
  String get tv => 'TV';

  @override
  String get screenMirroringSession => 'Сеанс зеркалирования экрана';

  @override
  String get mirroringDidntStartTap =>
      'Зеркалирование не началось. Нажмите «Старт» ещё раз и выберите телевизор в списке.';

  @override
  String get openSmartViewOr =>
      'Откройте Smart View или Cast в быстрых настройках телефона, чтобы начать зеркалирование.';

  @override
  String get quality => 'Качество';

  @override
  String get adjustsToYourWi =>
      'Подстраивается под ваш Wi-Fi для максимально плавной картинки.';

  @override
  String upToLowerIt(Object label) {
    return 'До $label. Снизьте, если картинка тормозит.';
  }

  @override
  String get stillNeedHelp => 'Нужна помощь?';

  @override
  String get startingScreenMirroring => 'Запуск зеркалирования экрана…';

  @override
  String mirroringTo(Object value) {
    return 'Зеркалирование на $value';
  }

  @override
  String get stopping => 'Остановка…';

  @override
  String get readyToMirror => 'Готово к зеркалированию';

  @override
  String get beforeYouStart => 'Перед началом';

  @override
  String get phoneAndTvAre => 'Телефон и телевизор в одной сети Wi-Fi';

  @override
  String get noVpnIsConnected => 'На телефоне не подключён VPN';

  @override
  String get tvIsOnWith => 'Телевизор включён, зеркалирование экрана включено';

  @override
  String get phoneIsCloseTo => 'Телефон рядом с телевизором';

  @override
  String get stopMirroring => 'Остановить зеркалирование';

  @override
  String get startMirroring2 => 'Начать зеркалирование';

  @override
  String get stop => 'Стоп';

  @override
  String get start => 'Старт';

  @override
  String get duration => 'Длительность';

  @override
  String get adIsLoading => 'Загрузка рекламы';

  @override
  String get ad => 'Реклама';

  @override
  String get mirrorYourScreenTo => 'Зеркалируйте экран на любой телевизор';

  @override
  String get showYourPhoneOnThe =>
      'Покажите телефон на большом экране одним касанием: без проводов и лишних хлопот.';

  @override
  String get shareMemoriesWithThe =>
      'Делитесь воспоминаниями со всеми и управляйте с телефона.';

  @override
  String get castFromWebApps => 'Трансляция из интернета и приложений';

  @override
  String get sendVideosFromYoutube =>
      'Отправляйте видео из YouTube, Facebook и любого сайта прямо на телевизор.';

  @override
  String pageOf(Object value, Object length) {
    return 'Страница $value из $length';
  }

  @override
  String get getStarted => 'Начать';

  @override
  String get localNetwork => 'Локальная сеть';

  @override
  String get findTvsAndStreaming =>
      'Находите телевизоры и стриминговые устройства в вашей сети Wi-Fi.';

  @override
  String get notifications => 'Уведомления';

  @override
  String get showCastingControlsWhile =>
      'Показывать элементы управления трансляцией в других приложениях.';

  @override
  String get photosVideosMusic => 'Фото, видео и музыка';

  @override
  String get pickWhatYouWantTo =>
      'Выберите, что транслировать из галереи и медиатеки.';

  @override
  String get screenCapture => 'Захват экрана';

  @override
  String get mirrorYourScreenYoull =>
      'Зеркалирование экрана. Каждый сеанс нужно подтверждать.';

  @override
  String get webVideo => 'Веб-видео';

  @override
  String get link => 'Ссылка';

  @override
  String get screenMirroring2 => 'Зеркалирование экрана';

  @override
  String nowCastingOpenRemote(Object title) {
    return 'Идёт трансляция: $title. Открыть пульт';
  }

  @override
  String castingTo2(Object value) {
    return 'Трансляция на $value';
  }

  @override
  String get nowCasting => 'Сейчас в эфире';

  @override
  String get nothingIsCasting => 'Ничего не транслируется';

  @override
  String get pickAPhotoVideo =>
      'Выберите фото, видео, песню или веб-видео, чтобы отправить на телевизор.';

  @override
  String get backToHome => 'На главную';

  @override
  String slide2(Object formatDuration) {
    return 'Слайд $formatDuration';
  }

  @override
  String get back10Seconds => 'Назад на 10 секунд';

  @override
  String get forward10Seconds => 'Вперёд на 10 секунд';

  @override
  String get tvVolume => 'Громкость ТВ';

  @override
  String tvVolumePercent(Object round) {
    return 'Громкость ТВ: $round процентов';
  }

  @override
  String get upNext => 'Далее';

  @override
  String get addPhotos => 'Добавить фото';

  @override
  String get addVideos => 'Добавить видео';

  @override
  String get nothingElseInThe => 'В очереди больше ничего нет.';

  @override
  String play2(Object title) {
    return 'Воспроизвести $title';
  }

  @override
  String get unknownDevice => 'Неизвестное устройство';

  @override
  String get perWeek => 'в неделю';

  @override
  String get perYear => 'в год';

  @override
  String get payOnce => 'разовый платёж';

  @override
  String get wirelessScreenMirroring => 'Беспроводное зеркалирование экрана';

  @override
  String get castVideosPhotosMusic => 'Трансляция видео, фото и музыки';

  @override
  String get fullTvRemoteControl => 'Полное управление телевизором';

  @override
  String get worksWithAllMajor => 'Работает со всеми популярными телевизорами';

  @override
  String get smoothLagFreeStreaming => 'Плавная трансляция без задержек';

  @override
  String get noAds => 'Без рекламы';

  @override
  String get welcomeToCastflowPro => 'Добро пожаловать в CastFlow Pro!';

  @override
  String get purchaseCancelled => 'Покупка отменена.';

  @override
  String get purchasePendingProUnlocks =>
      'Покупка в обработке. Pro включится, как только магазин подтвердит её.';

  @override
  String get purchaseFailedPleaseTry =>
      'Не удалось совершить покупку. Повторите попытку.';

  @override
  String get theStoreIsntAvailable => 'Магазин сейчас недоступен.';

  @override
  String get close => 'Закрыть';

  @override
  String get goProWithCastflow => 'ПЕРЕХОДИТЕ НА PRO С CASTFLOW';

  @override
  String get unlockEveryFeature => 'Откройте все функции';

  @override
  String get renewsAutomaticallyUntilCancelled =>
      'Продлевается автоматически, пока вы не отмените.';

  @override
  String get oneTimePurchaseNo => 'Разовая покупка. Без подписки.';

  @override
  String get continueAction => 'Продолжить';

  @override
  String get privacyPolicy => 'Политика конфиденциальности';

  @override
  String get termsAndConditions => 'Условия использования';

  @override
  String get cancelAnytime => 'Отмена в любой момент';

  @override
  String get loadingPrice => 'Загрузка цены…';

  @override
  String get pricesUnavailableTapTo =>
      'Цены недоступны · Нажмите, чтобы повторить';

  @override
  String get noPlansAvailableRight => 'Сейчас нет доступных планов.';

  @override
  String get weekly => 'Неделя';

  @override
  String get yearly => 'Год';

  @override
  String get lifetime => 'Навсегда';

  @override
  String get bestValue => 'Выгодно';

  @override
  String get disconnectFromTv => 'Отключиться от телевизора?';

  @override
  String get thisStopsWhatIs =>
      'Это остановит всё, что сейчас воспроизводится или зеркалируется.';

  @override
  String get useTouchpad => 'Использовать тачпад';

  @override
  String get useDPad => 'Использовать стрелки';

  @override
  String receiversDontAcceptRemote(Object label) {
    return 'Приёмники $label не принимают команды пульта.';
  }

  @override
  String someButtonsAreUnavailable(Object label) {
    return 'Некоторые кнопки недоступны на $label.';
  }

  @override
  String get idle => 'ОЖИДАНИЕ';

  @override
  String get playing => 'ВОСПРОИЗВЕДЕНИЕ';

  @override
  String get paused => 'ПАУЗА';

  @override
  String get noTvConnected => 'Телевизор не подключён';

  @override
  String get mute2 => 'БЕЗ ЗВУКА';

  @override
  String vol(Object volume) {
    return 'ГРОМК. $volume';
  }

  @override
  String get noTvConnectedTap =>
      'Телевизор не подключён. Нажмите, чтобы выбрать устройство';

  @override
  String get tapToChooseA => 'Нажмите, чтобы выбрать устройство';

  @override
  String isntSupportedBy(Object label, Object label2) {
    return '$label не поддерживается: $label2';
  }

  @override
  String get touchpadSwipeToMove =>
      'Тачпад. Проведите, чтобы двигаться, коснитесь, чтобы выбрать.';

  @override
  String get swipeToMoveTap =>
      'Проведите, чтобы двигаться · Коснитесь, чтобы выбрать';

  @override
  String get navigationIsntSupportedBy =>
      'Этот телевизор не поддерживает навигацию';

  @override
  String get vol2 => 'ГРОМК.';

  @override
  String get auto => 'Авто';

  @override
  String get automatic => 'Автоматически';

  @override
  String get googleCastFirst => 'Сначала Google Cast';

  @override
  String get dlnaUpnpFirst => 'Сначала DLNA / UPnP';

  @override
  String get miracastFirst => 'Сначала Miracast';

  @override
  String get tvOnly => 'Только ТВ';

  @override
  String get phoneAndTv => 'Телефон и ТВ';

  @override
  String get phoneOnly => 'Только телефон';

  @override
  String get touchpad => 'Тачпад';

  @override
  String get doMyPhoneAnd =>
      'Нужно ли, чтобы телефон и телевизор были в одной сети Wi-Fi?';

  @override
  String get yesDiscoveryAndCasting =>
      'Да. Поиск и трансляция работают только в вашей локальной сети, поэтому оба устройства должны быть в одной сети Wi-Fi (похожие названия диапазонов могут быть разными сетями).';

  @override
  String get myRouterHasAp =>
      'В моём роутере включена «изоляция AP / клиентов»';

  @override
  String get isolationBlocksDevicesFrom =>
      'Изоляция не даёт устройствам видеть друг друга. Отключите её в настройках роутера или используйте негостевую сеть.';

  @override
  String get findingYourTv => 'Поиск телевизора';

  @override
  String get myTvDoesntAppear => 'Мой телевизор не появляется в списке';

  @override
  String get turnOnCastingScreen =>
      'Включите трансляцию / зеркалирование на телевизоре, выведите его из режима ожидания и нажмите «Сканировать снова». Разрешите доступ к локальной сети, если появится запрос.';

  @override
  String get onlySomeDevicesShow => 'Показываются только некоторые устройства';

  @override
  String get olderTvsMayNeed =>
      'Старым телевизорам может потребоваться обновление прошивки. Телевизоры Miracast видны только при открытом входе «Зеркалирование экрана».';

  @override
  String get connectionFailsOrTimes =>
      'Подключение не удаётся или истекает время';

  @override
  String get restartTheTvApp =>
      'Перезапустите приложение на телевизоре или сам телевизор, подойдите ближе к роутеру и подтвердите любой запрос на экране телевизора.';

  @override
  String get itKeepsReconnectingTo =>
      'Постоянно подключается к старому телевизору';

  @override
  String get turnOffAutoConnect =>
      'Отключите «Автоподключение к последнему ТВ» в Настройки → Трансляция.';

  @override
  String get mirroringIsLaggy => 'Зеркалирование тормозит';

  @override
  String get chooseALowerQuality =>
      'Выберите качество ниже (720p или 480p), закройте тяжёлые приложения и используйте сеть Wi-Fi 5 ГГц.';

  @override
  String get thePictureIsRotated => 'Изображение повёрнуто или обрезано';

  @override
  String get toggleAutoRotateOn =>
      'Включите или выключите автоповорот на экране зеркалирования.';

  @override
  String get sound => 'Звук';

  @override
  String get thereIsNoSound => 'На телевизоре нет звука';

  @override
  String get makeSureAudioIs =>
      'Убедитесь, что звук включён в зеркалировании, и проверьте Настройки → Трансляция → Вывод звука. Некоторые приёмники не поддерживают звук с телефона.';

  @override
  String get tvRemote2 => 'Пульт ТВ';

  @override
  String get someRemoteButtonsAre => 'Некоторые кнопки пульта неактивны';

  @override
  String get eachReceiverSupportsDifferent =>
      'Разные приёмники поддерживают разные команды. Chromecast и DLNA поддерживают только воспроизведение и громкость; в Miracast нет канала пульта.';

  @override
  String get canCastflowTurnMy =>
      'Может ли CastFlow включить телевизор или сменить вход?';

  @override
  String get onlyOnTvsThat =>
      'Только на телевизорах, которые принимают такие команды по сети. Неподдерживаемые кнопки отключаются, а не делают вид, что работают.';

  @override
  String get helpFaq => 'Справка и вопросы';

  @override
  String get stepByStepConnection => 'Пошаговое руководство по подключению';

  @override
  String androidSdk(Object release, Object sdkInt) {
    return 'Android $release (SDK $sdkInt)';
  }

  @override
  String get noEmailAppFound => 'Почтовое приложение не найдено.';

  @override
  String get enjoyingCastflow => 'Нравится CastFlow?';

  @override
  String get sorryToHearThat => 'Жаль это слышать';

  @override
  String get thanksHowCanWe => 'Спасибо! Как нам стать лучше?';

  @override
  String get wereGladYouLike => 'Мы рады, что вам нравится!';

  @override
  String get youMadeOurDay => 'Вы сделали наш день!';

  @override
  String get tapToExit => 'Нажмите, чтобы выйти';

  @override
  String get selectARating => 'Выберите оценку';

  @override
  String get sendFeedback => 'Отправить отзыв';

  @override
  String get rateUs => 'Оцените нас';

  @override
  String get rateYourExperienceBefore => 'Оцените приложение, прежде чем уйти.';

  @override
  String get tapAStarTo => 'Нажмите на звезду, чтобы оценить CastFlow.';

  @override
  String get general => 'Общие';

  @override
  String get english => 'English';

  @override
  String get defaultQuality => 'Качество по умолчанию';

  @override
  String get autoConnectToLast => 'Автоподключение к последнему ТВ';

  @override
  String get hapticFeedback => 'Тактильный отклик';

  @override
  String get clearCastingHistory => 'Очистить историю трансляций';

  @override
  String get clearCastingHistory2 => 'Очистить историю трансляций?';

  @override
  String get onlyCastflowsListIs =>
      'Очищается только список CastFlow. Медиафайлы на телефоне не удаляются.';

  @override
  String get appearance => 'Оформление';

  @override
  String get light => 'Светлая';

  @override
  String get dark => 'Тёмная';

  @override
  String get system => 'Системная';

  @override
  String get aboutSupport => 'О приложении и поддержка';

  @override
  String get rateApp => 'Оценить приложение';

  @override
  String get feedback => 'Отзыв';

  @override
  String get termsConditions => 'Условия использования';

  @override
  String get version => 'Версия';

  @override
  String get castflowProIsActive => 'CastFlow Pro активен';

  @override
  String get upgradeToPremium => 'Перейти на Premium';

  @override
  String get castflowPremium => 'CastFlow Premium';

  @override
  String get thanksForYourSupport =>
      'Спасибо за поддержку. Наслаждайтесь трансляцией без рекламы.';

  @override
  String get noAds1080pMirroring =>
      'Без рекламы, зеркалирование 1080p и безлимитные трансляции';

  @override
  String get upgrade => 'Улучшить';

  @override
  String get mirrorCastBeautifullySimple =>
      'Зеркалируйте и транслируйте — просто и красиво';

  @override
  String get thisActionMayContain => 'Это действие может содержать рекламу';

  @override
  String get webCast => 'Веб-трансляция';

  @override
  String get castThisVideo => 'Транслировать это видео';

  @override
  String get searchOrTypeAWeb => 'Введите запрос или веб-адрес';

  @override
  String get removeBookmark => 'Удалить закладку';

  @override
  String get bookmark => 'Закладка';

  @override
  String get quickAccess => 'Быстрый доступ';

  @override
  String open2(Object title) {
    return 'Открыть $title';
  }

  @override
  String get bookmarks => 'Закладки';

  @override
  String get noBookmarks => 'Нет закладок';

  @override
  String get tapTheBookmarkIcon =>
      'Нажмите значок закладки в адресной строке, чтобы сохранить страницу.';

  @override
  String get noHistory => 'Нет истории';

  @override
  String get pagesYouVisitShow => 'Посещённые страницы появятся здесь.';

  @override
  String get remove => 'Удалить';

  @override
  String resultOn(Object value, Object host) {
    return 'Результат $value на $host';
  }

  @override
  String get aSimulatedPageResult => 'Имитация результата страницы';

  @override
  String get videosOnThisPage => 'Видео на этой странице';

  @override
  String get pickOneToSend => 'Выберите одно, чтобы отправить на телевизор.';

  @override
  String get onboardHotspotTitle => 'Нет Wi-Fi? Используйте точку доступа';

  @override
  String get onboardHotspotBody =>
      'Включите точку доступа на телефоне и подключите к ней телевизор. Трансляция работает так же, как по Wi-Fi.';

  @override
  String get stillCantFindTitle => 'Всё ещё не видите телевизор?';

  @override
  String get stillCantFindBody =>
      'Подключите телевизор к точке доступа телефона:';

  @override
  String get hotspotStep4 =>
      'Нажмите «Повторить» и выберите телевизор в списке';

  @override
  String get castOverHotspot =>
      'Нет Wi-Fi? Транслируйте через точку доступа телефона:';

  @override
  String get queue => 'Очередь';

  @override
  String get addMusic => 'Добавить музыку';

  @override
  String get connectWithWifi => 'Подключиться к Wi-Fi';

  @override
  String get continueWithHotspot => 'Продолжить через точку доступа';

  @override
  String get noWifiAlertMessage =>
      'Вы используете мобильный интернет. Подключите телефон и телевизор к одной сети Wi-Fi или включите точку доступа на телефоне и подключите к ней телевизор.';
}
