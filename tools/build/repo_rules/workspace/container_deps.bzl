load("@rules_oci//oci:pull.bzl", container_pull = "oci_pull")
load("//:deps.bzl", "DEPS")

def to_container_image(*, name, repository, digest, registry, **kwargs):
    return {
        "name": name,
        "registry": registry,
        "repository": repository,
        "digest": digest,
    }

CONTAINER_IMAGES = {
    dep["name"]: to_container_image(**dep)
    for dep in DEPS["container_deps"]
}

def container_deps(*, container_images = CONTAINER_IMAGES):
    for image in container_images.values():
        if image["registry"] == "docker.io":
            image = dict(**image)
            image["registry"] = "index.docker.io"
        container_pull(**image)
