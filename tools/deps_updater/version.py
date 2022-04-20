"""
Helper functions related to versions.
"""
import re


def _handle_version_type(version_type):
    def default_helper(version):
        if version is None:
            return (0,)
        if version.startswith("v"):
            version = version[len("v") :]

        numbers = version.split(".")
        for number in numbers:
            if not number.isnumeric():
                return (0,)
        return tuple(int(number) for number in numbers)

    helpers = {}
    return helpers.get(version_type, default_helper)


def _handle_version_regex(regex):
    if regex is None:
        return lambda x: x

    def helper(version):
        if version is None:
            return None
        if regex:
            match = re.match(regex, version)
            if match:
                return match.group(1)
        return None

    return helper


def update_version(dep, version):
    """Update "version" field in |dep| based on "version", "version_type" and "version_regex"."""
    version_type = _handle_version_type(dep.get("version_type"))
    version_regex = _handle_version_regex(dep.get("version_regex"))

    updatable = version_type(version_regex(version)) > version_type(
        version_regex(dep.get("version"))
    )
    if updatable:
        dep["version"] = version
    return updatable
