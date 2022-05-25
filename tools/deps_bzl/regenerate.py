"""
The deps.bzl regenerator.
"""
import argparse
import sys

import boleynsu_org.tools.deps_bzl.parser
import boleynsu_org.tools.deps_bzl.include

parser = argparse.ArgumentParser(description="The deps.bzl regenerator.")
parser.add_argument("--include", nargs="*", help="include another deps.bzl")
parser.add_argument("deps_bzl_path", help="input")
parser.add_argument("deps_bzl_out_path", help="output")


def main(argv):
    """The main function."""
    args = parser.parse_args(argv)
    deps_bzl_path = args.deps_bzl_path
    deps_bzl_out_path = args.deps_bzl_out_path
    included_deps_bzl_paths = args.include

    deps = boleynsu_org.tools.deps_bzl.parser.load_deps_yaml(deps_bzl_path)
    for included_deps_bzl_path in included_deps_bzl_paths:
        included_deps = boleynsu_org.tools.deps_bzl.parser.load_deps_yaml(
            included_deps_bzl_path
        )
        deps = boleynsu_org.tools.deps_bzl.include.include(deps, included_deps)
    boleynsu_org.tools.deps_bzl.parser.dump_deps_bzl(deps, deps_bzl_out_path)


if __name__ == "__main__":
    main(sys.argv[1:])
