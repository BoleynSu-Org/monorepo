load("@io_grpc_grpc_java//:repositories.bzl", "IO_GRPC_GRPC_JAVA_ARTIFACTS", "IO_GRPC_GRPC_JAVA_OVERRIDE_TARGETS")
load("@bazel_skylib//rules:write_file.bzl", "write_file")
load("//tools/build/rules:expand_template.bzl", "expand_template")
load("//tools/build/rules:genfile.bzl", "genfile")

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

expand_template(
    name = "gen_module_bazel",
    substitutions = {
        "ARTIFACTS_PLACE_HOLDER": "[\n" + "\n".join(['    "{}",'.format(artifact) for artifact in IO_GRPC_GRPC_JAVA_ARTIFACTS]) + "\n]",
        "OVERRIDE_TARGETS_PLACE_HOLDER": "{\n" + "\n".join(['    "{}": "{}",'.format(k, v) for k, v in IO_GRPC_GRPC_JAVA_OVERRIDE_TARGETS.items()]) + "\n}",
    },
    template = "repo.tpl.MODULE.bazel",
    visibility = ["//:__pkg__"],
)

genfile(
    name = "module_bazel",
    src = "gen_module_bazel",
    out = "repo.MODULE.bazel",
)
