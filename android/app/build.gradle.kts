import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")

if (keystorePropertiesFile.exists()) {
    keystorePropertiesFile.inputStream().use { keystoreProperties.load(it) }
}

android {
    namespace = "com.example.flutter_base_project"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    buildFeatures {
        resValues = true
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.flutter_base_project"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    flavorDimensions += "environment"

    productFlavors {
        create("dev") {
            dimension = "environment"
            applyEnvConfig("dev")
        }

        create("prod") {
            dimension = "environment"
            applyEnvConfig("prod")
        }
    }

    signingConfigs {
        if (keystorePropertiesFile.exists()) {
            create("release") {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = keystoreProperties["storeFile"]?.let { file(it) }
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            if (keystorePropertiesFile.exists()) {
                signingConfig = signingConfigs.getByName("release")
            }
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


fun loadEnv(env: String): Map<String, String> {
    val envFile = rootProject.file("../.env.$env")

    if (!envFile.exists()) {
        throw GradleException("Env file not found: ${envFile.absolutePath}")
    }

    return envFile
        .readLines(Charsets.UTF_8)
        .map { it.trim() }
        .filter { it.isNotEmpty() && !it.startsWith("#") }
        .associate { line ->
            val separatorIndex = line.indexOf('=')
            if (separatorIndex < 0) {
                throw GradleException("Invalid env line in .env.$env: $line")
            }

            val key = line.substring(0, separatorIndex).trim()
            val value = line.substring(separatorIndex + 1)
                .trim()
                .removeSurrounding("\"")
                .removeSurrounding("'")

            key to value
        }
}

fun com.android.build.api.dsl.ApplicationProductFlavor.applyEnvConfig(envName: String) {
    val env = loadEnv(envName)

    applicationId = requiredEnv(env, envName, "ANDROID_BUNDLE_ID")
    versionCode = requiredEnv(env, envName, "VERSION_CODE").toInt()
    versionName = requiredEnv(env, envName, "VERSION_NAME")

    resValue("string", "app_name", requiredEnv(env, envName, "APP_NAME"))
}

fun requiredEnv(env: Map<String, String>, envName: String, key: String): String {
    return env[key]
        ?: throw GradleException("Missing env key '$key' in .env.$envName")
}
