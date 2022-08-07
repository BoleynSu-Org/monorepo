load("@bazel_tools//tools/cpp:toolchain_utils.bzl", "find_cpp_toolchain", "use_cpp_toolchain")
load("@rules_cc//cc:action_names.bzl", "CPP_COMPILE_ACTION_NAME")

def _get_compilation_contexts_from_deps(deps):
    compilation_contexts = []
    for dep in deps:
        if CcInfo in dep:
            compilation_contexts.append(dep[CcInfo].compilation_context)
    return compilation_contexts

def _cc_build_failure_impl(ctx):
    compilation_context = cc_common.merge_compilation_contexts(compilation_contexts = _get_compilation_contexts_from_deps(ctx.attr.deps))

    cc_toolchain = find_cpp_toolchain(ctx)
    feature_configuration = cc_common.configure_features(
        ctx = ctx,
        cc_toolchain = cc_toolchain,
        requested_features = ctx.features,
        unsupported_features = ctx.disabled_features,
    )
    cc_compiler_path = cc_common.get_tool_for_action(
        feature_configuration = feature_configuration,
        action_name = CPP_COMPILE_ACTION_NAME,
    )

    output_files = []
    for source_file in ctx.files.srcs:
        output_file = ctx.actions.declare_file(source_file.short_path + ".o")
        output_files.append(output_file)

        cc_compile_variables = cc_common.create_compile_variables(
            feature_configuration = feature_configuration,
            cc_toolchain = cc_toolchain,
            user_compile_flags = ctx.fragments.cpp.copts + ctx.fragments.cpp.cxxopts,
            source_file = source_file.path,
            output_file = output_file.path,
        )
        command_line = cc_common.get_memory_inefficient_command_line(
            feature_configuration = feature_configuration,
            action_name = CPP_COMPILE_ACTION_NAME,
            variables = cc_compile_variables,
        )
        env = cc_common.get_environment_variables(
            feature_configuration = feature_configuration,
            action_name = CPP_COMPILE_ACTION_NAME,
            variables = cc_compile_variables,
        )

        args = ctx.actions.args()
        args.add(source_file)
        args.add(output_file)
        args.add(cc_compiler_path)
        args.add_all(command_line)
        args.add_all(compilation_context.defines, before_each = "-D")
        args.add_all(compilation_context.local_defines, before_each = "-D")
        args.add_all(compilation_context.framework_includes, before_each = "-F")
        args.add_all(compilation_context.includes, before_each = "-I")
        args.add_all(compilation_context.quote_includes, before_each = "-iquote")
        args.add_all(compilation_context.system_includes, before_each = "-isystem")
        ctx.actions.run(
            executable = ctx.executable._cc_build_failure,
            arguments = [args],
            env = env,
            inputs = depset(
                [source_file],
                transitive = [cc_toolchain.all_files, compilation_context.headers],
            ),
            outputs = [output_file],
        )
    return [
        DefaultInfo(files = depset(output_files)),
    ]

cc_build_failure = rule(
    implementation = _cc_build_failure_impl,
    attrs = {
        "srcs": attr.label_list(mandatory = True, allow_files = True),
        "deps": attr.label_list(providers = [CcInfo]),
        "_cc_toolchain": attr.label(default = "@bazel_tools//tools/cpp:current_cc_toolchain"),
        "_cc_build_failure": attr.label(
            default = "//tools/build/rules:cc_build_failure_sh",
            executable = True,
            cfg = "exec",
        ),
    },
    toolchains = use_cpp_toolchain(),
    fragments = ["cpp"],
)
