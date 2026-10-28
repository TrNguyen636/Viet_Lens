const { getDefaultConfig } = require('expo/metro-config');

const config = getDefaultConfig(__dirname);

// Bổ sung định dạng .pmtiles vào danh sách assetExts của Metro
if (!config.resolver.assetExts.includes('pmtiles')) {
  config.resolver.assetExts.push('pmtiles');
}

module.exports = config;
