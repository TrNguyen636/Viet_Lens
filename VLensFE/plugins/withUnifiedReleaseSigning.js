const { withAppBuildGradle, createRunOncePlugin } = require('@expo/config-plugins');
const fs = require('fs');
const path = require('path');

/**
 * withUnifiedReleaseSigning Expo Config Plugin
 * Configures Release signing configuration with vietlens-release.jks for Vietlens mobile app.
 */
function withUnifiedReleaseSigning(config, options = {}) {
  const storeFileName = options.storeFile || 'vietlens-release.jks';
  const keyAlias = options.keyAlias || 'vietlens';

  return withAppBuildGradle(config, (gradleConfig) => {
    let contents = gradleConfig.modResults.contents;

    // 1. Khai báo biến đọc keystore & credentials từ ENV / credentials.txt trước signingConfigs
    if (!contents.includes('def releaseStoreFile')) {
      const releaseSigningSnippet = `
    // Unified Release Signing Credentials & Keystore Setup
    def releaseStoreFile = findProperty("VIETLENS_RELEASE_STORE_FILE") ?: "${storeFileName}"
    def releaseKeyAlias = findProperty("VIETLENS_RELEASE_KEY_ALIAS") ?: "${keyAlias}"
    def releaseStorePassword = System.getenv("ANDROID_KEYSTORE_PASSWORD") ?: findProperty("ANDROID_KEYSTORE_PASSWORD")
    def releaseKeyPassword = System.getenv("ANDROID_KEY_PASSWORD") ?: findProperty("ANDROID_KEY_PASSWORD")

    def credsCandidates = [
        new File(System.getProperty("user.home"), ".vietlens-signing/credentials.txt"),
        file("../credentials.txt"),
        file("../../signing/credentials.txt"),
        file("credentials.txt")
    ]
    for (File f : credsCandidates) {
        if (f.exists()) {
            f.getText("UTF-8").replace("\\uFEFF", "").eachLine { line ->
                def trimmed = line.trim()
                if (trimmed && !trimmed.startsWith("#") && trimmed.contains("=")) {
                    def parts = trimmed.split("=", 2)
                    def k = parts[0].trim()
                    def v = parts[1].trim()
                    if (!releaseStorePassword && k == "STORE_PASSWORD") {
                        releaseStorePassword = v
                    }
                    if (!releaseKeyPassword && k == "KEY_PASSWORD") {
                        releaseKeyPassword = v
                    }
                }
            }
            if (releaseStorePassword && releaseKeyPassword) {
                break
            }
        }
    }

    def resolvedStoreFile = file(releaseStoreFile)
    if (!resolvedStoreFile.exists()) {
        resolvedStoreFile = file("../signing/" + releaseStoreFile)
    }
    if (!resolvedStoreFile.exists()) {
        resolvedStoreFile = file("../../signing/" + releaseStoreFile)
    }

    println "[Vietlens] Keystore path: \${resolvedStoreFile.absolutePath} (exists: \${resolvedStoreFile.exists()})"
    println "[Vietlens] Release signing credentials loaded: \${releaseStorePassword != null && releaseKeyPassword != null}"
`;
      contents = contents.replace(/signingConfigs\s*\{/, `${releaseSigningSnippet}\n    signingConfigs {`);
    }

    // 2. Thêm khối signingConfigs.release nếu prebuild chưa có
    if (!/signingConfigs\s*\{[\s\S]*?\brelease\s*\{/.test(contents)) {
      const releaseConfigBlock = `        release {
            if (resolvedStoreFile.exists() && releaseStorePassword && releaseKeyPassword) {
                storeFile resolvedStoreFile
                storePassword releaseStorePassword
                keyAlias releaseKeyAlias
                keyPassword releaseKeyPassword
                enableV1Signing = true
                enableV2Signing = true
                enableV3Signing = true
                enableV4Signing = true
            } else {
                storeFile file('debug.keystore')
                storePassword 'android'
                keyAlias 'androiddebugkey'
                keyPassword 'android'
            }
        }`;
      contents = contents.replace(/(signingConfigs\s*\{)/, `$1\n${releaseConfigBlock}`);
    }

    // 3. Chuyển buildTypes.release sang dùng signingConfigs.release thay vì debug
    contents = contents.replace(
      /(buildTypes\s*\{[\s\S]*?\brelease\s*\{[\s\S]*?)signingConfig\s*(?:=\s*)?signingConfigs\.debug/,
      '$1signingConfig = signingConfigs.release'
    );

    gradleConfig.modResults.contents = contents;
    return gradleConfig;
  });
}

module.exports = createRunOncePlugin(withUnifiedReleaseSigning, 'withUnifiedReleaseSigning', '1.0.0');
