#!/usr/bin/env sh
#
# Builds //tensorflow/:libtensorflow.so for Linux/macOS and copies files to a
# directory to make them easy to use in other projects.

if [[ "$@" = "-h" || "$@" = "--help" ]]; then
    echo "Build libtensorflow.so for Linux/macOS."
    echo "Usage: tensorflow/contrib/loomai/build_all_linux.sh <directory>"
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
bazel_build_path=bazel-bin/tensorflow/libtensorflow.so

bazel build -c opt //tensorflow:libtensorflow.so

if [ $? -eq 0 ]; then
    if [ ! -d "$lib_dir" ]; then
        mkdir -p $lib_dir
    fi
    cp $bazel_build_path $lib_dir
else
    echo "Unable to build TensorFlow."
    exit 1
fi

echo "All builds were successful."

