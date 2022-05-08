load("@io_bazel_rules_docker//container:container.bzl", "container_pull")
load(":deps.bzl", "DEPS")

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
        container_pull(**image)
