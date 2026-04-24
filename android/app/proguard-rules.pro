# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Agora
-keep class io.agora.** { *; }

# Retrofit / OkHttp / Gson / JSON
-keepattributes Signature
-keepattributes *Annotation*
-keep class retrofit2.** { *; }
-keepclasseswithmembers class * {
    @retrofit2.http.* <methods>;
}
-keep class com.google.gson.** { *; }
-keep class * extends com.google.gson.TypeAdapter

# Kotlin
-keep class kotlin.** { *; }
-keep class kotlin.Metadata { *; }
-keepclassmembers class **$WhenMappings {
    <fields>;
}

# AndroidX / Lifecycle
-keep class androidx.lifecycle.** { *; }

# Dart/Flutter Method Channels
-keep class * implements io.flutter.plugin.common.MethodChannel$MethodCallHandler { *; }

# Play Core needed for Flutter split install
-dontwarn com.google.android.play.core.**

# SLF4J
-dontwarn org.slf4j.**

# Pusher & Java WebSocket
-keep class com.pusher.** { *; }
-keep class org.java_websocket.** { *; }
