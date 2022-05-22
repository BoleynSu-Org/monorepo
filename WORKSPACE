workspace(name = "boleynsu_org")

new_local_repository(
    name = "boleynsu_deps_bzl",
    build_file_content = "",
    path = "configs/deps",
)

local_repository(
    name = "boleynsu",
    path = "../..",
)

load("//configs/build:workspace_0.bzl", workspace_0 = "workspace")

workspace_0()

load("//configs/build:workspace_1.bzl", workspace_1 = "workspace")

workspace_1()

load("//configs/build:workspace_2.bzl", workspace_2 = "workspace")

workspace_2()
