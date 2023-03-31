def _exports_files_impl(repository_ctx):
    repository_ctx.file("WORKSPACE", content = "workspace(name=\"{}\")".format(repository_ctx.name))
    repository_ctx.file("BUILD", content = 'exports_files(glob(["**"]))')
    for path, label in zip(repository_ctx.attr.paths, repository_ctx.attr.labels):
        repository_ctx.symlink(label, path)

_exports_files = repository_rule(
    implementation = _exports_files_impl,
    attrs = {
        "paths": attr.string_list(default = []),
        "labels": attr.label_list(default = []),
    },
)

def exports_files(*, name, files):
    _exports_files(name = name, paths = files.keys(), labels = files.values())
