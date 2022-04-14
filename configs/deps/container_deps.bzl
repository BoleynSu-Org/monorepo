load("@io_bazel_rules_docker//container:container.bzl", "container_pull")
load(":deps.bzl", "deps")

def _container_image(*, name, repository, digest, registry = "docker.io", tag = "latest", pull = False, **kwargs):
    return {
        "name": name,
        "registry": registry,
        "repository": repository,
        "digest": digest,
    }

CONTAINER_IMAGES = [
    _container_image(**image)
    for image in deps["container_deps"]
    if "pull" in image and image["pull"]
]

def container_deps():
    for image in CONTAINER_IMAGES:
        container_pull(**image)
