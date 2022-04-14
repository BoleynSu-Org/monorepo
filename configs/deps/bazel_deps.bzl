load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("//configs/deps:deps.bzl", "deps")

_LOCAL_ARCHIVES = [
    {
        "name": "boleynsu_oj",
        "path": "third_party/oj",
    },
]

def _bazel_archive(*, name, sha256, url = None, urls = None, strip_prefix = None, patch = None, **kwargs):
    return {
        "name": name,
        "sha256": sha256,
        "url": url,
        "urls": urls,
        "strip_prefix": strip_prefix,
        "patch": patch,
    }

def bazel_deps():
    for dep in deps["bazel_deps"]:
        maybe(
            http_archive,
            **_bazel_archive(**dep)
        )

    for archive in _LOCAL_ARCHIVES:
        maybe(
            native.local_repository,
            **archive
        )
