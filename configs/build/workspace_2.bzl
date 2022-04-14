load("@maven//:compat.bzl", maven_compat_repositories = "compat_repositories")
load("@maven//:defs.bzl", maven_pinned_maven_install = "pinned_maven_install")
load("@python3_10//:defs.bzl", "interpreter")
load("//configs/deps:pip_deps.bzl", more_pip_deps = "pip_deps")

def workspace():
    maven_compat_repositories()
    maven_pinned_maven_install()
    more_pip_deps(interpreter = interpreter)
