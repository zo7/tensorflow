#!/usr/bin/env sh
#
# Builds //tensorflow/contrib/loomai:libtensorflow_inference_native.so for
# several Android architectures and copies them to a directory to make them
# easy to use in other projects.

if [[ "$@" = "-h" || "$@" = "--help" ]]; then
    echo "Build libtensorflow_inference_native.so for multiple Android architectures."
    echo "Usage: tensorflow/contrib/loomai/build_all_android.sh <directory>"
    exit 0
fi

if [ -z "$@" ]; then
    echo "Please provide a directory to copy files to."
    exit 1
fi

if [ ! -f tensorflow/tensorflow.bzl ]; then
    echo "Please run this script from the root of the TensorFlow source tree."
    exit 1
fi

dst_dir=$@


# Copy include files

include_dir=$dst_dir/include/tensorflow/c

if [ ! -d "$include_dir" ]; then
    mkdir -p $include_dir
fi

cp tensorflow/c/c_api.h $include_dir
cp LICENSE $include_dir

chmod 755 $include_dir/c_api.h
chmod 755 $include_dir/LICENSE


# Build and copy libs for each architecture

lib_dir=$dst_dir/lib
bazel_build_path=bazel-bin/tensorflow/contrib/loomai/libtensorflow_inference_native.so

for arch in arm64-v8a armeabi-v7a x86 x86_64; do

    echo "Building TensorFlow for '$arch'"

    bazel build -c opt //tensorflow/contrib/loomai:libtensorflow_inference_native.so \
        --crosstool_top=//external:android/crosstool \
        --host_crosstool_top=@bazel_tools//tools/cpp:toolchain \
        --cpu=$arch

    if [ $? -eq 0 ]; then
        if [ ! -d "$lib_dir/$arch" ]; then
            mkdir -p $lib_dir/$arch
        fi
        cp $bazel_build_path $lib_dir/$arch
    else
        echo "Unable to build TensorFlow for architecture '$arch'"
        exit 1
    fi
done

echo "All builds were successful."

