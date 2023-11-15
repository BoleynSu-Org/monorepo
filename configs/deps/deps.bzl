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
  url: https://github.com/bazelbuild/rules_cc/archive/refs/tags/0.0.9.tar.gz
  sha256: 2037875b9a4456dce4a79d112a8ae885bbc4aad968e6587dca6e64f3a0900cdf
  version: 0.0.9
  strip_prefix: rules_cc-0.0.9
  updated_at: '2023-09-22'
- name: rules_java
  type: http_archive
  sha256: f6068480cee4454755e2f422702722f31ef37b3628aa0ba9811fffc407b1b315
  url: https://github.com/bazelbuild/rules_java/archive/refs/tags/7.1.0.tar.gz
  strip_prefix: rules_java-7.1.0
  updated_at: '2023-11-09'
  version: 7.1.0
  load_deps: |
    load("@rules_java//java:repositories.bzl", "java_tools_repos", "remote_jdk21_repos")
    def deps():
      java_tools_repos()
      remote_jdk21_repos()
- name: rules_python
  type: http_archive
  sha256: 9d04041ac92a0985e344235f5d946f71ac543f1b1565f2cdbc9a2aaee8adf55b
  strip_prefix: rules_python-0.26.0
  url: https://github.com/bazelbuild/rules_python/archive/refs/tags/0.26.0.tar.gz
  updated_at: '2023-10-19'
  version: 0.26.0
  load_deps: |
    load("@rules_python//python:repositories.bzl", "python_register_toolchains")
    load("@rules_python//python/private:toolchains_repo.bzl", "toolchains_repo")
    load("@rules_python//python/private:internal_config_repo.bzl", "internal_config_repo")
    load("@bazel_deps//:toolchain_deps.bzl", "PYTHON_VERSION")
    def deps():
      internal_config_repo(name = "rules_python_internal")
      python_register_toolchains(
        name = "python_sdk",
        python_version = PYTHON_VERSION,
        register_toolchains = False,
      )
      toolchains_repo(
          name = "python_sdk_toolchains",
          python_version = PYTHON_VERSION,
          set_python_version_constraint = False,
          user_repository_name = "python_sdk",
      )
- name: rules_proto
  type: http_archive
  sha256: dc3fb206a2cb3441b485eb1e423165b231235a1ea9b031b4433cf7bc1fa460dd
  strip_prefix: rules_proto-5.3.0-21.7
  url: https://github.com/bazelbuild/rules_proto/archive/refs/tags/5.3.0-21.7.tar.gz
  updated_at: '2023-10-18'
  version: 5.3.0-21.7
  version_regex: ([^-]*)[0-9.-]*$
  load_deps: |
    load("@rules_proto//proto:repositories.bzl", "rules_proto_dependencies")
    def deps():
      rules_proto_dependencies()
- name: io_bazel_rules_go
  type: http_archive
  sha256: 9cf66773949710d831f84ed02b30af969af468e4325e6ab89dcb3b2238b734ad
  url: https://github.com/bazelbuild/rules_go/archive/refs/tags/v0.42.0.tar.gz
  updated_at: '2023-09-30'
  version: v0.42.0
  strip_prefix: rules_go-0.42.0
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
  expires_at: '2024-07-01'
  version: v0.25.0
  patches:
  - '@boleynsu_org//third_party:io_bazel_rules_docker.patch'
  patch_cmds:
  - sed -i '/native.register_toolchains/Q' repositories/repositories.bzl
  load_deps: |
    load("@io_bazel_rules_docker//repositories:repositories.bzl", "repositories")
    def deps():
      repositories()
- name: io_bazel_rules_k8s
  type: http_archive
  url: https://github.com/bazelbuild/rules_k8s/archive/refs/tags/v0.7.tar.gz
  sha256: ce5b9bc0926681e2e7f2147b49096f143e6cbc783e71bc1d4f36ca76b00e6f4a
  strip_prefix: rules_k8s-0.7
  updated_at: '2022-06-18'
  expires_at: '2024-06-18'
  version: v0.7
  patch_cmds:
  - sed -i 's/kubectl create --dry-run/%{kubectl_tool} create --dry-run=client --kubeconfig="%{kubeconfig}" --cluster="%{cluster}" --context="%{context}" --user="%{user}"/g' k8s/describe.sh.tpl
  - sed -i "s/| cut -d'\"' -f 2//g" k8s/describe.sh.tpl
  - sed -i 's/"${RESOURCE_NAME}"/${RESOURCE_NAME}/g' k8s/describe.sh.tpl
  - sed -i 's#@com_github_yaml_pyyaml//:yaml3#@pip_pyyaml//:pkg#g' k8s/BUILD
- name: bazel_skylib
  type: http_archive
  url: https://github.com/bazelbuild/bazel-skylib/archive/refs/tags/1.5.0.tar.gz
  sha256: 118e313990135890ee4cc8504e32929844f9578804a1b2f571d69b1dd080cfb8
  updated_at: '2023-11-06'
  version: 1.5.0
  strip_prefix: bazel-skylib-1.5.0
- name: rules_jvm_external
  type: http_archive
  sha256: 8ac1c5c2a8681c398883bb2cabc18f913337f165059f24e8c55714e05757761e
  strip_prefix: rules_jvm_external-5.3
  url: https://github.com/bazelbuild/rules_jvm_external/archive/refs/tags/5.3.tar.gz
  updated_at: '2023-06-24'
  version: '5.3'
- name: rules_pkg
  type: http_archive
  url: https://github.com/bazelbuild/rules_pkg/archive/refs/tags/0.9.1.tar.gz
  sha256: 360c23a88ceaf7f051abc99e2e6048cf7fe5d9af792690576554a88b2013612d
  updated_at: '2023-05-04'
  version: 0.9.1
  strip_prefix: rules_pkg-0.9.1
