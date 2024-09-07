load("@rules_cc//cc:defs.bzl", "cc_binary")

def bsl_binary(*, name, srcs):
    native.genrule(
        name = "{}_src".format(name),
        srcs = srcs,
        outs = [
            "{}.out.bsl".format(name),
            "{}.out.bsl.c".format(name),
        ],
        cmd = "cp $(SRCS) $(execpath {name}.out.bsl); $(execpath {compiler}) -c $(execpath {name}.out.bsl)".format(
            name = name,
            compiler = Label("//legacy/BSL-AlgorithmW/src:main"),
        ),
        tools = [Label("//legacy/BSL-AlgorithmW/src:main")],
    )

    cc_binary(
        name = name,
        srcs = ["{}.out.bsl.c".format(name)],
        copts = [
            "--include=stdio.h",
            "-Wno-error=int-conversion",
            "-Wno-error=all",
            "-w",
        ],
        deps = [Label("//legacy/BSL-AlgorithmW/rt")],
    )
