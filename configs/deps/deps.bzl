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
  url: https://github.com/bazelbuild/rules_cc/archive/refs/tags/0.0.2.tar.gz
  sha256: 0e5801b1834a51c1308044e9abaeb6aaf945e4a4274866ea84fbccc50a292368
  version: 0.0.2
  strip_prefix: rules_cc-0.0.2
  updated_at: '2022-07-22'
  load_deps: |
    load("@rules_cc//cc:repositories.bzl", "rules_cc_dependencies", "rules_cc_toolchains")
    def deps():
      rules_cc_dependencies()
      rules_cc_toolchains()
- name: rules_java
  type: http_archive
  sha256: 1f0619be85a68a86af1093449e9a373fd112b6bccaeea18dfd6a18b1bbf9ba40
  url: https://github.com/bazelbuild/rules_java/archive/refs/tags/5.1.0.tar.gz
  strip_prefix: rules_java-5.1.0
  updated_at: '2022-09-16'
  version: 5.1.0
  load_deps: |
    load("@rules_java//java:repositories.bzl", "rules_java_dependencies", "rules_java_toolchains")
    def deps():
      rules_java_dependencies()
      rules_java_toolchains()
- name: rules_python
  type: http_archive
  sha256: b593d13bb43c94ce94b483c2858e53a9b811f6f10e1e0eedc61073bd90e58d9c
  strip_prefix: rules_python-0.12.0
  url: https://github.com/bazelbuild/rules_python/archive/refs/tags/0.12.0.tar.gz
  updated_at: '2022-09-16'
  version: 0.12.0
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
  updated_at: '2022-04-10'
  version: 4.0.0
  load_deps: |
    load("@rules_proto//proto:repositories.bzl", "rules_proto_dependencies", "rules_proto_toolchains")
    def deps():
      rules_proto_dependencies()
      rules_proto_toolchains()
