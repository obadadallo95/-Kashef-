#!/bin/bash

# Kashef Release Build Script
# Usage: ./build_release.sh

echo "🚀 Starting Release Build for Kashef v1.0.0..."

echo "🧹 Cleaning project..."
flutter clean

echo "📦 Getting dependencies..."
flutter pub get

echo "🔨 Building Release APK (Obfuscated)..."
# Using --obfuscate and --split-debug-info for security (Blocklist protection)
flutter build apk --obfuscate --split-debug-info=./debug-info --release

if [ -f "build/app/outputs/flutter-apk/app-release.apk" ]; then
    echo "📋 Copying APK to root..."
    cp build/app/outputs/flutter-apk/app-release.apk ./Kashef_v1.0.0.apk
    echo "✅ APK is ready: Kashef_v1.0.0.apk"
else
    echo "❌ Build failed! APK not found."
    exit 1
fi
