import copy
import datetime
import math
import os
import sys

import ruamel.yaml

import tools.deps_updater.pip_updater
import tools.deps_updater.maven_updater
import tools.deps_updater.bazel_updater

updaters = {
    "pip_deps": tools.deps_updater.pip_updater.update,
    "maven_deps": tools.deps_updater.maven_updater.update,
    "bazel_deps": tools.deps_updater.bazel_updater.update,
}

deps_yaml_prefix = "'''\n# BEGIN deps.yaml\n"
deps_yaml_suffix = "\n# END deps.yaml\n'''\n"


def load_deps_yaml(path):
    yaml = ruamel.yaml.YAML()
    with open(path) as f:
        content = f.read()
        begin = content.find(deps_yaml_prefix) + len(deps_yaml_prefix)
        end = content.find(deps_yaml_suffix)
        return yaml.load(content[begin:end])


def pinned(dep):
    if "pinned_until" in dep:
        if datetime.datetime.strptime(
                dep["pinned_until"], "%Y-%m-%d") < datetime.datetime.now():
            print("A pinned dependency has expired.")
            print(dep)
            sys.exit(1)
        return True
    return False


def main(argv):
    assert len(argv) >= 1
    if "BUILD_WORKSPACE_DIRECTORY" in os.environ:
        os.chdir(os.environ["BUILD_WORKSPACE_DIRECTORY"])
    deps_bzl_path = os.path.abspath(argv[0])

    deps = load_deps_yaml(deps_bzl_path)

    for dep in deps:
        updater = updaters.get(dep, lambda x: x)
        updated = []
        for item in deps[dep]:
            if pinned(item):
                updated.append(item)
            else:
                original_time = copy.deepcopy(item)
                updated_item = updater(item)
                if "updated_at" in original_time and original_time == updated_item:
                    if datetime.datetime.strptime(original_time["updated_at"], "%Y-%m-%d") + datetime.timedelta(days=365) < datetime.datetime.now():
                        print(
                            "A dependency has not been updated for more than one year.")
                        print(original_time)
                        sys.exit(1)
                else:
                    if "manual" in item and item["manual"]:
                        print("A dependency update needs manual approval.")
                        print(original_time)
                        sys.exit(1)
                    updated_item["updated_at"] = datetime.datetime.now().strftime(
                        "%Y-%m-%d")
                updated.append(updated_item)
        deps[dep] = updated

    with open(deps_bzl_path, "w") as f:
        yaml = ruamel.yaml.YAML()
        yaml.width = math.inf
        f.write(deps_yaml_prefix)
        yaml.dump(deps, f)
        f.write(deps_yaml_suffix)
        f.write(
            'def ordereddict(l): return {{ k: v for (k, v) in l }}\ndeps={}\n'.format(deps))


if __name__ == "__main__":
    main(sys.argv[1:])
