# CastFlow — Ads Master Prompt (code se verify kiya hua)

> Source of truth: `lib/features/monetization/**`, splash / language / onboarding / paywall / home / shell screens,
> `android/.../MainActivity.kt` aur `res/layout/custom_native_ad*.xml`. Har line code padh kar likhi hai.

---

## 0. PROMPT (copy-paste ke liye)

Tum CastFlow (Flutter, AdMob, Riverpod) ke ads ka owner ho. Neeche diya system **exactly** isi tarah behave karna chahiye.
Isse compare karo, jahan code alag ho wahan bug report karo ya fix karo. Kuch naya mat badlo.

### A. Global rules (har ad pe lagte hain)
1. **Premium user = zero ads.** Premium pe request hi nahi jaati (native slot, splash/click interstitial, app open sab skip). Purchase hote hi `AdManager.onPremiumPurchased()` sab cached ads dispose + overlay band + coordinator lock reset karta hai.
2. **Ek waqt mein sirf ek full-screen ad** (interstitial ya app open) — `AdDisplayCoordinator.present()` lock. Lock tab bhi reject karta hai jab **purchase in progress** ho (paywall `_purchase` me `setPurchaseInProgress(true/false)`).
3. **Debug = hamesha Google test IDs, Release = hamesha production IDs** (`AdMobConfig.unitId`). Release me test ID (`3940256099942544`) kabhi accept nahi.
4. **Native ad theme** app theme se aata hai (OS theme se nahi): `AdMobConfig.syncNativeTheme(dark)` → Android factory `custom_native_ad` (light) / `custom_native_ad_dark`.
5. **Ad failure kabhi navigation block nahi karta.** Har jagah timeout/no-fill par flow aage badhta hai.

### B. Ad units (production)
| Placement | Format | Unit ID |
|---|---|---|
| App Open (`appOpen`) | App Open | `…/1820249985` |
| Language (`languageFirstRun`, `languageSettings`) | Native | `…/7288199082` |
| Onboarding (`onboarding`) | Native | `…/4343692730` |
| Splash Interstitial 1st (first launch) | Interstitial | `…/9914362422` |
| Splash Interstitial 2nd (returning) | Interstitial | `…/5787415153` |
| Click Interstitial (`clickInterstitial`) | Interstitial | `…/9252192456` |
| Home Native (`homeNative`) | Native | `…/2742624427` (**defined hai, par kisi screen me use nahi hota**) |

Publisher: `ca-app-pub-3116238716336403`. Overrides: `--dart-define ADMOB_PROD_*`, ya native `getAdConfig` channel.

### C. Timeouts / numbers (AdMobConfig + screens)
| Cheez | Value |
|---|---|
| Splash timer + progress bar | **9 s** (`splashTimeout`) |
| Splash startup services (consent + premium + paywall prices) max wait | 6 s |
| Language screen landing loader | **3 s** (ya ad settle hote hi, jo pehle) |
| Onboarding 3rd-slide loader | **3 s** (ya ad settle hote hi) |
| NativeAdSlot `loadLimit` | 6 s |
| App Open loading overlay | **6 s** max |
| App Open freshness | 4 ghante |
| Splash in-flight wait (paywall close pe) | 3 s |
| Native failure cooldown (`AdManager.loadNative`) | 30 s |
| Click interstitial | 1st click load, 2nd click show, **max 1 per session** |

### D. Flow (kaun si screen pe kya)
**Flow A — first launch, non-premium:** Splash → Language → Paywall → Onboarding → Home
**Flow B — returning, non-premium:** Splash → Paywall → Home
**Flow C — premium:** Splash → Home (first run me language + onboarding ek baar, paywall nahi)

#### D1. Splash (`/splash`)
- Layout: gradient bg, logo, progress bar (9 s), neeche "This action may contain ads" (sirf verified non-premium ko).
- Order: consent (UMP + SDK init) ‖ premium verify ‖ paywall prices (max 6 s) → phir **`_startClock()` (9 s) aur splash interstitial request ek saath start**.
- Placement: first launch → `splashInterstitialFirst`, returning → `splashInterstitialSecond`.
- Ad 9 s ke andar load ho gaya → **turant splash pe show**, close hote hi next screen.
- 9 s tak load nahi hua → `tryShowOnSplash` (loaded ho to show) warna splash chhod do; request chalti rehti hai aur baad ke mauko (D2/D3/D5) pe use hoti hai.
- Back button splash pe disabled.