- name: io_grpc_grpc_java
  type: http_archive
  sha256: 3bcf6be49fc7ab8187577a5211421258cb8e6d179f46023cc82e42e3a6188e51
  strip_prefix: grpc-java-1.59.0
  url: https://github.com/grpc/grpc-java/archive/refs/tags/v1.59.0.tar.gz
  updated_at: '2023-10-21'
  version: v1.59.0
  load_deps: |
    load("@io_grpc_grpc_java//:repositories.bzl", "grpc_java_repositories")
    def deps():
      grpc_java_repositories()
- name: bazel_gazelle
  type: http_archive
  sha256: 775202071b874bbdefeea0c775856b5fb0409ceb193d25b11c4c543cff5674a3
  url: https://github.com/bazelbuild/bazel-gazelle/archive/refs/tags/v0.34.0.tar.gz
  updated_at: '2023-11-09'
  version: v0.34.0
  strip_prefix: bazel-gazelle-0.34.0
  # FIXME(https://github.com/bazelbuild/bazel-gazelle/issues/1305):
  # The current implementation forces users to declare go_repository before gazelle_dependencies to avoid being overridden.
  patch_cmds:
  - "sed -i 's#go_repository = _go_repository#go_repository = _go_repository\\ndef fake_go_repository(**kwargs): pass#g' deps.bzl"
  - sed -i 's# go_repository,# fake_go_repository,#g' deps.bzl
  load_deps: |
    load("@bazel_gazelle//:deps.bzl", "gazelle_dependencies")
    def deps():
      gazelle_dependencies()
- name: com_github_cdolivet_editarea
  type: http_archive
  url: https://github.com/cdolivet/EditArea/archive/refs/tags/v0.8.2.tar.gz
  sha256: 47b58cf925b76252156da52187329d2cfede4f0f6f83416dcd9f0753592cb1f0
  strip_prefix: EditArea-0.8.2
  updated_at: '2022-07-24'
  expires_at: '2024-07-24'
  version: v0.8.2
  build_file: '@boleynsu_org//third_party:com_github_cdolivet_editarea.BUILD'
- name: llvm_linux_x86_64
  type: http_archive
  url: https://github.com/llvm/llvm-project/releases/download/llvmorg-17.0.5/clang+llvm-17.0.5-x86_64-linux-gnu-ubuntu-22.04.tar.xz
  sha256: 5a3cedecd8e2e8663e84bec2f8e5522b8ea097f4a8b32637386f27ac1ca01818
  strip_prefix: clang+llvm-17.0.5-x86_64-linux-gnu-ubuntu-22.04
  version: llvmorg-17.0.5
  version_regex: llvmorg-(.*)
  updated_at: '2023-11-14'
  override_updater:
  - type: deps_updater
    name: bazel_deps
    extra_args:
    - name: fields
      value: [version]
  - type: shell
    cmd: |
      name=$(curl --netrc-optional -sL https://api.github.com/repos/llvm/llvm-project/releases | jq -r '.[] | select(.tag_name == "'${DEPS_UPDATER_version}'") | .assets[] | select(.name | test("x86_64-linux-gnu-ubuntu.*tar.xz$")) | .name')
      echo DEPS_UPDATER_url=https://github.com/llvm/llvm-project/releases/download/${DEPS_UPDATER_version}/${name}
      echo DEPS_UPDATER_strip_prefix=${name%.tar.xz}
  - type: deps_updater
    name: bazel_deps
    extra_args:
    - name: fields
      value: [sha256]
- name: com_grail_bazel_toolchain
  type: http_archive
  url: https://github.com/grailbio/bazel-toolchain/archive/refs/tags/0.10.3.tar.gz
  sha256: c2a58fdd8420cca3645843b1be7b18a2d5df388d192d50c238ae3edd9b693011
  strip_prefix: bazel-toolchain-0.10.3
  updated_at: '2023-09-22'
  version: 0.10.3
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
              "linux-x86_64": [BAZEL_DEPS["llvm_linux_x86_64"]["url"]],
          },
          strip_prefix = {
              "linux-x86_64": BAZEL_DEPS["llvm_linux_x86_64"]["strip_prefix"],
          },
          sha256 = {
              "linux-x86_64": BAZEL_DEPS["llvm_linux_x86_64"]["sha256"],
          },
      )
- name: bazel_linux_x86_64
  type: http_archive
  version: 6.4.0
  url: https://github.com/bazelbuild/bazel/releases/download/6.4.0/bazel-6.4.0-installer-linux-x86_64.sh
  http_archive_type: zip
  sha256: 4a52769e0bcc783d8dd038ca71a50153a425555993918291a8ce576d121b3671
  updated_at: '2023-10-20'
  executable: true
  override_updater:
  - type: deps_updater
    name: bazel_deps
    extra_args:
    - name: fields
      value: [version]
  - type: shell
    cmd: echo DEPS_UPDATER_url=https://github.com/bazelbuild/bazel/releases/download/${DEPS_UPDATER_version}/bazel-${DEPS_UPDATER_version}-installer-linux-x86_64.sh
  - type: deps_updater
    name: bazel_deps
    extra_args:
    - name: fields
      value: [sha256]
  build_file_content: exports_files(glob(["**"]))
  load_deps: |
    load("@bazel_deps//:bazel_deps.bzl", "BAZEL_DEPS")
    def deps():
      if BAZEL_DEPS["bazel_linux_x86_64"]["version"] != native.bazel_version:
        print("You are using an unsupported version of Bazel")
- name: rules_license
  type: http_archive
  sha256: 7626bea5473d3b11d44269c5b510a210f11a78bca1ed639b0f846af955b0fe31
  strip_prefix: rules_license-0.0.7
  url: https://github.com/bazelbuild/rules_license/archive/refs/tags/0.0.7.tar.gz
  updated_at: '2023-09-16'
  version: 0.0.7
