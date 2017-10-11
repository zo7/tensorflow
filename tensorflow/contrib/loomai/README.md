# Native TensorFlow Builds

TensorFlow builds for use in native projects.

## Linux / macOS

To build for Linux or macOS, we only need the standard build that TensorFlow
provides to use the C API. However, we provide a script that will easily build
it for you and copy everything you need to your favorite directory.

From the root of the TensorFlow source tree, run:
```sh
tensorflow/contrib/loomai/build_linux.sh my/favorite/directory
```

The library can be found in `my/favorite/directory/lib/libtensorflow.so` and
includes in `my/favorite/directory/include`.

**NOTE:** This will only build with `-march=native` so it will only work on
your host architecture.

## Android

For Android, we need to use a special Bazel build rule to build TensorFlow for
Android with the C API and the ops we need to run some of our models.

First follow the Bazel setup instructions described in
[tensorflow/examples/android/README.md](../../examples/android/README.md) to
configure Bazel to use your Android SDK/NDK.

Then from the root of the TensorFlow source tree, run:
```sh
tensorflow/contrib/loomai/build_linux.sh my/favorite/directory
```

The libraries can be found in
`my/favorite/directory/lib/<arch>/libtensorflow_inference_native.so` (where
`<arch>` is the corresponding architecture) and includes in
`my/favorite/directory/include`.

If you wish to build it by hand, you may instead run Bazel's build command
directly:
``` sh
bazel build -c opt //tensorflow/contrib/loomai:libtensorflow_inference_native.so \
   --crosstool_top=//external:android/crosstool \
   --host_crosstool_top=@bazel_tools//tools/cpp:toolchain \
   --cpu=<arch>
```

Replacing `<arch>` with your desired architecture. Your build can then be found
in `bazel-bin/tensorflow/contrib/loomai/libtensorflow_inference_native.so`.
