# Flutter & Plugins
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.embedding.**

# Room Database (reflection instantiation of generated implementation)
-keep class * extends androidx.room.RoomDatabase {
    public <init>();
    *;
}
-keepclassmembers class * extends androidx.room.RoomDatabase {
    public <init>();
    *;
}
-dontwarn androidx.room.paging.**

# AndroidX WorkManager
-keep class androidx.work.impl.WorkDatabase { *; }
-keep class androidx.work.impl.WorkDatabase_Impl {
    public <init>();
    *;
}
-keep class * extends androidx.work.impl.WorkDatabase {
    public <init>();
    *;
}
-keep class androidx.work.** { *; }
-keep interface androidx.work.** { *; }
-keep class * extends androidx.work.Worker {
    public <init>(android.content.Context, androidx.work.WorkerParameters);
    *;
}
-keep class * extends androidx.work.ListenableWorker {
    public <init>(android.content.Context, androidx.work.WorkerParameters);
    *;
}
-dontwarn androidx.work.impl.**

# Photo Manager
-keep class com.fluttercandies.photo_manager.** { *; }

# Google Mobile Ads SDK
-keep class com.google.android.gms.ads.** { *; }
-keep interface com.google.android.gms.ads.** { *; }
-keep class com.google.ads.mediation.** { *; }
-keep class io.flutter.plugins.googlemobileads.** { *; }
-keep class com.castflow.castflow.CustomNativeAdFactory { *; }
-dontwarn com.google.android.gms.ads.**

# Google Play Billing / In-App Purchase
-keep class com.android.billingclient.api.** { *; }
-keep class io.flutter.plugins.inapppurchase.** { *; }
-dontwarn com.android.billingclient.api.**

# Firebase / Google Play services
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.measurement.** { *; }
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**

# Flutter deferred components / Play Core (not used, avoid R8 missing-class errors)
-dontwarn com.google.android.play.core.**

# Secure storage / crypto (BouncyCastle via pointycastle is Dart; Tink used by secure storage)
-keep class com.google.crypto.tink.** { *; }
-dontwarn com.google.errorprone.annotations.**
-dontwarn javax.annotation.**

# Keep stack traces readable
-keepattributes SourceFile,LineNumberTable

# Keep generic signatures and reflection attributes
-keepattributes *Annotation*,Signature,InnerClasses,EnclosingMethod
