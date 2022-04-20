"""
Helper functions for updating bazel dependency.
"""
import hashlib
import requests

import tools.deps_updater.version
import tools.deps_updater.github.version

GITHUB = "https://github.com/"
GITHUB_ARCHIVE_URL_TEMPLATE = (
    "https://github.com/{repo}/archive/refs/tags/{version}.tar.gz"
)


def _get_github_repo(dep):
    if "url" in dep:
        urls = [dep["url"]]
    else:
        urls = dep["urls"]
    for url in urls:
        if url.startswith(GITHUB):
            path = url[len(GITHUB) :]
            return "/".join(path.split("/")[:2])
    return None


def _update_archive_info(dep):
    repo = _get_github_repo(dep)
    url = GITHUB_ARCHIVE_URL_TEMPLATE.format(repo=repo, version=dep["version"])

    if "urls" in dep:
        dep.pop("urls")
    dep["url"] = url

    stripped_version = (
        dep["version"][len("v") :] if dep["version"].startswith("v") else dep["version"]
    )
    dep["strip_prefix"] = repo.split("/")[1] + "-" + stripped_version

    sha256 = hashlib.sha256()
    sha256.update(requests.get(url).content)
    dep["sha256"] = sha256.hexdigest()


def update(dep):
    """Update |dep|."""
    repo = _get_github_repo(dep)

    release = tools.deps_updater.github.version.get_version(repo)
    if tools.deps_updater.version.update_version(dep, release):
        _update_archive_info(dep)
    return dep
