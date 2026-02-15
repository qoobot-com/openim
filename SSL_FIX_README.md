# Flutter SSL 证书问题解决方案

## 问题描述
构建 Flutter 项目时出现以下错误：
```
javax.net.ssl.SSLHandshakeException: PKIX path building failed
```

## 解决方案

### 1. 已完成的配置修改

#### gradle.properties 配置
已在以下位置添加了 SSL 和网络配置：
- `android/gradle.properties`
- 项目根目录下的 `gradle.properties`

主要配置包括：
- 忽略 SSL 证书验证
- 增加网络超时时间
- 配置国内镜像源
- 优化 JVM 内存设置

#### gradle-wrapper.properties 修改
已将 Gradle 分发包地址改为腾讯云镜像：
```
distributionUrl=https\://mirrors.cloud.tencent.com/gradle/gradle-8.14-all.zip
```

### 2. 使用方法

#### 方法一：运行批处理脚本（推荐）
双击运行 `clean_and_build.bat` 文件，该脚本会自动：
1. 清理项目缓存
2. 删除构建目录
3. 重新获取依赖
4. 构建 APK

#### 方法二：手动执行命令
打开命令提示符，执行以下命令：

```cmd
# 清理项目
flutter clean

# 获取依赖
flutter pub get

# 构建 APK
flutter build apk --debug
```

### 3. 备用解决方案

如果上述方法仍无法解决问题，可以尝试：

#### 方案 A：使用其他镜像源
在 `android/gradle/wrapper/gradle-wrapper.properties` 中取消注释其他镜像：
```
# 华为云镜像
distributionUrl=https\://mirrors.huaweicloud.com/gradle/gradle-8.14-all.zip
```

#### 方案 B：手动下载 Gradle
1. 访问 https://mirrors.cloud.tencent.com/gradle/gradle-8.14-all.zip
2. 下载后放到 `~/.gradle/wrapper/dists/gradle-8.14-all/` 目录下
3. 重新构建项目

#### 方案 C：检查网络环境
- 确保网络连接正常
- 如果在公司网络，可能需要配置代理
- 尝试使用 VPN 连接

### 4. 验证修复结果

成功修复后应该能看到类似输出：
```
Running Gradle task 'assembleDebug'...
✓ Built build\app\outputs\flutter-apk\app-debug.apk.
```

### 5. 注意事项

- 这些配置主要是为了绕过 SSL 证书问题，适合开发环境使用
- 生产环境建议使用正确的证书配置
- 如果问题持续存在，建议更新 Java JDK 版本

## 技术说明

错误原因：Java 的 SSL 证书验证机制无法验证某些服务器的证书链，特别是在使用国内网络环境时。

解决方案原理：
1. 通过配置忽略证书验证
2. 使用国内镜像源避免网络问题
3. 增加超时时间应对网络延迟
4. 优化内存配置提高构建稳定性