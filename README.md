# cmx

CMake Extensions (or cmx for short) is a collection of useful, cross-platform CMake modules for integrating popular libraries into your projects.
It can be used as a lightweight alternative to vcpkg if the required dependencies are supported. It also provides various utilities like platform, CPU architecture and OS-related compile definitions, as well as useful macros for defining targets more easily.

### Using cmx in your project

In order to use cmx in your own project, you will need to include the cmx-bootstrap module which takes care of downloading all other modules and keeping them up-to-date. In order to add the bootstrap module to your project, use the following command:

```shell
wget https://getcmx.karmakrafts.dev
```

You can also manually download the bootstrapper by following the [aformentioned link](https://getcmx.karmakrafts.dev).

After you added the bootstrapper to your project, you can include cmx by adding the following two lines to your CMakeLists file:

```cmake
set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}")
include(cmx-bootstrap)
```