#### D2. Language (`/language`, first run) — Native medium, **bottom** me
- Slot `languageFirstRun`; Settings se khule to `languageSettings` (alag unit nahi, wahi Language unit).
- **Landing loader (3 s):** screen khulte hi ad request + top-right ✓ (Done) icon ki jagah spinner, ✓ disabled. 3 s baad ya ad loaded/no-fill/timeout hote hi spinner hat'ta hai (jo pehle ho). Ad na aaye to bhi user ✓ dabake aage ja sakta hai.
- Placeholder: shimmer box (surface + divider border). No-fill par slot poora collapse (khali jagah nahi).
- ✓ dabane par (first run): language save → **Splash Interstitial Opportunity 1** (`tryShowAtLanguageCompletion`; loaded ho to show, nahi to Opportunity 2 ke liye save) → next step.
- Back (first run) = ✓ jaisa. Settings flow me back = bina apply nikalna.
- Landscape: ad right column (300 dp), portrait: list ke neeche.

#### D3. Paywall (`/paywall?slot=first|returning`, `/premium`)
- **Koi native ad nahi.** Splash interstitial yahan **close (X)** pe show hota hai agar Language pe nahi dikha (`tryShowAtPaywallClose`; 3 s tak in-flight load ka wait; load na hua to Home first-click ke liye bachta hai).
- Purchase success → koi interstitial nahi, `onPremiumPurchased()`.
- Paywall pe App Open blocked (`/paywall`, `/premium`).

#### D4. Onboarding (`/onboarding`) — Native medium, **Next/Get Started ke neeche** (portrait), right column (landscape)
- Slot `onboarding`: **ek hi ad instance** poore onboarding me (3 slides ke beech dispose nahi hota); `_finish()` pe `releaseOnboardingAd()`.
- Ad onboarding khulte hi request hota hai. **Loader sirf slide 3 pe**, aur sirf tab jab ad abhi tak na aaya ho na settle hua ho: "Get Started" button spinner (3 s ya settle). Spinner ke dauran tap ignore.
- Back = Next (slide 1→2→3→Home).

#### D5. Home & tabs (`/home`, shell)
- **Home pe koi native ad nahi** (homeNative unused).
- **Click interstitial** (`ClickCountInterstitialManager.onBottomNavClick`) in dono se trigger:
  1. Bottom nav pe **doosre tab** par tap (same tab nahi).
  2. Home feature tap: `/mirror`, `/photos`, `/videos`, `/music`, `/apps`.
- Rules: premium ignore · coordinator me ad chal raha ho to ignore · agar splash interstitial pending ho to **pehla click usi ko milta hai** (`tryShowOnHomeClick`), uske baad hi click-ad load · warna 1st click = background load, 2nd click = show (ready ho to) warna navigation + retry load · ek baar dikha to session me dobara kabhi nahi.

#### D6. App Open (background → foreground)
- Sirf tab jab: non-premium **aur** flow finished (Home tak pahunch chuka) **aur** background hote waqt top route safe tha.
- **Blocked routes:** `/splash`, `/paywall`, `/premium`, `/language`, `/onboarding`, `/ad-loading`.
- **Suppressed (App Open nahi):** permission prompts (location / nearby wifi / etc.), system settings, external links, review/feedback, consent privacy form — `AdSuppression.suppressNextAppOpen()/around()`.
- Fresh cached ad ho to turant (white/black full backdrop ke saath); nahi to **transparent "Ad is loading…" overlay, max 6 s**; error pe turant band; late-loaded ad cache hota hai aur next foreground pe pehle use hota hai. 4 ghante se purana ad discard.
- Koi min-background time ya gap nahi (config me `appOpenMinBackground` 3 s hai par code use nahi karta).

