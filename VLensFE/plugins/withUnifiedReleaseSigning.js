const { withAppBuildGradle, createRunOncePlugin } = require('@expo/config-plugins');
const fs = require('fs');
const path = require('path');

/**
 * Tìm vị trí dấu '{' và '}' tương ứng của 1 block Groovy để không khớp nhầm sang block kế bên (như buildTypes.release)
 */
function findBlockBounds(source, blockName) {
  const match = new RegExp(`\\b${blockName}\\s*\\{`).exec(source);
  if (!match) return null;
  const openBraceIndex = source.indexOf('{', match.index);
  let depth = 0;
  for (let i = openBraceIndex; i < source.length; i++) {
    if (source[i] === '{') depth++;
    else if (source[i] === '}') {
      depth--;
      if (depth === 0) {
        return { start: openBraceIndex, end: i };
      }
    }
  }
  return null;
}

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

    // 2. Chỉ kiểm tra bên trong scope của signingConfigs { ... } để không khớp nhầm buildTypes.release
    const signingBounds = findBlockBounds(contents, 'signingConfigs');
    const signingBlock = signingBounds
      ? contents.slice(signingBounds.start, signingBounds.end + 1)
      : '';
    if (signingBounds && !/\brelease\s*\{/.test(signingBlock)) {
      const releaseConfigBlock = `
        release {
            if (resolvedStoreFile.exists() && releaseStorePassword && releaseKeyPassword) {
                storeFile resolvedStoreFile
                storePassword releaseStorePassword
                keyAlias releaseKeyAlias
                keyPassword releaseKeyPassword
                enableV1Signing = true
                enableV2Signing = true
            } else {
                storeFile file('debug.keystore')
                storePassword 'android'
                keyAlias 'androiddebugkey'
                keyPassword 'android'
            }
        }`;
      contents =
        contents.slice(0, signingBounds.start + 1) +
        releaseConfigBlock +
        contents.slice(signingBounds.start + 1);
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
