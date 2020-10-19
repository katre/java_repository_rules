load(":toolchain.bzl", "SampleJavaToolchain")

def _sample_java_binary(ctx):
    toolchain = ctx.toolchains["@sample_java_rules//:toolchain_type"].sample_java_toolchain
    print("sample_java_binary: target %s has toolchain %s" % (ctx.label, toolchain.id))
    pass

sample_java_binary = rule(
    implementation = _sample_java_binary,
    toolchains = ["@sample_java_rules//:toolchain_type"],
)
