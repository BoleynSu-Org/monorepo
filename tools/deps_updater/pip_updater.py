"""
Helper functions for updating pip dependency.
"""
import json

import requests

import tools.deps_updater.version

PIPY_METADATA_URL_TEMPLATE = "https://pypi.python.org/pypi/{package}/json"


def get_version(package, url_pattern=PIPY_METADATA_URL_TEMPLATE):
    """Return version of package on pypi.python.org using json."""
    req = requests.get(url_pattern.format(package=package))
    return json.loads(req.text.encode(req.encoding)).get("info", {}).get("version")


def update(dep):
    """Update |dep|."""
    release = str(get_version(dep["name"]))
    tools.deps_updater.version.update_version(dep, release)
    return dep