- name: platforms
  type: http_archive
  sha256: 58ca5559d562def65cf1aeae9cd994d2776f7273eab9f48779ad043c3ffb3ce3
  strip_prefix: platforms-0.0.8
  url: https://github.com/bazelbuild/platforms/archive/refs/tags/0.0.8.tar.gz
  updated_at: '2023-10-19'
  version: 0.0.8
- name: kubectl_linux_amd64
  type: http_file
  url: https://dl.k8s.io/release/v1.28.3/bin/linux/amd64/kubectl
  sha256: 0c680c90892c43e5ce708e918821f92445d1d244f9b3d7513023bcae9a6246d1
  version: v1.28.3
  updated_at: '2023-10-19'
  executable: true
  override_updater:
  - type: shell
    cmd: |
      version=$(curl -sL https://dl.k8s.io/release/stable.txt)
      echo DEPS_UPDATER_version=${version}
      echo DEPS_UPDATER_url=https://dl.k8s.io/release/${version}/bin/linux/amd64/kubectl
  - type: deps_updater
    name: bazel_deps
    extra_args:
    - name: fields
      value: [sha256]

pip_deps:
- name: ruamel.yaml
  version: 0.18.5
  updated_at: '2023-11-03'
- name: PyYAML
  version: 6.0.1
  updated_at: '2023-07-22'

maven_deps:
- name: commons-io:commons-io
  version: 2.15.0
  updated_at: '2023-10-25'
- name: org.mariadb.jdbc:mariadb-java-client
  version: 3.3.0
  updated_at: '2023-11-09'
- name: org.apache.tomcat.embed:tomcat-embed-core
  version: 10.1.16
  updated_at: '2023-11-14'
- name: org.apache.tomcat.embed:tomcat-embed-jasper
  version: 10.1.16
  updated_at: '2023-11-14'
- name: org.webjars:jquery
  version: 3.7.1
  updated_at: '2023-09-02'
- name: org.webjars:bootstrap
  version: 3.4.1
  version_regex: 3\..*
  updated_at: '2022-04-09'
  # FIXME(https://github.com/BoleynSu/oj/issues/2):
  # Upgrade third-party JavaScript/stylesheet libraries
  expires_at: '2024-04-09'
- name: io.undertow:undertow-core
  version: 2.3.10.Final
  version_regex: (.*)\.Final
  updated_at: '2023-10-18'
- name: commons-validator:commons-validator
  version: '1.7'
  updated_at: '2022-04-15'
  expires_at: '2024-04-15'
- name: commons-codec:commons-codec
  version: 1.16.0
  updated_at: '2023-06-22'
- name: org.wildfly.common:wildfly-common
  version: 1.7.0.Final
  version_regex: (.*)\.Final
  updated_at: '2023-11-03'
- name: com.googlecode.owasp-java-html-sanitizer:owasp-java-html-sanitizer
  version: '20220608.1'
  updated_at: '2023-04-01'
- name: org.apache.commons:commons-text
  version: 1.11.0
  updated_at: '2023-10-29'
- name: com.google.android:annotations
  version: 4.1.1.4
  included_from: io_grpc_grpc_java
- name: com.google.api.grpc:proto-google-common-protos
  version: 2.22.0
  included_from: io_grpc_grpc_java
- name: com.google.auth:google-auth-library-credentials
  version: 1.4.0
  included_from: io_grpc_grpc_java
- name: com.google.auth:google-auth-library-oauth2-http
  version: 1.4.0
  included_from: io_grpc_grpc_java
- name: com.google.code.findbugs:jsr305
  version: 3.0.2
  included_from: io_grpc_grpc_java
- name: com.google.auto.value:auto-value
  version: 1.10.2
  included_from: io_grpc_grpc_java
- name: com.google.auto.value:auto-value-annotations
  version: 1.10.2
  included_from: io_grpc_grpc_java
- name: com.google.errorprone:error_prone_annotations
  version: 2.20.0
  included_from: io_grpc_grpc_java
- name: com.google.guava:failureaccess
  version: 1.0.1
  included_from: io_grpc_grpc_java
- name: com.google.guava:guava
  version: 32.0.1-android
  included_from: io_grpc_grpc_java
- name: com.google.truth:truth
  version: 1.1.5
  included_from: io_grpc_grpc_java
- name: com.squareup.okhttp:okhttp
  version: 2.7.5
  included_from: io_grpc_grpc_java
- name: com.squareup.okio:okio
  version: 2.10.0
  included_from: io_grpc_grpc_java
- name: io.netty:netty-buffer
  version: 4.1.97.Final
  included_from: io_grpc_grpc_java
- name: io.netty:netty-codec-http2
  version: 4.1.97.Final
  included_from: io_grpc_grpc_java
- name: io.netty:netty-codec-http
  version: 4.1.97.Final
  included_from: io_grpc_grpc_java
- name: io.netty:netty-codec-socks
  version: 4.1.97.Final
  included_from: io_grpc_grpc_java
- name: io.netty:netty-codec
  version: 4.1.97.Final
  included_from: io_grpc_grpc_java
- name: io.netty:netty-common
  version: 4.1.97.Final
  included_from: io_grpc_grpc_java
- name: io.netty:netty-handler-proxy
  version: 4.1.97.Final
  included_from: io_grpc_grpc_java
- name: io.netty:netty-handler
  version: 4.1.97.Final
  included_from: io_grpc_grpc_java
- name: io.netty:netty-resolver
  version: 4.1.97.Final
  included_from: io_grpc_grpc_java
- name: io.netty:netty-tcnative-boringssl-static
  version: 2.0.61.Final
  included_from: io_grpc_grpc_java
- name: io.netty:netty-transport-native-epoll:jar:linux-x86_64
  version: 4.1.97.Final
  included_from: io_grpc_grpc_java
- name: io.netty:netty-transport
  version: 4.1.97.Final
  included_from: io_grpc_grpc_java
- name: io.opencensus:opencensus-api
  version: 0.31.0
  included_from: io_grpc_grpc_java
- name: io.opencensus:opencensus-contrib-grpc-metrics
  version: 0.31.0
  included_from: io_grpc_grpc_java
- name: io.perfmark:perfmark-api
  version: 0.26.0
  included_from: io_grpc_grpc_java
- name: junit:junit
  version: 4.13.2
  included_from: io_grpc_grpc_java
- name: org.apache.tomcat:annotations-api
  version: 6.0.53
  included_from: io_grpc_grpc_java
- name: org.codehaus.mojo:animal-sniffer-annotations
  version: '1.23'
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
  override_target: '@com_google_protobuf_javalite//:protobuf_javalite'
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
  version: 2.10.1
  included_from: io_grpc_grpc_java
- name: com.google.re2j:re2j
  version: '1.7'
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
  version: 2.0.61.Final
  included_from: io_grpc_grpc_java
- name: io.netty:netty-transport-native-unix-common
  version: 4.1.97.Final
  included_from: io_grpc_grpc_java
- name: io.grpc:grpc-inprocess
  version: override
  override_target: '@io_grpc_grpc_java//inprocess'
  included_from: io_grpc_grpc_java
- name: io.grpc:grpc-util
  version: override
  override_target: '@io_grpc_grpc_java//util'
  included_from: io_grpc_grpc_java

container_deps:
- name: java_debug_image_base
  version: debug
  version_regex: ^(debug)$
  registry: gcr.io
  repository: distroless/java21
  tag: debug
  digest: sha256:a2400aaf8c6447a4ebb171900a8a92dad752475492b7af0e311520d1c45b3a96
  updated_at: '2023-11-15'
- name: java_image_base
  version: latest
  version_regex: ^(latest)$
  registry: gcr.io
  repository: distroless/java21
  tag: latest
  digest: sha256:f0c6d6a656ec9516fe75f6aa7a69015d00b593ce2c3d75142175ac2b7391f160
  updated_at: '2023-11-15'
- name: io_quay_boleynsu_ci_runner
  version: '20231110.162612'
  registry: quay.io
  repository: boleynsu/ci-runner
  tag: '20231110.162612'
  digest: sha256:ff0cd830ff953078fbcbbd4e65a2ce523b372cc917fff3cd0a405e92fbe3141c
  updated_at: '2023-11-10'
- name: io_docker_library_mariadb
  version: latest
  # latest is the stable version.
  # See https://mariadb.org/mariadb/all-releases/
  version_regex: ^(latest)$
  registry: docker.io
  repository: library/mariadb
  tag: latest
  digest: sha256:e51c275914b2da5e8e8e0ed9eaecf1e4d5142b5e570f231224320001cf5c86cf
  updated_at: '2023-10-13'
- name: io_docker_library_adminer
  version: 4.8.1
  registry: docker.io
  repository: library/adminer
  tag: 4.8.1
  digest: sha256:b96876e1c6d4eda21b2653d54bb8c9d4674fc177749254c5a44d097f92e2362e
  updated_at: '2023-11-01'
- name: io_docker_filebrowser_filebrowser
  version: v2.26.0
  registry: docker.io
  repository: filebrowser/filebrowser
  tag: v2.26.0
  digest: sha256:0e0a4b700302457772b07c4efc47bc90143d7538d36731baabcf7d375360bcee
  updated_at: '2023-11-03'
- name: io_quay_boleynsu_oj_c99runner
  version: '20231110.162612'
  registry: quay.io
  repository: boleynsu/oj-c99runner
  tag: '20231110.162612'
  digest: sha256:7480f92078d562c901cdc8d573d9a56eeed7cc55456e9510fd2d1e7de9bfe236
  updated_at: '2023-11-10'
- name: io_quay_boleynsu_rbe_fedora
  version: '20231110.162612'
  registry: quay.io
  repository: boleynsu/rbe-fedora
  tag: '20231110.162612'
  digest: sha256:d267b0bae3c7adc13e64816f631720eca8d242d3380fad26b480ca0a6ac91613
  updated_at: '2023-11-10'

go_deps:
- name: github.com/google/go-containerregistry
  version: v0.16.1
  updated_at: '2023-09-17'
- name: github.com/pkg/errors
  version: v0.9.1
  updated_at: '2023-09-17'
- name: gopkg.in/yaml.v2
  version: v2.4.0
  updated_at: '2023-09-17'
- name: github.com/kylelemons/godebug
  version: v1.1.0
  updated_at: '2023-09-17'
- name: github.com/ghodss/yaml
  version: v1.0.0
  updated_at: '2023-09-17'

toolchain_deps:
- name: c
  version: '17'
  updated_at: '2022-05-07'
  expires_at: '2024-05-07'
- name: cpp
  version: '20'
  updated_at: '2023-05-12'
- name: java
  version: '21'
  updated_at: '2023-05-12'
- name: python
  version: 3.11.6
  updated_at: '2023-05-12'
- name: golang
  version: 1.20.10
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
      "url": "https://github.com/bazelbuild/rules_cc/archive/refs/tags/0.0.9.tar.gz",
      "sha256": "2037875b9a4456dce4a79d112a8ae885bbc4aad968e6587dca6e64f3a0900cdf",
      "version": "0.0.9",
      "strip_prefix": "rules_cc-0.0.9",
      "updated_at": "2023-09-22"
    },
    {
      "name": "rules_java",
      "type": "http_archive",
      "sha256": "f6068480cee4454755e2f422702722f31ef37b3628aa0ba9811fffc407b1b315",
      "url": "https://github.com/bazelbuild/rules_java/archive/refs/tags/7.1.0.tar.gz",
      "strip_prefix": "rules_java-7.1.0",
      "updated_at": "2023-11-09",
      "version": "7.1.0",
      "load_deps": "load(\"@rules_java//java:repositories.bzl\", \"java_tools_repos\", \"remote_jdk21_repos\")\ndef deps():\n  java_tools_repos()\n  remote_jdk21_repos()\n"
    },
    {
      "name": "rules_python",
      "type": "http_archive",
      "sha256": "9d04041ac92a0985e344235f5d946f71ac543f1b1565f2cdbc9a2aaee8adf55b",
      "strip_prefix": "rules_python-0.26.0",
      "url": "https://github.com/bazelbuild/rules_python/archive/refs/tags/0.26.0.tar.gz",
      "updated_at": "2023-10-19",
      "version": "0.26.0",
      "load_deps": "load(\"@rules_python//python:repositories.bzl\", \"python_register_toolchains\")\nload(\"@rules_python//python/private:toolchains_repo.bzl\", \"toolchains_repo\")\nload(\"@rules_python//python/private:internal_config_repo.bzl\", \"internal_config_repo\")\nload(\"@bazel_deps//:toolchain_deps.bzl\", \"PYTHON_VERSION\")\ndef deps():\n  internal_config_repo(name = \"rules_python_internal\")\n  python_register_toolchains(\n    name = \"python_sdk\",\n    python_version = PYTHON_VERSION,\n    register_toolchains = False,\n  )\n  toolchains_repo(\n      name = \"python_sdk_toolchains\",\n      python_version = PYTHON_VERSION,\n      set_python_version_constraint = False,\n      user_repository_name = \"python_sdk\",\n  )\n"
    },
    {
      "name": "rules_proto",
      "type": "http_archive",
      "sha256": "dc3fb206a2cb3441b485eb1e423165b231235a1ea9b031b4433cf7bc1fa460dd",
      "strip_prefix": "rules_proto-5.3.0-21.7",
      "url": "https://github.com/bazelbuild/rules_proto/archive/refs/tags/5.3.0-21.7.tar.gz",
      "updated_at": "2023-10-18",
      "version": "5.3.0-21.7",
      "version_regex": "([^-]*)[0-9.-]*$",
      "load_deps": "load(\"@rules_proto//proto:repositories.bzl\", \"rules_proto_dependencies\")\ndef deps():\n  rules_proto_dependencies()\n"
    },
    {
      "name": "io_bazel_rules_go",
      "type": "http_archive",
      "sha256": "9cf66773949710d831f84ed02b30af969af468e4325e6ab89dcb3b2238b734ad",
      "url": "https://github.com/bazelbuild/rules_go/archive/refs/tags/v0.42.0.tar.gz",
      "updated_at": "2023-09-30",
      "version": "v0.42.0",
      "strip_prefix": "rules_go-0.42.0",
      "load_deps": "load(\"@io_bazel_rules_go//go:deps.bzl\", \"go_download_sdk\", \"go_rules_dependencies\")\nload(\"@bazel_deps//:toolchain_deps.bzl\", \"GOLANG_VERSION\")\ndef deps():\n  go_rules_dependencies()\n  go_download_sdk(\n      name = \"go_linux_amd64\",\n      goos = \"linux\",\n      goarch = \"amd64\",\n      version = GOLANG_VERSION,\n      register_toolchains = False,\n  )\n"
    },
    {
      "name": "io_bazel_rules_docker",
      "type": "http_archive",
      "url": "https://github.com/bazelbuild/rules_docker/archive/refs/tags/v0.25.0.tar.gz",
      "sha256": "07ee8ca536080f5ebab6377fc6e8920e9a761d2ee4e64f0f6d919612f6ab56aa",
      "strip_prefix": "rules_docker-0.25.0",
      "updated_at": "2022-07-01",
      "expires_at": "2024-07-01",
      "version": "v0.25.0",
      "patches": [
        "@boleynsu_org//third_party:io_bazel_rules_docker.patch"
      ],
      "patch_cmds": [
        "sed -i '/native.register_toolchains/Q' repositories/repositories.bzl"
      ],
      "load_deps": "load(\"@io_bazel_rules_docker//repositories:repositories.bzl\", \"repositories\")\ndef deps():\n  repositories()\n"
    },
    {
      "name": "io_bazel_rules_k8s",
      "type": "http_archive",
      "url": "https://github.com/bazelbuild/rules_k8s/archive/refs/tags/v0.7.tar.gz",
      "sha256": "ce5b9bc0926681e2e7f2147b49096f143e6cbc783e71bc1d4f36ca76b00e6f4a",
      "strip_prefix": "rules_k8s-0.7",
      "updated_at": "2022-06-18",
      "expires_at": "2024-06-18",
      "version": "v0.7",
      "patch_cmds": [
        "sed -i 's/kubectl create --dry-run/%{kubectl_tool} create --dry-run=client --kubeconfig=\"%{kubeconfig}\" --cluster=\"%{cluster}\" --context=\"%{context}\" --user=\"%{user}\"/g' k8s/describe.sh.tpl",
        "sed -i \"s/| cut -d'\\\"' -f 2//g\" k8s/describe.sh.tpl",
        "sed -i 's/\"${RESOURCE_NAME}\"/${RESOURCE_NAME}/g' k8s/describe.sh.tpl",
        "sed -i 's#@com_github_yaml_pyyaml//:yaml3#@pip_pyyaml//:pkg#g' k8s/BUILD"
      ]
    },
    {
      "name": "bazel_skylib",
      "type": "http_archive",
      "url": "https://github.com/bazelbuild/bazel-skylib/archive/refs/tags/1.5.0.tar.gz",
      "sha256": "118e313990135890ee4cc8504e32929844f9578804a1b2f571d69b1dd080cfb8",
      "updated_at": "2023-11-06",
      "version": "1.5.0",
      "strip_prefix": "bazel-skylib-1.5.0"
    },
    {
      "name": "rules_jvm_external",
      "type": "http_archive",
      "sha256": "8ac1c5c2a8681c398883bb2cabc18f913337f165059f24e8c55714e05757761e",
      "strip_prefix": "rules_jvm_external-5.3",
      "url": "https://github.com/bazelbuild/rules_jvm_external/archive/refs/tags/5.3.tar.gz",
      "updated_at": "2023-06-24",
      "version": "5.3"
    },
    {
      "name": "rules_pkg",
      "type": "http_archive",
      "url": "https://github.com/bazelbuild/rules_pkg/archive/refs/tags/0.9.1.tar.gz",
      "sha256": "360c23a88ceaf7f051abc99e2e6048cf7fe5d9af792690576554a88b2013612d",
      "updated_at": "2023-05-04",
      "version": "0.9.1",
      "strip_prefix": "rules_pkg-0.9.1"
    },
    {
      "name": "io_grpc_grpc_java",
      "type": "http_archive",
      "sha256": "3bcf6be49fc7ab8187577a5211421258cb8e6d179f46023cc82e42e3a6188e51",
      "strip_prefix": "grpc-java-1.59.0",
      "url": "https://github.com/grpc/grpc-java/archive/refs/tags/v1.59.0.tar.gz",
      "updated_at": "2023-10-21",
      "version": "v1.59.0",
      "load_deps": "load(\"@io_grpc_grpc_java//:repositories.bzl\", \"grpc_java_repositories\")\ndef deps():\n  grpc_java_repositories()\n"
    },
    {
      "name": "bazel_gazelle",
      "type": "http_archive",
      "sha256": "775202071b874bbdefeea0c775856b5fb0409ceb193d25b11c4c543cff5674a3",
      "url": "https://github.com/bazelbuild/bazel-gazelle/archive/refs/tags/v0.34.0.tar.gz",
      "updated_at": "2023-11-09",
      "version": "v0.34.0",
      "strip_prefix": "bazel-gazelle-0.34.0",
      "patch_cmds": [
        "sed -i 's#go_repository = _go_repository#go_repository = _go_repository\\ndef fake_go_repository(**kwargs): pass#g' deps.bzl",
        "sed -i 's# go_repository,# fake_go_repository,#g' deps.bzl"
      ],
      "load_deps": "load(\"@bazel_gazelle//:deps.bzl\", \"gazelle_dependencies\")\ndef deps():\n  gazelle_dependencies()\n"
    },
    {
      "name": "com_github_cdolivet_editarea",
      "type": "http_archive",
      "url": "https://github.com/cdolivet/EditArea/archive/refs/tags/v0.8.2.tar.gz",
      "sha256": "47b58cf925b76252156da52187329d2cfede4f0f6f83416dcd9f0753592cb1f0",
      "strip_prefix": "EditArea-0.8.2",
      "updated_at": "2022-07-24",
      "expires_at": "2024-07-24",
      "version": "v0.8.2",
      "build_file": "@boleynsu_org//third_party:com_github_cdolivet_editarea.BUILD"
    },
    {
      "name": "llvm_linux_x86_64",
      "type": "http_archive",
      "url": "https://github.com/llvm/llvm-project/releases/download/llvmorg-17.0.5/clang+llvm-17.0.5-x86_64-linux-gnu-ubuntu-22.04.tar.xz",
      "sha256": "5a3cedecd8e2e8663e84bec2f8e5522b8ea097f4a8b32637386f27ac1ca01818",
      "strip_prefix": "clang+llvm-17.0.5-x86_64-linux-gnu-ubuntu-22.04",
      "version": "llvmorg-17.0.5",
      "version_regex": "llvmorg-(.*)",
      "updated_at": "2023-11-14",
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
          "cmd": "name=$(curl --netrc-optional -sL https://api.github.com/repos/llvm/llvm-project/releases | jq -r '.[] | select(.tag_name == \"'${DEPS_UPDATER_version}'\") | .assets[] | select(.name | test(\"x86_64-linux-gnu-ubuntu.*tar.xz$\")) | .name')\necho DEPS_UPDATER_url=https://github.com/llvm/llvm-project/releases/download/${DEPS_UPDATER_version}/${name}\necho DEPS_UPDATER_strip_prefix=${name%.tar.xz}\n"
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
      "url": "https://github.com/grailbio/bazel-toolchain/archive/refs/tags/0.10.3.tar.gz",
      "sha256": "c2a58fdd8420cca3645843b1be7b18a2d5df388d192d50c238ae3edd9b693011",
      "strip_prefix": "bazel-toolchain-0.10.3",
      "updated_at": "2023-09-22",
      "version": "0.10.3",
      "patches": [
        "@boleynsu_org//third_party:com_grail_bazel_toolchain.patch"
      ],
      "load_deps": "load(\"@com_grail_bazel_toolchain//toolchain:rules.bzl\", \"llvm_toolchain\")\nload(\"@bazel_deps//:bazel_deps.bzl\", \"BAZEL_DEPS\")\ndef deps():\n  llvm_toolchain(\n      name = \"llvm_toolchain_linux_x86_64\",\n      llvm_version = BAZEL_DEPS[\"llvm_linux_x86_64\"][\"version\"][len(\"llvmorg-\"):],\n      exec_os = \"linux\",\n      exec_cpu = \"x86_64\",\n      urls = {\n          \"linux-x86_64\": [BAZEL_DEPS[\"llvm_linux_x86_64\"][\"url\"]],\n      },\n      strip_prefix = {\n          \"linux-x86_64\": BAZEL_DEPS[\"llvm_linux_x86_64\"][\"strip_prefix\"],\n      },\n      sha256 = {\n          \"linux-x86_64\": BAZEL_DEPS[\"llvm_linux_x86_64\"][\"sha256\"],\n      },\n  )\n"
    },
    {
      "name": "bazel_linux_x86_64",
      "type": "http_archive",
      "version": "6.4.0",
      "url": "https://github.com/bazelbuild/bazel/releases/download/6.4.0/bazel-6.4.0-installer-linux-x86_64.sh",
      "http_archive_type": "zip",
      "sha256": "4a52769e0bcc783d8dd038ca71a50153a425555993918291a8ce576d121b3671",
      "updated_at": "2023-10-20",
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
          "cmd": "echo DEPS_UPDATER_url=https://github.com/bazelbuild/bazel/releases/download/${DEPS_UPDATER_version}/bazel-${DEPS_UPDATER_version}-installer-linux-x86_64.sh"
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
      ],
      "build_file_content": "exports_files(glob([\"**\"]))",
      "load_deps": "load(\"@bazel_deps//:bazel_deps.bzl\", \"BAZEL_DEPS\")\ndef deps():\n  if BAZEL_DEPS[\"bazel_linux_x86_64\"][\"version\"] != native.bazel_version:\n    print(\"You are using an unsupported version of Bazel\")\n"
    },
    {
      "name": "rules_license",
      "type": "http_archive",
      "sha256": "7626bea5473d3b11d44269c5b510a210f11a78bca1ed639b0f846af955b0fe31",
      "strip_prefix": "rules_license-0.0.7",
      "url": "https://github.com/bazelbuild/rules_license/archive/refs/tags/0.0.7.tar.gz",
      "updated_at": "2023-09-16",
      "version": "0.0.7"
    },
    {
      "name": "platforms",
      "type": "http_archive",
      "sha256": "58ca5559d562def65cf1aeae9cd994d2776f7273eab9f48779ad043c3ffb3ce3",
      "strip_prefix": "platforms-0.0.8",
      "url": "https://github.com/bazelbuild/platforms/archive/refs/tags/0.0.8.tar.gz",
      "updated_at": "2023-10-19",
      "version": "0.0.8"
    },
    {
      "name": "kubectl_linux_amd64",
      "type": "http_file",
      "url": "https://dl.k8s.io/release/v1.28.3/bin/linux/amd64/kubectl",
      "sha256": "0c680c90892c43e5ce708e918821f92445d1d244f9b3d7513023bcae9a6246d1",
      "version": "v1.28.3",
      "updated_at": "2023-10-19",
      "executable": true,
      "override_updater": [
        {
          "type": "shell",
          "cmd": "version=$(curl -sL https://dl.k8s.io/release/stable.txt)\necho DEPS_UPDATER_version=${version}\necho DEPS_UPDATER_url=https://dl.k8s.io/release/${version}/bin/linux/amd64/kubectl\n"
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
      "version": "0.18.5",
      "updated_at": "2023-11-03"
    },
    {
      "name": "PyYAML",
      "version": "6.0.1",
      "updated_at": "2023-07-22"
    }
  ],
  "maven_deps": [
    {
      "name": "commons-io:commons-io",
      "version": "2.15.0",
      "updated_at": "2023-10-25"
    },
    {
      "name": "org.mariadb.jdbc:mariadb-java-client",
      "version": "3.3.0",
      "updated_at": "2023-11-09"
    },
    {
      "name": "org.apache.tomcat.embed:tomcat-embed-core",
      "version": "10.1.16",
      "updated_at": "2023-11-14"
    },
    {
      "name": "org.apache.tomcat.embed:tomcat-embed-jasper",
      "version": "10.1.16",
      "updated_at": "2023-11-14"
    },
    {
      "name": "org.webjars:jquery",
      "version": "3.7.1",
      "updated_at": "2023-09-02"
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
      "version": "2.3.10.Final",
      "version_regex": "(.*)\\.Final",
      "updated_at": "2023-10-18"
    },
    {
      "name": "commons-validator:commons-validator",
      "version": "1.7",
      "updated_at": "2022-04-15",
      "expires_at": "2024-04-15"
    },
    {
      "name": "commons-codec:commons-codec",
      "version": "1.16.0",
      "updated_at": "2023-06-22"
    },
    {
      "name": "org.wildfly.common:wildfly-common",
      "version": "1.7.0.Final",
      "version_regex": "(.*)\\.Final",
      "updated_at": "2023-11-03"
    },
    {
      "name": "com.googlecode.owasp-java-html-sanitizer:owasp-java-html-sanitizer",
      "version": "20220608.1",
      "updated_at": "2023-04-01"
    },
    {
      "name": "org.apache.commons:commons-text",
      "version": "1.11.0",
      "updated_at": "2023-10-29"
    },
    {
      "name": "com.google.android:annotations",
      "version": "4.1.1.4",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "com.google.api.grpc:proto-google-common-protos",
      "version": "2.22.0",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "com.google.auth:google-auth-library-credentials",
      "version": "1.4.0",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "com.google.auth:google-auth-library-oauth2-http",
      "version": "1.4.0",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "com.google.code.findbugs:jsr305",
      "version": "3.0.2",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "com.google.auto.value:auto-value",
      "version": "1.10.2",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "com.google.auto.value:auto-value-annotations",
      "version": "1.10.2",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "com.google.errorprone:error_prone_annotations",
      "version": "2.20.0",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "com.google.guava:failureaccess",
      "version": "1.0.1",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "com.google.guava:guava",
      "version": "32.0.1-android",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "com.google.truth:truth",
      "version": "1.1.5",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "com.squareup.okhttp:okhttp",
      "version": "2.7.5",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "com.squareup.okio:okio",
      "version": "2.10.0",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.netty:netty-buffer",
      "version": "4.1.97.Final",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.netty:netty-codec-http2",
      "version": "4.1.97.Final",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.netty:netty-codec-http",
      "version": "4.1.97.Final",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.netty:netty-codec-socks",
      "version": "4.1.97.Final",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.netty:netty-codec",
      "version": "4.1.97.Final",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.netty:netty-common",
      "version": "4.1.97.Final",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.netty:netty-handler-proxy",
      "version": "4.1.97.Final",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.netty:netty-handler",
      "version": "4.1.97.Final",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.netty:netty-resolver",
      "version": "4.1.97.Final",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.netty:netty-tcnative-boringssl-static",
      "version": "2.0.61.Final",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.netty:netty-transport-native-epoll:jar:linux-x86_64",
      "version": "4.1.97.Final",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.netty:netty-transport",
      "version": "4.1.97.Final",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.opencensus:opencensus-api",
      "version": "0.31.0",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.opencensus:opencensus-contrib-grpc-metrics",
      "version": "0.31.0",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.perfmark:perfmark-api",
      "version": "0.26.0",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "junit:junit",
      "version": "4.13.2",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "org.apache.tomcat:annotations-api",
      "version": "6.0.53",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "org.codehaus.mojo:animal-sniffer-annotations",
      "version": "1.23",
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
      "override_target": "@com_google_protobuf_javalite//:protobuf_javalite",
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
      "version": "2.10.1",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "com.google.re2j:re2j",
      "version": "1.7",
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
      "version": "2.0.61.Final",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.netty:netty-transport-native-unix-common",
      "version": "4.1.97.Final",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.grpc:grpc-inprocess",
      "version": "override",
      "override_target": "@io_grpc_grpc_java//inprocess",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.grpc:grpc-util",
      "version": "override",
      "override_target": "@io_grpc_grpc_java//util",
      "included_from": "io_grpc_grpc_java"
    }
  ],
  "container_deps": [
    {
      "name": "java_debug_image_base",
      "version": "debug",
      "version_regex": "^(debug)$",
      "registry": "gcr.io",
      "repository": "distroless/java21",
      "tag": "debug",
      "digest": "sha256:a2400aaf8c6447a4ebb171900a8a92dad752475492b7af0e311520d1c45b3a96",
      "updated_at": "2023-11-15"
    },
    {
      "name": "java_image_base",
      "version": "latest",
      "version_regex": "^(latest)$",
      "registry": "gcr.io",
      "repository": "distroless/java21",
      "tag": "latest",
      "digest": "sha256:f0c6d6a656ec9516fe75f6aa7a69015d00b593ce2c3d75142175ac2b7391f160",
      "updated_at": "2023-11-15"
    },
    {
      "name": "io_quay_boleynsu_ci_runner",
      "version": "20231110.162612",
      "registry": "quay.io",
      "repository": "boleynsu/ci-runner",
      "tag": "20231110.162612",
      "digest": "sha256:ff0cd830ff953078fbcbbd4e65a2ce523b372cc917fff3cd0a405e92fbe3141c",
      "updated_at": "2023-11-10"
    },
    {
      "name": "io_docker_library_mariadb",
      "version": "latest",
      "version_regex": "^(latest)$",
      "registry": "docker.io",
      "repository": "library/mariadb",
      "tag": "latest",
      "digest": "sha256:e51c275914b2da5e8e8e0ed9eaecf1e4d5142b5e570f231224320001cf5c86cf",
      "updated_at": "2023-10-13"
    },
    {
      "name": "io_docker_library_adminer",
      "version": "4.8.1",
      "registry": "docker.io",
      "repository": "library/adminer",
      "tag": "4.8.1",
      "digest": "sha256:b96876e1c6d4eda21b2653d54bb8c9d4674fc177749254c5a44d097f92e2362e",
      "updated_at": "2023-11-01"
    },
    {
      "name": "io_docker_filebrowser_filebrowser",
      "version": "v2.26.0",
      "registry": "docker.io",
      "repository": "filebrowser/filebrowser",
      "tag": "v2.26.0",
      "digest": "sha256:0e0a4b700302457772b07c4efc47bc90143d7538d36731baabcf7d375360bcee",
      "updated_at": "2023-11-03"
    },
    {
      "name": "io_quay_boleynsu_oj_c99runner",
      "version": "20231110.162612",
      "registry": "quay.io",
      "repository": "boleynsu/oj-c99runner",
      "tag": "20231110.162612",
      "digest": "sha256:7480f92078d562c901cdc8d573d9a56eeed7cc55456e9510fd2d1e7de9bfe236",
      "updated_at": "2023-11-10"
    },
    {
      "name": "io_quay_boleynsu_rbe_fedora",
      "version": "20231110.162612",
      "registry": "quay.io",
      "repository": "boleynsu/rbe-fedora",
      "tag": "20231110.162612",
      "digest": "sha256:d267b0bae3c7adc13e64816f631720eca8d242d3380fad26b480ca0a6ac91613",
      "updated_at": "2023-11-10"
    }
  ],
  "go_deps": [
    {
      "name": "github.com/google/go-containerregistry",
      "version": "v0.16.1",
      "updated_at": "2023-09-17"
    },
    {
      "name": "github.com/pkg/errors",
      "version": "v0.9.1",
      "updated_at": "2023-09-17"
    },
    {
      "name": "gopkg.in/yaml.v2",
      "version": "v2.4.0",
      "updated_at": "2023-09-17"
    },
    {
      "name": "github.com/kylelemons/godebug",
      "version": "v1.1.0",
      "updated_at": "2023-09-17"
    },
    {
      "name": "github.com/ghodss/yaml",
      "version": "v1.0.0",
      "updated_at": "2023-09-17"
    }
  ],
  "toolchain_deps": [
    {
      "name": "c",
      "version": "17",
      "updated_at": "2022-05-07",
      "expires_at": "2024-05-07"
    },
    {
      "name": "cpp",
      "version": "20",
      "updated_at": "2023-05-12"
    },
    {
      "name": "java",
      "version": "21",
      "updated_at": "2023-05-12"
    },
    {
      "name": "python",
      "version": "3.11.6",
      "updated_at": "2023-05-12"
    },
    {
      "name": "golang",
      "version": "1.20.10",
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
""") if hash(_DEPS_YAML) != -1317414395 or hash(_DEPS_JSON) != 623939990 else None]

DEPS = json.decode(_DEPS_JSON)
