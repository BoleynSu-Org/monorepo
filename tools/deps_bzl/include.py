"""
The deps.bzl updater that updates using metadata.include.
"""
import copy


def include(deps, included_deps):
    """Update deps by including included_deps."""
    included_deps = copy.deepcopy(included_deps)
    included_deps_name = included_deps.pop("metadata")["name"]
    for kind in included_deps:
        if kind not in deps:
            deps[kind] = []
        mapping = {dep["name"]: dep for dep in deps[kind]}
        for included_dep in included_deps[kind]:
            included_dep["included_from"] = included_deps_name
            if included_dep["name"] not in mapping:
                deps[kind].append(included_dep)
            else:
                dep = mapping[included_dep["name"]]
                if dep.get("included_from") == included_deps_name:
                    dep.clear()
                    dep.update(included_dep)
    return deps
