genrule(
    name = "deps_bzl",
    srcs = ["@io_bazel_rules_docker_deps_bzl_files//:repositories/go_repositories.bzl"],
    outs = ["deps.bzl"],
    cmd = '''
cat >"$@" <<'EOF'
# BEGIN deps.yaml
_DEPS_YAML = r"""
metadata:
  name: io_bazel_rules_docker

go_deps:
EOF

cat "$<" | while read -r line; do
  if grep importpath <<<"$$line" >/dev/null; then
    name=$$(sed -n 's/importpath = "\\([^"]*\\)",/\\1/p' <<<"$$line")
    echo "- name: $$name" >>"$@"
  fi
  if grep strip_prefix <<<"$$line" >/dev/null; then
    if [[ "$$name" == "github.com/google/go-containerregistry" ]]; then
      version=$$(sed -n 's/strip_prefix = "go-containerregistry-\\([^"]*\\)",/\\1/p' <<<"$$line")
      echo "  version: v$$version" >>"$@"
    fi
  fi
  if grep version <<<"$$line" >/dev/null; then
    version=$$(sed -n 's/version = "\\([^"]*\\)",/\\1/p' <<<"$$line")
    echo "  version: $$version" >>"$@"
  fi
done

cat >>"$@" <<'EOF'
"""
# END deps.yaml
EOF
''',
    visibility = ["//visibility:public"],
)
