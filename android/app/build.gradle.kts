plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin") // Flutter plugin
}

android {
    namespace = "com.example.footware_page"
    compileSdk = 35  // Use the latest stable version
    ndkVersion = "27.0.12077973"  // ✅ Fixed NDK version

    defaultConfig {
        applicationId = "com.example.footware_page"
        minSdk = 23  // ✅ Updated minSdkVersion
        targetSdk = 34  // Match the latest SDK
        versionCode = 1
        versionName = "1.0"
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
