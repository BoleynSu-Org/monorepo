load("@bazel_skylib//lib:dicts.bzl", "dicts")
load("@rules_jvm_external//:defs.bzl", "maven_install")
load("@io_grpc_grpc_java//:repositories.bzl", "IO_GRPC_GRPC_JAVA_ARTIFACTS", "IO_GRPC_GRPC_JAVA_OVERRIDE_TARGETS")
load(":deps.bzl", "deps")

_MAVEN_ARTIFACTS = ["{name}:{version}".format(**artifact) for artifact in deps["maven_deps"]]

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

def maven_deps(
        *,
        name = "maven",
        artifacts = MAVEN_ARTIFACTS,
        maven_install_json = Label("//:maven_install.json"),
        override_targets = MAVEN_OVERRIDE_TARGETS,
        generate_compat_repositories = True,
        repositories = [
            "https://repo1.maven.org/maven2",
        ],
        fail_if_repin_required = True,
        **kwargs):
    maven_install(
        name = name,
        artifacts = artifacts,
        maven_install_json = maven_install_json,
        override_targets = override_targets,
        generate_compat_repositories = generate_compat_repositories,
        repositories = repositories,
        fail_if_repin_required = fail_if_repin_required,
    )
