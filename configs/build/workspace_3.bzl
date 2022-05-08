# install pip deps
load("@pip//:requirements.bzl", pip_install_deps = "install_deps")

def workspace():
    # install pip deps
    pip_install_deps()
