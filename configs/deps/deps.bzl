"""
deps.bzl

To manually update some deps,
    please edit _DPES_YAML and then run `bazel run //cmd/infra/deps:update`.
"""

# BEGIN deps.yaml
_DEPS_YAML = r"""
metadata:
  name: boleynsu_org
  pin_cmd: bazel run //cmd/infra/deps:update
  include:
  - '@boleynsu_org//third_party/io_grpc_grpc_java_deps_bzl:deps_bzl'

bazel_deps:
- name: rules_cc
  type: http_archive
  url: https://github.com/bazelbuild/rules_cc/archive/refs/tags/0.0.6.tar.gz
  sha256: 3d9e271e2876ba42e114c9b9bc51454e379cbf0ec9ef9d40e2ae4cec61a31b40
  version: 0.0.6
  strip_prefix: rules_cc-0.0.6
  updated_at: '2023-02-18'
  load_deps: |
    load("@rules_cc//cc:repositories.bzl", "rules_cc_dependencies")
    def deps():
      rules_cc_dependencies()
- name: rules_java
  type: http_archive
  sha256: f90111a597b2aa77b7104dbdc685fd35ea0cca3b7c3f807153765e22319cbd88
  url: https://github.com/bazelbuild/rules_java/archive/refs/tags/5.4.0.tar.gz
  strip_prefix: rules_java-5.4.0
  updated_at: '2023-01-02'
  version: 5.4.0
  version_skip:
  - 5.4.1 # Won't build with grpc-java
  load_deps: |
    load("@rules_java//java:repositories.bzl", "rules_java_dependencies", "rules_java_toolchains")
    def deps():
      rules_java_dependencies()
      rules_java_toolchains()
- name: rules_python
  type: http_archive
  sha256: ffc7b877c95413c82bfd5482c017edcf759a6250d8b24e82f41f3c8b8d9e287e
  strip_prefix: rules_python-0.19.0
  url: https://github.com/bazelbuild/rules_python/archive/refs/tags/0.19.0.tar.gz
  updated_at: '2023-03-03'
  version: 0.19.0
  load_deps: |
    load("@rules_python//python:repositories.bzl", "python_register_toolchains")
    load("@bazel_deps//:toolchain_deps.bzl", "PYTHON_VERSION")
    def deps():
      python_register_toolchains(
        name = "python_sdk",
        python_version = PYTHON_VERSION,
      )
- name: rules_proto
  type: http_archive
  sha256: 66bfdf8782796239d3875d37e7de19b1d94301e8972b3cbd2446b332429b4df1
  strip_prefix: rules_proto-4.0.0
  url: https://github.com/bazelbuild/rules_proto/archive/refs/tags/4.0.0.tar.gz
  updated_at: '2022-11-26'
  version: 4.0.0
  version_regex: ([^-]*).*
  version_skip:
  - 5.3.0
  load_deps: |
    load("@rules_proto//proto:repositories.bzl", "rules_proto_dependencies", "rules_proto_toolchains")
    def deps():
      rules_proto_dependencies()
      rules_proto_toolchains()
- name: io_bazel_rules_go
  type: http_archive
  sha256: fa85588bd4d56a8f5a16c9107098e5662dbedb3004bf2640d183bd02cd899d57
  url: https://github.com/bazelbuild/rules_go/archive/refs/tags/v0.38.1.tar.gz
  updated_at: '2023-02-03'
  version: v0.38.1
  strip_prefix: rules_go-0.38.1
  load_deps: |
    load("@io_bazel_rules_go//go:deps.bzl", "go_download_sdk", "go_rules_dependencies")
    load("@bazel_deps//:toolchain_deps.bzl", "GOLANG_VERSION")
    def deps():
      go_rules_dependencies()
      go_download_sdk(
          name = "go_linux_amd64",
          goos = "linux",
          goarch = "amd64",
          version = GOLANG_VERSION
      )
- name: io_bazel_rules_docker
  type: http_archive
  url: https://github.com/bazelbuild/rules_docker/archive/refs/tags/v0.25.0.tar.gz
  sha256: 07ee8ca536080f5ebab6377fc6e8920e9a761d2ee4e64f0f6d919612f6ab56aa
  strip_prefix: rules_docker-0.25.0
  updated_at: '2022-07-01'
  version: v0.25.0
  load_deps: |
    load("@io_bazel_rules_docker//repositories:repositories.bzl", "repositories")
    load("@io_bazel_rules_docker//repositories:deps.bzl", deps_ = "deps")
    def deps():
      repositories()
      deps_()
- name: com_github_yaml_pyyaml
  type: http_archive
  url: https://github.com/yaml/pyyaml/archive/refs/tags/6.0.tar.gz
  sha256: f33eaba25d8e0c1a959bbf00655198c287dfc5868f5b7b01e401eaa1796cc778
  strip_prefix: pyyaml-6.0
  version: '6.0'
  updated_at: '2022-07-17'
  build_file_content: |
    alias(
        name = "yaml",
        actual = "@pip_pyyaml//:pkg",
        visibility = ["//visibility:public"],
    )

    alias(
        name = "yaml3",
        actual = "@pip_pyyaml//:pkg",
        visibility = ["//visibility:public"],
    )
- name: io_bazel_rules_k8s
  type: http_archive
  url: https://github.com/bazelbuild/rules_k8s/archive/refs/tags/v0.7.tar.gz
  sha256: ce5b9bc0926681e2e7f2147b49096f143e6cbc783e71bc1d4f36ca76b00e6f4a
  strip_prefix: rules_k8s-0.7
  updated_at: '2022-06-18'
  version: v0.7
  load_deps: |
    def deps():
      native.register_toolchains("@boleynsu_org//configs/build/toolchains:kubectl_toolchain")
- name: bazel_skylib
  type: http_archive
  url: https://github.com/bazelbuild/bazel-skylib/archive/refs/tags/1.4.1.tar.gz
  sha256: 060426b186670beede4104095324a72bd7494d8b4e785bf0d84a612978285908
  updated_at: '2023-02-11'
  version: 1.4.1
  strip_prefix: bazel-skylib-1.4.1
  load_deps: |
    load("@bazel_skylib//:workspace.bzl", "bazel_skylib_workspace")
    def deps():
      bazel_skylib_workspace()
- name: rules_jvm_external
  type: http_archive
  sha256: 6e9f2b94ecb6aa7e7ec4a0fbf882b226ff5257581163e88bf70ae521555ad271
  strip_prefix: rules_jvm_external-4.5
  url: https://github.com/bazelbuild/rules_jvm_external/archive/refs/tags/4.5.tar.gz
  updated_at: '2022-11-25'
  version: '4.5'
- name: bazel_toolchains
  type: http_archive
  url: https://github.com/bazelbuild/bazel-toolchains/archive/refs/tags/v5.1.2.tar.gz
  sha256: 02e4f3744f1ce3f6e711e261fd322916ddd18cccd38026352f7a4c0351dbda19
  strip_prefix: bazel-toolchains-5.1.2
  updated_at: '2022-09-16'
  version: v5.1.2
- name: rules_pkg
  type: http_archive
  url: https://github.com/bazelbuild/rules_pkg/archive/refs/tags/0.8.1.tar.gz
  sha256: 99d56f7cba0854dd1db96cf245fd52157cef58808c8015e96994518d28e3c7ab
  updated_at: '2023-02-11'
  version: 0.8.1
  strip_prefix: rules_pkg-0.8.1
  load_deps: |
    load("@rules_pkg//:deps.bzl", "rules_pkg_dependencies")
    def deps():
      rules_pkg_dependencies()
- name: io_grpc_grpc_java
  type: http_archive
  sha256: fd0a649d03a8da06746814f414fb4d36c1b2f34af2aad4e19ae43f7c4bd6f15e
  strip_prefix: grpc-java-1.53.0
  url: https://github.com/grpc/grpc-java/archive/refs/tags/v1.53.0.tar.gz
  updated_at: '2023-02-18'
  version: v1.53.0
  load_deps: |
    load("@io_grpc_grpc_java//:repositories.bzl", "grpc_java_repositories")
    def deps():
      grpc_java_repositories()
- name: bazel_gazelle
  type: http_archive
  sha256: 1b4c8e2b2e7d20236810362d61288fdaad192ecdb4e3c49b953ce0c5cee8258a
  url: https://github.com/bazelbuild/bazel-gazelle/archive/refs/tags/v0.29.0.tar.gz
  updated_at: '2023-01-17'
  version: v0.29.0
  strip_prefix: bazel-gazelle-0.29.0
  # FIXME(https://github.com/bazelbuild/bazel-gazelle/issues/1305):
  # The current implementation forces users to declare go_repository before gazelle_dependencies to avoid being overridden.
  patch_cmds:
  - "sed -i 's#go_repository = _go_repository#go_repository = _go_repository\\ndef fake_go_repository(**kwargs): pass#g' deps.bzl"
  - sed -i 's# go_repository,# fake_go_repository,#g' deps.bzl
  load_deps: |
    load("@bazel_gazelle//:deps.bzl", "gazelle_dependencies")
    def deps():
      gazelle_dependencies()
- name: io_k8s_kubernetes
  type: http_archive
  url: https://github.com/kubernetes/kubernetes/archive/refs/tags/v1.26.2.tar.gz
  sha256: 7a50f0a8f0b649922f021f811d6ace8c282d09a0e3a30fa69d86b6c28eb51fd1
  strip_prefix: kubernetes-1.26.2
  updated_at: '2023-03-03'
  version: v1.26.2
  build_file: '@boleynsu_org//third_party:io_k8s_kubernetes.BUILD'
- name: com_github_cdolivet_editarea
  type: http_archive
  url: https://github.com/cdolivet/EditArea/archive/refs/tags/v0.8.2.tar.gz
  sha256: 47b58cf925b76252156da52187329d2cfede4f0f6f83416dcd9f0753592cb1f0
  strip_prefix: EditArea-0.8.2
  updated_at: '2022-07-24'
  version: v0.8.2
  build_file: '@boleynsu_org//third_party:com_github_cdolivet_editarea.BUILD'
- name: llvm-raw
  type: http_archive
  url: https://github.com/llvm/llvm-project/archive/refs/tags/llvmorg-15.0.6.tar.gz
  sha256: 4d857d7a180918bdacd09a5910bf9743c9861a1e49cb065a85f7a990f812161d
  strip_prefix: llvm-project-llvmorg-15.0.6
  version: llvmorg-15.0.6
  version_regex: llvmorg-(.*)
  version_skip:
  - llvmorg-15.0.7
  updated_at: '2022-12-24'
- name: llvm_linux_x86_64
  type: http_archive
  url: https://github.com/llvm/llvm-project/releases/download/llvmorg-15.0.6/clang+llvm-15.0.6-x86_64-linux-gnu-ubuntu-18.04.tar.xz
  sha256: 38bc7f5563642e73e69ac5626724e206d6d539fbef653541b34cae0ba9c3f036
  strip_prefix: clang+llvm-15.0.6-x86_64-linux-gnu-ubuntu-18.04
  version: llvmorg-15.0.6
  version_regex: llvmorg-(.*)
  version_skip:
  - llvmorg-15.0.7
  updated_at: '2022-12-24'
  load_deps: |
    load("@com_grail_bazel_toolchain//toolchain:rules.bzl", "llvm_toolchain")
    load("@bazel_deps//:bazel_deps.bzl", "BAZEL_DEPS")

    def deps():
        llvm_toolchain(
            name = "llvm_toolchain_linux_x86_64",
            llvm_version = BAZEL_DEPS["llvm_linux_x86_64"]["version"][len("llvmorg-"):],
            exec_os = "linux",
            exec_cpu = "x86_64",
            urls = {
                "linux_x86_64": [BAZEL_DEPS["llvm_linux_x86_64"]["url"]],
            },
            strip_prefix = {
                "linux_x86_64": BAZEL_DEPS["llvm_linux_x86_64"]["strip_prefix"],
            },
            sha256 = {
                "linux_x86_64": BAZEL_DEPS["llvm_linux_x86_64"]["sha256"],
            },
        )
        native.register_toolchains("@llvm_toolchain_linux_x86_64//:cc-toolchain-x86_64-linux")
  override_updater:
  - type: deps_updater
    name: bazel_deps
    extra_args:
    - name: fields
      value: [version]
  - type: shell
    cmd: |
      name=$(curl -H "Authorization: Bearer $GITHUB_TOKEN" -sL https://api.github.com/repos/llvm/llvm-project/releases | jq -r '.[] | select(.tag_name == "'${DEPS_UPDATER_version}'") | .assets[] | select(.name | test("x86_64-linux-gnu-ubuntu.*tar.xz$")) | .name')
      echo DEPS_UPDATER_url=https://github.com/llvm/llvm-project/releases/download/${DEPS_UPDATER_version}/${name}
      echo DEPS_UPDATER_strip_prefix=${name%.tar.xz}
  - type: deps_updater
    name: bazel_deps
    extra_args:
    - name: fields
      value: [sha256]
- name: com_grail_bazel_toolchain
  type: http_archive
  url: https://github.com/grailbio/bazel-toolchain/archive/refs/tags/0.8.tar.gz
  sha256: d3d218287e76c0ad28bc579db711d1fa019fb0463634dfd944a1c2679ef9565b
  strip_prefix: bazel-toolchain-0.8
  updated_at: '2022-12-23'
  version: '0.8'
  patches:
  - '@boleynsu_org//third_party:com_grail_bazel_toolchain.patch'
- name: io_bazel
  type: http_archive
  version: 6.0.0
  url: https://github.com/bazelbuild/bazel/archive/refs/tags/6.0.0.tar.gz
  sha256: 06d3dbcba2286d45fc6479a87ccc649055821fc6da0c3c6801e73da780068397
  updated_at: '2022-12-23'
  load_deps: |
    load("@bazel_deps//:bazel_deps.bzl", "BAZEL_DEPS")
    def deps():
      if BAZEL_DEPS["io_bazel"]["version"] != native.bazel_version:
        print("You are using an unsupported version of Bazel")
  strip_prefix: bazel-6.0.0
- name: bazel_linux_x86_64
  type: http_file
  version: 6.0.0
  url: https://github.com/bazelbuild/bazel/releases/download/6.0.0/bazel-6.0.0-linux-x86_64
  sha256: f03d44ecaac3878e3d19489e37caa4ca1dc57427b686a78a85065ea3c27ebe68
  updated_at: '2022-12-23'
  executable: true
  override_updater:
  - type: deps_updater
    name: bazel_deps
    extra_args:
    - name: fields
      value: [version]
  - type: shell
    cmd: echo DEPS_UPDATER_url=https://github.com/bazelbuild/bazel/releases/download/${DEPS_UPDATER_version}/bazel-${DEPS_UPDATER_version}-linux-x86_64
  - type: deps_updater
    name: bazel_deps
    extra_args:
    - name: fields
      value: [sha256]

pip_deps:
- name: ruamel.yaml
  version: 0.17.21
  updated_at: '2022-04-09'
- name: PyYAML
  version: '6.0'
  updated_at: '2022-05-11'

maven_deps:
- name: commons-io:commons-io
  version: 2.11.0
  updated_at: '2022-04-09'
- name: com.mysql:mysql-connector-j
  version: 8.0.32
  updated_at: '2023-01-25'
- name: org.apache.tomcat.embed:tomcat-embed-core
  version: 10.1.6
  updated_at: '2023-02-25'
- name: org.apache.tomcat.embed:tomcat-embed-jasper
  version: 10.1.6
  updated_at: '2023-02-25'
- name: org.webjars:jquery
  version: 3.6.3
  updated_at: '2023-01-07'
  manual: true
- name: org.webjars:bootstrap
  version: 3.4.1
  updated_at: '2022-04-09'
  # FIXME(https://github.com/BoleynSu/oj/issues/2):
  # Upgrade third-party JavaScript/stylesheet libraries
  pinned_until: '2023-04-09'
- name: io.undertow:undertow-core
  version: 2.3.4.Final
  version_regex: (.*)\.Final
  updated_at: '2023-02-18'
- name: commons-validator:commons-validator
  version: '1.7'
  updated_at: '2022-04-15'
- name: commons-codec:commons-codec
  version: '1.15'
  updated_at: '2022-04-15'
- name: org.wildfly.common:wildfly-common
  version: 1.6.0.Final
  version_regex: (.*)\.Final
  updated_at: '2022-05-22'
- name: com.google.android:annotations
  version: 4.1.1.4
  included_from: io_grpc_grpc_java
- name: com.google.api.grpc:proto-google-common-protos
  version: 2.9.0
  included_from: io_grpc_grpc_java
- name: com.google.auth:google-auth-library-credentials
  version: 0.22.0
  included_from: io_grpc_grpc_java
- name: com.google.auth:google-auth-library-oauth2-http
  version: 0.22.0
  included_from: io_grpc_grpc_java
- name: com.google.code.findbugs:jsr305
  version: 3.0.2
  included_from: io_grpc_grpc_java
- name: com.google.auto.value:auto-value
  version: '1.9'
  included_from: io_grpc_grpc_java
- name: com.google.auto.value:auto-value-annotations
  version: '1.9'
  included_from: io_grpc_grpc_java
- name: com.google.errorprone:error_prone_annotations
  version: 2.9.0
  included_from: io_grpc_grpc_java
- name: com.google.guava:failureaccess
  version: 1.0.1
  included_from: io_grpc_grpc_java
- name: com.google.guava:guava
  version: 31.0.1-android
  included_from: io_grpc_grpc_java
- name: com.google.j2objc:j2objc-annotations
  version: '1.3'
  included_from: io_grpc_grpc_java
- name: com.google.truth:truth
  version: 1.0.1
  included_from: io_grpc_grpc_java
- name: com.squareup.okhttp:okhttp
  version: 2.7.5
  included_from: io_grpc_grpc_java
- name: com.squareup.okio:okio
  version: 1.17.5
  included_from: io_grpc_grpc_java
- name: io.netty:netty-buffer
  version: 4.1.79.Final
  included_from: io_grpc_grpc_java
- name: io.netty:netty-codec-http2
  version: 4.1.79.Final
  included_from: io_grpc_grpc_java
- name: io.netty:netty-codec-http
  version: 4.1.79.Final
  included_from: io_grpc_grpc_java
- name: io.netty:netty-codec-socks
  version: 4.1.79.Final
  included_from: io_grpc_grpc_java
- name: io.netty:netty-codec
  version: 4.1.79.Final
  included_from: io_grpc_grpc_java
- name: io.netty:netty-common
  version: 4.1.79.Final
  included_from: io_grpc_grpc_java
- name: io.netty:netty-handler-proxy
  version: 4.1.79.Final
  included_from: io_grpc_grpc_java
- name: io.netty:netty-handler
  version: 4.1.79.Final
  included_from: io_grpc_grpc_java
- name: io.netty:netty-resolver
  version: 4.1.79.Final
  included_from: io_grpc_grpc_java
- name: io.netty:netty-tcnative-boringssl-static
  version: 2.0.54.Final
  included_from: io_grpc_grpc_java
- name: io.netty:netty-transport-native-epoll:jar:linux-x86_64
  version: 4.1.79.Final
  included_from: io_grpc_grpc_java
- name: io.netty:netty-transport
  version: 4.1.79.Final
  included_from: io_grpc_grpc_java
- name: io.opencensus:opencensus-api
  version: 0.24.0
  included_from: io_grpc_grpc_java
- name: io.opencensus:opencensus-contrib-grpc-metrics
  version: 0.24.0
  included_from: io_grpc_grpc_java
- name: io.perfmark:perfmark-api
  version: 0.25.0
  included_from: io_grpc_grpc_java
- name: junit:junit
  version: '4.12'
  included_from: io_grpc_grpc_java
- name: org.apache.tomcat:annotations-api
  version: 6.0.53
  included_from: io_grpc_grpc_java
- name: org.codehaus.mojo:animal-sniffer-annotations
  version: '1.21'
  included_from: io_grpc_grpc_java
- name: com.google.protobuf:protobuf-java
  version: override
  override_target: '@com_google_protobuf//:protobuf_java'
  included_from: io_grpc_grpc_java
- name: com.google.protobuf:protobuf-java-util
  version: override
  override_target: '@com_google_protobuf//:protobuf_java_util'
  included_from: io_grpc_grpc_java
- name: com.google.protobuf:protobuf-javalite
  version: override
  override_target: '@com_google_protobuf_javalite//:protobuf_java_lite'
  included_from: io_grpc_grpc_java
- name: io.grpc:grpc-alts
  version: override
  override_target: '@io_grpc_grpc_java//alts'
  included_from: io_grpc_grpc_java
- name: io.grpc:grpc-api
  version: override
  override_target: '@io_grpc_grpc_java//api'
  included_from: io_grpc_grpc_java
- name: io.grpc:grpc-auth
  version: override
  override_target: '@io_grpc_grpc_java//auth'
  included_from: io_grpc_grpc_java
- name: io.grpc:grpc-census
  version: override
  override_target: '@io_grpc_grpc_java//census'
  included_from: io_grpc_grpc_java
- name: io.grpc:grpc-context
  version: override
  override_target: '@io_grpc_grpc_java//context'
  included_from: io_grpc_grpc_java
- name: io.grpc:grpc-core
  version: override
  override_target: '@io_grpc_grpc_java//core:core_maven'
  included_from: io_grpc_grpc_java
- name: io.grpc:grpc-grpclb
  version: override
  override_target: '@io_grpc_grpc_java//grpclb'
  included_from: io_grpc_grpc_java
- name: io.grpc:grpc-netty
  version: override
  override_target: '@io_grpc_grpc_java//netty'
  included_from: io_grpc_grpc_java
- name: io.grpc:grpc-netty-shaded
  version: override
  override_target: '@io_grpc_grpc_java//netty:shaded_maven'
  included_from: io_grpc_grpc_java
- name: io.grpc:grpc-okhttp
  version: override
  override_target: '@io_grpc_grpc_java//okhttp'
  included_from: io_grpc_grpc_java
- name: io.grpc:grpc-protobuf
  version: override
  override_target: '@io_grpc_grpc_java//protobuf'
  included_from: io_grpc_grpc_java
- name: io.grpc:grpc-protobuf-lite
  version: override
  override_target: '@io_grpc_grpc_java//protobuf-lite'
  included_from: io_grpc_grpc_java
- name: io.grpc:grpc-stub
  version: override
  override_target: '@io_grpc_grpc_java//stub'
  included_from: io_grpc_grpc_java
- name: io.grpc:grpc-testing
  version: override
  override_target: '@io_grpc_grpc_java//testing'
  included_from: io_grpc_grpc_java
- name: com.google.code.gson:gson
  version: 2.9.0
  included_from: io_grpc_grpc_java
- name: com.google.re2j:re2j
  version: '1.6'
  included_from: io_grpc_grpc_java
- name: io.grpc:grpc-googleapis
  version: override
  override_target: '@io_grpc_grpc_java//googleapis'
  included_from: io_grpc_grpc_java
- name: io.grpc:grpc-rls
  version: override
  override_target: '@io_grpc_grpc_java//rls'
  included_from: io_grpc_grpc_java
- name: io.grpc:grpc-services
  version: override
  override_target: '@io_grpc_grpc_java//services:services_maven'
  included_from: io_grpc_grpc_java
- name: io.grpc:grpc-xds
  version: override
  override_target: '@io_grpc_grpc_java//xds:xds_maven'
  included_from: io_grpc_grpc_java
- name: io.netty:netty-tcnative-classes
  version: 2.0.54.Final
  included_from: io_grpc_grpc_java
- name: io.netty:netty-transport-native-unix-common
  version: 4.1.79.Final
  included_from: io_grpc_grpc_java

container_deps:
- name: java_debug_image_base
  version: debug
  version_regex: ^(debug)$
  registry: gcr.io
  repository: distroless/java11
  tag: debug
  digest: sha256:de8bbf5df214f89e4a0088452fcb8e3832aa6501d087d3beb908df96f9afb431
  updated_at: '2023-02-25'
- name: java_image_base
  version: latest
  version_regex: ^(latest)$
  registry: gcr.io
  repository: distroless/java11
  tag: latest
  digest: sha256:daf98e7efd97916bf247b84b00dc9ef3fbb53124551c3fe2c4ecfd21f7f24ae8
  updated_at: '2023-02-25'
- name: py3_debug_image_base
  version: debug
  version_regex: ^(debug)$
  registry: gcr.io
  repository: distroless/python3
  tag: debug
  digest: sha256:dfff3371dd0d40e4473d468cdf24e97a3f9100ea8418dd6b378b51bf1893a397
  updated_at: '2023-02-25'
- name: py3_image_base
  version: latest
  version_regex: ^(latest)$
  registry: gcr.io
  repository: distroless/python3
  tag: latest
  digest: sha256:f30b373326c5afefad87a139192aae25146147d923c409512839558ae0fd6473
  updated_at: '2023-02-25'
- name: go_debug_image_base
  version: debug
  version_regex: ^(debug)$
  registry: gcr.io
  repository: distroless/base
  tag: debug
  digest: sha256:0f503c6bfd207793bc416f20a35bf6b75d769a903c48f180ad73f60f7b60d7bd
  updated_at: '2023-02-25'
- name: go_image_base
  version: latest
  version_regex: ^(latest)$
  registry: gcr.io
  repository: distroless/base
  tag: latest
  digest: sha256:34e682800774ecbd0954b1663d90238505f1ba5543692dbc75feef7dd4839e90
  updated_at: '2023-02-25'
- name: go_debug_image_static
  version: debug
  version_regex: ^(debug)$
  registry: gcr.io
  repository: distroless/static
  tag: debug
  digest: sha256:5b154c2e08b18f21eb36327d93db998cca897600098c766c8b51e088c3eab0e0
  updated_at: '2023-02-25'
- name: go_image_static
  version: latest
  version_regex: ^(latest)$
  registry: gcr.io
  repository: distroless/static
  tag: latest
  digest: sha256:20c99e52d222a1fe9f232acb9dbaba5a02958f0993ef7f251677fdab1856178a
  updated_at: '2023-02-25'
- name: io_quay_boleynsu_ci_runner
  version: '20230226'
  registry: quay.io
  repository: boleynsu/ci-runner
  tag: '20230226'
  digest: sha256:6b3be482d4a045bff637a0c31d31f991142d92165321ffb708016e8160beccfa
  updated_at: '2023-02-26'
- name: io_docker_library_mariadb
  version: latest
  # latest is the stable version.
  # See https://mariadb.org/mariadb/all-releases/
  version_regex: ^(latest)$
  registry: docker.io
  repository: library/mariadb
  tag: latest
  digest: sha256:5d8ac14c245bb9fce7063df2eac582c475597a2e1e7188d39ebdefbe615606df
  updated_at: '2023-03-03'
- name: io_docker_library_adminer
  version: 4.8.1
  registry: docker.io
  repository: library/adminer
  tag: 4.8.1
  digest: sha256:f3249e2dc6a52b92c088b7e21785199f4b97b1375e7517a1f3277c37c56144ac
  updated_at: '2023-03-03'
- name: io_docker_filebrowser_filebrowser
  version: v2.23.0
  registry: docker.io
  repository: filebrowser/filebrowser
  tag: v2.23.0
  digest: sha256:dd9f222c59acea83633f4101597f32620e24aa868ee7a72c40305fbd010887f2
  updated_at: '2022-11-25'
- name: io_quay_boleynsu_oj_c99runner
  version: '20230226'
  registry: quay.io
  repository: boleynsu/oj-c99runner
  tag: '20230226'
  digest: sha256:afa04210ee759fd8f1b051b3dbb71e7d6365ffa8b33dba1c54bdf1dfdb79a1a9
  updated_at: '2023-02-26'
- name: io_quay_boleynsu_rbe_fedora
  version: '20230226'
  registry: quay.io
  repository: boleynsu/rbe-fedora
  tag: '20230226'
  digest: sha256:2ef81e723ab2f327d72934fd92bc815121e39f0e2615bfab5c91d0e06760adfd
  updated_at: '2023-02-26'

go_deps:
- name: k8s.io/kubectl
  version: v0.26.2
  # FIXME(https://github.com/bazelbuild/bazel-gazelle/issues/1392): bazel-gazelle bug
  patch_cmds:
  - |
    rm pkg/explain/v2/templates/BUILD.bazel
    cat <<EOF >pkg/explain/v2/BUILD.bazel
    load("@io_bazel_rules_go//go:def.bzl", "go_library")

    go_library(
        name = "explain",
        srcs = [
            "explain.go",
            "funcs.go",
            "generator.go",
            "template.go",
        ],
        embedsrcs = glob([
            "templates/*.tmpl"
        ]),
        importpath = "k8s.io/kubectl/pkg/explain/v2",
        importpath_aliases = ["k8s.io/kubectl/pkg/explain"],
        visibility = ["//visibility:public"],
        deps = [
            "//pkg/util/term",
            "@com_github_go_openapi_jsonreference//:jsonreference",
            "@io_k8s_apimachinery//pkg/runtime",
            "@io_k8s_apimachinery//pkg/runtime/schema",
            "@io_k8s_client_go//openapi",
        ],
    )
    EOF
  updated_at: '2023-03-03'
- name: k8s.io/client-go
  version: v0.26.2
  updated_at: '2023-03-03'
- name: k8s.io/component-base
  version: v0.26.2
  updated_at: '2023-03-03'

toolchain_deps:
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
  version: '1.19'
  updated_at: '2022-12-09'

"""
# END deps.yaml

