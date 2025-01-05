"""
Include another deps.yaml
"""

import copy
import math

import ruamel.yaml


def _normalize(obj, extra_newline=False):
    """Normalize the format of a YAML object"""

    class _Writer:
        def __init__(self):
            self._result = b""

        def write(self, data):
            """write to the result."""
            self._result += data

        def get(self):
            """get the result."""
            return self._result.decode("utf-8")

    yaml = ruamel.yaml.YAML()
    yaml.width = math.inf
    writer = _Writer()
    yaml.dump(obj, writer)
    yaml = ruamel.yaml.YAML()
    return yaml.load(writer.get().strip("\n") + "\n" + ("\n" if extra_newline else ""))


def include(deps, included_deps):
    """Update deps by including included_deps."""
    deps = copy.deepcopy(deps)
    included_deps = copy.deepcopy(included_deps)
    included_deps_name = included_deps["metadata"]["name"]
    for kind in set(deps.keys()).union(set(included_deps.keys())):
        if kind == "metadata":
            continue
        deps.setdefault(kind, [])
        included_deps.setdefault(kind, [])
        deps_mapping = {dep["name"]: i for i, dep in enumerate(deps[kind])}
        for included_dep in included_deps[kind]:
            included_dep = _normalize(included_dep)
            included_dep["included_from"] = included_deps_name
            if included_dep["name"] not in deps_mapping:
                deps[kind].append(included_dep)
            else:
                if (
                    deps[kind][deps_mapping[included_dep["name"]]].get("included_from")
                    == included_deps_name
                ):
                    deps[kind][deps_mapping[included_dep["name"]]] = included_dep
        included_deps_mapping = {
            dep["name"]: i for i, dep in enumerate(included_deps[kind])
        }
        deps[kind] = _normalize(
            [
                _normalize(dep)
                for dep in deps[kind]
                if (
                    dep.get("included_from") != included_deps_name
                    or dep["name"] in included_deps_mapping
                )
            ],
            extra_newline=True,
        )
    return deps
