load("@rules_shell//shell:sh_test.bzl", "sh_test")
load(":defs.bzl", "bsl_binary")

bsl_binary(
    name = "bootstrap",
    srcs = ["bootstrap.bsl"],
)

bsl_binary(
    name = "existential_type",
    srcs = ["existential_type.bsl"],
)

bsl_binary(
    name = "gadt",
    srcs = ["gadt.bsl"],
)

bsl_binary(
    name = "higher_kinded_types",
    srcs = ["higher_kinded_types.bsl"],
)

bsl_binary(
    name = "higher_rank",
    srcs = ["higher_rank.bsl"],
)

bsl_binary(
    name = "rec_and_lazy",
    srcs = ["rec_and_lazy.bsl"],
)

bsl_binary(
    name = "sort",
    srcs = ["sort.bsl"],
)

bsl_binary(
    name = "sort_improved",
    srcs = ["sort_improved.bsl"],
)

bsl_binary(
    name = "std",
    srcs = ["std.bsl"],
)

sh_test(
    name = "bootstrap_test",
    srcs = ["bootstrap_test.sh"],
    data = [
        ":bootstrap",
        "@rules_shell//shell/runfiles",
    ],
)
