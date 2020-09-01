#[========================================[.rst:
CImgMacros
----------

A ``CImg`` module for CMake.

Adds the :command:`setup_target_for_cimg`,
and provides options the following options:

``LINK_PUBLIC``
  link components publicly
``LINK_PRIVATE``
  link components privately
``FIND_QUIET``
  find components quietly
``REQUIRE_COMPONENTS``
  require components to be found
``COMPONENTS``
  the components to be used

.. code-block:: cmake
   setup_target_for_cimg(
     <target>
     [LINK_PUBLIC|LINK_PRIVATE]
     [FIND_QUIET]
     [REQUIRE_COMPONENTS]
     [COMPONENTS
       [CURL]
       [FFMPEG]
       [FFTW3]
       [JPEG]
       [LAPACK]
       [Magick++]
       [OpenCV]
       [OpenEXR]
       [OpenMP]
       [PNG]
       [Threads]
       [TIFF]
       [X11]
       [ZLIB]])

#]========================================]

include_guard(GLOBAL)

function(SETUP_TARGET_FOR_CIMG)
  cmake_parse_arguments(
    PARSE_ARGV 1 SETUP_TARGET_FOR_CIMG
    "LINK_PUBLIC;LINK_PRIVATE;FIND_QUIET;REQUIRE_COMPONENTS" "" "COMPONENTS")

  if(SETUP_TARGET_FOR_CIMG_LINK_PRIVATE)
    set(_cimg_link PRIVATE)
  else()
    set(_cimg_link PUBLIC)
  endif()

  if(SETUP_TARGET_FOR_CIMG_FIND_QUIET)
    set(_cimg_quiet QUIET)
  endif()

  if(SETUP_TARGET_FOR_CIMG_REQUIRE_COMPONENTS)
    set(_cimg_required REQUIRED)
  endif()

  if(NOT TARGET "${ARGV0}")
    message(FATAL_ERROR "\"${ARGV0}\" is not a valid target. Aborting...")
  else()
    set(_cimg_target "${ARGV0}")
  endif()

  if(NOT TARGET CImg::CImg)
    message(FATAL_ERROR "\"CImg::CImg\" is not a valid target. Aborting...")
  else()
    target_link_libraries(${_cimg_target} ${_cimg_link} CImg::CImg)
  endif()

  if(NOT SETUP_TARGET_FOR_CIMG_COMPONENTS OR "CURL" IN_LIST
                                             SETUP_TARGET_FOR_CIMG_COMPONENTS)
    find_package(CURL ${_cimg_quiet} ${_cimg_required})
    if(CURL_FOUND)
      target_link_libraries(${_cimg_target} ${_cimg_link} CURL::libcurl)
      target_compile_definitions(${_cimg_target} ${_cimg_link} cimg_use_curl)
    endif()
  endif()

  if(NOT SETUP_TARGET_FOR_CIMG_COMPONENTS OR "FFMPEG" IN_LIST
                                             SETUP_TARGET_FOR_CIMG_COMPONENTS)
    find_package(PkgConfig QUIET ${_cimg_required})
    if(PKG_CONFIG_FOUND)
      pkg_check_modules(LIBAVCODEC ${_cimg_quiet} ${_cimg_required}
                        IMPORTED_TARGET GLOBAL libavcodec)
      pkg_check_modules(LIBAVFORMAT ${_cimg_quiet} ${_cimg_required}
                        IMPORTED_TARGET GLOBAL libavformat)
      pkg_check_modules(LIBAVUTIL ${_cimg_quiet} ${_cimg_required}
                        IMPORTED_TARGET GLOBAL libavutil)
      pkg_check_modules(LIBSWSCALE ${_cimg_quiet} ${_cimg_required}
                        IMPORTED_TARGET GLOBAL libswscale)
      if(LIBAVCODEC_FOUND
         AND LIBAVFORMAT_FOUND
         AND LIBAVUTIL_FOUND
         AND LIBSWSCALE_FOUND)
        target_link_libraries(
          ${_cimg_target} ${_cimg_link} PkgConfig::LIBAVCODEC
          PkgConfig::LIBAVFORMAT PkgConfig::LIBAVUTIL PkgConfig::LIBSWSCALE)
        target_compile_definitions(${_cimg_target} ${_cimg_link}
                                                   cimg_use_ffmpeg)
      endif()
    endif()
  endif()

  if(NOT SETUP_TARGET_FOR_CIMG_COMPONENTS OR "FFTW3" IN_LIST
                                             SETUP_TARGET_FOR_CIMG_COMPONENTS)
    find_package(PkgConfig QUIET ${_cimg_required})
    if(PKG_CONFIG_FOUND)
      pkg_check_modules(FFTW3 ${_cimg_quiet} ${_cimg_required} IMPORTED_TARGET
                        GLOBAL fftw3)
      if(FFTW3_FOUND)
        target_link_libraries(${_cimg_target} ${_cimg_link} PkgConfig::FFTW3)
        target_compile_definitions(${_cimg_target} ${_cimg_link} cimg_use_fftw3)
      endif()
    endif()
  endif()

  if(NOT SETUP_TARGET_FOR_CIMG_COMPONENTS OR "JPEG" IN_LIST
                                             SETUP_TARGET_FOR_CIMG_COMPONENTS)
    find_package(JPEG ${_cimg_quiet} ${_cimg_required})
    if(JPEG_FOUND)
      target_link_libraries(${_cimg_target} ${_cimg_link} JPEG::JPEG)
      target_compile_definitions(${_cimg_target} ${_cimg_link} cimg_use_jpeg)
    endif()
  endif()

  if(NOT SETUP_TARGET_FOR_CIMG_COMPONENTS OR "LAPACK" IN_LIST
                                             SETUP_TARGET_FOR_CIMG_COMPONENTS)
    find_package(LAPACK ${_cimg_quiet} ${_cimg_required})
    if(LAPACK_FOUND)
      target_link_libraries(${_cimg_target} ${_cimg_link} LAPACK::LAPACK)
      target_compile_definitions(${_cimg_target} ${_cimg_link} cimg_use_lapack)
    endif()
  endif()

  if(NOT SETUP_TARGET_FOR_CIMG_COMPONENTS OR "Magick++" IN_LIST
                                             SETUP_TARGET_FOR_CIMG_COMPONENTS)
    find_package(PkgConfig QUIET ${_cimg_required})
    if(PKG_CONFIG_FOUND)
      pkg_check_modules(MAGICK ${_cimg_quiet} ${_cimg_required} IMPORTED_TARGET
                        GLOBAL Magick++)
      if(MAGICK_FOUND)
        target_link_libraries(${_cimg_target} ${_cimg_link} PkgConfig::MAGICK)
        target_compile_definitions(${_cimg_target} ${_cimg_link}
                                                   cimg_use_magick)
      endif()
    endif()
  endif()

  if(NOT SETUP_TARGET_FOR_CIMG_COMPONENTS OR "OpenCV" IN_LIST
                                             SETUP_TARGET_FOR_CIMG_COMPONENTS)
    find_package(OpenCV ${_cimg_quiet} ${_cimg_required})
    if(OpenCV_FOUND)
      target_link_libraries(${_cimg_target} ${_cimg_link} ${OpenCV_LIBS})
      target_compile_definitions(${_cimg_target} ${_cimg_link} cimg_use_opencv)
    endif()
  endif()

  if(NOT SETUP_TARGET_FOR_CIMG_COMPONENTS OR "OpenEXR" IN_LIST
                                             SETUP_TARGET_FOR_CIMG_COMPONENTS)
    find_package(PkgConfig QUIET ${_cimg_required})
    if(PKG_CONFIG_FOUND)
      pkg_check_modules(OPENEXR ${_cimg_quiet} ${_cimg_required}
                        IMPORTED_TARGET GLOBAL OpenEXR)
      if(OPENEXR_FOUND)
        target_link_libraries(${_cimg_target} ${_cimg_link} PkgConfig::OPENEXR)
        target_compile_definitions(${_cimg_target} ${_cimg_link}
                                                   cimg_use_openexr)
      endif()
    endif()
  endif()

  if(NOT SETUP_TARGET_FOR_CIMG_COMPONENTS OR "OpenMP" IN_LIST
                                             SETUP_TARGET_FOR_CIMG_COMPONENTS)
    find_package(OpenMP ${_cimg_quiet} ${_cimg_required})
    if(OpenMP_FOUND)
      target_link_libraries(${_cimg_target} ${_cimg_link} OpenMP::OpenMP_CXX)
      target_compile_definitions(${_cimg_target} ${_cimg_link} cimg_use_openmp)
      if(FFTW3_FOUND)
        find_library(
          FFTW3_OMP
          NAMES fftw3_omp
          HINTS ${FFTW3_LIBRARY_DIRS} REQUIRED)
        target_link_libraries(${_cimg_target} ${_cimg_link} ${FFTW3_OMP})
      endif()
    endif()
  endif()

  if(NOT SETUP_TARGET_FOR_CIMG_COMPONENTS OR "PNG" IN_LIST
                                             SETUP_TARGET_FOR_CIMG_COMPONENTS)
    find_package(PNG ${_cimg_quiet} ${_cimg_required})
    if(PNG_FOUND)
      target_link_libraries(${_cimg_target} ${_cimg_link} PNG::PNG)
      target_compile_definitions(${_cimg_target} ${_cimg_link} cimg_use_png)
    endif()
  endif()

  if(NOT SETUP_TARGET_FOR_CIMG_COMPONENTS OR "Threads" IN_LIST
                                             SETUP_TARGET_FOR_CIMG_COMPONENTS)
    set(THREADS_PREFER_PTHREAD_FLAG ON)
    find_package(Threads ${_cimg_quiet} ${_cimg_required})
    if(Threads_FOUND)
      target_link_libraries(${_cimg_target} ${_cimg_link} Threads::Threads)
      target_compile_definitions(${_cimg_target} ${_cimg_link} cimg_use_pthread)
      if(FFTW3_FOUND)
        find_library(
          FFTW3_THREADS
          NAMES fftw3_threads
          HINTS ${FFTW3_LIBRARY_DIRS} REQUIRED)
        target_link_libraries(${_cimg_target} ${_cimg_link} ${FFTW3_THREADS})
      endif()
    endif()
  endif()

  if(NOT SETUP_TARGET_FOR_CIMG_COMPONENTS OR "TIFF" IN_LIST
                                             SETUP_TARGET_FOR_CIMG_COMPONENTS)
    find_package(TIFF ${_cimg_quiet} ${_cimg_required})
    if(TIFF_FOUND)
      target_link_libraries(${_cimg_target} ${_cimg_link} TIFF::TIFF)
      target_compile_definitions(${_cimg_target} ${_cimg_link} cimg_use_tiff)
    endif()
  endif()

  if(NOT SETUP_TARGET_FOR_CIMG_COMPONENTS OR "X11" IN_LIST
                                             SETUP_TARGET_FOR_CIMG_COMPONENTS)
    find_package(X11 ${_cimg_quiet} ${_cimg_required})
    if(X11_FOUND
       AND X11_XShm_FOUND
       AND X11_Xrandr_FOUND)
      target_link_libraries(${_cimg_target} ${_cimg_link} X11::X11 X11::Xrandr)
      target_include_directories(${_cimg_target} ${_cimg_link}
                                 ${X11_XShm_INCLUDE_PATH})
      target_compile_definitions(${_cimg_target} ${_cimg_link} cimg_display=1
                                                 cimg_use_xshm cimg_use_xrandr)
    endif()
  endif()

  if(NOT SETUP_TARGET_FOR_CIMG_COMPONENTS OR "ZLIB" IN_LIST
                                             SETUP_TARGET_FOR_CIMG_COMPONENTS)
    find_package(ZLIB ${_cimg_quiet} ${_cimg_required})
    if(ZLIB_FOUND)
      target_link_libraries(${_cimg_target} ${_cimg_link} ZLIB::ZLIB)
      target_compile_definitions(${_cimg_target} ${_cimg_link} cimg_use_zlib)
    endif()
  endif()

endfunction()
