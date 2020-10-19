# Java Repository Rules

This repository is an example of some ways to use repository rules to configure
Java toolchains in Bazel.

## Code layout

There are several directories, as well at the actual use case samples.

-  `sample_java_rules`: A sample set of toolchain-using rules to demonstrate the
   layout.
   -  `rules.bzl`: The actual rule implementation. Just prints out what
      toolchain was selected.
   -  `toolchain.bzl`: The toolchain provider and a rule to generate it.
-  `local`: A repository which handles locally-installed toolchains.
   -  `autoconfigure.bzl`: Automatically configures a toolchain based on
      detecting locally installed programs.

## Use Case 1: No Configuration, No Local JDK

The WORKSPACE includes `@local//:autoconfigure.bzl`, but this could as easily
have been installed in the WORKSPACE suffix by Bazel.

```
$ cd 01_no_conf_no_local_jdk
$ bazel build //:main
DEBUG: /usr/local/google/home/jcater/.cache/bazel/_bazel_jcater/830ba95a5e288ac0918d8e6bf8272de4/external/sample_java_rules/rules.bzl:5:10: sample_java_binary: target //:main has toolchain local-auto
INFO: Analyzed target //:main (12 packages loaded, 27 targets configured).
INFO: Found 1 target...
Target //:main up-to-date (nothing to build)
INFO: Elapsed time: 2.799s, Critical Path: 0.03s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
```


## Use Case 2: No Configuration, Local JDK Installed

## Use Case 3: Configure Specific Local JDK

## Use Case 4: Configure Specific Remote JDK

## Use Case 5: Specify Java Language Version

