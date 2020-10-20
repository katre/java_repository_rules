def _autoconfigure_impl(repo_ctx):
    # TODO: Find a java binary
    # Create a new repository:
    if repo_ctx.attr.found:
        repo_ctx.file(
            "BUILD.bazel",
            content = """
load('@sample_java_rules//:toolchain.bzl', 'sample_java_toolchain')
sample_java_toolchain(
    name = 'autoconfigure',
    id = 'local-auto',
)

load('@local_config_platform//:constraints.bzl', 'HOST_CONSTRAINTS')
toolchain(
    name = 'autoconfigure_toolchain',
    toolchain_type = '@sample_java_rules//:toolchain_type',
    toolchain = ':autoconfigure',
    exec_compatible_with = HOST_CONSTRAINTS,
    target_compatible_with = HOST_CONSTRAINTS,
)
""",
        )
    else:
        # Don't write a toolchain since it wasn't found.
        repo_ctx.file(
            "BUILD.bazel",
            content = "",
        )

_autoconfigure = repository_rule(
    implementation = _autoconfigure_impl,
    attrs = {
        "found": attr.bool(default = True),
    },
    local = True,
    configure = True,
)

def autoconfigure(name, **args):
    # Create the actual repo.
    _autoconfigure(name = name, **args)

    # Register the toolchains.
    native.register_toolchains("@%s//:all" % name)
