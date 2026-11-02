# CastFlow

Screen mirroring & casting app. No backend: settings, history, devices and
ad counters live on the device; TVs are reached over the local Wi-Fi.

Product spec: [docs/CastFlow_Updated_Implementation_Plan.pdf](docs/CastFlow_Updated_Implementation_Plan.pdf)

```bash
flutter pub get
flutter run
```

On Android/iOS the app uses Google Mobile Ads (test IDs) and store billing.
Everywhere else (web preview, desktop, tests) it falls back to fake ads and a
fake store. Force the fakes on a phone with
`--dart-define=FAKE_ADS=true --dart-define=FAKE_BILLING=true`.

## Startup flow

One `AppFlowController` decides every startup route (`features/app_flow`):

- First run: Splash → Entry → Paywall A → Entry → Language → Paywall B → Onboarding → Permissions → Home
- Returning: Splash → Entry → Paywall → Entry → Home

Paywall slots can be switched off in `FlowConfig` without touching routing.
A router guard sends deep links back to Splash until the first run is done.

## Structure

```
lib/
  app/        app.dart, router.dart (go_router + guard), shell.dart
  core/       theme, widgets, storage (Hive CE), config (links), utils
  features/
    app_flow      AppFlowController, Entry screen
    monetization  AdManager, native slots, 5-click interstitial, App Open
    premium       BillingService (in_app_purchase), entitlement, paywall
    language      Language screen (first run + Settings)
    remote        TV remote + receiver capability matrix
    devices       discovery, connection, saved devices
    mirroring, media, player, webcast, appcast, linkcast
    history, settings (incl. FAQ), onboarding, permissions, splash, home
```

## Before release — replace placeholders

| What | Where |
|---|---|
| AdMob App IDs (test) | `android/app/src/main/AndroidManifest.xml`, `ios/Runner/Info.plist` |
| Ad unit IDs (test) | `lib/features/monetization/domain/ad_config.dart` |
| Store product IDs | `BillingConfig` in `lib/features/premium/domain/billing.dart` |
| Privacy, Terms, support email, store IDs | `lib/core/config/app_links.dart` |

## Debug tools

Settings → **Debug** (debug builds only):

- **Preview data states** switches the fake services between Live, Empty and Error.
- **Ad diagnostics** shows each placement's state, counters, cooldowns and the event log.

## Still fake

| Interface | Provider | Real implementation |
|---|---|---|
| `DeviceRepository` | `deviceRepositoryProvider` | mDNS / SSDP (UPnP, DLNA), Google Cast SDK |
| `MirroringService` | `mirroringServiceProvider` | Android MediaProjection + Cast/Miracast via platform channel; iOS ReplayKit |
| `RemoteService` | `remoteServiceProvider` | Roku ECP, Cast media session, DLNA, smart-TV APIs |
| `MediaRepository` | `mediaRepositoryProvider` | `photo_manager`, media store |
| `MediaDetector` | `mediaDetectorProvider` | `webview_flutter` / `flutter_inappwebview` + detection script |
| `PermissionService` | `permissionServiceProvider` | `permission_handler` |
| `MockAppContent` | `appContentProvider` | `youtube_explode_dart`, Google Photos / Drive APIs |
