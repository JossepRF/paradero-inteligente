plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

def mapsApiKey = project.hasProperty('MAPS_API_KEY') ? project.MAPS_API_KEY : ""

android {
    namespace = "com.proyecto.paradero.paradero_inteligente"
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
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.proyecto.paradero.paradero_inteligente"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // 🔧 Configuración específica para Google Maps
        multiDexEnabled = true
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")

            // ⚙️ Optimizaciones para release - CORREGIDO
            isMinifyEnabled = true  // Debe ser true para usar shrinkResources
            isShrinkResources = true  // Cambiar de shrinkResources a isShrinkResources

            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
        debug {
            // 🔧 Configuración para debug
            isDebuggable = true
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }

    // 🎯 Soporte para view binding (opcional pero recomendado)
    buildFeatures {
        viewBinding = true
        buildConfig = true
    }

    // 📦 Packaging options para evitar conflictos
    packaging {
        resources {
            excludes += listOf(
                "META-INF/DEPENDENCIES",
                "META-INF/LICENSE",
                "META-INF/LICENSE.txt",
                "META-INF/NOTICE",
                "META-INF/NOTICE.txt",
                "META-INF/AL2.0",
                "META-INF/LGPL2.1"
            )
        }
    }
}

flutter {
    source = "../.."
}

// 📋 Dependencias específicas de Android
dependencies {
    // 🗺️ Soporte para Google Play Services (necesario para maps)
    implementation("com.google.android.gms:play-services-maps:18.2.0")
    implementation("com.google.android.gms:play-services-location:21.0.1")

    // 📱 Soporte para multidex (si usas muchas dependencias)
    implementation("androidx.multidex:multidex:2.0.1")

    // 🎨 Material Design
    implementation("androidx.appcompat:appcompat:1.6.1")
    implementation("com.google.android.material:material:1.10.0")

    // 🔄 Lifecycle components
    implementation("androidx.lifecycle:lifecycle-viewmodel-ktx:2.7.0")
    implementation("androidx.lifecycle:lifecycle-livedata-ktx:2.7.0")
}