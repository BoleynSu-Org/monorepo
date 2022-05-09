"""
The deps.bzl regenerator.
"""
import argparse
import os
import sys

import boleynsu_org.tools.deps_bzl.parser

parser = argparse.ArgumentParser(description="The deps.bzl regenerator.")
parser.add_argument("deps_bzl_path", help="input")
parser.add_argument("deps_bzl_out_path", help="output")


def main(argv):
    """The main function."""
    args = parser.parse_args(argv)
    deps_bzl_path = args.deps_bzl_path
    deps_bzl_out_path = args.deps_bzl_out_path
    if "BUILD_WORKSPACE_DIRECTORY" in os.environ:
        if not os.path.isabs(deps_bzl_path):
            deps_bzl_path = os.path.join(
                os.environ["BUILD_WORKSPACE_DIRECTORY"], deps_bzl_path
            )
        if not os.path.isabs(deps_bzl_out_path):
            deps_bzl_out_path = os.path.join(
                os.environ["BUILD_WORKSPACE_DIRECTORY"], deps_bzl_out_path
            )

    deps = boleynsu_org.tools.deps_bzl.parser.load_deps_yaml(deps_bzl_path)
    boleynsu_org.tools.deps_bzl.parser.dump_deps_bzl(deps, deps_bzl_out_path)


if __name__ == "__main__":
    main(sys.argv[1:])
