load("@bazel_skylib//lib:dicts.bzl", "dicts")
load("@rules_jvm_external//:defs.bzl", "maven_install")
load("@io_grpc_grpc_java//:repositories.bzl", "IO_GRPC_GRPC_JAVA_ARTIFACTS", "IO_GRPC_GRPC_JAVA_OVERRIDE_TARGETS")
load(":deps.bzl", "DEPS")

_MAVEN_ARTIFACTS = {
    dep["name"]: dep["version"]
    for dep in DEPS["maven_deps"]
    if dep["version"] != "override"
}

_MAVEN_OVERRIDE_TARGETS = {
    dep["name"]: dep["override_target"]
    for dep in DEPS["maven_deps"]
    if dep["version"] == "override"
}

def _parse_artifacts(artifacts):
    return {
        artifact[:artifact.rfind(":")]: artifact[artifact.rfind(":") + 1:]
        for artifact in artifacts
    }

def _resolve_conflict(base, *delta):
    for artifacts in delta:
        for name, data in artifacts.items():
            if name not in base:
                base[name] = data
    return base

MAVEN_ARTIFACTS = _resolve_conflict(_MAVEN_ARTIFACTS, _parse_artifacts(IO_GRPC_GRPC_JAVA_ARTIFACTS))

MAVEN_OVERRIDE_TARGETS = _resolve_conflict(_MAVEN_OVERRIDE_TARGETS, IO_GRPC_GRPC_JAVA_OVERRIDE_TARGETS)

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
        artifacts = ["{name}:{version}".format(name = name, version = version) for name, version in artifacts.items()],
        maven_install_json = maven_install_json,
        override_targets = override_targets,
        generate_compat_repositories = generate_compat_repositories,
        repositories = repositories,
        fail_if_repin_required = fail_if_repin_required,
        **kwargs
    )
