def _bazel_deps_impl(repository_ctx):
    repository_ctx.file("WORKSPACE", content = "workspace(name=\"{}\")".format(repository_ctx.name))
    repository_ctx.file("BUILD", content = "")
    deps = repository_ctx.read(repository_ctx.attr.deps)
    deps = deps[deps.find("DEPS = "):]
    deps = deps[:deps.find("# DEPS END")]
    repository_ctx.file("deps.bzl", content = deps)

bazel_deps = repository_rule(
    implementation = _bazel_deps_impl,
    attrs = {
        "deps": attr.label(),
    },
)
