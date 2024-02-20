load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file")

def to_http_archive(*, name, sha256, url = None, urls = None, strip_prefix = None, patches = None, patch_cmds = None, build_file = None, build_file_content = None, workspace_file_content = None, archive_type = None, **kwargs):
    if patches != None:
        for patch in patches:
            if not patch.startswith("@"):
                fail("The target for patches must specify workspace name.")
    if build_file != None and not build_file.startswith("@"):
        fail("The target for build_file must specify workspace name.")
    return {
        "name": name,
        "sha256": sha256,
        "url": url,
        "urls": urls,
        "strip_prefix": strip_prefix,
        "patches": patches,
        "patch_cmds": patch_cmds,
        "build_file": build_file,
        "build_file_content": build_file_content,
        "workspace_file_content": workspace_file_content,
        "type": archive_type,
    }

def to_http_file(*, name, sha256, url = None, urls = None, executable = None, downloaded_file_path = None, **kwargs):
    return {
        "name": name,
        "sha256": sha256,
        "urls": [url] if url else urls,
        "executable": executable,
        "downloaded_file_path": downloaded_file_path,
    }

TYPE_TO_RULE_MAPPING = {
    "http_archive": (http_archive, to_http_archive),
    "http_file": (http_file, to_http_file),
}

def _bazel_deps_impl(repository_ctx):
    repository_ctx.file("WORKSPACE", content = "workspace(name=\"{}\")".format(repository_ctx.name))

    repository_ctx.file("BUILD", content = "")
    repository_ctx.file("deps.bzl", content = "DEPS = {}".format(json.decode(repository_ctx.attr.deps_json) if repository_ctx.attr.deps_json else repository_ctx.attr.deps))

    bazel_deps = repository_ctx.read(repository_ctx.attr.bazel_deps)
    repository_ctx.file("bazel_deps.bzl", content = """load("//:deps.bzl", "DEPS")
{}
BAZEL_DEPS = {{dep["name"]: dep for dep in DEPS["bazel_deps"]}}
""".format(bazel_deps))

    load_content = ""
    install_bazel_deps_content = "def install_bazel_deps():\n"
    if repository_ctx.attr.deps_name:
        for name, load_deps in zip(repository_ctx.attr.deps_name, repository_ctx.attr.deps_load_deps):
            name = name.replace("-", "_")
            repository_ctx.file("repos/{}.bzl".format(name), content = load_deps)
            load_content += 'load(":repos/{name}.bzl", {name}_deps = "deps")\n'.format(name = name)
            install_bazel_deps_content += "    {name}_deps()\n".format(name = name)
    else:
        install_bazel_deps_content += "    pass\n"

    repository_ctx.file("install_bazel_deps.bzl", content = load_content + install_bazel_deps_content)

    for path, label in zip(repository_ctx.attr.paths, repository_ctx.attr.labels):
        repository_ctx.symlink(label, path)

_bazel_deps = repository_rule(
    implementation = _bazel_deps_impl,
    attrs = {
        "deps_name": attr.string_list(default = []),
        "deps_load_deps": attr.string_list(default = []),
        "deps_json": attr.string(),
        "deps": attr.string(),
        "bazel_deps": attr.label(),
        "paths": attr.string_list(default = []),
        "labels": attr.label_list(default = []),
    },
)

def bazel_deps(
        *,
        name,
        deps,
        type_to_rule_mapping = TYPE_TO_RULE_MAPPING,
        is_bzlmod = False):
    if is_bzlmod:
        files = [
            "container_deps.bzl",
            "go_deps.bzl",
            "install_nonbazel_deps.bzl",
            "maven_deps.bzl",
            "nonbazel_deps.bzl",
            "pip_deps.bzl",
            "toolchain_deps.bzl",
        ]
        _bazel_deps(
            name = name,
            deps_name = [],
            deps_load_deps = [],
            deps = deps,
            bazel_deps = Label("//tools/build/repo_rules/workspace:bazel_deps.bzl"),
            paths = files,
            labels = [Label("//tools/build/repo_rules/workspace:{}".format(file)) for file in files],
        )
        return

    native.local_config_platform(name = "boleynsu_bzl_deps_local_config_platform")

    deps_json = json.encode(deps)
    deps = {dep["name"]: dep for dep in deps["bazel_deps"]}

    install_bazel_deps_name = []
    install_bazel_deps_load_deps = []
    for dep in deps.values():
        rule, _rule = type_to_rule_mapping[dep["type"]]
        rule(**_rule(**dep))
        if "load_deps" in dep:
            install_bazel_deps_name.append(dep["name"])
            install_bazel_deps_load_deps.append(dep["load_deps"])

    files = [
        "container_deps.bzl",
        "go_deps.bzl",
        "install_nonbazel_deps.bzl",
        "maven_deps.bzl",
        "nonbazel_deps.bzl",
        "pip_deps.bzl",
        "toolchain_deps.bzl",
    ]
    _bazel_deps(
        name = name,
        deps_name = install_bazel_deps_name,
        deps_load_deps = install_bazel_deps_load_deps,
        deps_json = deps_json,
        bazel_deps = Label("//tools/build/repo_rules/workspace:bazel_deps.bzl"),
        paths = files,
        labels = [Label("//tools/build/repo_rules/workspace:{}".format(file)) for file in files],
    )
