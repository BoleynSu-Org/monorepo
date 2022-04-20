load("@rules_python//python:pip.bzl", python_pip_parse = "pip_parse")
load("//tools/build/rules:requirements.bzl", "requirements_txt")
load(":deps.bzl", "deps")

packages = [dep["name"] for dep in deps["pip_deps"]]
versions = {dep["name"]: dep["version"] for dep in deps["pip_deps"]}

def pip_deps(*, interpreter = None, **kwargs):
    python_pip_parse(
        name = "pip",
        requirements_lock = Label("//:requirements.txt"),
        python_interpreter_target = interpreter,
        **kwargs
    )

def requirements_in(*, name, out, **kwargs):
    requirements_txt(name = name, out = out, packages = packages, versions = versions, **kwargs)
