def _expand_template_impl(ctx):
    ctx.actions.expand_template(
        template = ctx.file.template,
        output = ctx.outputs.out,
        substitutions = ctx.attr.substitutions,
        is_executable = ctx.attr.is_executable,
    )
    files = depset(direct = [ctx.outputs.out])
    runfiles = ctx.runfiles(files = [ctx.outputs.out])
    return [DefaultInfo(files = files, runfiles = runfiles, executable = ctx.outputs.out)]

_expand_template = rule(
    implementation = _expand_template_impl,
    attrs = {
        "template": attr.label(allow_single_file = True, mandatory = True),
        "substitutions": attr.string_dict(mandatory = True),
        "out": attr.output(mandatory = True),
        "is_executable": attr.bool(mandatory = True),
    },
    provides = [DefaultInfo],
)

def expand_template(*, name, substitutions, template = None, out = None, is_executable = False, **kwargs):
    if not substitutions:
        fail("Please use copy_file provided by @bazel_skylib instead!")
    if template == None:
        template = name + ".tpl"
    if out == None:
        out = name + ".tpl.out"
    _expand_template(
        name = name,
        template = template,
        substitutions = substitutions,
        out = out,
        is_executable = is_executable,
        **kwargs
    )
