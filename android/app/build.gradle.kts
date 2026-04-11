plugins {
    id("com.android.application")
    id("kotlin-android")
    // O plugin do Flutter deve vir depois dos plugins Android e Kotlin
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.controle_de_gastos_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    defaultConfig {
        applicationId = "com.example.controle_de_gastos_app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true   // ✅ sintaxe correta no Kotlin DSL
    }

    kotlinOptions {
        jvmTarget = "17"   // funciona, mas está deprecated
    }

    // Alternativa recomendada (novo DSL):
    // compilerOptions {
    //     jvmTarget.set(JvmTarget.JVM_17)
    // }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")

            isMinifyEnabled = true
            isShrinkResources = true

            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("org.jetbrains.kotlin:kotlin-stdlib:1.9.0")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.3")
}