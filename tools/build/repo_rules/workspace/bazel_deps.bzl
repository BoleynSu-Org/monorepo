load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file")
load("@boleynsu_deps_bzl//:deps.bzl", "DEPS")

def to_http_archive(*, name, sha256, url = None, urls = None, strip_prefix = None, patches = None, patch_cmds = None, build_file = None, build_file_content = None, workspace_file_content = None, **kwargs):
    if patches:
        for patch in patches:
            if not patch.startswith("@"):
                fail("The target for patches must specify workspace name.")
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

BAZEL_DEPS = {dep["name"]: dep for dep in DEPS["bazel_deps"]}

def _bazel_deps_impl(repository_ctx):
    repository_ctx.file("WORKSPACE", content = "workspace(name=\"{}\")".format(repository_ctx.name))

    repository_ctx.file("BUILD", content = "")

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
        "paths": attr.string_list(default = []),
        "labels": attr.label_list(default = []),
    },
)

def bazel_deps(
        *,
        name = "bazel_deps",
        type_to_rule_mapping = TYPE_TO_RULE_MAPPING,
        deps = BAZEL_DEPS,
        local_config_platform_name = "local_config_platform"):
    if local_config_platform_name != None:
        native.local_config_platform(name = local_config_platform_name)
    install_bazel_deps_name = []
    install_bazel_deps_load_deps = []
    for dep in deps.values():
        rule, _rule = type_to_rule_mapping[dep["type"]]
        maybe(rule, **_rule(**dep))
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
        paths = files,
        labels = [Label("//tools/build/repo_rules/workspace:{}".format(file)) for file in files],
    )
