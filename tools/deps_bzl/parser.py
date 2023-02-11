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

    update_msg, pin_msg = "", ""
    if "update_cmd" in metadata:
        update_msg = f"""
To update all deps to latest versions,
    please run `{metadata["update_cmd"]}`.
"""
    if "pin_cmd" in metadata:
        pin_msg = f"""
To manually update some deps,
    please edit _DPES_YAML and then run `{metadata["pin_cmd"]}`.
"""

    yaml = ruamel.yaml.YAML()
    yaml.width = math.inf
    deps_yaml_writer = _Writer()
    yaml.dump(deps, deps_yaml_writer)
    deps_yaml = deps_yaml_writer.get()
    assert '"""' not in deps_yaml
    deps_yaml_hash = _hash(
        eval('r"""\n' + f"{deps_yaml}" + '"""')  # pylint: disable=eval-used
    )

    deps_json = json.dumps(deps, indent=2)
    assert '"""' not in deps_json, '""" is not allowed in the generated json'
    deps_json_hash = _hash(
        f"""
{deps_json}
"""
    )
    output = f'''"""
deps.bzl
{update_msg}{pin_msg}"""
{DEPS_YAML_PREFIX}{deps_yaml}{DEPS_YAML_SUFFIX}
# DO NOT EDIT THE NEXT LINES! They are auto-generated.

_DEPS_JSON = r"""
{deps_json}
"""

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


def normalize(obj, extra_newline=False):
    """Normalize the format of a YAML object"""
    yaml = ruamel.yaml.YAML()
    yaml.width = math.inf
    writer = _Writer()
    yaml.dump(obj, writer)
    yaml = ruamel.yaml.YAML()
    return yaml.load(writer.get().strip("\n") + "\n" + ("\n" if extra_newline else ""))
