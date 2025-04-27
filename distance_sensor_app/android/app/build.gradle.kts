plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.distance_sensor_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.distance_sensor_app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // Enable core library desugaring
        vectorDrawables.useSupportLibrary = true
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")  // This is used for debug builds.
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Add the desugaring dependency
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:1.1.5")
}
