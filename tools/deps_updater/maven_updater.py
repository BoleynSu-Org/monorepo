"""
Helper functions for updating maven dependency.
"""
import xml.etree.ElementTree as ET

import requests

import tools.deps_updater.version

METADATA_URL_TEMPLATE = (
    "https://repo1.maven.org/maven2/{group_id}/{artifact_id}/maven-metadata.xml"
)


def get_version(group_id, artifact_id, url_pattern=METADATA_URL_TEMPLATE):
    """Return version of package on repo1.maven.org using maven-metadata.xml."""
    url = url_pattern.format(
        group_id=group_id,
        artifact_id=artifact_id,
    )

    return ET.fromstring(requests.get(url).content).find("./versioning/release").text


def update(dep):
    """Update |dep|."""
    group_id, artifact_id = dep["name"].split(":")
    release = get_version(
        group_id=group_id.replace(".", "/"),
        artifact_id=artifact_id,
    )
    tools.deps_updater.version.update_version(dep, release)
    return dep
