def _run_impl(ctx):
    ctx.actions.run(
        outputs = ctx.outputs.outputs,
        inputs = ctx.files.inputs,
        executable = ctx.executable.executable,
        tools = depset(transitive = [tool[DefaultInfo].default_runfiles.files for tool in ctx.attr.tools]),
        arguments = [ctx.expand_location(arg, ctx.attr.inputs + ctx.attr.tools) for arg in ctx.attr.arguments],
        mnemonic = ctx.expand_location(ctx.attr.mnemonic, ctx.attr.inputs + ctx.attr.tools) or None,
        progress_message = ctx.expand_location(ctx.attr.progress_message, ctx.attr.inputs + ctx.attr.tools) or None,
        use_default_shell_env = ctx.attr.use_default_shell_env,
        env = {k: ctx.expand_location(v, ctx.attr.inputs + ctx.attr.tools) for k, v in ctx.attr.env.items()},
    )
    if ctx.attr.is_executable:
        if len(ctx.outputs.outputs) != 1:
            fail("If is_executable is set to true, there should be only one output.")
        return [
            DefaultInfo(
                files = depset(ctx.outputs.outputs),
                runfiles = ctx.runfiles(files = ctx.outputs.outputs),
                executable = ctx.outputs.outputs[0],
            ),
        ]
    else:
        return [
            DefaultInfo(
                files = depset(ctx.outputs.outputs),
            ),
        ]

run = rule(
    implementation = _run_impl,
    attrs = {
        "outputs": attr.output_list(allow_empty = False, mandatory = True),
        "inputs": attr.label_list(allow_files = True),
        "executable": attr.label(
            executable = True,
            cfg = "exec",
            mandatory = True,
        ),
        "tools": attr.label_list(
            allow_files = True,
            cfg = "exec",
        ),
        "arguments": attr.string_list(),
        "mnemonic": attr.string(),
        "progress_message": attr.string(),
        "use_default_shell_env": attr.bool(),
        "env": attr.string_dict(),
        "is_executable": attr.bool(),
    },
)
