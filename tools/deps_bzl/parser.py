"""
deps.bzl parser.
"""
import json
import math

import ruamel.yaml


DEPS_YAML_PREFIX = '\n# BEGIN deps.yaml\n_DEPS_YAML = r"""\n'
DEPS_YAML_SUFFIX = '"""\n# END deps.yaml\n'


def load_deps_yaml(path):
    """Load _DEPS_YAML in deps.bzl."""
    yaml = ruamel.yaml.YAML()
    with open(path, encoding="utf-8") as file:
        content = file.read()
        begin = content.find(DEPS_YAML_PREFIX) + len(DEPS_YAML_PREFIX)
        end = content.find(DEPS_YAML_SUFFIX)
        return yaml.load(content[begin:end])


class _Writer:
    def __init__(self):
        self._result = b""

    def write(self, data):
        """write to the result."""
        self._result += data

    def get(self):
        """get the result."""
        return self._result.decode("utf-8")


# See https://docs.bazel.build/versions/5.1.0/skylark/lib/globals.html#hash
def _hash(value):
    result = 0
    for char in value:
        result = (result * 31 + ord(char)) % (1 << 32)
    if result >= (1 << 31):
        result -= 1 << 32
    return result


def dump_deps_bzl(deps, path):
    """Dump deps as deps.bzl."""
    metadata = deps["metadata"]

    yaml = ruamel.yaml.YAML()
    yaml.width = math.inf
    deps_yaml_writer = _Writer()
    yaml.dump(deps, deps_yaml_writer)
    deps_yaml = deps_yaml_writer.get()
    assert '"""' not in deps_yaml
    deps_yaml_hash = _hash(
        eval('r"""\n' + f"{deps_yaml}" + '"""')  # pylint: disable=eval-used
    )

    deps_json = json.dumps(deps)
    deps_json_hash = _hash(deps_json)
    output = f'''"""
deps.bzl

To update all deps to latest versions,
    please run `{metadata["update_cmd"]}`.

To manually update some deps,
    please edit _DPES_YAML and then run `{metadata["pin_cmd"]}`.
"""
{DEPS_YAML_PREFIX}{deps_yaml}{DEPS_YAML_SUFFIX}
# DO NOT EDIT THE NEXT LINES! They are auto-generated.

_DEPS_JSON = {repr(deps_json)}

[print("""
deps.bzl is outdated!
deps.bzl is outdated!
deps.bzl is outdated!
The important things should be emphasized three times!
""") if hash(_DEPS_YAML) != {deps_yaml_hash} or hash(_DEPS_JSON) != {deps_json_hash} else None]

DEPS = json.decode(_DEPS_JSON)
'''

    with open(path, "w", encoding="utf-8") as file:
        file.write(output)
