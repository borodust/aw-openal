#!/bin/bash

WORK_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

LIBRARY_DIR=$WORK_DIR/openal/

REST_ARGS=
while [[ $# -gt 0 ]]
do
key="$1"
case $key in
    --arch)
        TARGET_ARCH="$2"
        shift
        shift
        ;;
    --ndk)
        NDK="$2"
        shift
        shift
        ;;
    *)
        REST_ARGS+="$1"
        shift
        ;;
esac
done

if [[ -z "$REST_ARGS" ]]; then
        echo "Build platform missing, need desktop or android"
        exit 1
fi

BUILD_DIR="$WORK_DIR/build/$REST_ARGS/"

case "$(uname -s)" in
    Linux*)
        HOST_PLATFORM=LINUX
        ;;
    Darwin*)
        HOST_PLATFORM=DARWIN
        ;;
    *)
        HOST_PLATFORM=WIN
        ;;
esac


function build_android {
    if [[ -z "$NDK" ]]; then
        echo "Path to Android SDK must be provided via --ndk"
        exit 1
    fi

    ANDROID_ABI=arm64-v8a
    case "$TARGET_ARCH" in
        aarch64)
            ANDROID_ABI=arm64-v8a
            ;;
        armv7a)
            ANDROID_ABI=armeabi-v7a
            ;;
        *)
            echo "Using ABI $ANDROID_ABI"
            ;;
    esac

    mkdir -p $BUILD_DIR && cd $BUILD_DIR
    cmake -DCLAW_ANDROID_BUILD=ON \
          -DANDROID_ABI=$ANDROID_ABI \
          -DANDROID_ARM_NEON=ON \
          -DCMAKE_TOOLCHAIN_FILE="$NDK/build/cmake/android.toolchain.cmake" \
          $LIBRARY_DIR
    cmake --build . --config MinSizeRel
}

function build_desktop {
    case "$HOST_PLATFORM" in
        LINUX)
            EXT_CMAKE_OPTS=
            ;;
        DARWIN)
            EXT_CMAKE_OPTS= -DALSOFT_REQUIRE_COREAUDIO=ON
            ;;
        WIN)
            EXT_CMAKE_OPTS= -DALSOFT_REQUIRE_WINMM=ON -DALSOFT_REQUIRE_DSOUND=ON -DALSOFT_REQUIRE_WASAPI=ON
            ;;
    esac

    mkdir -p $BUILD_DIR && cd $BUILD_DIR
    cmake -DCMAKE_C_COMPILER=clang \
          -DCMAKE_CXX_COMPILER=clang++ \
          -DCMAKE_SHARED_LINKER_FLAGS="-stdlib=libc++ -lc++abi" \
          -DCMAKE_CXX_FLAGS="-stdlib=libc++" \
          -DCMAKE_SKIP_BUILD_RPATH=OFF \
          -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON \
          '-DCMAKE_INSTALL_RPATH=${ORIGIN}' \
          -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
	  -DLIBTYPE=SHARED \
	  -DBUILD_SHARED_LIBS=OFF \
	  -DALSOFT_UTILS=OFF \
	  -DALSOFT_NO_CONFIG_UTIL=OFF \
	  -DALSOFT_EXAMPLES=OFF \
	  -DALSOFT_INSTALL=OFF \
	  -DALSOFT_CPUEXT_SSE3=OFF \
	  -DALSOFT_CPUEXT_SSE4_1=OFF \
          ${EXT_CMAKE_OPTS} \
          $LIBRARY_DIR
    cmake --build . --config MinSizeRel
}


case "$REST_ARGS" in
    desktop)
        build_desktop
        ;;
    android)
        build_android
        ;;
    *)
        echo "Unrecognized platform $REST_ARGS"
        exit 1
        ;;
esac
