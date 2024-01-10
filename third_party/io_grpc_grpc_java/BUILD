load("@io_grpc_grpc_java//:repositories.bzl", "IO_GRPC_GRPC_JAVA_ARTIFACTS", "IO_GRPC_GRPC_JAVA_OVERRIDE_TARGETS")
load("@bazel_skylib//rules:write_file.bzl", "write_file")

write_file(
    name = "deps_yaml",
    out = "deps.yaml",
    content = ["metadata:\n  name: io_grpc_grpc_java\n\nmaven_deps:"] + [
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
    ],
    visibility = ["//visibility:public"],
)
