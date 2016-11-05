from conans import ConanFile, CMake

class ENetConan(ConanFile):
    name = "ENet"
    version = "1.3.13"
    settings = "os", "compiler", "build_type", "arch"
    options = {"shared": [True, False]}
    default_options = "shared=False"
    url = "http://github.com/inexor-game/conan-ENet"
    license = "MIT"

    def source(self):
        self.run("git clone https://github.com/lsalzman/enet.git")
        # This small hack might be useful to guarantee proper /MT /MD linkage in MSVC
        # if the packaged project doesn't have variables to set it properly
        tools.replace_in_file("enet/CMakeLists.txt", "PROJECT(enet)", '''PROJECT(enet)
        include(${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)
        conan_basic_setup()''')
        if self.options.shared == "True":
            tools.replace_in_file("enet/CMakeLists.txt", "add_library(enet STATIC", "add_library(enet SHARED")

    def config(self):
        del self.settings.compiler.libcxx # We are a pure C lib.

    def build(self):
        cmake = CMake(self.settings)
        self.run('cmake %s/enet %s' % (self.conanfile_directory, cmake.command_line))
        self.run("cmake --build . %s" % cmake.build_config)

    def package(self):
        self.copy('*', dst='include', src='enet/include')
        self.copy("*.lib", dst="lib", src="", keep_path=False)
        self.copy("*.a", dst="lib", src="", keep_path=False)
        self.copy("*.dll", dst="bin", keep_path=False)
        self.copy("*.so", dst="lib", keep_path=False)

    def package_info(self):
        self.cpp_info.libs = ["enet"]  # The libs to link against
        if self.settings.compiler == "Visual Studio":
            self.cpp_info.libs += ["ws2_32", "winmm"]
            if self.options.shared == "True":
                self.cpp_info.defines += ["ENET_DLL"]
        self.cpp_info.includedirs = ['include']  # Ordered list of include paths
        self.cpp_info.libdirs = ['lib']  # Directories where libraries can be found
