# 📱 Guia de Compilação do Aplicativo Flutter

Este guia detalha o processo completo de compilação do aplicativo 6amMart para Android, iOS e Web.

## 📋 Pré-requisitos

### Flutter SDK
- **Versão:** >= 3.2.0
- **Download:** https://flutter.dev/docs/get-started/install

### Para Android
- **Android Studio** ou **Android SDK CLI Tools**
- **JDK:** 11 ou superior
- **Gradle:** Incluído no projeto

### Para iOS (apenas macOS)
- **Xcode:** >= 14.0
- **CocoaPods:** `sudo gem install cocoapods`
- **Conta Apple Developer** (para distribuição)

### Para Web
- Nenhum pré-requisito adicional além do Flutter

## 🔧 Configuração Inicial

### 1. Instalar o Flutter

**Windows:**
```powershell
# Download do Flutter SDK
# Extraia para: C:\src\flutter

# Adicione ao PATH
$env:Path += ";C:\src\flutter\bin"

# Verifique a instalação
flutter doctor
```

**macOS/Linux:**
```bash
# Download e extração
cd ~/development
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_3.x.x-stable.zip
unzip flutter_macos_3.x.x-stable.zip

# Adicione ao PATH
export PATH="$PATH:~/development/flutter/bin"

# Verifique a instalação
flutter doctor
```

### 2. Instalar Dependências do Projeto

```bash
cd "User app and web"
flutter pub get
```

### 3. Configurar a API Base URL

Edite o arquivo de configuração da API (geralmente em `lib/util/app_constants.dart` ou `lib/config/app_config.dart`):

```dart
class AppConstants {
  static const String appName = '6amMart';
  static const String baseUrl = 'https://seudominio.com/api/v1'; // Altere aqui
  static const String apiKey = 'sua_api_key_aqui'; // Se necessário
  // ... outras configurações
}
```

## 🤖 Compilação para Android

### Configuração do Projeto Android

#### 1. Configure o package name (id do app)

Edite `android/app/build.gradle`:

```gradle
android {
    defaultConfig {
        applicationId "com.suaempresa.sixammart" // Altere aqui
        minSdkVersion 21
        targetSdkVersion 33
        versionCode 1
        versionName "1.0.0"
    }
}
```

#### 2. Configure o App Name

Edite `android/app/src/main/AndroidManifest.xml`:

```xml
<application
    android:label="6amMart"
    android:name="${applicationName}"
    android:icon="@mipmap/ic_launcher">
```

#### 3. Gerar Keystore (para Release)

```bash
# Windows
keytool -genkey -v -keystore c:\Users\SEUUSER\upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload

# macOS/Linux
keytool -genkey -v -keystore ~/upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

Crie o arquivo `android/key.properties`:

```properties
storePassword=sua_senha
keyPassword=sua_senha
keyAlias=upload
storeFile=c:/Users/SEUUSER/upload-keystore.jks
```

Edite `android/app/build.gradle` para usar o keystore:

```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    // ... configurações existentes

    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }

    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            shrinkResources true
        }
    }
}
```

### Compilar APK

```bash
cd "User app and web"

# APK Debug (para testes)
flutter build apk --debug

# APK Release (produção)
flutter build apk --release

# APK para múltiplas arquiteturas (menor tamanho)
flutter build apk --split-per-abi --release
```

**Localização dos arquivos:**
- Debug: `build/app/outputs/flutter-apk/app-debug.apk`
- Release: `build/app/outputs/flutter-apk/app-release.apk`
- Split: `build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk`, `app-arm64-v8a-release.apk`, `app-x86_64-release.apk`

### Compilar AAB (Android App Bundle) - Play Store

```bash
flutter build appbundle --release
```

**Localização:** `build/app/outputs/bundle/release/app-release.aab`

## 🍎 Compilação para iOS

**⚠️ Requer macOS com Xcode instalado**

### Configuração do Projeto iOS

#### 1. Configure o Bundle Identifier

Abra `ios/Runner.xcworkspace` no Xcode:

1. Selecione o projeto **Runner** na barra lateral
2. Em **General > Identity**, altere o **Bundle Identifier**: `com.suaempresa.sixammart`

#### 2. Configure Permissões

Edite `ios/Runner/Info.plist`:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Precisamos da sua localização para entregar pedidos</string>

<key>NSLocationAlwaysUsageDescription</key>
<string>Precisamos da sua localização para entregar pedidos</string>

<key>NSCameraUsageDescription</key>
<string>Precisamos acessar a câmera para fotos do perfil</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>Precisamos acessar a galeria para fotos do perfil</string>
```

#### 3. Instalar CocoaPods

```bash
cd ios
pod install
cd ..
```

### Compilar para iOS

```bash
cd "User app and web"

# Simulator (Debug)
flutter build ios --debug --simulator

# Release para dispositivos
flutter build ios --release
```

#### Criar IPA (para distribuição)

1. Abra o projeto no Xcode: `open ios/Runner.xcworkspace`
2. Selecione **Product > Archive**
3. Após o archive, clique em **Distribute App**
4. Escolha o método de distribuição:
   - **App Store Connect** (para publicar na App Store)
   - **Ad Hoc** (para distribuição interna)
   - **Enterprise** (para distribuição empresarial)