### E. Native ad layout (Android `CustomNativeAdFactory`)
- Horizontal row: **left 35%** icon (4 dp padding, fitCenter) | **right 65%**: "Ad" badge (10 sp, orange `#F59E0B`) → headline (14 sp bold, max 2 lines) → body (12 sp, max 2 lines, ellipsis) → CTA button (36 dp, full width, 12 dp upar margin).
- Slot height: measured native height (floor 96 dp), warna estimate `68 + 85×textScale(1–2) + 4` ≈ 157 dp. Full width, zero horizontal padding, `AnimatedSize` se smooth collapse.
- iOS: Google `NativeTemplateStyle` medium/small.
- Ek `AdWidget` ek hi baar mount (GlobalKey) — "already in widget tree" crash se bachav.

### F. Compliance
UMP consent splash pe (premium cached ho to skip). `consentAllowsAds` false ho to `AdManager.loadNative` skip. Ad badge "Ad" har native pe. Premium paywall me "No ads" benefit.

---

## 1. VERIFICATION REPORT — jo code me mila vs jo expected tha

### ✅ Sahi implement hai
- Language **3 s loader**, ad settle hote hi hat'ta hai; ad na aaye to bhi Done kaam karta hai.
- Onboarding **3 s loader** sirf slide 3 / Get Started pe, ad settle hote hi band.
- Splash interstitial: ek hi opportunity chain — Splash (9 s) → Language ✓ → Paywall X → Home first click. Ek baar dikha to `_hasShown/_isDismissed`.
- Single full-screen lock, purchase-in-progress block, premium purge, debug/release ID isolation.
- App Open blocked routes + suppression + 6 s overlay + freshness.
- Onboarding single native instance; Language ad no-fill pe collapse.

### ⚠️ Mismatch / bugs (tumhari expectation ya comments se alag)
1. **Splash 9 s hai, 3 s nahi.** 3 s sirf Language aur Onboarding ka loader hai. (`splash_screen.dart` ka comment "6-second" purana hai; `ad_manager.dart` ka comment "7-second overlay" bhi purana — asli 6 s.)
2. **Language loader screen dim nahi karta / taps block nahi karta** (comment aisa bolta hai). Sirf ✓ icon spinner banta hai aur disabled hota hai; list scroll/select chalta rehta hai.
3. **`AdConfig.loadAtClick = 3 / showAtClick = 5` dead constants hain.** Real logic 1st click load, 2nd click show (`ClickCountInterstitialManager`). Class doc "bottom navigation" bolta hai par Home feature taps bhi count hote hain.
4. **`AdRouteObserver.eligibleClickRoutes` + `onEligiblePush` kahin wire nahi hai** — route-based click counting kaam nahi karta; sirf tab tap + Home feature tap chalte hain. (Observer sirf `topIsSafe` ke liye use hota hai.)
5. **`homeNative` placement + production unit ID defined, par Home pe koi `NativeAdSlot` nahi.** Ya to slot lagao ya unused ID hata do.
6. **`preloadLanguageAd()` / `preloadOnboardingAd()` kabhi call nahi hote** (paywall me sirf khali comment). Ads screen landing pe hi request hote hain — isliye loader zaroori ho jaata hai.
7. **`NativeAdSlot` me "no fill = ek retry" ka comment galat:** `maxAttempts` default 1, yaani retry nahi hota. `ensureLoaded()` / `retry()` bhi kahin use nahi.
8. **Language/Onboarding native `NativeAdManager` se seedha `adapter.loadNative` karta hai** — `AdManager.loadNative` ke consent (`consentAllowsAds`), cooldown aur analytics events (ad_request / load_success / no_fill) in placements pe **skip** ho jaate hain. Sirf `homeNative` (unused) `AdManager` se jaata.
9. **`ad_diagnostics` route** release me `/home` pe redirect (sahi), debug me khula.

### Suggested fixes (agar chahiye)
- Language loader me bhi dim + `IgnorePointer`, ya comment sahi karo.
- Language/Onboarding native ko consent + analytics ke andar route karo (ya `AdManager.loadNative` use karo).
- Dead code hatao: `loadAtClick/showAtClick`, `appOpenMinBackground`, `eligibleClickRoutes/onEligiblePush`, `preload*`, `ensureLoaded/retry`, `homeNative` (ya Home pe slot lagao).
- Stale comments theek karo (splash 6 s, overlay 7 s).
