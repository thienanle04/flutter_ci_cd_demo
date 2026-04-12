plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

dependencies {
        // Add your Android dependencies here. Removed Firebase SDK entries to avoid
        // Kotlin/Gradle version incompatibilities in this demo pipeline. Firebase
        // App Distribution uses the CLI and does not require these SDKs in the app.
}

android {
    namespace = "com.flutter.cicd.demo"
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
        applicationId = "com.flutter.cicd.demo"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        // Ensure minSdk meets Firebase library requirements (>=23 for some libs)
        minSdk = maxOf(flutter.minSdkVersion, 23)
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // If a key.properties file exists at android/key.properties and the
            // keystore file is available (android/app/keystore.jks or storeFile path),
            // use that for release signing. Otherwise fall back to debug signing.
            val keystorePropertiesFile = rootProject.file("key.properties")
            val keystoreMap = mutableMapOf<String, String>()
            if (keystorePropertiesFile.exists()) {
                keystorePropertiesFile.readLines().forEach { line ->
                    val trimmed = line.trim()
                    if (trimmed.isNotEmpty() && !trimmed.startsWith("#") && trimmed.contains("=")) {
                        val (k, v) = trimmed.split("=", limit = 2)
                        keystoreMap[k.trim()] = v.trim()
                    }
                }
            }

            val storeFilePath = keystoreMap["storeFile"]
            val hasReleaseKeystore = if (storeFilePath != null) {
                val candidates = listOf(
                    file(storeFilePath), // android/app/<storeFile>
                    rootProject.file("$storeFilePath"), // android/<storeFile>
                    rootProject.file("app/$storeFilePath") // android/app/<storeFile>
                )
                candidates.any { it.exists() }
            } else {
                false
            }

            // Only enable release signing if keystore is present AND RELEASE_SIGNING_ENABLED env var is "true".
            val releaseSigningEnabled = System.getenv("RELEASE_SIGNING_ENABLED") == "true"
            if (hasReleaseKeystore && releaseSigningEnabled) {
                signingConfig = signingConfigs.create("release").also { sc ->
                    val storePwd = keystoreMap["storePassword"]
                    val keyPwd = keystoreMap["keyPassword"]
                    val keyAliasProp = keystoreMap["keyAlias"]
                    val resolvedPath = storeFilePath!!
                    val filePath = listOf(
                        file(resolvedPath),
                        rootProject.file(resolvedPath),
                        rootProject.file("app/$resolvedPath")
                    ).firstOrNull { it.exists() }?.path ?: resolvedPath
                    sc.storeFile = file(filePath)
                    if (storePwd != null) sc.storePassword = storePwd
                    if (keyPwd != null) sc.keyPassword = keyPwd
                    if (keyAliasProp != null) sc.keyAlias = keyAliasProp
                }
            } else {
                // Default to debug signing so local release runs still work. To enable
                // release signing in CI, set the environment variable
                // `RELEASE_SIGNING_ENABLED=true` and provide valid keystore and passwords.
                signingConfig = signingConfigs.getByName("debug")
            }
        }
    }
}

flutter {
    source = "../.."
}
