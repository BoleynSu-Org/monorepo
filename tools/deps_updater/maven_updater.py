import xml.etree.ElementTree as ET

import requests

import tools.deps_updater.version

METADATA_URL_TEMPLATE = "https://repo1.maven.org/maven2/{group_id}/{artifact_id}/maven-metadata.xml"


def update(dep):
    group_id, artifact_id = dep['name'].split(":")
    group_id = group_id.replace(".", "/")
    url = METADATA_URL_TEMPLATE.format(
        group_id=group_id,
        artifact_id=artifact_id,
    )
    metadata = ET.fromstring(requests.get(url).content)
    release = metadata.find("./versioning/release").text

    version_type = tools.deps_updater.version.version_types[dep.get(
        'version_type', 'default')]
    if version_type(release) > version_type(dep["version"]):
        dep["version"] = release
    return dep
