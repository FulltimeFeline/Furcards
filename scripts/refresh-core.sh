#!/bin/sh
# Rebuilds furcards-core's XCFramework from the Android repo (where the KMP
# module lives) and syncs it — plus the golden vector file — into this repo.
# Run after any change to furcards-core. Requires a JDK for Gradle; point
# JAVA_HOME at one (Android Studio's works) if none is on PATH.
set -eu

IOS_REPO="$(cd "$(dirname "$0")/.." && pwd)"
ANDROID_REPO="${FURCARDS_ANDROID_REPO:-$HOME/AndroidStudioProjects/Furcards}"
: "${JAVA_HOME:=/Applications/Android Studio.app/Contents/jbr/Contents/Home}"
export JAVA_HOME

(cd "$ANDROID_REPO" && ./gradlew :furcards-core:assembleFurcardsCoreXCFramework)

rsync -a --delete \
    "$ANDROID_REPO/furcards-core/build/XCFrameworks/release/FurcardsCore.xcframework" \
    "$IOS_REPO/Frameworks/"
cp "$ANDROID_REPO/furcards-core/src/commonTest/resources/vectors/v1.json" \
    "$IOS_REPO/FurcardsTests/vectors-v1.json"

echo "FurcardsCore.xcframework + golden vectors refreshed."
