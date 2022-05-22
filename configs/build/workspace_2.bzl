# install maven deps
load("@maven//:compat.bzl", maven_compat_repositories = "compat_repositories")
load("@maven//:defs.bzl", maven_pinned_maven_install = "pinned_maven_install")

# install pip deps
load("@pip//:requirements.bzl", pip_install_deps = "install_deps")

# install go deps
load("@gazelle_go_deps//:gazelle_go_deps.bzl", "go_dependencies")

def workspace():
    # install maven deps
    maven_compat_repositories()
    maven_pinned_maven_install()

    # install pip deps
    pip_install_deps()

    # install go deps
    go_dependencies()
