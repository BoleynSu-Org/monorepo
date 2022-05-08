# pip deps
load("//configs/deps:pip_deps.bzl", more_pip_deps = "pip_deps")

# install maven deps
load("@maven//:compat.bzl", maven_compat_repositories = "compat_repositories")
load("@maven//:defs.bzl", maven_pinned_maven_install = "pinned_maven_install")

# install go deps
load("@gazelle_go_deps//:gazelle_go_deps.bzl", "go_dependencies")

def workspace(*, enable_pip_deps = True):
    # pip deps
    if enable_pip_deps:
        more_pip_deps()

    # install maven deps
    maven_compat_repositories()
    maven_pinned_maven_install()

    # install go deps
    go_dependencies()