## 🌐 Compilação para Web

### Compilar Web

```bash
cd "User app and web"

# Build de produção
flutter build web --release

# Build com renderer específico
flutter build web --release --web-renderer canvaskit
```

**Localização:** `build/web/`

### Deploy da Web

#### Opção 1: cPanel

1. Compacte a pasta `build/web`:
   ```bash
   Compress-Archive -Path "build\web\*" -DestinationPath "6ammart-web.zip"
   ```

2. No cPanel:
   - Acesse **Gerenciador de Arquivos**
   - Navegue até `public_html` (ou subpasta)
   - Faça upload do `6ammart-web.zip`
   - Extraia os arquivos

3. Configure o `.htaccess`:
   ```apache
   <IfModule mod_rewrite.c>
     RewriteEngine On
     RewriteBase /
     RewriteCond %{REQUEST_FILENAME} !-f
     RewriteCond %{REQUEST_FILENAME} !-d
     RewriteRule ^(.*)$ index.html [L]
   </IfModule>
   ```

#### Opção 2: Firebase Hosting

```bash
# Instalar Firebase CLI
npm install -g firebase-tools

# Login
firebase login

# Inicializar
firebase init hosting

# Deploy
firebase deploy --only hosting
```

#### Opção 3: Netlify

1. Acesse https://netlify.com
2. Arraste a pasta `build/web` para fazer deploy
3. Configure redirects em `public/_redirects`:
   ```
   /*    /index.html   200
   ```

## 🔧 Configurações Avançadas

### Firebase (Push Notifications)

#### Android

1. Baixe `google-services.json` do Firebase Console
2. Coloque em: `android/app/google-services.json`

#### iOS

1. Baixe `GoogleService-Info.plist` do Firebase Console
2. No Xcode, arraste para `ios/Runner/`

### Google Maps

#### Android

Edite `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest>
    <application>
        <meta-data
            android:name="com.google.android.geo.API_KEY"
            android:value="SUA_GOOGLE_MAPS_API_KEY"/>
    </application>
</manifest>
```

#### iOS

Edite `ios/Runner/AppDelegate.swift`:

```swift
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("SUA_GOOGLE_MAPS_API_KEY")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

### Deep Links / App Links

#### Android

Edite `android/app/src/main/AndroidManifest.xml`:

```xml
<intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data
        android:scheme="https"
        android:host="seudominio.com" />
</intent-filter>
```

## 📊 Build Optimization

### Reduzir Tamanho do App

#### Android

```bash
# Split por ABI
flutter build apk --split-per-abi --release

# Obfuscate código
flutter build apk --obfuscate --split-debug-info=build/app/outputs/symbols
```

#### iOS

No Xcode:
1. **Build Settings > Deployment Postprocessing**: YES
2. **Build Settings > Strip Debug Symbols**: YES

### Performance

```bash
# Profile mode para análise
flutter build apk --profile
flutter build ios --profile

# Analisar tamanho
flutter build apk --analyze-size
flutter build appbundle --analyze-size
```

## 🐛 Troubleshooting

### Erro: Gradle build failed

```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter build apk
```

### Erro: CocoaPods out of date

```bash
cd ios
pod repo update
pod install --repo-update
cd ..
```

### Erro: Signing for "Runner" requires a development team

No Xcode:
1. Selecione o projeto **Runner**
2. Em **Signing & Capabilities**
3. Selecione seu **Team**

### Erro de permissão no Android

Verifique `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.CAMERA" />
```

## ✅ Checklist de Compilação

### Android
- [ ] Package name configurado
- [ ] App name configurado
- [ ] Keystore criado e configurado
- [ ] Google services configurado (Firebase)
- [ ] Google Maps API key configurado
- [ ] Permissões necessárias adicionadas
- [ ] Testado em dispositivo real
- [ ] APK/AAB compilado com sucesso

### iOS
- [ ] Bundle identifier configurado
- [ ] Info.plist com permissões
- [ ] CocoaPods instalados
- [ ] GoogleService-Info.plist adicionado
- [ ] Google Maps API key configurado
- [ ] Certificados e profiles configurados
- [ ] Testado em dispositivo real
- [ ] IPA criado para distribuição

### Web
- [ ] Base URL da API configurada
- [ ] Build web compilado
- [ ] .htaccess configurado (se necessário)
- [ ] Testado em navegadores principais
- [ ] Deploy realizado com sucesso

## 📱 Publicação

### Google Play Store

1. Crie uma conta de desenvolvedor: https://play.google.com/console
2. Crie um novo aplicativo
3. Faça upload do AAB em **Production > Create new release**
4. Preencha as informações necessárias (screenshots, descrição, etc.)
5. Submeta para revisão

### Apple App Store

1. Crie uma conta Apple Developer: https://developer.apple.com
2. Em App Store Connect, crie um novo app
3. Faça upload do IPA via Xcode ou Transporter
4. Preencha as informações necessárias
5. Submeta para revisão

## 📚 Recursos Adicionais

- **Flutter Docs:** https://flutter.dev/docs
- **Android Developer:** https://developer.android.com
- **iOS Developer:** https://developer.apple.com
- **Firebase Docs:** https://firebase.google.com/docs

---

**Última atualização:** Novembro 2025  
**Versão do App:** 1.0.0
