load("@rules_shell//shell:sh_binary.bzl", "sh_binary")

filegroup(
    name = "genfile_tpl_sh",
    srcs = ["genfile.tpl.sh"],
    visibility = ["//visibility:public"],
)

sh_binary(
    name = "genfile",
    srcs = ["genfile.sh"],
    visibility = ["//visibility:public"],
)
