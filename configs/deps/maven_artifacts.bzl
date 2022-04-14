load(":deps.bzl", "deps")

MAVEN_ARTIFACTS = ["{name}:{version}".format(**artifact) for artifact in deps["maven_deps"]]
