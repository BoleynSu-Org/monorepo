load("@pip//:requirements.bzl", pip_install_deps = "install_deps")

def workspace():
    pip_install_deps()
