"""
The deps.bzl generator.
"""
import argparse
import json
import pathlib
import sys

import ruamel.yaml

parser = argparse.ArgumentParser(description="The deps.bzl generator.")
parser.add_argument("deps_yaml_path", help="input")
parser.add_argument("deps_bzl_path", help="output")


# See https://docs.bazel.build/versions/5.1.0/skylark/lib/globals.html#hash
def _hash(value):
    result = 0
    for char in value:
        result = (result * 31 + ord(char)) % (1 << 32)
    if result >= (1 << 31):
        result -= 1 << 32
    return result


def main(argv):
    """The main function."""
    args = parser.parse_args(argv)
    deps_yaml_path = args.deps_yaml_path
    deps_bzl_path = args.deps_bzl_path

    yaml = ruamel.yaml.YAML()

    deps = yaml.load(pathlib.Path(deps_yaml_path))
    with pathlib.Path(deps_bzl_path).open("w", encoding="utf-8") as writer:
        deps_json = json.dumps(deps, indent=2)
        assert '"""' not in deps_json, '""" is not allowed in the generated json'
        deps_json_hash = _hash(
            rf"""
{deps_json}
"""
        )
        writer.write(
            f'''
_DEPS_JSON = r"""
{deps_json}
"""

[
    print("""
deps.bzl is outdated!
deps.bzl is outdated!
deps.bzl is outdated!
The important things should be emphasized three times!
""") if hash(_DEPS_JSON) != {deps_json_hash} else None
]

DEPS = json.decode(_DEPS_JSON)
'''
        )


if __name__ == "__main__":
    main(sys.argv[1:])
