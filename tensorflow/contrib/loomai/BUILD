# Description:
#   Native Android build of TensorFlow to run in NDK projects.

package(default_visibility = ["//visibility:public"])

licenses(["notice"])  # Apache 2.0

exports_files(["LICENSE"])

load(
    "//tensorflow:tensorflow.bzl",
    "if_android",
    "tf_copts",
    "tf_kernel_library",
)

# Version script to export C API symbols. Identical to
# //tensorflow/c:version_script.lds except it doesn't name the nodes
# (i.e. VERS_1.0) because it was causing the executable to be unable to link at
# runtime (unsure why though).
exports_files([
    "version_script.lds",
])

# Attention ops we need for some of our models. Note that we don't use
# //tensorflow/core/kernels:attention_ops because includes dependencies that
# won't build on Android but are unnecessary to use these ops.
tf_kernel_library(
    name = "attention_ops_android",
    srcs = [
        "//tensorflow/core/kernels:attention_ops.cc",
    ],
    deps = [
        "//tensorflow/core:android_tensorflow_lib",
    ],
)

# Build a shared library for Android to use in native NDK apps. Similar to
# //tensorflow/contrib/android:libtensorflow_inference.so except we do not
# compile the JNI interface and use the C API instead.
#
# Also includes attention ops which we need to run some of our models.
#
# Build with:
#
# bazel build -c opt //tensorflow/contrib/loomai:libtensorflow_inference_native.so \
#   --crosstool_top=//external:android/crosstool \
#   --host_crosstool_top=@bazel_tools//tools/cpp:toolchain \
#   --cpu=armeabi-v7a
cc_binary(
    name = "libtensorflow_inference_native.so",
    srcs = [],
    copts = tf_copts() + [
        "-ffunction-sections",
        "-fdata-sections",
    ],
    linkopts = if_android([
        "-landroid",
        "-latomic",
        "-ldl",
        "-llog",
        "-lm",
        "-z defs",
        "-s",
        "-Wl,--gc-sections",
        "-Wl,--version-script",  # This line must be directly followed by the version_script.lds file
        ":version_script.lds",
    ]),
    linkshared = 1,
    linkstatic = 1,
    tags = [
        "manual",
        "notap",
    ],
    deps = [
        "//tensorflow/core:android_tensorflow_lib",
        "//tensorflow/c:c_api",
        ":attention_ops_android",
        ":version_script.lds",
    ],
)
