def _fake_http_archive_impl(repo_ctx):
    url = repo_ctx.attr.url

    # Don't actually download, just create a fake target.
    repo_ctx.file(
        "BUILD.bazel",
        content = """
package(default_visibility = ["//visibility:public"])

# Fake target for %s
filegroup(name = "archive")
""" % url,
    )

_fake_http_archive = repository_rule(
    implementation = _fake_http_archive_impl,
    attrs = {
        "url": attr.string(mandatory = True),
    },
    local = False,
    configure = False,
)

def _remote_impl(repo_ctx):
    # Create a new repository:
    id = repo_ctx.attr.id
    remote = repo_ctx.attr.remote
    exec_compatible_with = ",".join(["'%s'" % constraint for constraint in repo_ctx.attr.exec_compatible_with])
    target_compatible_with = ",".join(["'%s'" % constraint for constraint in repo_ctx.attr.target_compatible_with])
    repo_ctx.file(
        "BUILD.bazel",
        content = """
package(default_visibility = ["//visibility:public"])

load('@sample_java_rules//:toolchain.bzl', 'sample_java_toolchain')
sample_java_toolchain(
    name = 'remote',
    id = 'remote-%s',
    deps = [
        '%s',
    ],
    # Should depend on remote
)

toolchain(
    name = 'remote_toolchain',
    toolchain_type = '@sample_java_rules//:toolchain_type',
    toolchain = ':remote',
    exec_compatible_with = [%s],
    target_compatible_with = [%s],
)
""" % (id, remote, exec_compatible_with, target_compatible_with),
    )

_remote = repository_rule(
    implementation = _remote_impl,
    attrs = {
        "id": attr.string(default = "default"),
        "remote": attr.label(),
        "exec_compatible_with": attr.string_list(default = []),
        "target_compatible_with": attr.string_list(default = []),
    },
    local = False,
    configure = False,
)

def remote(name, url, **args):
    # Create an http_archive for the url.
    _fake_http_archive(
        name = "%s_archive" % name,
        url = url,
    )

    # Create the actual repo.
    id = url.replace("://", "-").replace("/", "-")
    _remote(
        name = name,
        id = id,
        remote = "@%s_archive//:archive" % name,
        **args
    )

    # Register the toolchains.
    native.register_toolchains("@%s//:all" % name)
