load("@io_grpc_grpc_java//:repositories.bzl", "IO_GRPC_GRPC_JAVA_ARTIFACTS", "IO_GRPC_GRPC_JAVA_OVERRIDE_TARGETS")
load("@bazel_skylib//rules:write_file.bzl", "write_file")

DEPS_YAML_PREFIX = '\n# BEGIN deps.yaml\n_DEPS_YAML = r"""\n'

DEPS_YAML_SUFFIX = '"""\n# END deps.yaml\n'

write_file(
    name = "deps.bzl",
    out = "out/deps.bzl",
    content = [DEPS_YAML_PREFIX + "metadata:\n  name: io_grpc_grpc_java\n\nmaven_deps:"] + [
        "- name: {}\n  version: {}".format(
            repr(artifact),
            repr(version),
        )
        for artifact, version in [tuple(artifact.rsplit(":", 1)) for artifact in IO_GRPC_GRPC_JAVA_ARTIFACTS]
    ] + [
        "- name: {}\n  version: override\n  override_target: {}".format(
            repr(artifact),
            repr(target),
        )
        for artifact, target in IO_GRPC_GRPC_JAVA_OVERRIDE_TARGETS.items()
    ] + [DEPS_YAML_SUFFIX],
    visibility = ["//visibility:public"],
)