- name: io_bazel_rules_go
  type: http_archive
  sha256: cc027f11f98aef8bc52c472ced0714994507a16ccd3a0820b2df2d6db695facd
  url: https://github.com/bazelbuild/rules_go/archive/refs/tags/v0.35.0.tar.gz
  updated_at: '2022-09-16'
  version: v0.35.0
  strip_prefix: rules_go-0.35.0
  load_deps: |
    load("@io_bazel_rules_go//go:deps.bzl", "go_register_toolchains", "go_rules_dependencies")
    load("@bazel_deps//:toolchain_deps.bzl", "GOLANG_VERSION")
    def deps():
      go_rules_dependencies()
      go_register_toolchains(version = GOLANG_VERSION)
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
    # From https://github.com/bazelbuild/rules_k8s/blob/v0.7/k8s/k8s.bzl
    load("@rules_python//python:defs.bzl", "py_binary", "py_library")

    py_library(
        name = "yaml",
        srcs = glob(["lib/yaml/*.py"]),
        imports = [
            "lib",
        ],
        visibility = ["//visibility:public"],
    )

    py_library(
      name = "yaml3",
      srcs = glob(["lib3/yaml/*.py"]),
      imports = [
          "lib3",
      ],
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
  url: https://github.com/bazelbuild/bazel-skylib/archive/refs/tags/1.3.0.tar.gz
  sha256: 3b620033ca48fcd6f5ef2ac85e0f6ec5639605fa2f627968490e52fc91a9932f
  updated_at: '2022-09-16'
  version: 1.3.0
  strip_prefix: bazel-skylib-1.3.0
  load_deps: |
    load("@bazel_skylib//:workspace.bzl", "bazel_skylib_workspace")
    def deps():
      bazel_skylib_workspace()
- name: rules_jvm_external
  type: http_archive
  sha256: 23fe83890a77ac1a3ee143e2306ec12da4a845285b14ea13cb0df1b1e23658fe
  strip_prefix: rules_jvm_external-4.3
  url: https://github.com/bazelbuild/rules_jvm_external/archive/refs/tags/4.3.tar.gz
  updated_at: '2022-09-16'
  version: '4.3'
- name: bazel_toolchains
  type: http_archive
  url: https://github.com/bazelbuild/bazel-toolchains/archive/refs/tags/v5.1.2.tar.gz
  sha256: 02e4f3744f1ce3f6e711e261fd322916ddd18cccd38026352f7a4c0351dbda19
  strip_prefix: bazel-toolchains-5.1.2
  updated_at: '2022-09-16'
  version: v5.1.2
- name: rules_pkg
  type: http_archive
  url: https://github.com/bazelbuild/rules_pkg/archive/refs/tags/0.7.1.tar.gz
  sha256: d258fb6965cf3d7ebdbe146ec7e28b605f0644cb880101604e166e35d4ca62bc
  updated_at: '2022-09-16'
  version: 0.7.1
  strip_prefix: rules_pkg-0.7.1
  load_deps: |
    load("@rules_pkg//:deps.bzl", "rules_pkg_dependencies")
    def deps():
      rules_pkg_dependencies()
- name: io_grpc_grpc_java
  type: http_archive
  sha256: fd5f319252eac66920391ceb79b94611cac74de8f1ff7ef51391ee859a2243ea
  strip_prefix: grpc-java-1.49.0
  url: https://github.com/grpc/grpc-java/archive/refs/tags/v1.49.0.tar.gz
  updated_at: '2022-09-16'
  version: v1.49.0
  load_deps: |
    load("@io_grpc_grpc_java//:repositories.bzl", "grpc_java_repositories")
    def deps():
      grpc_java_repositories()
- name: bazel_gazelle
  type: http_archive
  sha256: 78f8fbf798229b76540c9159edbb4e7159cee65e8a825a825fca97cbc14a9688
  url: https://github.com/bazelbuild/bazel-gazelle/archive/refs/tags/v0.27.0.tar.gz
  updated_at: '2022-09-16'
  version: v0.27.0
  strip_prefix: bazel-gazelle-0.27.0
  # FIXME(https://github.com/bazelbuild/bazel-gazelle/issues/1305):
  # The current implementation forces users to declare go_repository before gazelle_dependencies to avoid being overridden.
  patch_cmds:
  - "sed -i 's#go_repository = _go_repository#go_repository = _go_repository\\ndef fake_go_repository(**kwargs): pass#g' deps.bzl"
  - sed -i 's# go_repository,# fake_go_repository,#g' deps.bzl
  load_deps: |
    load("@bazel_gazelle//:deps.bzl", "gazelle_dependencies")
    def deps():
      gazelle_dependencies(go_sdk = "go_sdk")
- name: io_k8s_kubernetes
  type: http_archive
  url: https://github.com/kubernetes/kubernetes/archive/refs/tags/v1.25.1.tar.gz
  sha256: 7f00e351b99851cdfbc7536a960a32c10f0f3dfe8bb3a09b93b0c7b0af224e25
  strip_prefix: kubernetes-1.25.1
  updated_at: '2022-09-16'
  version: v1.25.1
  build_file: '@boleynsu_org//third_party:io_k8s_kubernetes.BUILD'
- name: com_github_cdolivet_editarea
  type: http_archive
  url: https://github.com/cdolivet/EditArea/archive/refs/tags/v0.8.2.tar.gz
  sha256: 47b58cf925b76252156da52187329d2cfede4f0f6f83416dcd9f0753592cb1f0
  strip_prefix: EditArea-0.8.2
  updated_at: '2022-07-24'
  version: v0.8.2
  build_file: '@boleynsu_org//third_party:com_github_cdolivet_editarea.BUILD'

pip_deps:
- name: ruamel.yaml
  version: 0.17.21
  updated_at: '2022-04-09'

maven_deps:
- name: commons-io:commons-io
  version: 2.11.0
  updated_at: '2022-04-09'
- name: mysql:mysql-connector-java
  version: 8.0.30
  updated_at: '2022-07-26'
- name: org.apache.tomcat.embed:tomcat-embed-core
  version: 10.0.23
  updated_at: '2022-07-26'
- name: org.apache.tomcat.embed:tomcat-embed-jasper
  version: 10.0.23
  updated_at: '2022-07-26'
- name: org.webjars:jquery
  version: 3.6.1
  updated_at: '2022-09-16'
  manual: true
- name: org.webjars:bootstrap
  version: 3.4.1
  updated_at: '2022-04-09'
  # FIXME(https://github.com/BoleynSu/oj/issues/2):
  # Upgrade third-party JavaScript/stylesheet libraries
  pinned_until: '2023-04-09'
- name: io.undertow:undertow-core
  version: 2.2.19.Final
  version_regex: (.*)\.Final
  updated_at: '2022-09-16'
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
  version: 4.1.77.Final
  included_from: io_grpc_grpc_java
- name: io.netty:netty-codec-http2
  version: 4.1.77.Final
  included_from: io_grpc_grpc_java
- name: io.netty:netty-codec-http
  version: 4.1.77.Final
  included_from: io_grpc_grpc_java
- name: io.netty:netty-codec-socks
  version: 4.1.77.Final
  included_from: io_grpc_grpc_java
- name: io.netty:netty-codec
  version: 4.1.77.Final
  included_from: io_grpc_grpc_java
- name: io.netty:netty-common
  version: 4.1.77.Final
  included_from: io_grpc_grpc_java
- name: io.netty:netty-handler-proxy
  version: 4.1.77.Final
  included_from: io_grpc_grpc_java
- name: io.netty:netty-handler
  version: 4.1.77.Final
  included_from: io_grpc_grpc_java
- name: io.netty:netty-resolver
  version: 4.1.77.Final
  included_from: io_grpc_grpc_java
- name: io.netty:netty-tcnative-boringssl-static
  version: 2.0.53.Final
  included_from: io_grpc_grpc_java
- name: io.netty:netty-transport-native-epoll:jar:linux-x86_64
  version: 4.1.77.Final
  included_from: io_grpc_grpc_java
- name: io.netty:netty-transport
  version: 4.1.77.Final
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
  version: 2.0.53.Final
  included_from: io_grpc_grpc_java
- name: io.netty:netty-transport-native-unix-common
  version: 4.1.72.Final
  included_from: io_grpc_grpc_java

container_deps:
- name: io_docker_library_gcc
  version: latest
  registry: docker.io
  # the size of library/gcc is too large so we use frolvlad/alpine-gcc instead
  repository: frolvlad/alpine-gcc
  tag: latest
  digest: sha256:4c06bdaadd01d2f2cd17173c9ab6815cebccec157d6d9fe2b97193b42d8df0f4
  updated_at: '2022-06-18'
- name: java_debug_image_base
  version: debug
  version_regex: ^(debug)$
  registry: gcr.io
  repository: distroless/java11
  tag: debug
  digest: sha256:21636ce51df5fe068357ae6b6a7fbf1a8bb1d724742c7b13db6aeed1ecee8855
  updated_at: '2022-09-16'
- name: java_image_base
  version: latest
  version_regex: ^(latest)$
  registry: gcr.io
  repository: distroless/java11
  tag: latest
  digest: sha256:fddf66106c65dd741eb7e01cfcd18a79ddb0abc19cace51343eff972cc8b6cd2
  updated_at: '2022-09-16'
- name: py3_debug_image_base
  version: debug
  version_regex: ^(debug)$
  registry: gcr.io
  repository: distroless/python3
  tag: debug
  digest: sha256:257b8ee88096d5272c5879e20e0bf9eef3a5718b8be0192e4297d4d905ba2f8d
  updated_at: '2022-09-16'
- name: py3_image_base
  version: latest
  version_regex: ^(latest)$
  registry: gcr.io
  repository: distroless/python3
  tag: latest
  digest: sha256:ddaf123a09b09f4004b38d0a6904542df55d52ac58e8a6e990d9396588e16fdc
  updated_at: '2022-09-16'
- name: go_debug_image_base
  version: debug
  version_regex: ^(debug)$
  registry: gcr.io
  repository: distroless/base
  tag: debug
  digest: sha256:e4a7a5d73ebf41921cc9cdd043946c233d3d6650f4495b4383770ccaabc458a6
  updated_at: '2022-09-16'
- name: go_image_base
  version: latest
  version_regex: ^(latest)$
  registry: gcr.io
  repository: distroless/base
  tag: latest
  digest: sha256:4266c0b1808b25215515a8e4359df08a6b0c0058cb6055b14ed1508de40dbd1e
  updated_at: '2022-09-16'
- name: go_debug_image_static
  version: debug
  version_regex: ^(debug)$
  registry: gcr.io
  repository: distroless/static
  tag: debug
  digest: sha256:6534498fd01b529f0297061e26055ada911f9665a80cd1543367601f704d791a
  updated_at: '2022-09-16'
- name: go_image_static
  version: latest
  version_regex: ^(latest)$
  registry: gcr.io
  repository: distroless/static
  tag: latest
  digest: sha256:a7436badb916baa7d92533dfbc7140c329a0d9db1bf81c14151cf89bc01928b4
  updated_at: '2022-09-16'
- name: io_quay_boleynsu_ci_runner
  version: 44ae33bddc7120caa8477ab661e0d03a38e2b750
  registry: quay.io
  repository: boleynsu/ci-runner
  tag: 44ae33bddc7120caa8477ab661e0d03a38e2b750
  digest: sha256:7ee41e9c3544fb49378bcab561873aa0150333dc685a2c90cf30188f821f90f9
  updated_at: '2022-05-12'

go_deps:
- name: k8s.io/kubectl
  version: v0.25.0
  updated_at: '2022-09-16'
- name: k8s.io/client-go
  version: v0.25.0
  updated_at: '2022-09-16'

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
      "url": "https://github.com/bazelbuild/rules_cc/archive/refs/tags/0.0.2.tar.gz",
      "sha256": "0e5801b1834a51c1308044e9abaeb6aaf945e4a4274866ea84fbccc50a292368",
      "version": "0.0.2",
      "strip_prefix": "rules_cc-0.0.2",
      "updated_at": "2022-07-22",
      "load_deps": "load(\"@rules_cc//cc:repositories.bzl\", \"rules_cc_dependencies\", \"rules_cc_toolchains\")\ndef deps():\n  rules_cc_dependencies()\n  rules_cc_toolchains()\n"
    },
    {
      "name": "rules_java",
      "type": "http_archive",
      "sha256": "1f0619be85a68a86af1093449e9a373fd112b6bccaeea18dfd6a18b1bbf9ba40",
      "url": "https://github.com/bazelbuild/rules_java/archive/refs/tags/5.1.0.tar.gz",
      "strip_prefix": "rules_java-5.1.0",
      "updated_at": "2022-09-16",
      "version": "5.1.0",
      "load_deps": "load(\"@rules_java//java:repositories.bzl\", \"rules_java_dependencies\", \"rules_java_toolchains\")\ndef deps():\n  rules_java_dependencies()\n  rules_java_toolchains()\n"
    },
    {
      "name": "rules_python",
      "type": "http_archive",
      "sha256": "b593d13bb43c94ce94b483c2858e53a9b811f6f10e1e0eedc61073bd90e58d9c",
      "strip_prefix": "rules_python-0.12.0",
      "url": "https://github.com/bazelbuild/rules_python/archive/refs/tags/0.12.0.tar.gz",
      "updated_at": "2022-09-16",
      "version": "0.12.0",
      "load_deps": "load(\"@rules_python//python:repositories.bzl\", \"python_register_toolchains\")\nload(\"@bazel_deps//:toolchain_deps.bzl\", \"PYTHON_VERSION\")\ndef deps():\n  python_register_toolchains(\n    name = \"python_sdk\",\n    python_version = PYTHON_VERSION,\n  )\n"
    },
    {
      "name": "rules_proto",
      "type": "http_archive",
      "sha256": "66bfdf8782796239d3875d37e7de19b1d94301e8972b3cbd2446b332429b4df1",
      "strip_prefix": "rules_proto-4.0.0",
      "url": "https://github.com/bazelbuild/rules_proto/archive/refs/tags/4.0.0.tar.gz",
      "updated_at": "2022-04-10",
      "version": "4.0.0",
      "load_deps": "load(\"@rules_proto//proto:repositories.bzl\", \"rules_proto_dependencies\", \"rules_proto_toolchains\")\ndef deps():\n  rules_proto_dependencies()\n  rules_proto_toolchains()\n"
    },
    {
      "name": "io_bazel_rules_go",
      "type": "http_archive",
      "sha256": "cc027f11f98aef8bc52c472ced0714994507a16ccd3a0820b2df2d6db695facd",
      "url": "https://github.com/bazelbuild/rules_go/archive/refs/tags/v0.35.0.tar.gz",
      "updated_at": "2022-09-16",
      "version": "v0.35.0",
      "strip_prefix": "rules_go-0.35.0",
      "load_deps": "load(\"@io_bazel_rules_go//go:deps.bzl\", \"go_register_toolchains\", \"go_rules_dependencies\")\nload(\"@bazel_deps//:toolchain_deps.bzl\", \"GOLANG_VERSION\")\ndef deps():\n  go_rules_dependencies()\n  go_register_toolchains(version = GOLANG_VERSION)\n"
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
      "build_file_content": "# From https://github.com/bazelbuild/rules_k8s/blob/v0.7/k8s/k8s.bzl\nload(\"@rules_python//python:defs.bzl\", \"py_binary\", \"py_library\")\n\npy_library(\n    name = \"yaml\",\n    srcs = glob([\"lib/yaml/*.py\"]),\n    imports = [\n        \"lib\",\n    ],\n    visibility = [\"//visibility:public\"],\n)\n\npy_library(\n  name = \"yaml3\",\n  srcs = glob([\"lib3/yaml/*.py\"]),\n  imports = [\n      \"lib3\",\n  ],\n  visibility = [\"//visibility:public\"],\n)\n"
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
      "url": "https://github.com/bazelbuild/bazel-skylib/archive/refs/tags/1.3.0.tar.gz",
      "sha256": "3b620033ca48fcd6f5ef2ac85e0f6ec5639605fa2f627968490e52fc91a9932f",
      "updated_at": "2022-09-16",
      "version": "1.3.0",
      "strip_prefix": "bazel-skylib-1.3.0",
      "load_deps": "load(\"@bazel_skylib//:workspace.bzl\", \"bazel_skylib_workspace\")\ndef deps():\n  bazel_skylib_workspace()\n"
    },
    {
      "name": "rules_jvm_external",
      "type": "http_archive",
      "sha256": "23fe83890a77ac1a3ee143e2306ec12da4a845285b14ea13cb0df1b1e23658fe",
      "strip_prefix": "rules_jvm_external-4.3",
      "url": "https://github.com/bazelbuild/rules_jvm_external/archive/refs/tags/4.3.tar.gz",
      "updated_at": "2022-09-16",
      "version": "4.3"
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
      "url": "https://github.com/bazelbuild/rules_pkg/archive/refs/tags/0.7.1.tar.gz",
      "sha256": "d258fb6965cf3d7ebdbe146ec7e28b605f0644cb880101604e166e35d4ca62bc",
      "updated_at": "2022-09-16",
      "version": "0.7.1",
      "strip_prefix": "rules_pkg-0.7.1",
      "load_deps": "load(\"@rules_pkg//:deps.bzl\", \"rules_pkg_dependencies\")\ndef deps():\n  rules_pkg_dependencies()\n"
    },
    {
      "name": "io_grpc_grpc_java",
      "type": "http_archive",
      "sha256": "fd5f319252eac66920391ceb79b94611cac74de8f1ff7ef51391ee859a2243ea",
      "strip_prefix": "grpc-java-1.49.0",
      "url": "https://github.com/grpc/grpc-java/archive/refs/tags/v1.49.0.tar.gz",
      "updated_at": "2022-09-16",
      "version": "v1.49.0",
      "load_deps": "load(\"@io_grpc_grpc_java//:repositories.bzl\", \"grpc_java_repositories\")\ndef deps():\n  grpc_java_repositories()\n"
    },
    {
      "name": "bazel_gazelle",
      "type": "http_archive",
      "sha256": "78f8fbf798229b76540c9159edbb4e7159cee65e8a825a825fca97cbc14a9688",
      "url": "https://github.com/bazelbuild/bazel-gazelle/archive/refs/tags/v0.27.0.tar.gz",
      "updated_at": "2022-09-16",
      "version": "v0.27.0",
      "strip_prefix": "bazel-gazelle-0.27.0",
      "patch_cmds": [
        "sed -i 's#go_repository = _go_repository#go_repository = _go_repository\\ndef fake_go_repository(**kwargs): pass#g' deps.bzl",
        "sed -i 's# go_repository,# fake_go_repository,#g' deps.bzl"
      ],
      "load_deps": "load(\"@bazel_gazelle//:deps.bzl\", \"gazelle_dependencies\")\ndef deps():\n  gazelle_dependencies(go_sdk = \"go_sdk\")\n"
    },
    {
      "name": "io_k8s_kubernetes",
      "type": "http_archive",
      "url": "https://github.com/kubernetes/kubernetes/archive/refs/tags/v1.25.1.tar.gz",
      "sha256": "7f00e351b99851cdfbc7536a960a32c10f0f3dfe8bb3a09b93b0c7b0af224e25",
      "strip_prefix": "kubernetes-1.25.1",
      "updated_at": "2022-09-16",
      "version": "v1.25.1",
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
    }
  ],
  "pip_deps": [
    {
      "name": "ruamel.yaml",
      "version": "0.17.21",
      "updated_at": "2022-04-09"
    }
  ],
  "maven_deps": [
    {
      "name": "commons-io:commons-io",
      "version": "2.11.0",
      "updated_at": "2022-04-09"
    },
    {
      "name": "mysql:mysql-connector-java",
      "version": "8.0.30",
      "updated_at": "2022-07-26"
    },
    {
      "name": "org.apache.tomcat.embed:tomcat-embed-core",
      "version": "10.0.23",
      "updated_at": "2022-07-26"
    },
    {
      "name": "org.apache.tomcat.embed:tomcat-embed-jasper",
      "version": "10.0.23",
      "updated_at": "2022-07-26"
    },
    {
      "name": "org.webjars:jquery",
      "version": "3.6.1",
      "updated_at": "2022-09-16",
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
      "version": "2.2.19.Final",
      "version_regex": "(.*)\\.Final",
      "updated_at": "2022-09-16"
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
      "version": "4.1.77.Final",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.netty:netty-codec-http2",
      "version": "4.1.77.Final",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.netty:netty-codec-http",
      "version": "4.1.77.Final",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.netty:netty-codec-socks",
      "version": "4.1.77.Final",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.netty:netty-codec",
      "version": "4.1.77.Final",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.netty:netty-common",
      "version": "4.1.77.Final",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.netty:netty-handler-proxy",
      "version": "4.1.77.Final",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.netty:netty-handler",
      "version": "4.1.77.Final",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.netty:netty-resolver",
      "version": "4.1.77.Final",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.netty:netty-tcnative-boringssl-static",
      "version": "2.0.53.Final",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.netty:netty-transport-native-epoll:jar:linux-x86_64",
      "version": "4.1.77.Final",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.netty:netty-transport",
      "version": "4.1.77.Final",
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
      "version": "2.0.53.Final",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.netty:netty-transport-native-unix-common",
      "version": "4.1.72.Final",
      "included_from": "io_grpc_grpc_java"
    }
  ],
  "container_deps": [
    {
      "name": "io_docker_library_gcc",
      "version": "latest",
      "registry": "docker.io",
      "repository": "frolvlad/alpine-gcc",
      "tag": "latest",
      "digest": "sha256:4c06bdaadd01d2f2cd17173c9ab6815cebccec157d6d9fe2b97193b42d8df0f4",
      "updated_at": "2022-06-18"
    },
    {
      "name": "java_debug_image_base",
      "version": "debug",
      "version_regex": "^(debug)$",
      "registry": "gcr.io",
      "repository": "distroless/java11",
      "tag": "debug",
      "digest": "sha256:21636ce51df5fe068357ae6b6a7fbf1a8bb1d724742c7b13db6aeed1ecee8855",
      "updated_at": "2022-09-16"
    },
    {
      "name": "java_image_base",
      "version": "latest",
      "version_regex": "^(latest)$",
      "registry": "gcr.io",
      "repository": "distroless/java11",
      "tag": "latest",
      "digest": "sha256:fddf66106c65dd741eb7e01cfcd18a79ddb0abc19cace51343eff972cc8b6cd2",
      "updated_at": "2022-09-16"
    },
    {
      "name": "py3_debug_image_base",
      "version": "debug",
      "version_regex": "^(debug)$",
      "registry": "gcr.io",
      "repository": "distroless/python3",
      "tag": "debug",
      "digest": "sha256:257b8ee88096d5272c5879e20e0bf9eef3a5718b8be0192e4297d4d905ba2f8d",
      "updated_at": "2022-09-16"
    },
    {
      "name": "py3_image_base",
      "version": "latest",
      "version_regex": "^(latest)$",
      "registry": "gcr.io",
      "repository": "distroless/python3",
      "tag": "latest",
      "digest": "sha256:ddaf123a09b09f4004b38d0a6904542df55d52ac58e8a6e990d9396588e16fdc",
      "updated_at": "2022-09-16"
    },
    {
      "name": "go_debug_image_base",
      "version": "debug",
      "version_regex": "^(debug)$",
      "registry": "gcr.io",
      "repository": "distroless/base",
      "tag": "debug",
      "digest": "sha256:e4a7a5d73ebf41921cc9cdd043946c233d3d6650f4495b4383770ccaabc458a6",
      "updated_at": "2022-09-16"
    },
    {
      "name": "go_image_base",
      "version": "latest",
      "version_regex": "^(latest)$",
      "registry": "gcr.io",
      "repository": "distroless/base",
      "tag": "latest",
      "digest": "sha256:4266c0b1808b25215515a8e4359df08a6b0c0058cb6055b14ed1508de40dbd1e",
      "updated_at": "2022-09-16"
    },
    {
      "name": "go_debug_image_static",
      "version": "debug",
      "version_regex": "^(debug)$",
      "registry": "gcr.io",
      "repository": "distroless/static",
      "tag": "debug",
      "digest": "sha256:6534498fd01b529f0297061e26055ada911f9665a80cd1543367601f704d791a",
      "updated_at": "2022-09-16"
    },
    {
      "name": "go_image_static",
      "version": "latest",
      "version_regex": "^(latest)$",
      "registry": "gcr.io",
      "repository": "distroless/static",
      "tag": "latest",
      "digest": "sha256:a7436badb916baa7d92533dfbc7140c329a0d9db1bf81c14151cf89bc01928b4",
      "updated_at": "2022-09-16"
    },
    {
      "name": "io_quay_boleynsu_ci_runner",
      "version": "44ae33bddc7120caa8477ab661e0d03a38e2b750",
      "registry": "quay.io",
      "repository": "boleynsu/ci-runner",
      "tag": "44ae33bddc7120caa8477ab661e0d03a38e2b750",
      "digest": "sha256:7ee41e9c3544fb49378bcab561873aa0150333dc685a2c90cf30188f821f90f9",
      "updated_at": "2022-05-12"
    }
  ],
  "go_deps": [
    {
      "name": "k8s.io/kubectl",
      "version": "v0.25.0",
      "updated_at": "2022-09-16"
    },
    {
      "name": "k8s.io/client-go",
      "version": "v0.25.0",
      "updated_at": "2022-09-16"
    }
  ],
  "toolchain_deps": [
    {
      "name": "bazel",
      "version": "5.1.0",
      "updated_at": "2022-05-06"
    },
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
      "version": "1.18",
      "updated_at": "2022-05-05"
    }
  ]
}
"""

[print("""
deps.bzl is outdated!
deps.bzl is outdated!
deps.bzl is outdated!
The important things should be emphasized three times!
""") if hash(_DEPS_YAML) != 863492985 or hash(_DEPS_JSON) != -556143332 else None]

DEPS = json.decode(_DEPS_JSON)
