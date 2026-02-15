@echo off
echo 正在修复 AndroidX 配置并构建 Flutter 项目...

:: 清理 Flutter 缓存
echo 清理 Flutter 缓存...
flutter clean

:: 删除 Gradle 缓存
echo 删除 Gradle 缓存...
if exist ".gradle" rmdir /s /q ".gradle"
if exist "android\.gradle" rmdir /s /q "android\.gradle"

:: 删除构建目录
echo 删除构建目录...
if exist "build" rmdir /s /q "build"
if exist "android\build" rmdir /s /q "android\build"
if exist "android\app\build" rmdir /s /q "android\app\build"

:: 验证 AndroidX 配置
echo 验证 AndroidX 配置...
echo 检查 android\gradle.properties 文件...
type android\gradle.properties | findstr "android.useAndroidX"
type android\gradle.properties | findstr "android.enableJetifier"

:: 获取依赖
echo 获取 Flutter 依赖...
flutter pub get

:: 重新构建
echo 开始构建...
flutter build apk --debug

echo.
echo 构建完成！
echo 如果仍有问题，请检查：
echo 1. 网络连接是否正常
echo 2. 是否需要使用 VPN
echo 3. Java 环境配置是否正确
pause