# DO NOT EDIT THE NEXT LINES! They are auto-generated.

_DEPS_JSON = r"""
{
  "metadata": {
    "name": "boleynsu_org",
    "pin_cmd": "bazel run //cmd/infra/deps:update",
    "include": [
      "@boleynsu_org//third_party/io_grpc_grpc_java_deps_bzl:deps_bzl"
    ]
  },
  "bazel_deps": [
    {
      "name": "rules_cc",
      "type": "http_archive",
      "url": "https://github.com/bazelbuild/rules_cc/archive/refs/tags/0.0.6.tar.gz",
      "sha256": "3d9e271e2876ba42e114c9b9bc51454e379cbf0ec9ef9d40e2ae4cec61a31b40",
      "version": "0.0.6",
      "strip_prefix": "rules_cc-0.0.6",
      "updated_at": "2023-02-18",
      "load_deps": "load(\"@rules_cc//cc:repositories.bzl\", \"rules_cc_dependencies\")\ndef deps():\n  rules_cc_dependencies()\n"
    },
    {
      "name": "rules_java",
      "type": "http_archive",
      "sha256": "f90111a597b2aa77b7104dbdc685fd35ea0cca3b7c3f807153765e22319cbd88",
      "url": "https://github.com/bazelbuild/rules_java/archive/refs/tags/5.4.0.tar.gz",
      "strip_prefix": "rules_java-5.4.0",
      "updated_at": "2023-01-02",
      "version": "5.4.0",
      "version_skip": [
        "5.4.1"
      ],
      "load_deps": "load(\"@rules_java//java:repositories.bzl\", \"rules_java_dependencies\", \"rules_java_toolchains\")\ndef deps():\n  rules_java_dependencies()\n  rules_java_toolchains()\n"
    },
    {
      "name": "rules_python",
      "type": "http_archive",
      "sha256": "ffc7b877c95413c82bfd5482c017edcf759a6250d8b24e82f41f3c8b8d9e287e",
      "strip_prefix": "rules_python-0.19.0",
      "url": "https://github.com/bazelbuild/rules_python/archive/refs/tags/0.19.0.tar.gz",
      "updated_at": "2023-03-03",
      "version": "0.19.0",
      "load_deps": "load(\"@rules_python//python:repositories.bzl\", \"python_register_toolchains\")\nload(\"@bazel_deps//:toolchain_deps.bzl\", \"PYTHON_VERSION\")\ndef deps():\n  python_register_toolchains(\n    name = \"python_sdk\",\n    python_version = PYTHON_VERSION,\n  )\n"
    },
    {
      "name": "rules_proto",
      "type": "http_archive",
      "sha256": "66bfdf8782796239d3875d37e7de19b1d94301e8972b3cbd2446b332429b4df1",
      "strip_prefix": "rules_proto-4.0.0",
      "url": "https://github.com/bazelbuild/rules_proto/archive/refs/tags/4.0.0.tar.gz",
      "updated_at": "2022-11-26",
      "version": "4.0.0",
      "version_regex": "([^-]*).*",
      "version_skip": [
        "5.3.0"
      ],
      "load_deps": "load(\"@rules_proto//proto:repositories.bzl\", \"rules_proto_dependencies\", \"rules_proto_toolchains\")\ndef deps():\n  rules_proto_dependencies()\n  rules_proto_toolchains()\n"
    },
    {
      "name": "io_bazel_rules_go",
      "type": "http_archive",
      "sha256": "fa85588bd4d56a8f5a16c9107098e5662dbedb3004bf2640d183bd02cd899d57",
      "url": "https://github.com/bazelbuild/rules_go/archive/refs/tags/v0.38.1.tar.gz",
      "updated_at": "2023-02-03",
      "version": "v0.38.1",
      "strip_prefix": "rules_go-0.38.1",
      "load_deps": "load(\"@io_bazel_rules_go//go:deps.bzl\", \"go_download_sdk\", \"go_rules_dependencies\")\nload(\"@bazel_deps//:toolchain_deps.bzl\", \"GOLANG_VERSION\")\ndef deps():\n  go_rules_dependencies()\n  go_download_sdk(\n      name = \"go_linux_amd64\",\n      goos = \"linux\",\n      goarch = \"amd64\",\n      version = GOLANG_VERSION\n  )\n"
    },
    {
      "name": "io_bazel_rules_docker",
      "type": "http_archive",
      "url": "https://github.com/bazelbuild/rules_docker/archive/refs/tags/v0.25.0.tar.gz",
      "sha256": "07ee8ca536080f5ebab6377fc6e8920e9a761d2ee4e64f0f6d919612f6ab56aa",
      "strip_prefix": "rules_docker-0.25.0",
      "updated_at": "2022-07-01",
      "version": "v0.25.0",
      "load_deps": "load(\"@io_bazel_rules_docker//repositories:repositories.bzl\", \"repositories\")\nload(\"@io_bazel_rules_docker//repositories:deps.bzl\", deps_ = \"deps\")\ndef deps():\n  repositories()\n  deps_()\n"
    },
    {
      "name": "com_github_yaml_pyyaml",
      "type": "http_archive",
      "url": "https://github.com/yaml/pyyaml/archive/refs/tags/6.0.tar.gz",
      "sha256": "f33eaba25d8e0c1a959bbf00655198c287dfc5868f5b7b01e401eaa1796cc778",
      "strip_prefix": "pyyaml-6.0",
      "version": "6.0",
      "updated_at": "2022-07-17",
      "build_file_content": "alias(\n    name = \"yaml\",\n    actual = \"@pip_pyyaml//:pkg\",\n    visibility = [\"//visibility:public\"],\n)\n\nalias(\n    name = \"yaml3\",\n    actual = \"@pip_pyyaml//:pkg\",\n    visibility = [\"//visibility:public\"],\n)\n"
    },
    {
      "name": "io_bazel_rules_k8s",
      "type": "http_archive",
      "url": "https://github.com/bazelbuild/rules_k8s/archive/refs/tags/v0.7.tar.gz",
      "sha256": "ce5b9bc0926681e2e7f2147b49096f143e6cbc783e71bc1d4f36ca76b00e6f4a",
      "strip_prefix": "rules_k8s-0.7",
      "updated_at": "2022-06-18",
      "version": "v0.7",
      "load_deps": "def deps():\n  native.register_toolchains(\"@boleynsu_org//configs/build/toolchains:kubectl_toolchain\")\n"
    },
    {
      "name": "bazel_skylib",
      "type": "http_archive",
      "url": "https://github.com/bazelbuild/bazel-skylib/archive/refs/tags/1.4.1.tar.gz",
      "sha256": "060426b186670beede4104095324a72bd7494d8b4e785bf0d84a612978285908",
      "updated_at": "2023-02-11",
      "version": "1.4.1",
      "strip_prefix": "bazel-skylib-1.4.1",
      "load_deps": "load(\"@bazel_skylib//:workspace.bzl\", \"bazel_skylib_workspace\")\ndef deps():\n  bazel_skylib_workspace()\n"
    },
    {
      "name": "rules_jvm_external",
      "type": "http_archive",
      "sha256": "6e9f2b94ecb6aa7e7ec4a0fbf882b226ff5257581163e88bf70ae521555ad271",
      "strip_prefix": "rules_jvm_external-4.5",
      "url": "https://github.com/bazelbuild/rules_jvm_external/archive/refs/tags/4.5.tar.gz",
      "updated_at": "2022-11-25",
      "version": "4.5"
    },
    {
      "name": "bazel_toolchains",
      "type": "http_archive",
      "url": "https://github.com/bazelbuild/bazel-toolchains/archive/refs/tags/v5.1.2.tar.gz",
      "sha256": "02e4f3744f1ce3f6e711e261fd322916ddd18cccd38026352f7a4c0351dbda19",
      "strip_prefix": "bazel-toolchains-5.1.2",
      "updated_at": "2022-09-16",
      "version": "v5.1.2"
    },
    {
      "name": "rules_pkg",
      "type": "http_archive",
      "url": "https://github.com/bazelbuild/rules_pkg/archive/refs/tags/0.8.1.tar.gz",
      "sha256": "99d56f7cba0854dd1db96cf245fd52157cef58808c8015e96994518d28e3c7ab",
      "updated_at": "2023-02-11",
      "version": "0.8.1",
      "strip_prefix": "rules_pkg-0.8.1",
      "load_deps": "load(\"@rules_pkg//:deps.bzl\", \"rules_pkg_dependencies\")\ndef deps():\n  rules_pkg_dependencies()\n"
    },
    {
      "name": "io_grpc_grpc_java",
      "type": "http_archive",
      "sha256": "fd0a649d03a8da06746814f414fb4d36c1b2f34af2aad4e19ae43f7c4bd6f15e",
      "strip_prefix": "grpc-java-1.53.0",
      "url": "https://github.com/grpc/grpc-java/archive/refs/tags/v1.53.0.tar.gz",
      "updated_at": "2023-02-18",
      "version": "v1.53.0",
      "load_deps": "load(\"@io_grpc_grpc_java//:repositories.bzl\", \"grpc_java_repositories\")\ndef deps():\n  grpc_java_repositories()\n"
    },
    {
      "name": "bazel_gazelle",
      "type": "http_archive",
      "sha256": "1b4c8e2b2e7d20236810362d61288fdaad192ecdb4e3c49b953ce0c5cee8258a",
      "url": "https://github.com/bazelbuild/bazel-gazelle/archive/refs/tags/v0.29.0.tar.gz",
      "updated_at": "2023-01-17",
      "version": "v0.29.0",
      "strip_prefix": "bazel-gazelle-0.29.0",
      "patch_cmds": [
        "sed -i 's#go_repository = _go_repository#go_repository = _go_repository\\ndef fake_go_repository(**kwargs): pass#g' deps.bzl",
        "sed -i 's# go_repository,# fake_go_repository,#g' deps.bzl"
      ],
      "load_deps": "load(\"@bazel_gazelle//:deps.bzl\", \"gazelle_dependencies\")\ndef deps():\n  gazelle_dependencies()\n"
    },
    {
      "name": "io_k8s_kubernetes",
      "type": "http_archive",
      "url": "https://github.com/kubernetes/kubernetes/archive/refs/tags/v1.26.2.tar.gz",
      "sha256": "7a50f0a8f0b649922f021f811d6ace8c282d09a0e3a30fa69d86b6c28eb51fd1",
      "strip_prefix": "kubernetes-1.26.2",
      "updated_at": "2023-03-03",
      "version": "v1.26.2",
      "build_file": "@boleynsu_org//third_party:io_k8s_kubernetes.BUILD"
    },
    {
      "name": "com_github_cdolivet_editarea",
      "type": "http_archive",
      "url": "https://github.com/cdolivet/EditArea/archive/refs/tags/v0.8.2.tar.gz",
      "sha256": "47b58cf925b76252156da52187329d2cfede4f0f6f83416dcd9f0753592cb1f0",
      "strip_prefix": "EditArea-0.8.2",
      "updated_at": "2022-07-24",
      "version": "v0.8.2",
      "build_file": "@boleynsu_org//third_party:com_github_cdolivet_editarea.BUILD"
    },
    {
      "name": "llvm-raw",
      "type": "http_archive",
      "url": "https://github.com/llvm/llvm-project/archive/refs/tags/llvmorg-15.0.6.tar.gz",
      "sha256": "4d857d7a180918bdacd09a5910bf9743c9861a1e49cb065a85f7a990f812161d",
      "strip_prefix": "llvm-project-llvmorg-15.0.6",
      "version": "llvmorg-15.0.6",
      "version_regex": "llvmorg-(.*)",
      "version_skip": [
        "llvmorg-15.0.7"
      ],
      "updated_at": "2022-12-24"
    },
    {
      "name": "llvm_linux_x86_64",
      "type": "http_archive",
      "url": "https://github.com/llvm/llvm-project/releases/download/llvmorg-15.0.6/clang+llvm-15.0.6-x86_64-linux-gnu-ubuntu-18.04.tar.xz",
      "sha256": "38bc7f5563642e73e69ac5626724e206d6d539fbef653541b34cae0ba9c3f036",
      "strip_prefix": "clang+llvm-15.0.6-x86_64-linux-gnu-ubuntu-18.04",
      "version": "llvmorg-15.0.6",
      "version_regex": "llvmorg-(.*)",
      "version_skip": [
        "llvmorg-15.0.7"
      ],
      "updated_at": "2022-12-24",
      "load_deps": "load(\"@com_grail_bazel_toolchain//toolchain:rules.bzl\", \"llvm_toolchain\")\nload(\"@bazel_deps//:bazel_deps.bzl\", \"BAZEL_DEPS\")\n\ndef deps():\n    llvm_toolchain(\n        name = \"llvm_toolchain_linux_x86_64\",\n        llvm_version = BAZEL_DEPS[\"llvm_linux_x86_64\"][\"version\"][len(\"llvmorg-\"):],\n        exec_os = \"linux\",\n        exec_cpu = \"x86_64\",\n        urls = {\n            \"linux_x86_64\": [BAZEL_DEPS[\"llvm_linux_x86_64\"][\"url\"]],\n        },\n        strip_prefix = {\n            \"linux_x86_64\": BAZEL_DEPS[\"llvm_linux_x86_64\"][\"strip_prefix\"],\n        },\n        sha256 = {\n            \"linux_x86_64\": BAZEL_DEPS[\"llvm_linux_x86_64\"][\"sha256\"],\n        },\n    )\n    native.register_toolchains(\"@llvm_toolchain_linux_x86_64//:cc-toolchain-x86_64-linux\")\n",
      "override_updater": [
        {
          "type": "deps_updater",
          "name": "bazel_deps",
          "extra_args": [
            {
              "name": "fields",
              "value": [
                "version"
              ]
            }
          ]
        },
        {
          "type": "shell",
          "cmd": "name=$(curl -H \"Authorization: Bearer $GITHUB_TOKEN\" -sL https://api.github.com/repos/llvm/llvm-project/releases | jq -r '.[] | select(.tag_name == \"'${DEPS_UPDATER_version}'\") | .assets[] | select(.name | test(\"x86_64-linux-gnu-ubuntu.*tar.xz$\")) | .name')\necho DEPS_UPDATER_url=https://github.com/llvm/llvm-project/releases/download/${DEPS_UPDATER_version}/${name}\necho DEPS_UPDATER_strip_prefix=${name%.tar.xz}\n"
        },
        {
          "type": "deps_updater",
          "name": "bazel_deps",
          "extra_args": [
            {
              "name": "fields",
              "value": [
                "sha256"
              ]
            }
          ]
        }
      ]
    },
    {
      "name": "com_grail_bazel_toolchain",
      "type": "http_archive",
      "url": "https://github.com/grailbio/bazel-toolchain/archive/refs/tags/0.8.tar.gz",
      "sha256": "d3d218287e76c0ad28bc579db711d1fa019fb0463634dfd944a1c2679ef9565b",
      "strip_prefix": "bazel-toolchain-0.8",
      "updated_at": "2022-12-23",
      "version": "0.8",
      "patches": [
        "@boleynsu_org//third_party:com_grail_bazel_toolchain.patch"
      ]
    },
    {
      "name": "io_bazel",
      "type": "http_archive",
      "version": "6.0.0",
      "url": "https://github.com/bazelbuild/bazel/archive/refs/tags/6.0.0.tar.gz",
      "sha256": "06d3dbcba2286d45fc6479a87ccc649055821fc6da0c3c6801e73da780068397",
      "updated_at": "2022-12-23",
      "load_deps": "load(\"@bazel_deps//:bazel_deps.bzl\", \"BAZEL_DEPS\")\ndef deps():\n  if BAZEL_DEPS[\"io_bazel\"][\"version\"] != native.bazel_version:\n    print(\"You are using an unsupported version of Bazel\")\n",
      "strip_prefix": "bazel-6.0.0"
    },
    {
      "name": "bazel_linux_x86_64",
      "type": "http_file",
      "version": "6.0.0",
      "url": "https://github.com/bazelbuild/bazel/releases/download/6.0.0/bazel-6.0.0-linux-x86_64",
      "sha256": "f03d44ecaac3878e3d19489e37caa4ca1dc57427b686a78a85065ea3c27ebe68",
      "updated_at": "2022-12-23",
      "executable": true,
      "override_updater": [
        {
          "type": "deps_updater",
          "name": "bazel_deps",
          "extra_args": [
            {
              "name": "fields",
              "value": [
                "version"
              ]
            }
          ]
        },
        {
          "type": "shell",
          "cmd": "echo DEPS_UPDATER_url=https://github.com/bazelbuild/bazel/releases/download/${DEPS_UPDATER_version}/bazel-${DEPS_UPDATER_version}-linux-x86_64"
        },
        {
          "type": "deps_updater",
          "name": "bazel_deps",
          "extra_args": [
            {
              "name": "fields",
              "value": [
                "sha256"
              ]
            }
          ]
        }
      ]
    }
  ],
  "pip_deps": [
    {
      "name": "ruamel.yaml",
      "version": "0.17.21",
      "updated_at": "2022-04-09"
    },
    {
      "name": "PyYAML",
      "version": "6.0",
      "updated_at": "2022-05-11"
    }
  ],
  "maven_deps": [
    {
      "name": "commons-io:commons-io",
      "version": "2.11.0",
      "updated_at": "2022-04-09"
    },
    {
      "name": "com.mysql:mysql-connector-j",
      "version": "8.0.32",
      "updated_at": "2023-01-25"
    },
    {
      "name": "org.apache.tomcat.embed:tomcat-embed-core",
      "version": "10.1.6",
      "updated_at": "2023-02-25"
    },
    {
      "name": "org.apache.tomcat.embed:tomcat-embed-jasper",
      "version": "10.1.6",
      "updated_at": "2023-02-25"
    },
    {
      "name": "org.webjars:jquery",
      "version": "3.6.3",
      "updated_at": "2023-01-07",
      "manual": true
    },
    {
      "name": "org.webjars:bootstrap",
      "version": "3.4.1",
      "updated_at": "2022-04-09",
      "pinned_until": "2023-04-09"
    },
    {
      "name": "io.undertow:undertow-core",
      "version": "2.3.4.Final",
      "version_regex": "(.*)\\.Final",
      "updated_at": "2023-02-18"
    },
    {
      "name": "commons-validator:commons-validator",
      "version": "1.7",
      "updated_at": "2022-04-15"
    },
    {
      "name": "commons-codec:commons-codec",
      "version": "1.15",
      "updated_at": "2022-04-15"
    },
    {
      "name": "org.wildfly.common:wildfly-common",
      "version": "1.6.0.Final",
      "version_regex": "(.*)\\.Final",
      "updated_at": "2022-05-22"
    },
    {
      "name": "com.google.android:annotations",
      "version": "4.1.1.4",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "com.google.api.grpc:proto-google-common-protos",
      "version": "2.9.0",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "com.google.auth:google-auth-library-credentials",
      "version": "0.22.0",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "com.google.auth:google-auth-library-oauth2-http",
      "version": "0.22.0",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "com.google.code.findbugs:jsr305",
      "version": "3.0.2",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "com.google.auto.value:auto-value",
      "version": "1.9",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "com.google.auto.value:auto-value-annotations",
      "version": "1.9",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "com.google.errorprone:error_prone_annotations",
      "version": "2.9.0",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "com.google.guava:failureaccess",
      "version": "1.0.1",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "com.google.guava:guava",
      "version": "31.0.1-android",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "com.google.j2objc:j2objc-annotations",
      "version": "1.3",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "com.google.truth:truth",
      "version": "1.0.1",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "com.squareup.okhttp:okhttp",
      "version": "2.7.5",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "com.squareup.okio:okio",
      "version": "1.17.5",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.netty:netty-buffer",
      "version": "4.1.79.Final",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.netty:netty-codec-http2",
      "version": "4.1.79.Final",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.netty:netty-codec-http",
      "version": "4.1.79.Final",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.netty:netty-codec-socks",
      "version": "4.1.79.Final",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.netty:netty-codec",
      "version": "4.1.79.Final",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.netty:netty-common",
      "version": "4.1.79.Final",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.netty:netty-handler-proxy",
      "version": "4.1.79.Final",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.netty:netty-handler",
      "version": "4.1.79.Final",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.netty:netty-resolver",
      "version": "4.1.79.Final",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.netty:netty-tcnative-boringssl-static",
      "version": "2.0.54.Final",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.netty:netty-transport-native-epoll:jar:linux-x86_64",
      "version": "4.1.79.Final",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.netty:netty-transport",
      "version": "4.1.79.Final",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.opencensus:opencensus-api",
      "version": "0.24.0",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.opencensus:opencensus-contrib-grpc-metrics",
      "version": "0.24.0",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.perfmark:perfmark-api",
      "version": "0.25.0",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "junit:junit",
      "version": "4.12",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "org.apache.tomcat:annotations-api",
      "version": "6.0.53",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "org.codehaus.mojo:animal-sniffer-annotations",
      "version": "1.21",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "com.google.protobuf:protobuf-java",
      "version": "override",
      "override_target": "@com_google_protobuf//:protobuf_java",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "com.google.protobuf:protobuf-java-util",
      "version": "override",
      "override_target": "@com_google_protobuf//:protobuf_java_util",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "com.google.protobuf:protobuf-javalite",
      "version": "override",
      "override_target": "@com_google_protobuf_javalite//:protobuf_java_lite",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.grpc:grpc-alts",
      "version": "override",
      "override_target": "@io_grpc_grpc_java//alts",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.grpc:grpc-api",
      "version": "override",
      "override_target": "@io_grpc_grpc_java//api",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.grpc:grpc-auth",
      "version": "override",
      "override_target": "@io_grpc_grpc_java//auth",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.grpc:grpc-census",
      "version": "override",
      "override_target": "@io_grpc_grpc_java//census",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.grpc:grpc-context",
      "version": "override",
      "override_target": "@io_grpc_grpc_java//context",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.grpc:grpc-core",
      "version": "override",
      "override_target": "@io_grpc_grpc_java//core:core_maven",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.grpc:grpc-grpclb",
      "version": "override",
      "override_target": "@io_grpc_grpc_java//grpclb",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.grpc:grpc-netty",
      "version": "override",
      "override_target": "@io_grpc_grpc_java//netty",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.grpc:grpc-netty-shaded",
      "version": "override",
      "override_target": "@io_grpc_grpc_java//netty:shaded_maven",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.grpc:grpc-okhttp",
      "version": "override",
      "override_target": "@io_grpc_grpc_java//okhttp",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.grpc:grpc-protobuf",
      "version": "override",
      "override_target": "@io_grpc_grpc_java//protobuf",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.grpc:grpc-protobuf-lite",
      "version": "override",
      "override_target": "@io_grpc_grpc_java//protobuf-lite",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.grpc:grpc-stub",
      "version": "override",
      "override_target": "@io_grpc_grpc_java//stub",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.grpc:grpc-testing",
      "version": "override",
      "override_target": "@io_grpc_grpc_java//testing",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "com.google.code.gson:gson",
      "version": "2.9.0",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "com.google.re2j:re2j",
      "version": "1.6",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.grpc:grpc-googleapis",
      "version": "override",
      "override_target": "@io_grpc_grpc_java//googleapis",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.grpc:grpc-rls",
      "version": "override",
      "override_target": "@io_grpc_grpc_java//rls",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.grpc:grpc-services",
      "version": "override",
      "override_target": "@io_grpc_grpc_java//services:services_maven",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.grpc:grpc-xds",
      "version": "override",
      "override_target": "@io_grpc_grpc_java//xds:xds_maven",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.netty:netty-tcnative-classes",
      "version": "2.0.54.Final",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.netty:netty-transport-native-unix-common",
      "version": "4.1.79.Final",
      "included_from": "io_grpc_grpc_java"
    }
  ],
  "container_deps": [
    {
      "name": "java_debug_image_base",
      "version": "debug",
      "version_regex": "^(debug)$",
      "registry": "gcr.io",
      "repository": "distroless/java11",
      "tag": "debug",
      "digest": "sha256:de8bbf5df214f89e4a0088452fcb8e3832aa6501d087d3beb908df96f9afb431",
      "updated_at": "2023-02-25"
    },
    {
      "name": "java_image_base",
      "version": "latest",
      "version_regex": "^(latest)$",
      "registry": "gcr.io",
      "repository": "distroless/java11",
      "tag": "latest",
      "digest": "sha256:daf98e7efd97916bf247b84b00dc9ef3fbb53124551c3fe2c4ecfd21f7f24ae8",
      "updated_at": "2023-02-25"
    },
    {
      "name": "py3_debug_image_base",
      "version": "debug",
      "version_regex": "^(debug)$",
      "registry": "gcr.io",
      "repository": "distroless/python3",
      "tag": "debug",
      "digest": "sha256:dfff3371dd0d40e4473d468cdf24e97a3f9100ea8418dd6b378b51bf1893a397",
      "updated_at": "2023-02-25"
    },
    {
      "name": "py3_image_base",
      "version": "latest",
      "version_regex": "^(latest)$",
      "registry": "gcr.io",
      "repository": "distroless/python3",
      "tag": "latest",
      "digest": "sha256:f30b373326c5afefad87a139192aae25146147d923c409512839558ae0fd6473",
      "updated_at": "2023-02-25"
    },
    {
      "name": "go_debug_image_base",
      "version": "debug",
      "version_regex": "^(debug)$",
      "registry": "gcr.io",
      "repository": "distroless/base",
      "tag": "debug",
      "digest": "sha256:0f503c6bfd207793bc416f20a35bf6b75d769a903c48f180ad73f60f7b60d7bd",
      "updated_at": "2023-02-25"
    },
    {
      "name": "go_image_base",
      "version": "latest",
      "version_regex": "^(latest)$",
      "registry": "gcr.io",
      "repository": "distroless/base",
      "tag": "latest",
      "digest": "sha256:34e682800774ecbd0954b1663d90238505f1ba5543692dbc75feef7dd4839e90",
      "updated_at": "2023-02-25"
    },
    {
      "name": "go_debug_image_static",
      "version": "debug",
      "version_regex": "^(debug)$",
      "registry": "gcr.io",
      "repository": "distroless/static",
      "tag": "debug",
      "digest": "sha256:5b154c2e08b18f21eb36327d93db998cca897600098c766c8b51e088c3eab0e0",
      "updated_at": "2023-02-25"
    },
    {
      "name": "go_image_static",
      "version": "latest",
      "version_regex": "^(latest)$",
      "registry": "gcr.io",
      "repository": "distroless/static",
      "tag": "latest",
      "digest": "sha256:20c99e52d222a1fe9f232acb9dbaba5a02958f0993ef7f251677fdab1856178a",
      "updated_at": "2023-02-25"
    },
    {
      "name": "io_quay_boleynsu_ci_runner",
      "version": "20230226",
      "registry": "quay.io",
      "repository": "boleynsu/ci-runner",
      "tag": "20230226",
      "digest": "sha256:6b3be482d4a045bff637a0c31d31f991142d92165321ffb708016e8160beccfa",
      "updated_at": "2023-02-26"
    },
    {
      "name": "io_docker_library_mariadb",
      "version": "latest",
      "version_regex": "^(latest)$",
      "registry": "docker.io",
      "repository": "library/mariadb",
      "tag": "latest",
      "digest": "sha256:5d8ac14c245bb9fce7063df2eac582c475597a2e1e7188d39ebdefbe615606df",
      "updated_at": "2023-03-03"
    },
    {
      "name": "io_docker_library_adminer",
      "version": "4.8.1",
      "registry": "docker.io",
      "repository": "library/adminer",
      "tag": "4.8.1",
      "digest": "sha256:f3249e2dc6a52b92c088b7e21785199f4b97b1375e7517a1f3277c37c56144ac",
      "updated_at": "2023-03-03"
    },
    {
      "name": "io_docker_filebrowser_filebrowser",
      "version": "v2.23.0",
      "registry": "docker.io",
      "repository": "filebrowser/filebrowser",
      "tag": "v2.23.0",
      "digest": "sha256:dd9f222c59acea83633f4101597f32620e24aa868ee7a72c40305fbd010887f2",
      "updated_at": "2022-11-25"
    },
    {
      "name": "io_quay_boleynsu_oj_c99runner",
      "version": "20230226",
      "registry": "quay.io",
      "repository": "boleynsu/oj-c99runner",
      "tag": "20230226",
      "digest": "sha256:afa04210ee759fd8f1b051b3dbb71e7d6365ffa8b33dba1c54bdf1dfdb79a1a9",
      "updated_at": "2023-02-26"
    },
    {
      "name": "io_quay_boleynsu_rbe_fedora",
      "version": "20230226",
      "registry": "quay.io",
      "repository": "boleynsu/rbe-fedora",
      "tag": "20230226",
      "digest": "sha256:2ef81e723ab2f327d72934fd92bc815121e39f0e2615bfab5c91d0e06760adfd",
      "updated_at": "2023-02-26"
    }
  ],
  "go_deps": [
    {
      "name": "k8s.io/kubectl",
      "version": "v0.26.2",
      "patch_cmds": [
        "rm pkg/explain/v2/templates/BUILD.bazel\ncat <<EOF >pkg/explain/v2/BUILD.bazel\nload(\"@io_bazel_rules_go//go:def.bzl\", \"go_library\")\n\ngo_library(\n    name = \"explain\",\n    srcs = [\n        \"explain.go\",\n        \"funcs.go\",\n        \"generator.go\",\n        \"template.go\",\n    ],\n    embedsrcs = glob([\n        \"templates/*.tmpl\"\n    ]),\n    importpath = \"k8s.io/kubectl/pkg/explain/v2\",\n    importpath_aliases = [\"k8s.io/kubectl/pkg/explain\"],\n    visibility = [\"//visibility:public\"],\n    deps = [\n        \"//pkg/util/term\",\n        \"@com_github_go_openapi_jsonreference//:jsonreference\",\n        \"@io_k8s_apimachinery//pkg/runtime\",\n        \"@io_k8s_apimachinery//pkg/runtime/schema\",\n        \"@io_k8s_client_go//openapi\",\n    ],\n)\nEOF\n"
      ],
      "updated_at": "2023-03-03"
    },
    {
      "name": "k8s.io/client-go",
      "version": "v0.26.2",
      "updated_at": "2023-03-03"
    },
    {
      "name": "k8s.io/component-base",
      "version": "v0.26.2",
      "updated_at": "2023-03-03"
    }
  ],
  "toolchain_deps": [
    {
      "name": "c",
      "version": "17",
      "updated_at": "2022-05-07"
    },
    {
      "name": "cpp",
      "version": "17",
      "updated_at": "2022-05-05"
    },
    {
      "name": "java",
      "version": "11",
      "updated_at": "2022-05-05"
    },
    {
      "name": "python",
      "version": "3.10",
      "updated_at": "2022-05-05"
    },
    {
      "name": "golang",
      "version": "1.19",
      "updated_at": "2022-12-09"
    }
  ]
}
"""

[print("""
deps.bzl is outdated!
deps.bzl is outdated!
deps.bzl is outdated!
The important things should be emphasized three times!
""") if hash(_DEPS_YAML) != -263586167 or hash(_DEPS_JSON) != 538634941 else None]

DEPS = json.decode(_DEPS_JSON)
