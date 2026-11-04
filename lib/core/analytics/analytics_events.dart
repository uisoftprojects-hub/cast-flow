/// Every analytics event the app sends. Names are snake_case, grouped by a
/// prefix so related events sort together in Firebase:
///
///   app_*       launch
///   funnel_*    first-run journey from splash to home (drop-off analysis)
///   paywall_*   paywall views and closes
///   purchase_*  store purchase results
///   ad_*        ad lifecycle per placement
///   device_*    connection results
///   mirror_*    screen mirroring
///   cast_*      media casting
///   browser_*   web video detection and cast
///   home_*      Home feature taps
///
/// Only major events are tracked; screen visits come from screen_view.
///
/// See docs/analytics_events.md for the full table with parameters.
abstract final class AnalyticsEvent {
  // App.
  static const appLaunch = 'app_launch';

  // First-run funnel (splash → home).
  static const funnelSplashView = 'funnel_splash_view';
  static const funnelLanguageView = 'funnel_language_view';
  static const funnelLanguageDone = 'funnel_language_done';
  static const funnelOnboardingView = 'funnel_onboarding_view';
  static const funnelOnboardingDone = 'funnel_onboarding_done';
  static const funnelPaywallView = 'funnel_paywall_view';
  static const funnelHomeView = 'funnel_home_view';
  static const funnelDrop = 'funnel_drop';

  // Paywall.
  static const paywallView = 'paywall_view';
  static const paywallClose = 'paywall_close';

  // Purchase.
  static const purchaseStart = 'purchase_start';
  static const purchaseSuccess = 'purchase_success';
  static const purchaseFail = 'purchase_fail';

  // Ads.
  static const adRequest = 'ad_request';
  static const adLoadSuccess = 'ad_load_success';
  static const adNoFill = 'ad_no_fill';
  static const adLoadFail = 'ad_load_fail';
  static const adImpression = 'ad_impression_app';
  static const adClick = 'ad_click';

  // Devices.
  static const deviceNoneFound = 'device_none_found';
  static const deviceConnectSuccess = 'device_connect_success';
  static const deviceConnectFail = 'device_connect_fail';
  static const networkNoWifi = 'network_no_wifi';
  static const hotspotGuideOpen = 'hotspot_guide_open';

  // Mirroring.
  static const mirrorStartTap = 'mirror_start_tap';
  static const mirrorLive = 'mirror_live';

  // Casting.
  static const castStart = 'cast_start';

  // Browser.
  static const browserVideoFound = 'browser_video_found';
  static const browserCastTap = 'browser_cast_tap';

  // Remote.

  // Home & settings.
  static const homeFeatureTap = 'home_feature_tap';
  static const languageChange = 'language_change';
  static const rateSubmit = 'rate_submit';

  // Help.
}

/// Parameter names shared across events.
abstract final class AnalyticsParam {
  static const adName = 'ad_name'; // e.g. native_language_first_open
  static const adFormat = 'ad_format'; // native | interstitial | app_open
  static const adUnit = 'ad_unit';
  static const reason = 'reason';
  static const loadMs = 'load_ms';
  static const errorMessage = 'error_message';
  static const source = 'source';
  static const firstOpen = 'first_open';
  static const launchCount = 'launch_count';
  static const step = 'step';
  static const elapsedMs = 'elapsed_ms';
  static const productId = 'product_id';
  static const plan = 'plan';
  static const price = 'price';
  static const deviceType = 'device_type';
  static const networkMode = 'network_mode';
  static const quality = 'quality';
  static const mediaType = 'media_type';
  static const itemCount = 'item_count';
  static const videoType = 'video_type';
  static const videoCount = 'video_count';
  static const host = 'host';
  static const fromLanguage = 'from_language';
  static const toLanguage = 'to_language';
  static const language = 'language';
  static const rating = 'rating';
  static const feature = 'feature';
}

/// User properties set once and attached by Firebase to every event.
abstract final class AnalyticsUserProperty {
  static const isPremium = 'is_premium';
  static const appLanguage = 'app_language';
  static const firstOpenDone = 'first_open_done';
}
