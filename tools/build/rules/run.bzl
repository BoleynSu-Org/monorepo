def _run_impl(ctx):
    ctx.actions.run(
        executable = ctx.executable.executable,
        tools = depset(transitive = [tool[DefaultInfo].default_runfiles.files for tool in ctx.attr.tools]),
        env = {k: ctx.expand_location(v, ctx.attr.inputs + ctx.attr.tools) for k, v in ctx.attr.env.items()},
        inputs = ctx.files.inputs,
        outputs = ctx.outputs.outputs,
        arguments = [ctx.expand_location(arg, ctx.attr.inputs + ctx.attr.tools) for arg in ctx.attr.arguments],
        use_default_shell_env = ctx.attr.use_default_shell_env,
        mnemonic = "Run",
    )
    return DefaultInfo(
        files = depset(ctx.outputs.outputs),
        runfiles = ctx.runfiles(files = ctx.outputs.outputs),
        executable = ctx.outputs.outputs[0],
    )

_run = rule(
    implementation = _run_impl,
    attrs = {
        "executable": attr.label(
            executable = True,
            allow_files = True,
            cfg = "exec",
            mandatory = True,
        ),
        "tools": attr.label_list(
            allow_files = True,
            cfg = "exec",
            mandatory = True,
        ),
        "env": attr.string_dict(mandatory = True),
        "inputs": attr.label_list(allow_files = True, mandatory = True),
        "outputs": attr.output_list(mandatory = True),
        "arguments": attr.string_list(mandatory = True),
        "use_default_shell_env": attr.bool(mandatory = True),
        "is_executable": attr.bool(mandatory = True),
    },
)

def run(*, name, executable, tools, outputs, env = {}, inputs = [], arguments = [], use_default_shell_env = True, is_executable = False, **kwargs):
    _run(
        name = name,
        executable = executable,
        tools = tools,
        env = env,
        inputs = inputs,
        outputs = outputs,
        arguments = arguments,
        use_default_shell_env = use_default_shell_env,
        is_executable = is_executable,
        **kwargs
    )
