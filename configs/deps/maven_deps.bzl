load("@bazel_skylib//lib:dicts.bzl", "dicts")
load("@rules_jvm_external//:defs.bzl", jvm_external_maven_install = "maven_install")
load("@io_grpc_grpc_java//:repositories.bzl", "IO_GRPC_GRPC_JAVA_ARTIFACTS", "IO_GRPC_GRPC_JAVA_OVERRIDE_TARGETS")
load(":maven_artifacts.bzl", _MAVEN_ARTIFACTS = "MAVEN_ARTIFACTS")

_MAVEN_OVERRIDE_TARGETS = dict()

def _filter_artifacts(artifacts):
    return [
        artifact
        for artifact in artifacts
        if artifact[:artifact.rfind(":")] not in [artifact[:artifact.rfind(":")] for artifact in _MAVEN_ARTIFACTS]
    ]

MAVEN_ARTIFACTS = _MAVEN_ARTIFACTS + _filter_artifacts(IO_GRPC_GRPC_JAVA_ARTIFACTS)

def _filter_targets(targets):
    return {
        k: targets[k]
        for k in targets
        if k not in _MAVEN_OVERRIDE_TARGETS
    }

MAVEN_OVERRIDE_TARGETS = dicts.add(_MAVEN_OVERRIDE_TARGETS, _filter_targets(IO_GRPC_GRPC_JAVA_OVERRIDE_TARGETS))

def maven_deps():
    jvm_external_maven_install(
        name = "maven",
        artifacts = MAVEN_ARTIFACTS,
        maven_install_json = "//:maven_install.json",
        override_targets = MAVEN_OVERRIDE_TARGETS,
        generate_compat_repositories = True,
        repositories = [
            "https://repo1.maven.org/maven2",
        ],
    )
