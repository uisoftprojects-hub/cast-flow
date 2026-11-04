# CastFlow analytics events

Major events only. Every screen visit is also logged automatically as Firebase
`screen_view` with a readable `screen_name` (`home`, `browser`, `paywall`,
`screen_mirroring`, …), so screens don't have their own events.

Code: `lib/core/analytics/analytics_events.dart` (names) and
`lib/core/analytics/analytics.dart` (sending, Firebase rules, screen names).
Events go to Firebase Analytics once `android/app/google-services.json` is
added; without it they are only printed in debug builds.

Rules: snake_case names up to 40 characters, text values cut to 100
characters, `true/false` sent as `1/0`, times in milliseconds.

## User properties

| Property | Values |
|---|---|
| `is_premium` | `true` / `false` |
| `app_language` | language code, e.g. `en`, `hi` |
| `first_open_done` | `true` / `false` |

## App and first-run funnel (splash → home)

Build a Firebase funnel from `funnel_splash_view` to `funnel_home_view` to see
where new users drop. `funnel_drop` names the step they left the app on.

| Event | When | Params |
|---|---|---|
| `app_launch` | Every app start | `first_open`, `launch_count`, `language` |
| `funnel_splash_view` | Splash shown | `first_open` |
| `funnel_language_view` | Language screen shown (first run) | `first_open`, `elapsed_ms` |
| `funnel_language_done` | Done tapped on language | `first_open`, `elapsed_ms`, `language` |
| `funnel_onboarding_view` | Onboarding shown | `first_open`, `elapsed_ms` |
| `funnel_onboarding_done` | Get started tapped | `first_open`, `elapsed_ms` |
| `funnel_paywall_view` | Startup paywall shown | `first_open`, `elapsed_ms`, `source` (`first_open` / `returning`) |
| `funnel_home_view` | Home reached at the end of the startup flow | `first_open`, `elapsed_ms` |
| `funnel_drop` | App sent to background before reaching Home | `step` (`language` / `onboarding` / `paywall` / `paywallReturning`), `first_open`, `elapsed_ms` |

`elapsed_ms` is the time since the app started.

## Paywall and purchase

| Event | When | Params |
|---|---|---|
| `paywall_view` | Any paywall shown | `source` |
| `paywall_close` | Paywall closed with X | `source`, `elapsed_ms` (time on paywall) |
| `purchase_start` | Continue tapped, store sheet opening | `product_id`, `plan` (`weekly` / `yearly` / `lifetime`), `price`, `source` |
| `purchase_success` | Store confirmed the purchase | same as `purchase_start` |
| `purchase_fail` | Purchase didn't complete | same as `purchase_start` + `reason` (`cancelled` / `pending` / `failed` / `unavailable`) |

`source` values: `first_open`, `returning`, `home_pro_button`,
`settings_banner`.

## Ads

Every ad event has `ad_name`, `ad_format` and `ad_unit` (last part of the AdMob
unit ID).

| `ad_name` | `ad_format` | Where |
|---|---|---|
| `native_language_first_open` | `native` | Language screen, first run |
| `native_language_settings` | `native` | Language screen from Settings |
| `native_onboarding` | `native` | Onboarding |
| `inter_5_click` | `interstitial` | Every 5th eligible tap |
| `app_open_resume` | `app_open` | Returning to the app |

| Event | When | Extra params |
|---|---|---|
| `ad_request` | Ad requested | `source` (e.g. `resume`, `click 3`) |
| `ad_load_success` | Ad loaded | `load_ms` |
| `ad_no_fill` | Network had no ad to serve | `error_message` |
| `ad_load_fail` | Any other load error | `error_message` |
| `ad_impression_app` | Ad shown to the user | – |
| `ad_click` | Ad tapped | – |

Fill rate = `ad_load_success` / `ad_request` per `ad_name`.
`ad_impression_app` is named so it doesn't double-count with the
`ad_impression` event AdMob logs by itself once AdMob is linked to Firebase.

## Core features

| Event | When | Params |
|---|---|---|
| `home_feature_tap` | A feature opened from Home | `feature` (`screen_mirroring`, `tv_remote`, `photos`, `videos`, `music`, `browser`, `apps`, `guide`) |
| `network_no_wifi` | A scan or cast was blocked by no Wi-Fi / hotspot | `source` |
| `hotspot_guide_open` | Hotspot guide opened | – |
| `device_none_found` | Scan finished with no TV | `network_mode` (`wifi` / `hotspot`) |
| `device_connect_success` | Connected to a TV | `device_type` |
| `device_connect_fail` | Connection failed | `device_type`, `reason` (`network-lost`, `pairing_cancelled` or the error) |
| `mirror_start_tap` | Start mirroring tapped | `quality` |
| `mirror_live` | Mirroring actually started | `quality` |
| `cast_start` | Photo / video / music / link / web video starts on the TV | `media_type`, `item_count`, `device_type`, `source` (`slideshow` when set) |
| `browser_video_found` | First video detected on a web page | `video_count`, `host` |
| `browser_cast_tap` | Cast tapped on a web video | `video_type`, `quality`, `host` |
| `language_change` | Language changed | `from_language`, `to_language`, `first_open` |
| `rate_submit` | Stars submitted | `rating` (1–5), `source` (`home_back` / `settings`) |

Mirroring success rate = `mirror_live` / `mirror_start_tap`.
Connection success rate = `device_connect_success` / (`device_connect_success` + `device_connect_fail`).
