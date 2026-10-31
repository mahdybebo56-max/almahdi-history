@echo off
chcp 65001 >nul
setlocal
where flutter >nul 2>nul
if errorlevel 1 (
  echo Flutter is not installed or not added to PATH.
  echo Install Flutter SDK and Android Studio, then run this file again.
  pause
  exit /b 1
)
if not exist android (
  echo Creating Android project files...
  flutter create . --platforms=android
  if errorlevel 1 goto fail
)
echo Getting dependencies...
flutter pub get
if errorlevel 1 goto fail
echo Building release APK...
flutter build apk --release
if errorlevel 1 goto fail
echo.
echo Build completed. APK location:
echo build\app\outputs\flutter-apk\app-release.apk
pause
exit /b 0
:fail
echo Build failed. Copy the error message and send it for troubleshooting.
pause
exit /b 1
