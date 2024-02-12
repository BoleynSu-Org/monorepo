load("@rules_oci//oci:defs.bzl", "oci_image")

package(
    default_visibility = ["//visibility:public"],
)

oci_image(
    name = "base",
    base = "@io_quay_boleynsu_base",
    target_compatible_with = select({
        "@platforms//os:linux": [],
        "//conditions:default": ["@platforms//:incompatible"],
    }),
)

oci_image(
    name = "oj-c99runner",
    base = "@io_quay_boleynsu_oj_c99runner",
    target_compatible_with = select({
        "@platforms//os:linux": [],
        "//conditions:default": ["@platforms//:incompatible"],
    }),
)
