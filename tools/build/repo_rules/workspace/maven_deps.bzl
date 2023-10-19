load("@rules_jvm_external//:defs.bzl", "maven_install")
load("//:deps.bzl", "DEPS")

def parse_artifacts(artifacts):
    return {
        artifact[:artifact.rfind(":")]: artifact[artifact.rfind(":") + 1:]
        for artifact in artifacts
    }

MAVEN_ARTIFACTS = {
    dep["name"]: dep["version"]
    for dep in DEPS["maven_deps"]
    if "override_target" not in dep
}

MAVEN_OVERRIDE_TARGETS = {
    dep["name"]: dep["override_target"]
    for dep in DEPS["maven_deps"]
    if "override_target" in dep
}

def maven_deps(
        *,
        name = "maven",
        artifacts = MAVEN_ARTIFACTS,
        maven_install_json = Label("@//:maven_install.json"),
        override_targets = MAVEN_OVERRIDE_TARGETS,
        generate_compat_repositories = True,
        repositories = [
            "https://repo1.maven.org/maven2",
        ],
        fail_if_repin_required = True,
        version_conflict_policy = "pinned",
        duplicate_version_warning = "error",
        strict_visibility = True,
        **kwargs):
    maven_install(
        name = name,
        artifacts = ["{name}:{version}".format(name = name, version = version) for name, version in artifacts.items()],
        maven_install_json = maven_install_json,
        override_targets = override_targets,
        generate_compat_repositories = generate_compat_repositories,
        repositories = repositories,
        fail_if_repin_required = fail_if_repin_required,
        version_conflict_policy = version_conflict_policy,
        duplicate_version_warning = duplicate_version_warning,
        strict_visibility = strict_visibility,
        **kwargs
    )
