"""
deps.bzl

To update all deps to latest versions,
    please run `REPIN=1 bazel run //configs/deps:update # run internal tool to update deps.bzl first`.

To manually update some deps,
    please edit _DPES_YAML and then run `REPIN=1 bazel run //configs/deps:update # run internal tool to update deps.bzl first`.
"""

# BEGIN deps.yaml
_DEPS_YAML = r"""
metadata:
  pin_cmd: 'REPIN=1 bazel run //configs/deps:update # run internal tool to update deps.bzl first'
  update_cmd: 'REPIN=1 bazel run //configs/deps:update # run internal tool to update deps.bzl first'

bazel_deps:
- name: rules_pkg
  type: http_archive
  url: https://github.com/bazelbuild/rules_pkg/archive/refs/tags/0.7.0.tar.gz
  sha256: e110311d898c1ff35f39829ae3ec56e39c0ef92eb44de74418982a114f51e132
  updated_at: '2022-04-10'
  version: 0.7.0
  strip_prefix: rules_pkg-0.7.0
- name: bazel_skylib
  type: http_archive
  url: https://github.com/bazelbuild/bazel-skylib/archive/refs/tags/1.2.1.tar.gz
  sha256: 710c2ca4b4d46250cdce2bf8f5aa76ea1f0cba514ab368f2988f70e864cfaf51
  updated_at: '2022-04-10'
  version: 1.2.1
  strip_prefix: bazel-skylib-1.2.1
- name: io_bazel_rules_docker
  type: http_archive
  url: https://github.com/bazelbuild/rules_docker/releases/download/v0.19.0/rules_docker-v0.19.0.tar.gz
  sha256: 1f4e59843b61981a96835dc4ac377ad4da9f8c334ebe5e0bb3f58f80c09735f4
  strip_prefix: rules_docker-0.19.0
  updated_at: '2022-04-10'
  version: v0.19.0
  # FIXME(https://github.com/bazelbuild/rules_k8s/issues/687):
  # container/go/pkg/compat/reader.go#ReadImage is changed in v0.20.0 and will break io_bazel_rules_k8s
  pinned_until: '2022-07-10'
- name: io_bazel_rules_k8s
  type: http_archive
  url: https://github.com/bazelbuild/rules_k8s/archive/refs/tags/v0.6.tar.gz
  sha256: 51f0977294699cd547e139ceff2396c32588575588678d2054da167691a227ef
  strip_prefix: rules_k8s-0.6
  updated_at: '2022-04-10'
  version: v0.6
- name: bazel_toolchains
  type: http_archive
  url: https://github.com/bazelbuild/bazel-toolchains/archive/refs/tags/v5.1.1.tar.gz
  sha256: e52789d4e89c3e2dc0e3446a9684626a626b6bec3fde787d70bae37c6ebcc47f
  strip_prefix: bazel-toolchains-5.1.1
  updated_at: '2022-04-10'
  version: v5.1.1
- name: rules_java
  type: http_archive
  sha256: ddc9e11f4836265fea905d2845ac1d04ebad12a255f791ef7fd648d1d2215a5b
  url: https://github.com/bazelbuild/rules_java/archive/refs/tags/5.0.0.tar.gz
  strip_prefix: rules_java-5.0.0
  updated_at: '2022-04-10'
  version: 5.0.0
- name: rules_jvm_external
  type: http_archive
  sha256: 2cd77de091e5376afaf9cc391c15f093ebd0105192373b334f0a855d89092ad5
  strip_prefix: rules_jvm_external-4.2
  url: https://github.com/bazelbuild/rules_jvm_external/archive/refs/tags/4.2.tar.gz
  updated_at: '2022-04-10'
  version: '4.2'
- name: rules_proto
  type: http_archive
  sha256: 66bfdf8782796239d3875d37e7de19b1d94301e8972b3cbd2446b332429b4df1
  strip_prefix: rules_proto-4.0.0
  url: https://github.com/bazelbuild/rules_proto/archive/refs/tags/4.0.0.tar.gz
  updated_at: '2022-04-10'
  version: 4.0.0
- name: io_grpc_grpc_java
  type: http_archive
  sha256: c1b80883511ceb1e433fb2d4b2f6d85dca0c62a265a6a3e6695144610d6f65b8
  strip_prefix: grpc-java-1.46.0
  url: https://github.com/grpc/grpc-java/archive/refs/tags/v1.46.0.tar.gz
  updated_at: '2022-05-01'
  version: v1.46.0
- name: rules_python
  type: http_archive
  sha256: cdf6b84084aad8f10bf20b46b77cb48d83c319ebe6458a18e9d2cebf57807cdd
  # FIXME(https://github.com/bazelbuild/rules_python/issues/689):
  # the test created by compile_pip_requirements will fail when run as an external dependency
  patches: [//third_party:rules_python.patch]
  strip_prefix: rules_python-0.8.1
  url: https://github.com/bazelbuild/rules_python/archive/refs/tags/0.8.1.tar.gz
  updated_at: '2022-04-23'
  version: 0.8.1
- name: io_bazel_rules_go
  type: http_archive
  sha256: 7618869e5f53cc17d5b837edafd06e25b5cddb596482880b5e55f6ec4d276fea
  url: https://github.com/bazelbuild/rules_go/archive/refs/tags/v0.31.0.tar.gz
  updated_at: '2022-04-10'
  version: v0.31.0
  strip_prefix: rules_go-0.31.0
- name: bazel_gazelle
  type: http_archive
  sha256: 0ba1c56b5df496c07b8d258fb97193668baa0b3a93e4dbb0a1559a6dcbd7d057
  url: https://github.com/bazelbuild/bazel-gazelle/archive/refs/tags/v0.23.0.tar.gz
  updated_at: '2022-04-10'
  version: v0.23.0
  strip_prefix: bazel-gazelle-0.23.0
  # FIXME(https://github.com/bazelbuild/bazel-gazelle/issues/1150#issuecomment-1066091291):
  # This happened on Gazelle latest release (0.24.0) as well as latest commit on master.
  # Reverting to 0.23.0 and the issue gone away.
  pinned_until: '2022-06-10'
- name: rules_cc
  type: http_archive
  url: https://github.com/bazelbuild/rules_cc/archive/refs/tags/0.0.1.tar.gz
  sha256: 935e2644125fccb36fa858495697301f7834d980d0e16419943b9618af2771a4
  version: 0.0.1
  strip_prefix: rules_cc-0.0.1
  updated_at: '2022-04-20'

pip_deps:
- name: ruamel.yaml
  version: 0.17.21
  updated_at: '2022-04-09'

maven_deps:
- name: commons-io:commons-io
  version: 2.11.0
  updated_at: '2022-04-09'
- name: mysql:mysql-connector-java
  version: 8.0.29
  updated_at: '2022-04-27'
- name: org.apache.tomcat.embed:tomcat-embed-core
  version: 10.0.20
  updated_at: '2022-04-09'
- name: org.apache.tomcat.embed:tomcat-embed-jasper
  version: 10.0.20
  updated_at: '2022-04-09'
- name: org.webjars:jquery
  version: 3.6.0
  updated_at: '2022-04-09'
  manual: true
- name: org.webjars:bootstrap
  version: 3.4.1
  updated_at: '2022-04-09'
  # FIXME(https://github.com/BoleynSu/oj/issues/2):
  # Upgrade third-party JavaScript/stylesheet libraries
  pinned_until: '2023-04-09'
- name: io.undertow:undertow-core
  version: 2.2.17.Final
  version_regex: (.*)\\.Final
  updated_at: '2022-04-15'
- name: commons-validator:commons-validator
  version: '1.7'
  updated_at: '2022-04-15'
- name: commons-codec:commons-codec
  version: '1.15'
  updated_at: '2022-04-15'

container_deps:
- name: io_docker_library_gcc
  version: latest
  registry: docker.io
  # the size of library/gcc is too large so we use frolvlad/alpine-gcc instead
  repository: frolvlad/alpine-gcc
  tag: latest
  digest: sha256:d5e0ee8c9f505ab55272e8e9e2b7198b1138b173997f544c326bf1c91f884bcc
  updated_at: '2022-05-05'
- name: java_debug_image_base
  version: debug
  version_regex: ^(debug)$
  registry: gcr.io
  repository: distroless/java11
  tag: debug
  digest: sha256:f76a526834ec4dfcbc0a5002dd30c861bdadbdd184fbe0807126a3c85f5fdba0
  updated_at: '2022-05-09'
- name: java_image_base
  version: latest
  version_regex: ^(latest)$
  registry: gcr.io
  repository: distroless/java11
  tag: latest
  digest: sha256:07a1f699d34272bbcd42bba54be9dc2d7196b68e2614955aa6af2a9dfe07ecc4
  updated_at: '2022-05-09'

go_deps: []

toolchain_deps:
- name: bazel
  version: 5.1.0
  updated_at: '2022-05-06'
- name: c
  version: '17'
  updated_at: '2022-05-07'
- name: cpp
  version: '17'
  updated_at: '2022-05-05'
- name: java
  version: '11'
  updated_at: '2022-05-05'
- name: python
  version: '3.10'
  updated_at: '2022-05-05'
- name: golang
  version: '1.18'
  updated_at: '2022-05-05'
"""
# END deps.yaml

