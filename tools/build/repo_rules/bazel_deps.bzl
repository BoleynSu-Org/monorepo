def _bazel_deps_impl(repository_ctx):
    repository_ctx.file("WORKSPACE", content = "workspace(name=\"{}\")".format(repository_ctx.name))
    repository_ctx.file("BUILD", content = "")
    repository_ctx.file("deps.bzl", content = "DEPS = {}".format(repository_ctx.attr.deps))

bazel_deps = repository_rule(
    implementation = _bazel_deps_impl,
    attrs = {
        "deps": attr.string(),
    },
)
