import hashlib
import os
import requests

import tools.deps_updater.version

GITHUB = "https://github.com/"
GITHUB_ARCHIVE_TEMPLATE = "https://github.com/{name}/archive/refs/tags/{version}.tar.gz"


def update(dep):
    headers = None
    if "GITHUB_TOKEN" in os.environ:
        headers = {"Authorization": "Bearer " + os.environ["GITHUB_TOKEN"]}

    if "url" in dep:
        urls = [dep["url"]]
    else:
        urls = dep["urls"]
    for url in urls:
        if url.startswith(GITHUB):
            path = url[len(GITHUB):]
            name = "/".join(path.split("/")[:2])
            release = requests.get(
                "https://api.github.com/repos/{}/releases/latest".format(name), headers=headers).json()["tag_name"]

            version_type = tools.deps_updater.version.version_types[dep.get(
                "version_type", "default")]
            if version_type(release) > version_type(dep["version"]):
                dep["version"] = release

                url = GITHUB_ARCHIVE_TEMPLATE.format(
                    name=name, version=dep["version"])
                if "urls" in dep:
                    dep.pop("urls")
                dep["url"] = url

                # TODO: better strip_prefix handling
                v = "v"
                dep["strip_prefix"] = path.split(
                    "/")[1] + "-" + (dep["version"][len(v):] if dep["version"].startswith(v) else dep["version"])

                sha256 = hashlib.sha256()
                sha256.update(requests.get(url).content)
                dep["sha256"] = sha256.hexdigest()
            return dep
    return dep
