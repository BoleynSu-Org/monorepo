"""
The deps.yaml regenerator.
"""

import argparse
import math
import pathlib
import sys

import ruamel.yaml

import deps_yaml.include

parser = argparse.ArgumentParser(description="The deps.yaml regenerator.")
parser.add_argument("--include", action="append", help="include another deps.yaml")
parser.add_argument("deps_yaml_path", help="input")
parser.add_argument("deps_yaml_out_path", help="output")


def main(argv):
    """The main function."""
    args = parser.parse_args(argv)
    deps_yaml_path = args.deps_yaml_path
    deps_yaml_out_path = args.deps_yaml_out_path
    included_deps_yaml_paths = args.include or []

    yaml = ruamel.yaml.YAML()

    deps = yaml.load(pathlib.Path(deps_yaml_path))
    for included_deps_yaml_path in included_deps_yaml_paths:
        included_deps = yaml.load(pathlib.Path(included_deps_yaml_path))
        deps = deps_yaml.include.include(deps, included_deps)
    yaml.width = math.inf
    yaml.dump(deps, pathlib.Path(deps_yaml_out_path))


if __name__ == "__main__":
    main(sys.argv[1:])
