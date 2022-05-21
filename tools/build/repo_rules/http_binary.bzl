def _http_binary_impl(ctx):
    ctx.file("WORKSPACE", "workspace(name = \"{name}\")".format(name = ctx.name))
    ctx.file("BUILD", "exports_files(['{}'])".format(ctx.attr.executable_path))
    download_info = ctx.download(
        ctx.attr.url,
        ctx.attr.executable_path,
        ctx.attr.sha256,
        True,
    )

http_binary = repository_rule(
    implementation = _http_binary_impl,
    attrs = {
        "url": attr.string(mandatory = True),
        "sha256": attr.string(mandatory = True),
        "executable_path": attr.string(default = "executable"),
    },
)
