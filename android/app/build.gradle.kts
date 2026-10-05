import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Dati della chiave di firma, letti da android/key.properties.
//
// Il file non sta nel repository: in locale lo crea chi pubblica, su GitHub lo
// scrive il flusso di lavoro a partire dai segreti. Se manca, la build di
// release usa la chiave di debug e l'APK resta installabile ma non
// aggiornabile (firma diversa a ogni macchina).
val proprietaFirma = Properties().apply {
    val file = rootProject.file("key.properties")
    if (file.exists()) {
        file.inputStream().use { load(it) }
    }
}

android {
    namespace = "spesone.maratuck.com"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "spesone.maratuck.com"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        // Uses the version code from pubspec.yaml. When using split APKs, 1000 * ABI_VERSION
        // is added automatically by Flutter. (https://developer.android.com/studio/build/configure-apk-splits#configure-APK-versions)
        // You can force using the value of versionCode by specifying the `-P force-version-code-ignoring-abi=true`
        // flag during build.
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        // La configurazione esiste solo se la chiave c'e'.
        if (proprietaFirma.isNotEmpty()) {
            create("release") {
                storeFile = file(proprietaFirma.getProperty("storeFile"))
                storePassword = proprietaFirma.getProperty("storePassword")
                keyAlias = proprietaFirma.getProperty("keyAlias")
                keyPassword = proprietaFirma.getProperty("keyPassword")
            }
        }
    }

    buildTypes {
        release {
            signingConfig =
                signingConfigs.findByName("release") ?: signingConfigs.getByName("debug")
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
