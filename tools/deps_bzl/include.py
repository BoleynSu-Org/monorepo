"""
The deps.bzl updater that updates using metadata.include.
"""
import copy

import boleynsu_org.tools.deps_bzl.parser


def include(deps, included_deps):
    """Update deps by including included_deps."""
    deps = copy.deepcopy(deps)
    included_deps = copy.deepcopy(included_deps)
    included_deps_name = included_deps["metadata"]["name"]
    for kind in set(deps.keys()).union(set(included_deps.keys())):
        if kind == "metadata":
            continue
        if kind not in deps:
            deps[kind] = []
        if kind not in included_deps:
            included_deps[kind] = []
        deps_mapping = {dep["name"]: i for i, dep in enumerate(deps[kind])}
        for included_dep in included_deps[kind]:
            included_dep = boleynsu_org.tools.deps_bzl.parser.normalize(included_dep)
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
        deps[kind] = boleynsu_org.tools.deps_bzl.parser.normalize(
            [
                boleynsu_org.tools.deps_bzl.parser.normalize(dep)
                for dep in deps[kind]
                if (
                    dep.get("included_from") != included_deps_name
                    or dep["name"] in included_deps_mapping
                )
            ],
            extra_newline=True,
        )
    return deps
