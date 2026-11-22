import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    // Firebase: reads android/app/google-services.json
    id("com.google.gms.google-services")
}

// Release signing: android/key.properties (git-ignored). Keystore path is relative to android/app.
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystorePropertiesFile.inputStream().use { keystoreProperties.load(it) }
}

android {
    namespace = "com.castflow.castflow"
    compileSdk = 37
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.smarttvcast.screenmirror"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 24
        targetSdk = 37
        // Uses the version code from pubspec.yaml. When using split APKs, 1000 * ABI_VERSION
        // is added automatically by Flutter. (https://developer.android.com/studio/build/configure-apk-splits#configure-APK-versions)
        // You can force using the value of versionCode by specifying the `-P force-version-code-ignoring-abi=true`
        // flag during build.
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildFeatures {
        buildConfig = true
        resValues = true
    }

    signingConfigs {
        create("release") {
            if (keystorePropertiesFile.exists()) {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
    }

    buildTypes {
        debug {
            // Official Google AdMob test IDs for debug mode - NEVER use production IDs in debug
            val testAppId = "ca-app-pub-3940256099942544~3347511713"
            val testAppOpenId = "ca-app-pub-3940256099942544/9257395921"
            val testNativeId = "ca-app-pub-3940256099942544/2247696110"
            val testInterstitialId = "ca-app-pub-3940256099942544/1033173712"

            manifestPlaceholders["admobAppId"] = testAppId
            resValue("string", "admob_app_id", testAppId)
            resValue("string", "admob_app_open_id", testAppOpenId)
            // Google's VIDEO native test unit: Language (first run + Settings) and Onboarding
            // use the media layout, so debug builds must show a real video, not an image.
            val testNativeVideoId = "ca-app-pub-3940256099942544/1044960115"
            resValue("string", "admob_language_native_id", testNativeVideoId)
            resValue("string", "admob_onboarding_native_id", testNativeVideoId)
            resValue("string", "admob_splash_interstitial_first_id", testInterstitialId)
            resValue("string", "admob_splash_interstitial_second_id", testInterstitialId)
            resValue("string", "admob_click_interstitial_id", testInterstitialId)
            resValue("string", "admob_home_native_id", testNativeId)
            // Aliases for backward compatibility
            resValue("string", "admob_interstitial_id", testInterstitialId)
            resValue("string", "admob_native_id", testNativeId)
        }
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )

            // Real Production AdMob Credentials for Cast to TV (com.smarttvcast.screenmirror)
            val prodAppId = "ca-app-pub-3116238716336403~3352823507"
            val prodAppOpenId = "ca-app-pub-3116238716336403/1820249985"
            val prodLanguageNativeId = "ca-app-pub-3116238716336403/7288199082"
            val prodOnboardingNativeId = "ca-app-pub-3116238716336403/4343692730"
            val prodSplashInterstitialFirstId = "ca-app-pub-3116238716336403/9914362422"
            val prodSplashInterstitialSecondId = "ca-app-pub-3116238716336403/5787415153"
            val prodClickInterstitialId = "ca-app-pub-3116238716336403/9252192456"
            val prodHomeNativeId = "ca-app-pub-3116238716336403/2742624427"

            manifestPlaceholders["admobAppId"] = prodAppId
            resValue("string", "admob_app_id", prodAppId)
            resValue("string", "admob_app_open_id", prodAppOpenId)
            resValue("string", "admob_language_native_id", prodLanguageNativeId)
            resValue("string", "admob_onboarding_native_id", prodOnboardingNativeId)
            resValue("string", "admob_splash_interstitial_first_id", prodSplashInterstitialFirstId)
            resValue("string", "admob_splash_interstitial_second_id", prodSplashInterstitialSecondId)
            resValue("string", "admob_click_interstitial_id", prodClickInterstitialId)
            resValue("string", "admob_home_native_id", prodHomeNativeId)
            // Aliases for backward compatibility
            resValue("string", "admob_interstitial_id", prodClickInterstitialId)
            resValue("string", "admob_native_id", prodLanguageNativeId)
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
