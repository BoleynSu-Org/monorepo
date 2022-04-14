load("@bazel_skylib//rules:write_file.bzl", "write_file")
load("@rules_python//python:pip.bzl", python_pip_parse = "pip_parse")
load(":deps.bzl", "deps")

def pip_deps(interpreter = None):
    python_pip_parse(
        name = "pip",
        requirements_lock = "//:requirements.txt",
        python_interpreter_target = interpreter,
    )

def requirements_in(name):
    write_file(
        name = name,
        out = "{}.requirements.in".format(name),
        content = ["{name} == {version}".format(**dep) for dep in deps["pip_deps"]],
    )
