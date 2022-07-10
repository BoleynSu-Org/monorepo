load(":toolchain_deps.bzl", "toolchain_deps")
load(":maven_deps.bzl", "maven_deps")
load(":pip_deps.bzl", "pip_deps")
load(":go_deps.bzl", "go_deps")
load(":container_deps.bzl", "container_deps")

def nonbazel_deps(
        *,
        toolchain_deps_config = {},
        maven_deps_config = {},
        pip_deps_config = {},
        go_deps_config = {},
        container_deps_config = {}):
    toolchain_deps(**toolchain_deps_config)
    maven_deps(**maven_deps_config)
    pip_deps(**pip_deps_config)
    go_deps(**go_deps_config)
    container_deps(**container_deps_config)
