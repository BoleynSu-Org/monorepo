# install maven deps
load("@maven//:compat.bzl", maven_compat_repositories = "compat_repositories")
load("@maven//:defs.bzl", maven_pinned_maven_install = "pinned_maven_install")

# install go deps
load("@gazelle_go_deps//:gazelle_go_deps.bzl", "go_dependencies")

# pip deps
load("@python_sdk//:defs.bzl", "interpreter")
load("//configs/deps:pip_deps.bzl", more_pip_deps = "pip_deps")

def workspace():
    # install maven deps
    maven_compat_repositories()
    maven_pinned_maven_install()

    # install go deps
    go_dependencies()

    # pip deps
    more_pip_deps(python_interpreter_target = interpreter)
