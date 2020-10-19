SampleJavaToolchain = provider("Sample toolchain", fields = ["id"])

def _sample_java_toolchain(ctx):
    provider = SampleJavaToolchain(id = ctx.attr.id)
    toolchain_info = platform_common.ToolchainInfo(sample_java_toolchain = provider)
    return [toolchain_info]

sample_java_toolchain = rule(
    implementation = _sample_java_toolchain,
    attrs = {
        "id": attr.string(mandatory = True),
    },
)
