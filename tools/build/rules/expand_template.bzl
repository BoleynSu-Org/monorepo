def _expand_template_impl(ctx):
    ctx.actions.expand_template(
        template = ctx.file.template,
        output = ctx.outputs.output,
        substitutions = ctx.attr.substitutions if not ctx.attr.expand_location_for else {
            k: ctx.expand_location(v, targets = ctx.attr.expand_location_for)
            for k, v in ctx.attr.substitutions.items()
        },
        is_executable = ctx.attr.is_executable,
    )
    files = depset(direct = [ctx.outputs.output])
    runfiles = ctx.runfiles(files = [ctx.outputs.output])
    if ctx.attr.is_executable:
        return [DefaultInfo(files = files)]
    else:
        return [DefaultInfo(files = files, runfiles = runfiles, executable = ctx.outputs.output)]

_expand_template = rule(
    implementation = _expand_template_impl,
    attrs = {
        "template": attr.label(allow_single_file = True, mandatory = True),
        "substitutions": attr.string_dict(mandatory = True),
        "expand_location_for": attr.label_list(allow_files = True, mandatory = True),
        "output": attr.output(mandatory = True),
        "is_executable": attr.bool(mandatory = True),
    },
    provides = [DefaultInfo],
)

def expand_template(*, name, substitutions, expand_location_for = [], template = None, output = None, is_executable = False, **kwargs):
    if not substitutions:
        fail("Please use copy_file provided by @bazel_skylib instead!")
    if template == None:
        template = name + ".tpl"
    if output == None:
        output = name + ".tpl.out"
    _expand_template(
        name = name,
        template = template,
        substitutions = substitutions,
        expand_location_for = expand_location_for,
        output = output,
        is_executable = is_executable,
        **kwargs
    )
