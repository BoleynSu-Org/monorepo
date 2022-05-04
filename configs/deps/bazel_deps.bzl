load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load(":deps.bzl", "deps")

_LOCAL_ARCHIVES = [
    {
        "name": "boleynsu_oj",
        "path": "third_party/oj",
    },
    {
        "name": "boleynsu_urlshortener",
        "path": "third_party/urlshortener",
    },
]

def _bazel_archive(*, name, sha256, url = None, urls = None, strip_prefix = None, patches = None, build_file_content = None, workspace_file_content = None, **kwargs):
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

def bazel_deps():
    for archive in _LOCAL_ARCHIVES:
        maybe(
            native.local_repository,
            **archive
        )

    for dep in deps["bazel_deps"]:
        maybe(
            http_archive,
            **_bazel_archive(**dep)
        )
