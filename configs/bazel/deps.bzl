# DO NOT EDIT! This file is auto-generated.
# Run `bazel run //configs/bazel:deps_bzl.genfile` to regenerate.

_DEPS_JSON = r"""
{
  "metadata": {
    "name": "boleynsu_org",
    "pin_cmd": "bazel run //cmd/infra/deps:update",
    "include": [
      "@boleynsu_org//third_party/io_grpc_grpc_java:deps_yaml"
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
      "sha256": "c8f8f5ff4813d8248df38e5b1c5a31e0314578a8c53938141e8e1ea4af6cdee9",
      "url": "https://github.com/bazelbuild/rules_java/archive/refs/tags/7.4.0.tar.gz",
      "strip_prefix": "rules_java-7.4.0",
      "updated_at": "2024-02-09",
      "version": "7.4.0",
      "load_deps": "load(\"@rules_java//java:repositories.bzl\", \"java_tools_repos\", \"remote_jdk21_repos\")\ndef deps():\n  java_tools_repos()\n  remote_jdk21_repos()\n"
    },
    {
      "name": "rules_python",
      "type": "http_archive",
      "sha256": "c68bdc4fbec25de5b5493b8819cfc877c4ea299c0dcb15c244c5a00208cde311",
      "strip_prefix": "rules_python-0.31.0",
      "url": "https://github.com/bazelbuild/rules_python/archive/refs/tags/0.31.0.tar.gz",
      "updated_at": "2024-02-16",
      "version": "0.31.0",
      "load_deps": "load(\"@rules_python//python/private:internal_config_repo.bzl\", \"internal_config_repo\")\nload(\"@rules_python//python/pip_install:repositories.bzl\", \"pip_install_dependencies\")\nload(\"@rules_python//python:repositories.bzl\", \"python_register_toolchains\")\nload(\"@rules_python//python/private:toolchains_repo.bzl\", \"toolchains_repo\")\nload(\"@bazel_deps//:toolchain_deps.bzl\", \"PYTHON_VERSION\")\ndef deps():\n  internal_config_repo(name = \"rules_python_internal\")\n  pip_install_dependencies()\n  python_register_toolchains(\n    name = \"python_sdk\",\n    python_version = PYTHON_VERSION,\n    register_toolchains = False,\n  )\n  toolchains_repo(\n      name = \"python_sdk_toolchains\",\n      python_version = PYTHON_VERSION,\n      set_python_version_constraint = False,\n      user_repository_name = \"python_sdk\",\n  )\n"
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
      "load_deps": "load(\"@rules_proto//proto:repositories.bzl\", \"rules_proto_dependencies\")\ndef deps():\n  rules_proto_dependencies()\n",
      "patch_cmds": [
        "sed -i 's/protobuf_workspace(name = \"com_google_protobuf\")//g' proto/repositories.bzl"
      ]
    },
    {
      "name": "io_bazel_rules_go",
      "module_name": "rules_go",
      "type": "http_archive",
      "sha256": "3ff4f1607c010b2785400ce37141400d24133099529947f7850b50a8d95cafe6",
      "url": "https://github.com/bazelbuild/rules_go/archive/refs/tags/v0.46.0.tar.gz",
      "updated_at": "2024-02-10",
      "version": "v0.46.0",
      "strip_prefix": "rules_go-0.46.0",
      "load_deps": "load(\"@io_bazel_rules_go//go:deps.bzl\", \"go_download_sdk\")\nload(\"@io_bazel_rules_go//go/private:nogo.bzl\", \"go_register_nogo\", \"DEFAULT_NOGO\")\nload(\"@bazel_deps//:toolchain_deps.bzl\", \"GOLANG_VERSION\")\ndef deps():\n  go_register_nogo(\n      name = \"io_bazel_rules_nogo\",\n      nogo = DEFAULT_NOGO,\n  )\n  go_download_sdk(\n      name = \"go_linux_amd64\",\n      goos = \"linux\",\n      goarch = \"amd64\",\n      version = GOLANG_VERSION,\n      register_toolchains = False,\n  )\n",
      "patch_cmds": [
        "sed -i 's/io_bazel_rules_go_bazel_features/bazel_features/g' MODULE.bazel go/private/*.bzl"
      ]
    },
    {
      "name": "rules_oci",
      "type": "http_archive",
      "url": "https://github.com/bazel-contrib/rules_oci/archive/refs/tags/v1.7.4.tar.gz",
      "sha256": "4a276e9566c03491649eef63f27c2816cc222f41ccdebd97d2c5159e84917c3b",
      "strip_prefix": "rules_oci-1.7.4",
      "updated_at": "2024-02-28",
      "version": "v1.7.4",
      "load_deps": "load(\"@rules_oci//oci:repositories.bzl\", \"LATEST_CRANE_VERSION\", \"oci_register_toolchains\")\ndef deps():\n  oci_register_toolchains(\n      name = \"oci\",\n      crane_version = LATEST_CRANE_VERSION,\n  )\n"
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
      "sha256": "a566f1c84dbc09c19b3086bdfe9ffc2e02058675067a8286fb11a604508a4a09",
      "strip_prefix": "rules_jvm_external-6.0",
      "url": "https://github.com/bazelbuild/rules_jvm_external/archive/refs/tags/6.0.tar.gz",
      "updated_at": "2024-01-19",
      "version": "6.0"
    },
    {
      "name": "rules_pkg",
      "type": "http_archive",
      "url": "https://github.com/bazelbuild/rules_pkg/archive/refs/tags/0.10.1.tar.gz",
      "sha256": "d330dbe3e3004241ddb9b377416ffc5c823e3e2c08c0d56a7e1935499e7f8577",
      "updated_at": "2024-02-16",
      "version": "0.10.1",
      "strip_prefix": "rules_pkg-0.10.1"
    },
    {
      "name": "io_grpc_grpc_java",
      "type": "http_archive",
      "sha256": "30cfc954c2174493822601a74b876837986c444d9b9e917082994b5e34348f34",
      "strip_prefix": "grpc-java-1.62.2",
      "url": "https://github.com/grpc/grpc-java/archive/refs/tags/v1.62.2.tar.gz",
      "updated_at": "2024-02-27",
      "version": "v1.62.2",
      "load_deps": "load(\"@io_grpc_grpc_java//:repositories.bzl\", \"grpc_java_repositories\")\ndef deps():\n  grpc_java_repositories()\n",
      "module_file": "@boleynsu_org//third_party/io_grpc_grpc_java:repo.MODULE.bazel"
    },
    {
      "name": "bazel_gazelle",
      "module_name": "gazelle",
      "type": "http_archive",
      "sha256": "a0ee1d304f7caa46680ba06bdef0e5d9ec8815f6e01ec29398efd13256598c3f",
      "url": "https://github.com/bazelbuild/bazel-gazelle/archive/refs/tags/v0.35.0.tar.gz",
      "updated_at": "2023-12-21",
      "version": "v0.35.0",
      "strip_prefix": "bazel-gazelle-0.35.0",
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
      "build_file": "@boleynsu_org//third_party/com_github_cdolivet_editarea:repo.BUILD"
    },
    {
      "name": "llvm_linux_x86_64",
      "type": "http_archive",
      "url": "https://github.com/llvm/llvm-project/releases/download/llvmorg-17.0.6/clang+llvm-17.0.6-x86_64-linux-gnu-ubuntu-22.04.tar.xz",
      "sha256": "884ee67d647d77e58740c1e645649e29ae9e8a6fe87c1376be0f3a30f3cc9ab3",
      "strip_prefix": "clang+llvm-17.0.6-x86_64-linux-gnu-ubuntu-22.04",
      "version": "llvmorg-17.0.6",
      "version_regex": "llvmorg-(.*)",
      "updated_at": "2023-11-28",
      "module_file_content": "module(\n    name = \"llvm_linux_x86_64\",\n    version = \"0.0.0\",\n    compatibility_level = 1,\n)\n",
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
      "name": "toolchains_llvm",
      "type": "http_archive",
      "url": "https://github.com/bazel-contrib/toolchains_llvm/archive/refs/tags/0.10.3.tar.gz",
      "sha256": "22c100d9540669405d14f13ff4cf1101f2a768917211f9f67f3c37a7d3207ea7",
      "strip_prefix": "toolchains_llvm-0.10.3",
      "updated_at": "2024-02-20",
      "version": "0.10.3",
      "module_file": "@boleynsu_org//third_party/toolchains_llvm:repo.MODULE.bazel",
      "patches": [
        "@boleynsu_org//third_party/toolchains_llvm:bzl.patch"
      ],
      "load_deps": "load(\"@toolchains_llvm//toolchain:rules.bzl\", \"llvm_toolchain\")\nload(\"@bazel_deps//:bazel_deps.bzl\", \"BAZEL_DEPS\")\ndef deps():\n  llvm_toolchain(\n      name = \"llvm_toolchain_linux_x86_64\",\n      llvm_version = BAZEL_DEPS[\"llvm_linux_x86_64\"][\"version\"][len(\"llvmorg-\"):],\n      exec_os = \"linux\",\n      exec_cpu = \"x86_64\",\n      urls = {\n          \"linux-x86_64\": [BAZEL_DEPS[\"llvm_linux_x86_64\"][\"url\"]],\n      },\n      strip_prefix = {\n          \"linux-x86_64\": BAZEL_DEPS[\"llvm_linux_x86_64\"][\"strip_prefix\"],\n      },\n      sha256 = {\n          \"linux-x86_64\": BAZEL_DEPS[\"llvm_linux_x86_64\"][\"sha256\"],\n      },\n      sysroot = {\n          \"linux-x86_64\": \"@sysroot_linux_x86_64//:sysroot\",\n      },\n  )\n"
    },
    {
      "name": "bazel_linux_x86_64",
      "type": "http_archive",
      "version": "7.1.0",
      "url": "https://github.com/bazelbuild/bazel/releases/download/7.1.0/bazel-7.1.0-installer-linux-x86_64.sh",
      "archive_type": "zip",
      "sha256": "5891b435ab1a906be90523a807d9851a2ba5941395396a9c742fe25012d52da1",
      "updated_at": "2024-03-11",
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
      "sha256": "8c1155797cb5f5697ea8c6eac6c154cf51aa020e368813d9d9b949558c84f2da",
      "strip_prefix": "rules_license-0.0.8",
      "url": "https://github.com/bazelbuild/rules_license/archive/refs/tags/0.0.8.tar.gz",
      "updated_at": "2024-01-24",
      "version": "0.0.8"
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
      "url": "https://dl.k8s.io/release/v1.29.2/bin/linux/amd64/kubectl",
      "sha256": "7816d067740f47f949be826ac76943167b7b3a38c4f0c18b902fffa8779a5afa",
      "version": "v1.29.2",
      "updated_at": "2024-02-16",
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
    },
    {
      "name": "sysroot_linux_x86_64",
      "type": "http_archive",
      "version": "20240301.082747",
      "sha256": "14de5b35fc8dd6954f708226e1008da3819f0b94e7ac5119fdee66067343048d",
      "url": "https://public-artifacts.storage.boleyn.su/prebuilt/sysroot/20240301.082747/sysroot_linux_x86_64.tar.gz",
      "updated_at": "2024-03-01",
      "build_file_content": "filegroup(\n    name = \"sysroot\",\n    srcs = glob([\"**\"], exclude = [\"etc/shadow\", \"etc/gshadow\"]),\n    visibility = [\"//visibility:public\"],\n)\n",
      "patch_cmds": [
        "chmod -R 755 ."
      ]
    },
    {
      "name": "bazel_features",
      "type": "http_archive",
      "version": "v1.9.0",
      "commit": "8e490647a04dae5ec92342d6f29d893d7b177584",
      "sha256": "06f02b97b6badb3227df2141a4b4622272cdcd2951526f40a888ab5f43897f14",
      "strip_prefix": "bazel_features-1.9.0",
      "url": "https://github.com/bazel-contrib/bazel_features/releases/download/v1.9.0/bazel_features-v1.9.0.tar.gz",
      "github_repo": "bazel-contrib/bazel_features",
      "updated_at": "2024-03-08",
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
          "cmd": "echo DEPS_UPDATER_url=https://github.com/bazel-contrib/bazel_features/releases/download/${DEPS_UPDATER_version}/bazel_features-${DEPS_UPDATER_version}.tar.gz\necho DEPS_UPDATER_strip_prefix=bazel_features-${DEPS_UPDATER_version#v}\n"
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
      "load_deps": "load(\"@bazel_features//:deps.bzl\", \"bazel_features_deps\")\ndef deps():\n  bazel_features_deps()\n"
    },
    {
      "name": "com_google_protobuf",
      "module_name": "protobuf",
      "type": "http_archive",
      "url": "https://github.com/protocolbuffers/protobuf/archive/refs/tags/v3.19.6.tar.gz",
      "sha256": "9a301cf94a8ddcb380b901e7aac852780b826595075577bb967004050c835056",
      "strip_prefix": "protobuf-3.19.6",
      "version": "v3.19.6",
      "version_regex": "^v(3)\\.([0-9.]*)$",
      "updated_at": "2024-01-06",
      "module_file_content": "module(\n    name = \"protobuf\",\n    version = \"3.19.6\",\n    compatibility_level = 1,\n    repo_name = \"com_google_protobuf\",\n)\nbazel_dep(name = \"bazel_skylib\", version = \"1.0.3\")\nbazel_dep(name = \"zlib\", version = \"1.2.12\")\nbazel_dep(name = \"rules_python\", version = \"0.4.0\")\nbazel_dep(name = \"rules_cc\", version = \"0.0.1\")\nbazel_dep(name = \"rules_proto\", version = \"4.0.0\")\nbazel_dep(name = \"rules_java\", version = \"4.0.0\")\nbazel_dep(name = \"rules_jvm_external\", version = \"0.0.0\")\n"
    },
    {
      "name": "zlib",
      "type": "http_archive",
      "url": "https://github.com/madler/zlib/releases/download/v1.3.1/zlib-1.3.1.tar.gz",
      "sha256": "9a93b2b7dfdac77ceba5a558a580e74667dd6fede4585b91eefb60f03b72df23",
      "strip_prefix": "zlib-1.3.1",
      "version": "v1.3.1",
      "updated_at": "2024-01-22",
      "module_file_content": "module(\n    name = \"zlib\",\n    version = \"1.3\",\n    compatibility_level = 1,\n)\nbazel_dep(name = \"platforms\", version = \"0.0.7\")\nbazel_dep(name = \"rules_cc\", version = \"0.0.8\")\n",
      "build_file": "@com_google_protobuf//third_party:zlib.BUILD",
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
          "cmd": "echo DEPS_UPDATER_url=https://github.com/madler/zlib/releases/download/${DEPS_UPDATER_version}/zlib-${DEPS_UPDATER_version#v}.tar.gz\necho DEPS_UPDATER_strip_prefix=zlib-${DEPS_UPDATER_version#v}\n"
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
      "name": "apple_support",
      "type": "http_archive",
      "url": "https://github.com/bazelbuild/apple_support/releases/download/1.14.0/apple_support.1.14.0.tar.gz",
      "sha256": "a8ba6fd09d0ffeba9b5f398f3a46262470fe0addddb4ef5afa7eab18d001a7b0",
      "version": "1.14.0",
      "updated_at": "2024-02-22",
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
          "cmd": "echo DEPS_UPDATER_url=https://github.com/bazelbuild/apple_support/releases/download/${DEPS_UPDATER_version}/apple_support.${DEPS_UPDATER_version}.tar.gz\n"
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
      "name": "stardoc",
      "type": "http_archive",
      "url": "https://github.com/bazelbuild/stardoc/releases/download/0.6.2/stardoc-0.6.2.tar.gz",
      "sha256": "62bd2e60216b7a6fec3ac79341aa201e0956477e7c8f6ccc286f279ad1d96432",
      "version": "0.6.2",
      "updated_at": "2024-01-06",
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
          "cmd": "echo DEPS_UPDATER_url=https://github.com/bazelbuild/stardoc/releases/download/${DEPS_UPDATER_version}/stardoc-${DEPS_UPDATER_version}.tar.gz\n"
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
      "name": "rules_kotlin",
      "type": "http_archive",
      "url": "https://github.com/bazelbuild/rules_kotlin/releases/download/v1.9.1/rules_kotlin-v1.9.1.tar.gz",
      "sha256": "d9898c3250e0442436eeabde4e194c30d6c76a4a97f517b18cefdfd4e345725a",
      "version": "v1.9.1",
      "updated_at": "2024-03-01",
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
          "cmd": "echo DEPS_UPDATER_url=https://github.com/bazelbuild/rules_kotlin/releases/download/${DEPS_UPDATER_version}/rules_kotlin-${DEPS_UPDATER_version}.tar.gz\n"
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
      "name": "aspect_bazel_lib",
      "type": "http_archive",
      "version": "v2.5.3",
      "commit": "8e490647a04dae5ec92342d6f29d893d7b177584",
      "sha256": "6c25c59581041ede31e117693047f972cc4700c89acf913658dc89d04c338f8d",
      "strip_prefix": "bazel-lib-2.5.3",
      "url": "https://github.com/aspect-build/bazel-lib/releases/download/v2.5.3/bazel-lib-v2.5.3.tar.gz",
      "github_repo": "aspect-build/bazel-lib",
      "updated_at": "2024-03-08",
      "module_file": "@boleynsu_org//third_party/aspect_bazel_lib:repo.MODULE.bazel",
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
          "cmd": "echo DEPS_UPDATER_url=https://github.com/aspect-build/bazel-lib/releases/download/${DEPS_UPDATER_version}/bazel-lib-${DEPS_UPDATER_version}.tar.gz\necho DEPS_UPDATER_strip_prefix=bazel-lib-${DEPS_UPDATER_version#v}\n"
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
      "version": "0.18.6",
      "updated_at": "2024-02-07"
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
      "version": "2.15.1",
      "updated_at": "2023-11-30"
    },
    {
      "name": "org.mariadb.jdbc:mariadb-java-client",
      "version": "3.3.3",
      "updated_at": "2024-02-21"
    },
    {
      "name": "org.apache.tomcat.embed:tomcat-embed-core",
      "version": "10.1.19",
      "updated_at": "2024-02-20"
    },
    {
      "name": "org.apache.tomcat.embed:tomcat-embed-jasper",
      "version": "10.1.19",
      "updated_at": "2024-02-20"
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
      "version": "2.3.12.Final",
      "version_regex": "(.*)\\.Final",
      "updated_at": "2024-02-21"
    },
    {
      "name": "commons-validator:commons-validator",
      "version": "1.8.0",
      "updated_at": "2023-12-14"
    },
    {
      "name": "commons-codec:commons-codec",
      "version": "1.16.1",
      "updated_at": "2024-02-09"
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
      "version": "2.29.0",
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
      "version": "1.10.4",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "com.google.auto.value:auto-value-annotations",
      "version": "1.10.4",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "com.google.errorprone:error_prone_annotations",
      "version": "2.23.0",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "com.google.guava:failureaccess",
      "version": "1.0.1",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "com.google.guava:guava",
      "version": "32.1.3-android",
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
      "version": "4.1.100.Final",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.netty:netty-codec-http2",
      "version": "4.1.100.Final",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.netty:netty-codec-http",
      "version": "4.1.100.Final",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.netty:netty-codec-socks",
      "version": "4.1.100.Final",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.netty:netty-codec",
      "version": "4.1.100.Final",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.netty:netty-common",
      "version": "4.1.100.Final",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.netty:netty-handler-proxy",
      "version": "4.1.100.Final",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.netty:netty-handler",
      "version": "4.1.100.Final",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.netty:netty-resolver",
      "version": "4.1.100.Final",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.netty:netty-tcnative-boringssl-static",
      "version": "2.0.61.Final",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.netty:netty-transport-native-epoll:jar:linux-x86_64",
      "version": "4.1.100.Final",
      "included_from": "io_grpc_grpc_java"
    },
    {
      "name": "io.netty:netty-transport",
      "version": "4.1.100.Final",
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
      "version": "4.1.100.Final",
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
      "name": "io_quay_boleynsu_ci_runner",
      "version": "20240311.220429",
      "registry": "quay.io",
      "repository": "boleynsu/ci-runner",
      "tag": "20240311.220429",
      "digest": "sha256:c6419347d9080138c70185a0d93269da593d819487aaf46cf17449b15ba4eccb",
      "updated_at": "2024-03-12"
    },
    {
      "name": "io_docker_library_mariadb",
      "version": "latest",
      "version_regex": "^(latest)$",
      "registry": "docker.io",
      "repository": "library/mariadb",
      "tag": "latest",
      "digest": "sha256:a009cebdcd294d08590817a3ebdf3da822a1509187ba946ab7b384c8a333ac94",
      "updated_at": "2024-03-12",
      "platforms": [
        "linux/amd64",
        "linux/arm64/v8",
        "linux/ppc64le",
        "linux/s390x"
      ]
    },
    {
      "name": "io_docker_library_adminer",
      "version": "4.8.1",
      "registry": "docker.io",
      "repository": "library/adminer",
      "tag": "4.8.1",
      "digest": "sha256:8b2866201eabaac2f6d965f8033748bf0bf25d021a5450c179e6b6f8bd139ecc",
      "updated_at": "2024-03-12",
      "platforms": [
        "linux/amd64",
        "linux/arm/v5",
        "linux/arm/v7",
        "linux/arm64/v8",
        "linux/386",
        "linux/mips64le",
        "linux/ppc64le",
        "linux/s390x"
      ]
    },
    {
      "name": "io_docker_filebrowser_filebrowser",
      "version": "v2.27.0",
      "registry": "docker.io",
      "repository": "filebrowser/filebrowser",
      "tag": "v2.27.0",
      "digest": "sha256:00b75afd52a92e4525e3bcaf61caa2a31b8d878a5b371380686b1145cb0424fd",
      "updated_at": "2024-02-10",
      "platforms": [
        "linux/amd64",
        "linux/arm64",
        "linux/arm/v7"
      ]
    },
    {
      "name": "io_quay_boleynsu_oj_c99runner",
      "version": "20240308.160131",
      "registry": "quay.io",
      "repository": "boleynsu/oj-c99runner",
      "tag": "20240308.160131",
      "digest": "sha256:5cf7630d66757c87ba3ff93850c57fdf989a652878055b1306ba6e09e8c17cfc",
      "updated_at": "2024-03-08"
    },
    {
      "name": "io_quay_boleynsu_rbe_fedora",
      "version": "20240308.160131",
      "registry": "quay.io",
      "repository": "boleynsu/rbe-fedora",
      "tag": "20240308.160131",
      "digest": "sha256:3436de91b8d15e12fb77c5e43ad2dbb15d5eb13c8e0e566d341b188479773910",
      "updated_at": "2024-03-08"
    },
    {
      "name": "io_quay_boleynsu_base",
      "registry": "quay.io",
      "repository": "boleynsu/base",
      "digest": "sha256:f940f55dc1b9dfb5f64496671634f4987472bec636a7b17db416b14124395da1",
      "version": "20240308.160131",
      "tag": "20240308.160131",
      "updated_at": "2024-03-08"
    }
  ],
  "go_deps": [
    {
      "name": "github.com/google/go-containerregistry",
      "version": "v0.19.0",
      "updated_at": "2024-01-29"
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
      "updated_at": "2023-12-14"
    },
    {
      "name": "golang",
      "version": "1.20.12",
      "updated_at": "2023-12-14"
    }
  ]
}
"""

DEPS = json.decode(_DEPS_JSON) if hash(_DEPS_JSON) == -668462797 else fail("deps.bzl is corrupted")
