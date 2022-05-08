load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file")
load(":deps.bzl", "DEPS")

def _local_repository(*, name, path, **kwargs):
    return {
        "name": name,
        "path": path,
    }

def _http_archive(*, name, sha256, url = None, urls = None, strip_prefix = None, patches = None, build_file_content = None, workspace_file_content = None, **kwargs):
    return {
        "name": name,
        "sha256": sha256,
        "url": url,
        "urls": urls,
        "strip_prefix": strip_prefix,
        "patches": [Label(patch) for patch in patches] if (patches != None) else [],
        "build_file_content": build_file_content,
        "workspace_file_content": build_file_content,
    }

def _http_file(*, name, sha256, url = None, urls = None, executable = None, **kwargs):
    return {
        "name": name,
        "sha256": sha256,
        "urls": [url] if url else urls,
        "executable": executable,
    }

_TYPE_TO_RULE_MAPPING = {
    "local_repository": (native.local_repository, _local_repository),
    "http_archive": (http_archive, _http_archive),
    "http_file": (http_file, _http_file),
}

BAZEL_DEPS = {dep["name"]: dep for dep in DEPS["bazel_deps"]}

def bazel_deps(*, type_to_rule_mapping = _TYPE_TO_RULE_MAPPING, deps = BAZEL_DEPS):
    for dep in deps.values():
        rule, _rule = type_to_rule_mapping[dep["type"]]
        maybe(rule, **_rule(**dep))
