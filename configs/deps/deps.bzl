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
  - '@boleynsu_org//third_party/io_bazel_rules_docker_deps_bzl:deps_bzl'

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
  sha256: 7436356107f1cf24b45f95909753e521efe2d06622de184ea25e13cb7a0d72f9
  url: https://github.com/bazelbuild/rules_java/archive/refs/tags/5.5.0.tar.gz
  strip_prefix: rules_java-5.5.0
  updated_at: '2023-03-25'
  version: 5.5.0
  load_deps: |
    load("@rules_java//java:repositories.bzl", "rules_java_dependencies", "remote_jdk11_repos", "remote_jdk17_repos", "remote_jdk19_repos")
    def deps():
      rules_java_dependencies()
      remote_jdk11_repos()
  patch_cmds:
  - sed -i s@remotejdk_17@remote_jdk11@g toolchains/default_java_toolchain.bzl
- name: rules_python
  type: http_archive
  sha256: 94750828b18044533e98a129003b6a68001204038dc4749f40b195b24c38f49f
  strip_prefix: rules_python-0.21.0
  url: https://github.com/bazelbuild/rules_python/archive/refs/tags/0.21.0.tar.gz
  updated_at: '2023-04-21'
  version: 0.21.0
  load_deps: |
    load("@rules_python//python:repositories.bzl", "python_register_toolchains")
    load("@bazel_deps//:toolchain_deps.bzl", "PYTHON_VERSION")
    def deps():
      python_register_toolchains(
        name = "python_sdk",
        python_version = PYTHON_VERSION,
        register_toolchains = False,
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
    load("@rules_proto//proto:repositories.bzl", "rules_proto_dependencies")
    def deps():
      rules_proto_dependencies()
- name: io_bazel_rules_go
  type: http_archive
  sha256: 473a064d502e89d11c497a59f9717d1846e01515a3210bd169f22323161c076e
  url: https://github.com/bazelbuild/rules_go/archive/refs/tags/v0.39.1.tar.gz
  updated_at: '2023-04-21'
  version: v0.39.1
  strip_prefix: rules_go-0.39.1
  load_deps: |
    load("@io_bazel_rules_go//go:deps.bzl", "go_download_sdk", "go_rules_dependencies")
    load("@bazel_deps//:toolchain_deps.bzl", "GOLANG_VERSION")
    def deps():
      go_rules_dependencies()
      go_download_sdk(
          name = "go_linux_amd64",
          goos = "linux",
          goarch = "amd64",
          version = GOLANG_VERSION,
          register_toolchains = False,
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
    load("@boleynsu_org//tools/build/repo_rules:exports_files.bzl", "exports_files")
    def deps():
      exports_files(
        name = "io_bazel_rules_docker_deps_bzl_files",
        files= {
          "repositories/go_repositories.bzl": "@io_bazel_rules_docker//repositories:go_repositories.bzl"
        },
      )
      repositories()
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
  sha256: c9ae901381ae7f7eca08aed96caeb542f96c5449052db9c9d27274a8dc154cdf
  strip_prefix: rules_jvm_external-5.2
  url: https://github.com/bazelbuild/rules_jvm_external/archive/refs/tags/5.2.tar.gz
  updated_at: '2023-04-16'
  version: '5.2'
- name: rules_pkg
  type: http_archive
  url: https://github.com/bazelbuild/rules_pkg/archive/refs/tags/0.9.0.tar.gz
  sha256: a36867d8d9c40bf713e85ac89b9b9e4d5da16a903302d2afb39d7a1e956b75df
  updated_at: '2023-03-31'
  version: 0.9.0
  strip_prefix: rules_pkg-0.9.0
  load_deps: |
    load("@rules_pkg//:deps.bzl", "rules_pkg_dependencies")
    def deps():
      rules_pkg_dependencies()
- name: io_grpc_grpc_java
  type: http_archive
  sha256: 98c32df8a878cbca5a6799922d28e9df93a4d5607316e0e3f8269a5886d9e429
  strip_prefix: grpc-java-1.54.1
  url: https://github.com/grpc/grpc-java/archive/refs/tags/v1.54.1.tar.gz
  updated_at: '2023-04-21'
  version: v1.54.1
  load_deps: |
    load("@io_grpc_grpc_java//:repositories.bzl", "grpc_java_repositories")
    def deps():
      grpc_java_repositories()
- name: bazel_gazelle
  type: http_archive
  sha256: c012845ad21bb8053b5f0e92868a095caf9afa1eea9372c5bb46df068d7051f2
  url: https://github.com/bazelbuild/bazel-gazelle/archive/refs/tags/v0.30.0.tar.gz
  updated_at: '2023-03-31'
  version: v0.30.0
  strip_prefix: bazel-gazelle-0.30.0
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
  url: https://github.com/kubernetes/kubernetes/archive/refs/tags/v1.27.1.tar.gz
  sha256: 3a3f7c6b8cf1d9f03aa67ba2f04669772b1205b89826859f1636062d5f8bec3f
  strip_prefix: kubernetes-1.27.1
  updated_at: '2023-04-16'
  version: v1.27.1
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
  url: https://github.com/llvm/llvm-project/archive/refs/tags/llvmorg-16.0.2.tar.gz
  sha256: 97c3c6aafb53c4bb0ed2781a18d6f05e75445e24bb1dc57a32b74f8d710ac19f
  strip_prefix: llvm-project-llvmorg-16.0.2
  version: llvmorg-16.0.2
  version_regex: llvmorg-(.*)
  updated_at: '2023-04-21'
- name: llvm_linux_x86_64
  type: http_archive
  url: https://github.com/llvm/llvm-project/releases/download/llvmorg-16.0.2/clang+llvm-16.0.2-x86_64-linux-gnu-ubuntu-22.04.tar.xz
  sha256: 9530eccdffedb9761f23cbd915cf95d861b1d95f340ea36ded68bd6312af912e
  strip_prefix: clang+llvm-16.0.2-x86_64-linux-gnu-ubuntu-22.04
  version: llvmorg-16.0.2
  version_regex: llvmorg-(.*)
  updated_at: '2023-04-21'
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
- name: io_bazel
  type: http_archive
  version: 6.1.2
  url: https://github.com/bazelbuild/bazel/archive/refs/tags/6.1.2.tar.gz
  sha256: 7067251d3029b12fe8d501266279f8b5a7c4c4f8d75ef3a0e0653f20bc7a1322
  updated_at: '2023-04-21'
  load_deps: |
    load("@bazel_deps//:bazel_deps.bzl", "BAZEL_DEPS")
    def deps():
      if BAZEL_DEPS["io_bazel"]["version"] != native.bazel_version:
        print("You are using an unsupported version of Bazel")
  strip_prefix: bazel-6.1.2
- name: bazel_linux_x86_64
  type: http_file
  version: 6.1.2
  url: https://github.com/bazelbuild/bazel/releases/download/6.1.2/bazel-6.1.2-linux-x86_64
  sha256: e89747d63443e225b140d7d37ded952dacea73aaed896bca01ccd745827c6289
  updated_at: '2023-04-21'
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
  expires_at: '2024-04-09'
- name: PyYAML
  version: '6.0'
  updated_at: '2022-05-11'

maven_deps:
- name: commons-io:commons-io
  version: 2.11.0
  updated_at: '2022-04-09'
  expires_at: '2024-04-09'
- name: com.mysql:mysql-connector-j
  version: 8.0.33
  updated_at: '2023-04-21'
- name: org.apache.tomcat.embed:tomcat-embed-core
  version: 10.1.8
  updated_at: '2023-04-21'
- name: org.apache.tomcat.embed:tomcat-embed-jasper
  version: 10.1.8
  updated_at: '2023-04-21'
- name: org.webjars:jquery
  version: 3.6.4
  updated_at: '2023-01-07'
  manual: true
- name: org.webjars:bootstrap
  version: 3.4.1
  version_regex: 3\..*
  updated_at: '2022-04-09'
  # FIXME(https://github.com/BoleynSu/oj/issues/2):
  # Upgrade third-party JavaScript/stylesheet libraries
  expires_at: '2024-04-09'
- name: io.undertow:undertow-core
  version: 2.3.5.Final
  version_regex: (.*)\.Final
  updated_at: '2023-03-31'
- name: commons-validator:commons-validator
  version: '1.7'
  updated_at: '2022-04-15'
  expires_at: '2024-04-15'
- name: commons-codec:commons-codec
  version: '1.15'
  updated_at: '2022-04-15'
  expires_at: '2024-04-15'
- name: org.wildfly.common:wildfly-common
  version: 1.6.0.Final
  version_regex: (.*)\.Final
  updated_at: '2022-05-22'
- name: com.googlecode.owasp-java-html-sanitizer:owasp-java-html-sanitizer
  version: '20220608.1'
  updated_at: '2023-04-01'
- name: org.apache.commons:commons-text
  version: 1.10.0
  updated_at: '2023-04-01'
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
  version: 4.1.87.Final
  included_from: io_grpc_grpc_java
- name: io.netty:netty-codec-http2
  version: 4.1.87.Final
  included_from: io_grpc_grpc_java
- name: io.netty:netty-codec-http
  version: 4.1.87.Final
  included_from: io_grpc_grpc_java
- name: io.netty:netty-codec-socks
  version: 4.1.87.Final
  included_from: io_grpc_grpc_java
- name: io.netty:netty-codec
  version: 4.1.87.Final
  included_from: io_grpc_grpc_java
- name: io.netty:netty-common
  version: 4.1.87.Final
  included_from: io_grpc_grpc_java
- name: io.netty:netty-handler-proxy
  version: 4.1.87.Final
  included_from: io_grpc_grpc_java
- name: io.netty:netty-handler
  version: 4.1.87.Final
  included_from: io_grpc_grpc_java
- name: io.netty:netty-resolver
  version: 4.1.87.Final
  included_from: io_grpc_grpc_java
- name: io.netty:netty-tcnative-boringssl-static
  version: 2.0.56.Final
  included_from: io_grpc_grpc_java
- name: io.netty:netty-transport-native-epoll:jar:linux-x86_64
  version: 4.1.87.Final
  included_from: io_grpc_grpc_java
- name: io.netty:netty-transport
  version: 4.1.87.Final
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
  version: 2.0.56.Final
  included_from: io_grpc_grpc_java
- name: io.netty:netty-transport-native-unix-common
  version: 4.1.87.Final
  included_from: io_grpc_grpc_java

container_deps:
- name: java_debug_image_base
  version: debug
  version_regex: ^(debug)$
  registry: gcr.io
  repository: distroless/java11
  tag: debug
  digest: sha256:a5fca930de95658d35700d1dbd6dc8cb12f2583d29e6a63a8329ab4637c3b01b
  updated_at: '2023-03-31'
- name: java_image_base
  version: latest
  version_regex: ^(latest)$
  registry: gcr.io
  repository: distroless/java11
  tag: latest
  digest: sha256:f88c393a67fff3f9b599eca0e90350ee27e96d3803cbc7742ec23de6a9d6dd7d
  updated_at: '2023-03-31'
- name: py3_debug_image_base
  version: debug
  version_regex: ^(debug)$
  registry: gcr.io
  repository: distroless/python3
  tag: debug
  digest: sha256:0576e591321147c6843969af7493899295633af77bd21f33e3659f26f34f1d64
  updated_at: '2023-03-31'
- name: py3_image_base
  version: latest
  version_regex: ^(latest)$
  registry: gcr.io
  repository: distroless/python3
  tag: latest
  digest: sha256:57dbab565d405ce5ae9c7a8c781c95fa229655cb8381d0e5db4ece28661fa687
  updated_at: '2023-03-31'
- name: go_debug_image_base
  version: debug
  version_regex: ^(debug)$
  registry: gcr.io
  repository: distroless/base
  tag: debug
  digest: sha256:c59a1e5509d1b2586e28b899667774e599b79d7289a6bb893766a0cbbce7384b
  updated_at: '2023-03-31'
- name: go_image_base
  version: latest
  version_regex: ^(latest)$
  registry: gcr.io
  repository: distroless/base
  tag: latest
  digest: sha256:8267a5d9fa15a538227a8850e81cf6c548a78de73458e99a67e8799bbffb1ba0
  updated_at: '2023-03-31'
- name: go_debug_image_static
  version: debug
  version_regex: ^(debug)$
  registry: gcr.io
  repository: distroless/static
  tag: debug
  digest: sha256:850331fb1a5024fcbbbddde0cc7a182ff48723bb135916d7b61a1411b42be677
  updated_at: '2023-03-31'
- name: go_image_static
  version: latest
  version_regex: ^(latest)$
  registry: gcr.io
  repository: distroless/static
  tag: latest
  digest: sha256:8d4cc4a622ce09a75bd7b1eea695008bdbff9e91fea426c2d353ea127dcdc9e3
  updated_at: '2023-03-31'
- name: io_quay_boleynsu_ci_runner
  version: '20230421'
  registry: quay.io
  repository: boleynsu/ci-runner
  tag: '20230421'
  digest: sha256:e60e499c6fd5dd96e516963a0150797eef694aceff3f7eedab4fcd7d7401803f
  updated_at: '2023-04-21'
- name: io_docker_library_mariadb
  version: latest
  # latest is the stable version.
  # See https://mariadb.org/mariadb/all-releases/
  version_regex: ^(latest)$
  registry: docker.io
  repository: library/mariadb
  tag: latest
  digest: sha256:7781ab82c8701e38b7a039ca155beca4574bd36ac19e5f54b99cee9666ac2249
  updated_at: '2023-03-25'
- name: io_docker_library_adminer
  version: 4.8.1
  registry: docker.io
  repository: library/adminer
  tag: 4.8.1
  digest: sha256:6d5d4a863c0f2e05e4a7a4dd5971a49afbe247bea72a6f7a2bf43586907cf541
  updated_at: '2023-04-16'
- name: io_docker_filebrowser_filebrowser
  version: v2.23.0
  registry: docker.io
  repository: filebrowser/filebrowser
  tag: v2.23.0
  digest: sha256:dd9f222c59acea83633f4101597f32620e24aa868ee7a72c40305fbd010887f2
  updated_at: '2022-11-25'
- name: io_quay_boleynsu_oj_c99runner
  version: '20230421'
  registry: quay.io
  repository: boleynsu/oj-c99runner
  tag: '20230421'
  digest: sha256:c70e9b93ea1456851b17b738459f37709a660750b9e3b824cafb2d32fb85793b
  updated_at: '2023-04-21'
- name: io_quay_boleynsu_rbe_fedora
  version: '20230421'
  registry: quay.io
  repository: boleynsu/rbe-fedora
  tag: '20230421'
  digest: sha256:458527857150fb3e59fcaee54d96fa5ba1dd4587575ea6cdcfe51df95b2cc351
  updated_at: '2023-04-21'

go_deps:
- name: k8s.io/kubectl
  version: v0.27.1
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
  updated_at: '2023-04-16'
- name: k8s.io/client-go
  version: v0.27.1
  updated_at: '2023-04-16'
- name: k8s.io/component-base
  version: v0.27.1
  updated_at: '2023-04-16'
- name: github.com/google/go-containerregistry
  version: v0.5.1
  included_from: io_bazel_rules_docker
- name: github.com/pkg/errors
  version: v0.9.1
  included_from: io_bazel_rules_docker
- name: gopkg.in/yaml.v2
  version: v2.2.8
  included_from: io_bazel_rules_docker
- name: github.com/kylelemons/godebug
  version: v1.1.0
  included_from: io_bazel_rules_docker
- name: github.com/ghodss/yaml
  version: v1.0.0
  included_from: io_bazel_rules_docker

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
      "@boleynsu_org//third_party/io_grpc_grpc_java_deps_bzl:deps_bzl",
      "@boleynsu_org//third_party/io_bazel_rules_docker_deps_bzl:deps_bzl"
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
      "sha256": "7436356107f1cf24b45f95909753e521efe2d06622de184ea25e13cb7a0d72f9",
      "url": "https://github.com/bazelbuild/rules_java/archive/refs/tags/5.5.0.tar.gz",
      "strip_prefix": "rules_java-5.5.0",
      "updated_at": "2023-03-25",
      "version": "5.5.0",
      "load_deps": "load(\"@rules_java//java:repositories.bzl\", \"rules_java_dependencies\", \"remote_jdk11_repos\", \"remote_jdk17_repos\", \"remote_jdk19_repos\")\ndef deps():\n  rules_java_dependencies()\n  remote_jdk11_repos()\n",
      "patch_cmds": [
        "sed -i s@remotejdk_17@remote_jdk11@g toolchains/default_java_toolchain.bzl"
      ]
    },
    {
      "name": "rules_python",
      "type": "http_archive",
      "sha256": "94750828b18044533e98a129003b6a68001204038dc4749f40b195b24c38f49f",
      "strip_prefix": "rules_python-0.21.0",
      "url": "https://github.com/bazelbuild/rules_python/archive/refs/tags/0.21.0.tar.gz",
      "updated_at": "2023-04-21",
      "version": "0.21.0",
      "load_deps": "load(\"@rules_python//python:repositories.bzl\", \"python_register_toolchains\")\nload(\"@bazel_deps//:toolchain_deps.bzl\", \"PYTHON_VERSION\")\ndef deps():\n  python_register_toolchains(\n    name = \"python_sdk\",\n    python_version = PYTHON_VERSION,\n    register_toolchains = False,\n  )\n"
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
      "load_deps": "load(\"@rules_proto//proto:repositories.bzl\", \"rules_proto_dependencies\")\ndef deps():\n  rules_proto_dependencies()\n"
    },
    {
      "name": "io_bazel_rules_go",
      "type": "http_archive",
      "sha256": "473a064d502e89d11c497a59f9717d1846e01515a3210bd169f22323161c076e",
      "url": "https://github.com/bazelbuild/rules_go/archive/refs/tags/v0.39.1.tar.gz",
      "updated_at": "2023-04-21",
      "version": "v0.39.1",
      "strip_prefix": "rules_go-0.39.1",
      "load_deps": "load(\"@io_bazel_rules_go//go:deps.bzl\", \"go_download_sdk\", \"go_rules_dependencies\")\nload(\"@bazel_deps//:toolchain_deps.bzl\", \"GOLANG_VERSION\")\ndef deps():\n  go_rules_dependencies()\n  go_download_sdk(\n      name = \"go_linux_amd64\",\n      goos = \"linux\",\n      goarch = \"amd64\",\n      version = GOLANG_VERSION,\n      register_toolchains = False,\n  )\n"
    },
    {
      "name": "io_bazel_rules_docker",
      "type": "http_archive",
      "url": "https://github.com/bazelbuild/rules_docker/archive/refs/tags/v0.25.0.tar.gz",
      "sha256": "07ee8ca536080f5ebab6377fc6e8920e9a761d2ee4e64f0f6d919612f6ab56aa",
      "strip_prefix": "rules_docker-0.25.0",
      "updated_at": "2022-07-01",
      "version": "v0.25.0",
      "load_deps": "load(\"@io_bazel_rules_docker//repositories:repositories.bzl\", \"repositories\")\nload(\"@boleynsu_org//tools/build/repo_rules:exports_files.bzl\", \"exports_files\")\ndef deps():\n  exports_files(\n    name = \"io_bazel_rules_docker_deps_bzl_files\",\n    files= {\n      \"repositories/go_repositories.bzl\": \"@io_bazel_rules_docker//repositories:go_repositories.bzl\"\n    },\n  )\n  repositories()\n"
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
      "version": "v0.7"
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
      "sha256": "c9ae901381ae7f7eca08aed96caeb542f96c5449052db9c9d27274a8dc154cdf",
      "strip_prefix": "rules_jvm_external-5.2",
      "url": "https://github.com/bazelbuild/rules_jvm_external/archive/refs/tags/5.2.tar.gz",
      "updated_at": "2023-04-16",
      "version": "5.2"
    },
    {
      "name": "rules_pkg",
      "type": "http_archive",
      "url": "https://github.com/bazelbuild/rules_pkg/archive/refs/tags/0.9.0.tar.gz",
      "sha256": "a36867d8d9c40bf713e85ac89b9b9e4d5da16a903302d2afb39d7a1e956b75df",
      "updated_at": "2023-03-31",
      "version": "0.9.0",
      "strip_prefix": "rules_pkg-0.9.0",
      "load_deps": "load(\"@rules_pkg//:deps.bzl\", \"rules_pkg_dependencies\")\ndef deps():\n  rules_pkg_dependencies()\n"
    },
    {
      "name": "io_grpc_grpc_java",
      "type": "http_archive",
      "sha256": "98c32df8a878cbca5a6799922d28e9df93a4d5607316e0e3f8269a5886d9e429",
      "strip_prefix": "grpc-java-1.54.1",
      "url": "https://github.com/grpc/grpc-java/archive/refs/tags/v1.54.1.tar.gz",
      "updated_at": "2023-04-21",
      "version": "v1.54.1",
      "load_deps": "load(\"@io_grpc_grpc_java//:repositories.bzl\", \"grpc_java_repositories\")\ndef deps():\n  grpc_java_repositories()\n"
    },
    {
      "name": "bazel_gazelle",
      "type": "http_archive",
      "sha256": "c012845ad21bb8053b5f0e92868a095caf9afa1eea9372c5bb46df068d7051f2",
      "url": "https://github.com/bazelbuild/bazel-gazelle/archive/refs/tags/v0.30.0.tar.gz",
      "updated_at": "2023-03-31",
      "version": "v0.30.0",
      "strip_prefix": "bazel-gazelle-0.30.0",
      "patch_cmds": [
        "sed -i 's#go_repository = _go_repository#go_repository = _go_repository\\ndef fake_go_repository(**kwargs): pass#g' deps.bzl",
        "sed -i 's# go_repository,# fake_go_repository,#g' deps.bzl"
      ],
      "load_deps": "load(\"@bazel_gazelle//:deps.bzl\", \"gazelle_dependencies\")\ndef deps():\n  gazelle_dependencies()\n"
    },
    {
      "name": "io_k8s_kubernetes",
      "type": "http_archive",
      "url": "https://github.com/kubernetes/kubernetes/archive/refs/tags/v1.27.1.tar.gz",
      "sha256": "3a3f7c6b8cf1d9f03aa67ba2f04669772b1205b89826859f1636062d5f8bec3f",
      "strip_prefix": "kubernetes-1.27.1",
      "updated_at": "2023-04-16",
      "version": "v1.27.1",
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
      "url": "https://github.com/llvm/llvm-project/archive/refs/tags/llvmorg-16.0.2.tar.gz",
      "sha256": "97c3c6aafb53c4bb0ed2781a18d6f05e75445e24bb1dc57a32b74f8d710ac19f",
      "strip_prefix": "llvm-project-llvmorg-16.0.2",
      "version": "llvmorg-16.0.2",
      "version_regex": "llvmorg-(.*)",
      "updated_at": "2023-04-21"
    },
    {
      "name": "llvm_linux_x86_64",
      "type": "http_archive",
      "url": "https://github.com/llvm/llvm-project/releases/download/llvmorg-16.0.2/clang+llvm-16.0.2-x86_64-linux-gnu-ubuntu-22.04.tar.xz",
      "sha256": "9530eccdffedb9761f23cbd915cf95d861b1d95f340ea36ded68bd6312af912e",
      "strip_prefix": "clang+llvm-16.0.2-x86_64-linux-gnu-ubuntu-22.04",
      "version": "llvmorg-16.0.2",
      "version_regex": "llvmorg-(.*)",
      "updated_at": "2023-04-21",
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
      ],
      "load_deps": "load(\"@com_grail_bazel_toolchain//toolchain:rules.bzl\", \"llvm_toolchain\")\nload(\"@bazel_deps//:bazel_deps.bzl\", \"BAZEL_DEPS\")\ndef deps():\n  llvm_toolchain(\n      name = \"llvm_toolchain_linux_x86_64\",\n      llvm_version = BAZEL_DEPS[\"llvm_linux_x86_64\"][\"version\"][len(\"llvmorg-\"):],\n      exec_os = \"linux\",\n      exec_cpu = \"x86_64\",\n      urls = {\n          \"linux_x86_64\": [BAZEL_DEPS[\"llvm_linux_x86_64\"][\"url\"]],\n      },\n      strip_prefix = {\n          \"linux_x86_64\": BAZEL_DEPS[\"llvm_linux_x86_64\"][\"strip_prefix\"],\n      },\n      sha256 = {\n          \"linux_x86_64\": BAZEL_DEPS[\"llvm_linux_x86_64\"][\"sha256\"],\n      },\n  )\n"
    },
    {
      "name": "io_bazel",
      "type": "http_archive",
      "version": "6.1.2",
      "url": "https://github.com/bazelbuild/bazel/archive/refs/tags/6.1.2.tar.gz",
      "sha256": "7067251d3029b12fe8d501266279f8b5a7c4c4f8d75ef3a0e0653f20bc7a1322",
      "updated_at": "2023-04-21",
      "load_deps": "load(\"@bazel_deps//:bazel_deps.bzl\", \"BAZEL_DEPS\")\ndef deps():\n  if BAZEL_DEPS[\"io_bazel\"][\"version\"] != native.bazel_version:\n    print(\"You are using an unsupported version of Bazel\")\n",
      "strip_prefix": "bazel-6.1.2"
    },
    {
      "name": "bazel_linux_x86_64",
      "type": "http_file",
      "version": "6.1.2",
      "url": "https://github.com/bazelbuild/bazel/releases/download/6.1.2/bazel-6.1.2-linux-x86_64",
      "sha256": "e89747d63443e225b140d7d37ded952dacea73aaed896bca01ccd745827c6289",
      "updated_at": "2023-04-21",
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
      "updated_at": "2022-04-09",
      "expires_at": "2024-04-09"
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
      "updated_at": "2022-04-09",
      "expires_at": "2024-04-09"
    },
    {
      "name": "com.mysql:mysql-connector-j",
      "version": "8.0.33",
      "updated_at": "2023-04-21"
    },
    {
      "name": "org.apache.tomcat.embed:tomcat-embed-core",
      "version": "10.1.8",
      "updated_at": "2023-04-21"
    },
    {
      "name": "org.apache.tomcat.embed:tomcat-embed-jasper",
      "version": "10.1.8",
      "updated_at": "2023-04-21"
    },
    {
      "name": "org.webjars:jquery",
      "version": "3.6.4",
      "updated_at": "2023-01-07",
      "manual": true
    },
    {
      "name": "org.webjars:bootstrap",
      "version": "3.4.1",
      "version_regex": "3\\..*",
      "updated_at": "2022-04-09",
      "expires_at": "2024-04-09"
    },
    {
      "name": "io.undertow:undertow-core",
      "version": "2.3.5.Final",
      "version_regex": "(.*)\\.Final",
      "updated_at": "2023-03-31"
    },
    {
      "name": "commons-validator:commons-validator",
      "version": "1.7",
      "updated_at": "2022-04-15",
      "expires_at": "2024-04-15"
    },
    {
      "name": "commons-codec:commons-codec",
      "version": "1.15",
      "updated_at": "2022-04-15",
      "expires_at": "2024-04-15"
    },
    {
      "name": "org.wildfly.common:wildfly-common",
      "version": "1.6.0.Final",
      "version_regex": "(.*)\\.Final",
      "updated_at": "2022-05-22"
    },
    {
      "name": "com.googlecode.owasp-java-html-sanitizer:owasp-java-html-sanitizer",
      "version": "20220608.1",
      "updated_at": "2023-04-01"
    },
    {
      "name": "org.apache.commons:commons-text",
      "version": "1.10.0",
      "updated_at": "2023-04-01"
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
      "version": "4.1.87.Final",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.netty:netty-codec-http2",
      "version": "4.1.87.Final",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.netty:netty-codec-http",
      "version": "4.1.87.Final",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.netty:netty-codec-socks",
      "version": "4.1.87.Final",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.netty:netty-codec",
      "version": "4.1.87.Final",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.netty:netty-common",
      "version": "4.1.87.Final",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.netty:netty-handler-proxy",
      "version": "4.1.87.Final",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.netty:netty-handler",
      "version": "4.1.87.Final",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.netty:netty-resolver",
      "version": "4.1.87.Final",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.netty:netty-tcnative-boringssl-static",
      "version": "2.0.56.Final",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.netty:netty-transport-native-epoll:jar:linux-x86_64",
      "version": "4.1.87.Final",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.netty:netty-transport",
      "version": "4.1.87.Final",
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
      "version": "2.0.56.Final",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.netty:netty-transport-native-unix-common",
      "version": "4.1.87.Final",
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
      "digest": "sha256:a5fca930de95658d35700d1dbd6dc8cb12f2583d29e6a63a8329ab4637c3b01b",
      "updated_at": "2023-03-31"
    },
    {
      "name": "java_image_base",
      "version": "latest",
      "version_regex": "^(latest)$",
      "registry": "gcr.io",
      "repository": "distroless/java11",
      "tag": "latest",
      "digest": "sha256:f88c393a67fff3f9b599eca0e90350ee27e96d3803cbc7742ec23de6a9d6dd7d",
      "updated_at": "2023-03-31"
    },
    {
      "name": "py3_debug_image_base",
      "version": "debug",
      "version_regex": "^(debug)$",
      "registry": "gcr.io",
      "repository": "distroless/python3",
      "tag": "debug",
      "digest": "sha256:0576e591321147c6843969af7493899295633af77bd21f33e3659f26f34f1d64",
      "updated_at": "2023-03-31"
    },
    {
      "name": "py3_image_base",
      "version": "latest",
      "version_regex": "^(latest)$",
      "registry": "gcr.io",
      "repository": "distroless/python3",
      "tag": "latest",
      "digest": "sha256:57dbab565d405ce5ae9c7a8c781c95fa229655cb8381d0e5db4ece28661fa687",
      "updated_at": "2023-03-31"
    },
    {
      "name": "go_debug_image_base",
      "version": "debug",
      "version_regex": "^(debug)$",
      "registry": "gcr.io",
      "repository": "distroless/base",
      "tag": "debug",
      "digest": "sha256:c59a1e5509d1b2586e28b899667774e599b79d7289a6bb893766a0cbbce7384b",
      "updated_at": "2023-03-31"
    },
    {
      "name": "go_image_base",
      "version": "latest",
      "version_regex": "^(latest)$",
      "registry": "gcr.io",
      "repository": "distroless/base",
      "tag": "latest",
      "digest": "sha256:8267a5d9fa15a538227a8850e81cf6c548a78de73458e99a67e8799bbffb1ba0",
      "updated_at": "2023-03-31"
    },
    {
      "name": "go_debug_image_static",
      "version": "debug",
      "version_regex": "^(debug)$",
      "registry": "gcr.io",
      "repository": "distroless/static",
      "tag": "debug",
      "digest": "sha256:850331fb1a5024fcbbbddde0cc7a182ff48723bb135916d7b61a1411b42be677",
      "updated_at": "2023-03-31"
    },
    {
      "name": "go_image_static",
      "version": "latest",
      "version_regex": "^(latest)$",
      "registry": "gcr.io",
      "repository": "distroless/static",
      "tag": "latest",
      "digest": "sha256:8d4cc4a622ce09a75bd7b1eea695008bdbff9e91fea426c2d353ea127dcdc9e3",
      "updated_at": "2023-03-31"
    },
    {
      "name": "io_quay_boleynsu_ci_runner",
      "version": "20230421",
      "registry": "quay.io",
      "repository": "boleynsu/ci-runner",
      "tag": "20230421",
      "digest": "sha256:e60e499c6fd5dd96e516963a0150797eef694aceff3f7eedab4fcd7d7401803f",
      "updated_at": "2023-04-21"
    },
    {
      "name": "io_docker_library_mariadb",
      "version": "latest",
      "version_regex": "^(latest)$",
      "registry": "docker.io",
      "repository": "library/mariadb",
      "tag": "latest",
      "digest": "sha256:7781ab82c8701e38b7a039ca155beca4574bd36ac19e5f54b99cee9666ac2249",
      "updated_at": "2023-03-25"
    },
    {
      "name": "io_docker_library_adminer",
      "version": "4.8.1",
      "registry": "docker.io",
      "repository": "library/adminer",
      "tag": "4.8.1",
      "digest": "sha256:6d5d4a863c0f2e05e4a7a4dd5971a49afbe247bea72a6f7a2bf43586907cf541",
      "updated_at": "2023-04-16"
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
      "version": "20230421",
      "registry": "quay.io",
      "repository": "boleynsu/oj-c99runner",
      "tag": "20230421",
      "digest": "sha256:c70e9b93ea1456851b17b738459f37709a660750b9e3b824cafb2d32fb85793b",
      "updated_at": "2023-04-21"
    },
    {
      "name": "io_quay_boleynsu_rbe_fedora",
      "version": "20230421",
      "registry": "quay.io",
      "repository": "boleynsu/rbe-fedora",
      "tag": "20230421",
      "digest": "sha256:458527857150fb3e59fcaee54d96fa5ba1dd4587575ea6cdcfe51df95b2cc351",
      "updated_at": "2023-04-21"
    }
  ],
  "go_deps": [
    {
      "name": "k8s.io/kubectl",
      "version": "v0.27.1",
      "patch_cmds": [
        "rm pkg/explain/v2/templates/BUILD.bazel\ncat <<EOF >pkg/explain/v2/BUILD.bazel\nload(\"@io_bazel_rules_go//go:def.bzl\", \"go_library\")\n\ngo_library(\n    name = \"explain\",\n    srcs = [\n        \"explain.go\",\n        \"funcs.go\",\n        \"generator.go\",\n        \"template.go\",\n    ],\n    embedsrcs = glob([\n        \"templates/*.tmpl\"\n    ]),\n    importpath = \"k8s.io/kubectl/pkg/explain/v2\",\n    importpath_aliases = [\"k8s.io/kubectl/pkg/explain\"],\n    visibility = [\"//visibility:public\"],\n    deps = [\n        \"//pkg/util/term\",\n        \"@com_github_go_openapi_jsonreference//:jsonreference\",\n        \"@io_k8s_apimachinery//pkg/runtime\",\n        \"@io_k8s_apimachinery//pkg/runtime/schema\",\n        \"@io_k8s_client_go//openapi\",\n    ],\n)\nEOF\n"
      ],
      "updated_at": "2023-04-16"
    },
    {
      "name": "k8s.io/client-go",
      "version": "v0.27.1",
      "updated_at": "2023-04-16"
    },
    {
      "name": "k8s.io/component-base",
      "version": "v0.27.1",
      "updated_at": "2023-04-16"
    },
    {
      "name": "github.com/google/go-containerregistry",
      "version": "v0.5.1",
      "included_from": "io_bazel_rules_docker"
    },
    {
      "name": "github.com/pkg/errors",
      "version": "v0.9.1",
      "included_from": "io_bazel_rules_docker"
    },
    {
      "name": "gopkg.in/yaml.v2",
      "version": "v2.2.8",
      "included_from": "io_bazel_rules_docker"
    },
    {
      "name": "github.com/kylelemons/godebug",
      "version": "v1.1.0",
      "included_from": "io_bazel_rules_docker"
    },
    {
      "name": "github.com/ghodss/yaml",
      "version": "v1.0.0",
      "included_from": "io_bazel_rules_docker"
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
""") if hash(_DEPS_YAML) != 1812095245 or hash(_DEPS_JSON) != -182032263 else None]

DEPS = json.decode(_DEPS_JSON)
