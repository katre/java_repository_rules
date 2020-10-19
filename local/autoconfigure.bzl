def _autoconfigure_impl(repo_ctx):
    # TODO: Find a java binary
    # Create a new repository:
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
    pass

_autoconfigure = repository_rule(
    implementation = _autoconfigure_impl,
    local = True,
    configure = True,
)

def autoconfigure(name):
    # Create the actual repo.
    _autoconfigure(name = name)

    # Register the toolchains.
    native.register_toolchains("@%s//:all" % name)
