def _configure_impl(repo_ctx):
    # Create a new repository:
    path = repo_ctx.attr.path
    id = path.replace("/", "-")
    repo_ctx.file(
        "BUILD.bazel",
        content = """
load('@sample_java_rules//:toolchain.bzl', 'sample_java_toolchain')
sample_java_toolchain(
    name = 'configure',
    id = 'local%s',
)

load('@local_config_platform//:constraints.bzl', 'HOST_CONSTRAINTS')
toolchain(
    name = 'configure_toolchain',
    toolchain_type = '@sample_java_rules//:toolchain_type',
    toolchain = ':configure',
    exec_compatible_with = HOST_CONSTRAINTS,
    target_compatible_with = HOST_CONSTRAINTS,
)
""" % (id),
    )

_configure = repository_rule(
    implementation = _configure_impl,
    attrs = {
        "path": attr.string(mandatory = True),
    },
    local = True,
    configure = True,
)

def configure(name, **args):
    # Create the actual repo.
    _configure(name = name, **args)

    # Register the toolchains.
    native.register_toolchains("@%s//:all" % name)
