"""
Helper functions for getting the latest version of GitHub packages.
"""
import os
import requests

GITHUB_RELEASE_API_URL_TEMPLATE = "https://api.github.com/repos/{repo}/releases/latest"


def get_version(repo, github_token=None, url_pattern=GITHUB_RELEASE_API_URL_TEMPLATE):
    """Return version of package on github using github API."""
    headers = None
    if github_token is None and "GITHUB_TOKEN" in os.environ:
        headers = {"Authorization": "Bearer " + os.environ["GITHUB_TOKEN"]}
    return requests.get(url_pattern.format(repo=repo), headers=headers).json()[
        "tag_name"
    ]
