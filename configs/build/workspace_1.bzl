# languages related
## c and cpp
load("@rules_cc//cc:repositories.bzl", "rules_cc_dependencies", "rules_cc_toolchains")

## java
load("@rules_java//java:repositories.bzl", "rules_java_dependencies", "rules_java_toolchains")

## python
load("@rules_python//python:repositories.bzl", "python_register_toolchains")

## protobuf
load("@rules_proto//proto:repositories.bzl", "rules_proto_dependencies", "rules_proto_toolchains")

## golang
load("@io_bazel_rules_go//go:deps.bzl", "go_register_toolchains", "go_rules_dependencies")

# container and k8s related
## container
load("@io_bazel_rules_docker//repositories:repositories.bzl", container_repositories = "repositories")
load("@io_bazel_rules_docker//repositories:deps.bzl", container_deps = "deps")

## k8s
load("@io_bazel_rules_k8s//k8s:k8s.bzl", "k8s_repositories")
load("@io_bazel_rules_k8s//k8s:k8s_go_deps.bzl", k8s_go_deps = "deps")

## base images
### base image for python3
load("@io_bazel_rules_docker//python3:image.bzl", container_python3_image_repositories = "repositories")

### base image for golang
load("@io_bazel_rules_docker//go:image.bzl", container_go_image_repositories = "repositories")

# local configs
## toolchains
load("//configs/deps:toolchain_deps.bzl", "GOLANG_VERSION", "PYTHON_VERSION")

## maven deps
load("//configs/deps:maven_deps.bzl", more_maven_deps = "maven_deps")

# pip deps
load("//configs/deps:pip_deps.bzl", more_pip_deps = "pip_deps")

## go deps
load("//configs/deps:go_deps.bzl", more_go_deps = "go_deps")

## container deps
load("//configs/deps:container_deps.bzl", more_container_deps = "container_deps")

# misc
load("@bazel_skylib//:workspace.bzl", "bazel_skylib_workspace")
load("@rules_pkg//:deps.bzl", "rules_pkg_dependencies")
load("@io_grpc_grpc_java//:repositories.bzl", "grpc_java_repositories")

def workspace(*, enable_maven_deps = True, enable_pip_deps = True, enable_go_deps = True, enable_container_deps = True):
    # c and cpp
    rules_cc_dependencies()
    rules_cc_toolchains()

    # java
    rules_java_dependencies()
    rules_java_toolchains()

    # python
    python_register_toolchains(
        name = "python_sdk",
        python_version = PYTHON_VERSION,
    )

    # protobuf
    rules_proto_dependencies()
    rules_proto_toolchains()

    # golang
    go_rules_dependencies()
    go_register_toolchains(version = GOLANG_VERSION)

    # container
    container_repositories()
    container_deps()

    # base image for python3
    container_python3_image_repositories()

    # base image for golang
    container_go_image_repositories()

    # k8s
    k8s_repositories()
    k8s_go_deps(go_version = None)

    # maven deps
    if enable_maven_deps:
        # FIXME(https://github.com/grpc/grpc-java/issues/9288): remove strict_visibility=False after the upstream issue is fixed.
        more_maven_deps(strict_visibility = False)

    # pip deps
    if enable_pip_deps:
        more_pip_deps()

    # go deps
    if enable_go_deps:
        more_go_deps()

    # container deps
    if enable_container_deps:
        more_container_deps()

    # misc
    bazel_skylib_workspace()
    rules_pkg_dependencies()
    grpc_java_repositories()
