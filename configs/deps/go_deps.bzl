load("@bazel_gazelle//:deps.bzl", "go_repository")
load(":deps.bzl", "deps")

def _go_repository(*, name, version, sum, importpath, **kwargs):
    return {
        "name": name,
        "version": version,
        "sum": sum,
        "importpath": importpath,
    }

def go_deps():
    for repo in deps["go_deps"]:
        go_repository(**_go_repository(**repo))
