@echo off
setlocal enabledelayedexpansion

set "file=C:\Users\sctam\AppData\Local\Pub\Cache\hosted\pub.dev\dash_bubble-2.0.0\android\build.gradle"
set "temp=%TEMP%\build.gradle.tmp"

(
echo group 'dev.moaz.dash_bubble'
echo version '1.0-SNAPSHOT'
echo.
echo buildscript {
echo     ext.kotlin_version = '1.7.10'
echo     repositories {
echo         google^(^)
echo         mavenCentral^(^)
echo     }
echo.
echo     dependencies {
echo         classpath 'com.android.tools.build:gradle:7.2.0'
echo         classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
echo     }
echo }
echo.
echo allprojects {
echo     repositories {
echo         google^(^)
echo         mavenCentral^(^)
echo     }
echo }
echo.
echo apply plugin: 'com.android.library'
echo apply plugin: 'kotlin-android'
echo apply plugin: 'kotlin-parcelize'
echo.
echo android {
echo     namespace 'dev.moaz.dash_bubble'
echo     compileSdkVersion 33
echo.
echo     compileOptions {
echo         sourceCompatibility JavaVersion.VERSION_1_8
echo         targetCompatibility JavaVersion.VERSION_1_8
echo     }
echo.
echo     kotlinOptions {
echo         jvmTarget = '1.8'
echo     }
echo.
echo     sourceSets {
echo         main.java.srcDirs += 'src/main/kotlin'
echo     }
echo.
echo     defaultConfig {
echo         minSdkVersion 21
echo     }
echo }
echo.
echo dependencies {
echo //    def lifecycle_version = "2.5.1"
echo.
echo     implementation "androidx.core:core-ktx:1.9.0"
echo     implementation 'androidx.localbroadcastmanager:localbroadcastmanager:1.1.0'
echo     implementation^("io.github.torrydo:floating-bubble-view:0.5.3"^)
echo.
echo //    implementation "androidx.lifecycle:lifecycle-process:$lifecycle_version"
echo //    implementation "androidx.lifecycle:lifecycle-common:$lifecycle_version"
echo }
) > "%temp%"

copy /Y "%temp%" "%file%" > nul
del "%temp%"

echo Namespace added successfully!
