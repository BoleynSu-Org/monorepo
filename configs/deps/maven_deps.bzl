load("@rules_jvm_external//:defs.bzl", "maven_install")
load("@io_grpc_grpc_java//:repositories.bzl", "IO_GRPC_GRPC_JAVA_ARTIFACTS", "IO_GRPC_GRPC_JAVA_OVERRIDE_TARGETS")
load("//tools/build/utils:utils.bzl", "resolve_conflicts")
load(":deps.bzl", "DEPS")

def parse_artifacts(artifacts):
    return {
        artifact[:artifact.rfind(":")]: artifact[artifact.rfind(":") + 1:]
        for artifact in artifacts
    }

MAVEN_ARTIFACTS = resolve_conflicts({
    dep["name"]: dep["version"]
    for dep in DEPS["maven_deps"]
    if dep["version"] != "override"
}, parse_artifacts(IO_GRPC_GRPC_JAVA_ARTIFACTS))

MAVEN_OVERRIDE_TARGETS = resolve_conflicts({
    dep["name"]: dep["override_target"]
    for dep in DEPS["maven_deps"]
    if dep["version"] == "override"
}, IO_GRPC_GRPC_JAVA_OVERRIDE_TARGETS)

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