# DO NOT EDIT THE NEXT LINES! They are auto-generated.

_DEPS_JSON = '{"metadata": {"pin_cmd": "REPIN=1 bazel run //configs/deps:update # run internal tool to update deps.bzl first", "update_cmd": "REPIN=1 bazel run //configs/deps:update # run internal tool to update deps.bzl first"}, "bazel_deps": [{"name": "rules_pkg", "type": "http_archive", "url": "https://github.com/bazelbuild/rules_pkg/archive/refs/tags/0.7.0.tar.gz", "sha256": "e110311d898c1ff35f39829ae3ec56e39c0ef92eb44de74418982a114f51e132", "updated_at": "2022-04-10", "version": "0.7.0", "strip_prefix": "rules_pkg-0.7.0"}, {"name": "bazel_skylib", "type": "http_archive", "url": "https://github.com/bazelbuild/bazel-skylib/archive/refs/tags/1.2.1.tar.gz", "sha256": "710c2ca4b4d46250cdce2bf8f5aa76ea1f0cba514ab368f2988f70e864cfaf51", "updated_at": "2022-04-10", "version": "1.2.1", "strip_prefix": "bazel-skylib-1.2.1"}, {"name": "io_bazel_rules_docker", "type": "http_archive", "url": "https://github.com/bazelbuild/rules_docker/releases/download/v0.19.0/rules_docker-v0.19.0.tar.gz", "sha256": "1f4e59843b61981a96835dc4ac377ad4da9f8c334ebe5e0bb3f58f80c09735f4", "strip_prefix": "rules_docker-0.19.0", "updated_at": "2022-04-10", "version": "v0.19.0", "pinned_until": "2022-07-10"}, {"name": "io_bazel_rules_k8s", "type": "http_archive", "url": "https://github.com/bazelbuild/rules_k8s/archive/refs/tags/v0.6.tar.gz", "sha256": "51f0977294699cd547e139ceff2396c32588575588678d2054da167691a227ef", "strip_prefix": "rules_k8s-0.6", "updated_at": "2022-04-10", "version": "v0.6"}, {"name": "bazel_toolchains", "type": "http_archive", "url": "https://github.com/bazelbuild/bazel-toolchains/archive/refs/tags/v5.1.1.tar.gz", "sha256": "e52789d4e89c3e2dc0e3446a9684626a626b6bec3fde787d70bae37c6ebcc47f", "strip_prefix": "bazel-toolchains-5.1.1", "updated_at": "2022-04-10", "version": "v5.1.1"}, {"name": "rules_java", "type": "http_archive", "sha256": "ddc9e11f4836265fea905d2845ac1d04ebad12a255f791ef7fd648d1d2215a5b", "url": "https://github.com/bazelbuild/rules_java/archive/refs/tags/5.0.0.tar.gz", "strip_prefix": "rules_java-5.0.0", "updated_at": "2022-04-10", "version": "5.0.0"}, {"name": "rules_jvm_external", "type": "http_archive", "sha256": "2cd77de091e5376afaf9cc391c15f093ebd0105192373b334f0a855d89092ad5", "strip_prefix": "rules_jvm_external-4.2", "url": "https://github.com/bazelbuild/rules_jvm_external/archive/refs/tags/4.2.tar.gz", "updated_at": "2022-04-10", "version": "4.2"}, {"name": "rules_proto", "type": "http_archive", "sha256": "66bfdf8782796239d3875d37e7de19b1d94301e8972b3cbd2446b332429b4df1", "strip_prefix": "rules_proto-4.0.0", "url": "https://github.com/bazelbuild/rules_proto/archive/refs/tags/4.0.0.tar.gz", "updated_at": "2022-04-10", "version": "4.0.0"}, {"name": "io_grpc_grpc_java", "type": "http_archive", "sha256": "c1b80883511ceb1e433fb2d4b2f6d85dca0c62a265a6a3e6695144610d6f65b8", "strip_prefix": "grpc-java-1.46.0", "url": "https://github.com/grpc/grpc-java/archive/refs/tags/v1.46.0.tar.gz", "updated_at": "2022-05-01", "version": "v1.46.0"}, {"name": "rules_python", "type": "http_archive", "sha256": "cdf6b84084aad8f10bf20b46b77cb48d83c319ebe6458a18e9d2cebf57807cdd", "patches": ["//third_party:rules_python.patch"], "strip_prefix": "rules_python-0.8.1", "url": "https://github.com/bazelbuild/rules_python/archive/refs/tags/0.8.1.tar.gz", "updated_at": "2022-04-23", "version": "0.8.1"}, {"name": "io_bazel_rules_go", "type": "http_archive", "sha256": "7618869e5f53cc17d5b837edafd06e25b5cddb596482880b5e55f6ec4d276fea", "url": "https://github.com/bazelbuild/rules_go/archive/refs/tags/v0.31.0.tar.gz", "updated_at": "2022-04-10", "version": "v0.31.0", "strip_prefix": "rules_go-0.31.0"}, {"name": "bazel_gazelle", "type": "http_archive", "sha256": "0ba1c56b5df496c07b8d258fb97193668baa0b3a93e4dbb0a1559a6dcbd7d057", "url": "https://github.com/bazelbuild/bazel-gazelle/archive/refs/tags/v0.23.0.tar.gz", "updated_at": "2022-04-10", "version": "v0.23.0", "strip_prefix": "bazel-gazelle-0.23.0", "pinned_until": "2022-06-10"}, {"name": "rules_cc", "type": "http_archive", "url": "https://github.com/bazelbuild/rules_cc/archive/refs/tags/0.0.1.tar.gz", "sha256": "935e2644125fccb36fa858495697301f7834d980d0e16419943b9618af2771a4", "version": "0.0.1", "strip_prefix": "rules_cc-0.0.1", "updated_at": "2022-04-20"}], "pip_deps": [{"name": "ruamel.yaml", "version": "0.17.21", "updated_at": "2022-04-09"}], "maven_deps": [{"name": "commons-io:commons-io", "version": "2.11.0", "updated_at": "2022-04-09"}, {"name": "mysql:mysql-connector-java", "version": "8.0.29", "updated_at": "2022-04-27"}, {"name": "org.apache.tomcat.embed:tomcat-embed-core", "version": "10.0.20", "updated_at": "2022-04-09"}, {"name": "org.apache.tomcat.embed:tomcat-embed-jasper", "version": "10.0.20", "updated_at": "2022-04-09"}, {"name": "org.webjars:jquery", "version": "3.6.0", "updated_at": "2022-04-09", "manual": true}, {"name": "org.webjars:bootstrap", "version": "3.4.1", "updated_at": "2022-04-09", "pinned_until": "2023-04-09"}, {"name": "io.undertow:undertow-core", "version": "2.2.17.Final", "version_regex": "(.*)\\\\\\\\.Final", "updated_at": "2022-04-15"}, {"name": "commons-validator:commons-validator", "version": "1.7", "updated_at": "2022-04-15"}, {"name": "commons-codec:commons-codec", "version": "1.15", "updated_at": "2022-04-15"}], "container_deps": [{"name": "io_docker_library_gcc", "version": "latest", "registry": "docker.io", "repository": "frolvlad/alpine-gcc", "tag": "latest", "digest": "sha256:d5e0ee8c9f505ab55272e8e9e2b7198b1138b173997f544c326bf1c91f884bcc", "updated_at": "2022-05-05"}, {"name": "java_debug_image_base", "version": "debug", "version_regex": "^(debug)$", "registry": "gcr.io", "repository": "distroless/java11", "tag": "debug", "digest": "sha256:f76a526834ec4dfcbc0a5002dd30c861bdadbdd184fbe0807126a3c85f5fdba0", "updated_at": "2022-05-09"}, {"name": "java_image_base", "version": "latest", "version_regex": "^(latest)$", "registry": "gcr.io", "repository": "distroless/java11", "tag": "latest", "digest": "sha256:07a1f699d34272bbcd42bba54be9dc2d7196b68e2614955aa6af2a9dfe07ecc4", "updated_at": "2022-05-09"}], "go_deps": [], "toolchain_deps": [{"name": "bazel", "version": "5.1.0", "updated_at": "2022-05-06"}, {"name": "c", "version": "17", "updated_at": "2022-05-07"}, {"name": "cpp", "version": "17", "updated_at": "2022-05-05"}, {"name": "java", "version": "11", "updated_at": "2022-05-05"}, {"name": "python", "version": "3.10", "updated_at": "2022-05-05"}, {"name": "golang", "version": "1.18", "updated_at": "2022-05-05"}]}'

[print("""
deps.bzl is outdated!
deps.bzl is outdated!
deps.bzl is outdated!
The important things should be emphasized three times!
""") if hash(_DEPS_YAML) != 1772284186 or hash(_DEPS_JSON) != -1785125797 else None]

DEPS = json.decode(_DEPS_JSON)
