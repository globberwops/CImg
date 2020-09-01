cmake_minimum_required(VERSION 3.14...3.18)

project(
  CImg
  VERSION 0.221.0
  DESCRIPTION
    "The CImg Library is a small, open-source, and modern C++ toolkit for image processing"
  HOMEPAGE_URL "https://github.com/dtschump/CImg"
  LANGUAGES CXX)

if(CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME)
  option(BUILD_EXAMPLES "Build the examples" OFF)
endif()

add_library(CImg INTERFACE)
add_library(CImg::CImg ALIAS CImg)

target_include_directories(
  CImg INTERFACE $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>)

target_compile_features(CImg INTERFACE cxx_std_11)

set_target_properties(CImg PROPERTIES PUBLIC_HEADER ${CImg_SOURCE_DIR}/CImg.h)

include(GNUInstallDirs)
install(
  TARGETS CImg
  EXPORT CImgTargets
  INCLUDES
  DESTINATION include
  PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

install(
  EXPORT CImgTargets
  FILE CImgTargets.cmake
  NAMESPACE CImg::
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/CImg)

include(CMakePackageConfigHelpers)
write_basic_package_version_file(
  CImgConfigVersion.cmake
  VERSION ${PACKAGE_VERSION}
  COMPATIBILITY AnyNewerVersion ARCH_INDEPENDENT)

configure_package_config_file(
  CImgConfig.cmake.in CImgConfig.cmake
  INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/CImg
  NO_SET_AND_CHECK_MACRO NO_CHECK_REQUIRED_COMPONENTS_MACRO)

install(
  FILES ${CMAKE_CURRENT_BINARY_DIR}/CImgConfig.cmake
        ${CMAKE_CURRENT_BINARY_DIR}/CImgConfigVersion.cmake
        ${CMAKE_CURRENT_BINARY_DIR}/CImgMacros.cmake
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/CImg)

configure_file(CImgMacros.cmake CImgMacros.cmake COPYONLY)

export(
  TARGETS CImg
  NAMESPACE CImg::
  FILE CImgTargets.cmake)

if(CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME)
  set(CPACK_PACKAGE_VENDOR "David Tschumperlé")
  set(CPACK_RESOURCE_FILE_LICENSE
      "${CMAKE_CURRENT_SOURCE_DIR}/Licence_CeCILL_V2-en.txt")
  set(CPACK_RESOURCE_FILE_README "${CMAKE_CURRENT_SOURCE_DIR}/README.md")
  set(CPACK_SOURCE_GENERATOR "TGZ;ZIP")
  set(CPACK_SOURCE_IGNORE_FILES /.travis.yml /compile_commands.json /.git /dist
                                /.*build.* /\\\\.DS_Store)
  include(CPack)
endif()

if((CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME OR CImg_BUILD_EXAMPLES)
   AND BUILD_EXAMPLES)
  # add_subdirectory(examples)
endif()
