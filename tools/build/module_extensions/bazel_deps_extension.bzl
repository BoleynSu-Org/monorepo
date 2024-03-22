load("//tools/build/repo_rules:bazel_deps.bzl", "bazel_deps")

def _bazel_deps_extension(ctx):
    for module in ctx.modules:
        if module.is_root:
            (from_file,) = module.tags.from_file
            bazel_deps(
                name = "bazel_deps",
                deps = from_file.deps,
            )

bazel_deps_extension = module_extension(
    implementation = _bazel_deps_extension,
    tag_classes = {"from_file": tag_class(attrs = {"deps": attr.label()})},
)
