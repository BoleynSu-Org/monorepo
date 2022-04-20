'''
# BEGIN deps.yaml
# bazel run //configs/deps:update

bazel_deps:
- name: rules_pkg
  url: https://github.com/bazelbuild/rules_pkg/archive/refs/tags/0.7.0.tar.gz
  sha256: e110311d898c1ff35f39829ae3ec56e39c0ef92eb44de74418982a114f51e132
  updated_at: '2022-04-10'
  version: 0.7.0
  strip_prefix: rules_pkg-0.7.0
- name: bazel_skylib
  url: https://github.com/bazelbuild/bazel-skylib/archive/refs/tags/1.2.1.tar.gz
  sha256: 710c2ca4b4d46250cdce2bf8f5aa76ea1f0cba514ab368f2988f70e864cfaf51
  updated_at: '2022-04-10'
  version: 1.2.1
  strip_prefix: bazel-skylib-1.2.1
- name: io_bazel_rules_docker
  url: https://github.com/bazelbuild/rules_docker/releases/download/v0.19.0/rules_docker-v0.19.0.tar.gz
  sha256: 1f4e59843b61981a96835dc4ac377ad4da9f8c334ebe5e0bb3f58f80c09735f4
  strip_prefix: rules_docker-0.19.0
  updated_at: '2022-04-10'
  version: v0.19.0
  pinned_until: '2022-07-10' # container/go/pkg/compat/reader.go#ReadImage is changed in v0.20.0 and will break io_bazel_rules_k8s
- name: io_bazel_rules_k8s
  url: https://github.com/bazelbuild/rules_k8s/archive/refs/tags/v0.6.tar.gz
  sha256: 51f0977294699cd547e139ceff2396c32588575588678d2054da167691a227ef
  strip_prefix: rules_k8s-0.6
  updated_at: '2022-04-10'
  version: v0.6
- name: bazel_toolchains
  url: https://github.com/bazelbuild/bazel-toolchains/archive/refs/tags/v5.1.1.tar.gz
  sha256: e52789d4e89c3e2dc0e3446a9684626a626b6bec3fde787d70bae37c6ebcc47f
  strip_prefix: bazel-toolchains-5.1.1
  updated_at: '2022-04-10'
  version: v5.1.1
- name: rules_java
  sha256: ddc9e11f4836265fea905d2845ac1d04ebad12a255f791ef7fd648d1d2215a5b
  url: https://github.com/bazelbuild/rules_java/archive/refs/tags/5.0.0.tar.gz
  strip_prefix: rules_java-5.0.0
  updated_at: '2022-04-10'
  version: 5.0.0
- name: rules_jvm_external
  sha256: 2cd77de091e5376afaf9cc391c15f093ebd0105192373b334f0a855d89092ad5
  strip_prefix: rules_jvm_external-4.2
  url: https://github.com/bazelbuild/rules_jvm_external/archive/refs/tags/4.2.tar.gz
  updated_at: '2022-04-10'
  version: '4.2'
- name: rules_proto
  sha256: 66bfdf8782796239d3875d37e7de19b1d94301e8972b3cbd2446b332429b4df1
  strip_prefix: rules_proto-4.0.0
  url: https://github.com/bazelbuild/rules_proto/archive/refs/tags/4.0.0.tar.gz
  updated_at: '2022-04-10'
  version: 4.0.0
- name: io_grpc_grpc_java
  sha256: 51bac553d269b97214dbd6aee4e65fc616d8ccd414fc12d708e85979ed4c19b4
  strip_prefix: grpc-java-1.45.1
  url: https://github.com/grpc/grpc-java/archive/refs/tags/v1.45.1.tar.gz
  updated_at: '2022-04-10'
  version: v1.45.1
- name: rules_python
  sha256: 9fcf91dbcc31fde6d1edb15f117246d912c33c36f44cf681976bd886538deba6
  strip_prefix: rules_python-0.8.0
  url: https://github.com/bazelbuild/rules_python/archive/refs/tags/0.8.0.tar.gz
  updated_at: '2022-04-10'
  version: 0.8.0
- name: io_bazel_rules_go
  sha256: 7618869e5f53cc17d5b837edafd06e25b5cddb596482880b5e55f6ec4d276fea
  url: https://github.com/bazelbuild/rules_go/archive/refs/tags/v0.31.0.tar.gz
  updated_at: '2022-04-10'
  version: v0.31.0
  strip_prefix: rules_go-0.31.0
- name: bazel_gazelle
  sha256: bc54dfde4f55955370e4050da3917e2799b44ee935eca2cf9a20e9bc884ee243
  url: https://github.com/bazelbuild/bazel-gazelle/archive/refs/tags/v0.25.0.tar.gz
  updated_at: '2022-04-10'
  version: v0.25.0
  strip_prefix: bazel-gazelle-0.25.0

pip_deps:
- name: ruamel.yaml
  version: 0.17.21
  updated_at: '2022-04-09'
- name: requests
  version: 2.27.1
  updated_at: '2022-04-10'

maven_deps: []

container_deps: []

go_deps: []

# END deps.yaml
'''
def ordereddict(l): return { k: v for (k, v) in l }
deps=ordereddict([('bazel_deps', [ordereddict([('name', 'rules_pkg'), ('url', 'https://github.com/bazelbuild/rules_pkg/archive/refs/tags/0.7.0.tar.gz'), ('sha256', 'e110311d898c1ff35f39829ae3ec56e39c0ef92eb44de74418982a114f51e132'), ('updated_at', '2022-04-10'), ('version', '0.7.0'), ('strip_prefix', 'rules_pkg-0.7.0')]), ordereddict([('name', 'bazel_skylib'), ('url', 'https://github.com/bazelbuild/bazel-skylib/archive/refs/tags/1.2.1.tar.gz'), ('sha256', '710c2ca4b4d46250cdce2bf8f5aa76ea1f0cba514ab368f2988f70e864cfaf51'), ('updated_at', '2022-04-10'), ('version', '1.2.1'), ('strip_prefix', 'bazel-skylib-1.2.1')]), ordereddict([('name', 'io_bazel_rules_docker'), ('url', 'https://github.com/bazelbuild/rules_docker/releases/download/v0.19.0/rules_docker-v0.19.0.tar.gz'), ('sha256', '1f4e59843b61981a96835dc4ac377ad4da9f8c334ebe5e0bb3f58f80c09735f4'), ('strip_prefix', 'rules_docker-0.19.0'), ('updated_at', '2022-04-10'), ('version', 'v0.19.0'), ('pinned_until', '2022-07-10')]), ordereddict([('name', 'io_bazel_rules_k8s'), ('url', 'https://github.com/bazelbuild/rules_k8s/archive/refs/tags/v0.6.tar.gz'), ('sha256', '51f0977294699cd547e139ceff2396c32588575588678d2054da167691a227ef'), ('strip_prefix', 'rules_k8s-0.6'), ('updated_at', '2022-04-10'), ('version', 'v0.6')]), ordereddict([('name', 'bazel_toolchains'), ('url', 'https://github.com/bazelbuild/bazel-toolchains/archive/refs/tags/v5.1.1.tar.gz'), ('sha256', 'e52789d4e89c3e2dc0e3446a9684626a626b6bec3fde787d70bae37c6ebcc47f'), ('strip_prefix', 'bazel-toolchains-5.1.1'), ('updated_at', '2022-04-10'), ('version', 'v5.1.1')]), ordereddict([('name', 'rules_java'), ('sha256', 'ddc9e11f4836265fea905d2845ac1d04ebad12a255f791ef7fd648d1d2215a5b'), ('url', 'https://github.com/bazelbuild/rules_java/archive/refs/tags/5.0.0.tar.gz'), ('strip_prefix', 'rules_java-5.0.0'), ('updated_at', '2022-04-10'), ('version', '5.0.0')]), ordereddict([('name', 'rules_jvm_external'), ('sha256', '2cd77de091e5376afaf9cc391c15f093ebd0105192373b334f0a855d89092ad5'), ('strip_prefix', 'rules_jvm_external-4.2'), ('url', 'https://github.com/bazelbuild/rules_jvm_external/archive/refs/tags/4.2.tar.gz'), ('updated_at', '2022-04-10'), ('version', '4.2')]), ordereddict([('name', 'rules_proto'), ('sha256', '66bfdf8782796239d3875d37e7de19b1d94301e8972b3cbd2446b332429b4df1'), ('strip_prefix', 'rules_proto-4.0.0'), ('url', 'https://github.com/bazelbuild/rules_proto/archive/refs/tags/4.0.0.tar.gz'), ('updated_at', '2022-04-10'), ('version', '4.0.0')]), ordereddict([('name', 'io_grpc_grpc_java'), ('sha256', '51bac553d269b97214dbd6aee4e65fc616d8ccd414fc12d708e85979ed4c19b4'), ('strip_prefix', 'grpc-java-1.45.1'), ('url', 'https://github.com/grpc/grpc-java/archive/refs/tags/v1.45.1.tar.gz'), ('updated_at', '2022-04-10'), ('version', 'v1.45.1')]), ordereddict([('name', 'rules_python'), ('sha256', '9fcf91dbcc31fde6d1edb15f117246d912c33c36f44cf681976bd886538deba6'), ('strip_prefix', 'rules_python-0.8.0'), ('url', 'https://github.com/bazelbuild/rules_python/archive/refs/tags/0.8.0.tar.gz'), ('updated_at', '2022-04-10'), ('version', '0.8.0')]), ordereddict([('name', 'io_bazel_rules_go'), ('sha256', '7618869e5f53cc17d5b837edafd06e25b5cddb596482880b5e55f6ec4d276fea'), ('url', 'https://github.com/bazelbuild/rules_go/archive/refs/tags/v0.31.0.tar.gz'), ('updated_at', '2022-04-10'), ('version', 'v0.31.0'), ('strip_prefix', 'rules_go-0.31.0')]), ordereddict([('name', 'bazel_gazelle'), ('sha256', 'bc54dfde4f55955370e4050da3917e2799b44ee935eca2cf9a20e9bc884ee243'), ('url', 'https://github.com/bazelbuild/bazel-gazelle/archive/refs/tags/v0.25.0.tar.gz'), ('updated_at', '2022-04-10'), ('version', 'v0.25.0'), ('strip_prefix', 'bazel-gazelle-0.25.0')])]), ('pip_deps', [ordereddict([('name', 'ruamel.yaml'), ('version', '0.17.21'), ('updated_at', '2022-04-09')]), ordereddict([('name', 'requests'), ('version', '2.27.1'), ('updated_at', '2022-04-10')])]), ('maven_deps', []), ('container_deps', []), ('go_deps', [])])
