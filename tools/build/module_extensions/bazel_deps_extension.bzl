load("//tools/build/repo_rules/workspace:bazel_deps.bzl", "bazel_deps")

def _bazel_deps_extension(ctx):
    for module in ctx.modules:
        if module.is_root:
            (from_file,) = module.tags.from_file
            deps = ctx.read(from_file.deps)
            deps = deps[deps.find("DEPS = ") + len("DEPS = "):]
            deps = deps[:deps.find("# DEPS END")]
            bazel_deps(
                name = "bazel_deps",
                deps = deps,
                is_bzlmod = True,
            )

bazel_deps_extension = module_extension(
    implementation = _bazel_deps_extension,
    tag_classes = {"from_file": tag_class(attrs = {"deps": attr.label()})},
)
