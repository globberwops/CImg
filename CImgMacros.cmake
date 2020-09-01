include_guard(GLOBAL)

function(SETUP_TARGET_FOR_CIMG)
  if(NOT TARGET "${ARGV0}")
    message(FATAL_ERROR "\"${ARGV0}\" is not a valid target. Aborting...")
  else()
    set(_cimg_target "${ARGV0}")
  endif()

  option(CImg_USE_CURL "Use the CURL library" ON)
  find_package(CURL)
  if(CImg_USE_CURL AND CURL_FOUND)
    target_link_libraries(${_cimg_target} PUBLIC CURL::libcurl)
    target_compile_definitions(${_cimg_target} PUBLIC cimg_use_curl)
  endif()

  option(CImg_USE_FFMPEG "Use the FFMPEG libraries" ON)
  find_package(PkgConfig QUIET)
  if(PKG_CONFIG_FOUND)
    pkg_check_modules(LIBAVCODEC IMPORTED_TARGET GLOBAL libavcodec)
    pkg_check_modules(LIBAVFORMAT IMPORTED_TARGET GLOBAL libavformat)
    pkg_check_modules(LIBAVUTIL IMPORTED_TARGET GLOBAL libavutil)
    pkg_check_modules(LIBSWSCALE IMPORTED_TARGET GLOBAL libswscale)
    if(CImg_USE_FFMPEG
       AND LIBAVCODEC_FOUND
       AND LIBAVFORMAT_FOUND
       AND LIBAVUTIL_FOUND
       AND LIBSWSCALE_FOUND)
      target_link_libraries(
        ${_cimg_target} PUBLIC PkgConfig::LIBAVCODEC PkgConfig::LIBAVFORMAT
                               PkgConfig::LIBAVUTIL PkgConfig::LIBSWSCALE)
      target_compile_definitions(${_cimg_target} PUBLIC cimg_use_ffmpeg)
    endif()
  endif()

  option(CImg_USE_FFTW3 "Use the FFTW3 library" ON)
  find_package(PkgConfig QUIET)
  if(PKG_CONFIG_FOUND)
    pkg_check_modules(FFTW3 IMPORTED_TARGET GLOBAL fftw3)
    if(CImg_USE_FFTW3 AND FFTW3_FOUND)
      target_link_libraries(${_cimg_target} PUBLIC PkgConfig::FFTW3)
      target_compile_definitions(${_cimg_target} PUBLIC cimg_use_fftw3)
    endif()
  endif()

  option(CImg_USE_JPEG "Use the JPEG library" ON)
  find_package(JPEG)
  if(CImg_USE_JPEG AND JPEG_FOUND)
    target_link_libraries(${_cimg_target} PUBLIC JPEG::JPEG)
    target_compile_definitions(${_cimg_target} PUBLIC cimg_use_jpeg)
  endif()

  option(CImg_USE_LAPACK "Use the LAPACK library" ON)
  find_package(LAPACK)
  if(CImg_USE_LAPACK AND LAPACK_FOUND)
    target_link_libraries(${_cimg_target} PUBLIC LAPACK::LAPACK)
    target_compile_definitions(${_cimg_target} PUBLIC cimg_use_lapack)
  endif()

  option(CImg_USE_Magick "Use the Magick++ library" ON)
  find_package(PkgConfig QUIET)
  if(PKG_CONFIG_FOUND)
    pkg_check_modules(MAGICK IMPORTED_TARGET GLOBAL Magick++)
    if(CImg_USE_Magick AND MAGICK_FOUND)
      target_link_libraries(${_cimg_target} PUBLIC PkgConfig::MAGICK)
      target_compile_definitions(${_cimg_target} PUBLIC cimg_use_magick)
    endif()
  endif()

  option(CImg_USE_OpenCV "Use the OpenCV library" ON)
  find_package(OpenCV)
  if(CImg_USE_OpenCV AND OpenCV_FOUND)
    target_link_libraries(${_cimg_target} PUBLIC ${OpenCV_LIBS})
    target_compile_definitions(${_cimg_target} PUBLIC cimg_use_opencv)
  endif()

  option(CImg_USE_OpenEXR "Use the OpenEXR library" ON)
  find_package(PkgConfig QUIET)
  if(PKG_CONFIG_FOUND)
    pkg_check_modules(OPENEXR IMPORTED_TARGET GLOBAL OpenEXR)
    if(CImg_USE_OpenEXR AND OPENEXR_FOUND)
      target_link_libraries(${_cimg_target} PUBLIC PkgConfig::OPENEXR)
      target_compile_definitions(${_cimg_target} PUBLIC cimg_use_openexr)
    endif()
  endif()

  option(CImg_USE_OpenMP "Use the OpenMP library" ON)
  find_package(OpenMP)
  if(CImg_USE_OpenMP AND OpenMP_FOUND)
    target_link_libraries(${_cimg_target} PUBLIC OpenMP::OpenMP_CXX)
    target_compile_definitions(${_cimg_target} PUBLIC cimg_use_openmp)
    if(CImg_USE_FFTW3 AND FFTW3_FOUND)
      find_library(
        FFTW3_OMP
        NAMES fftw3_omp
        HINTS ${FFTW3_LIBRARY_DIRS} REQUIRED)
      target_link_libraries(${_cimg_target} PUBLIC ${FFTW3_OMP})
    endif()
  endif()

  option(CImg_USE_PNG "Use the PNG library" ON)
  find_package(PNG)
  if(CImg_USE_PNG AND PNG_FOUND)
    target_link_libraries(${_cimg_target} PUBLIC PNG::PNG)
    target_compile_definitions(${_cimg_target} PUBLIC cimg_use_png)
  endif()

  option(CImg_USE_PThread "Use the POSIX threads library" ON)
  set(THREADS_PREFER_PTHREAD_FLAG ON)
  find_package(Threads)
  if(CImg_USE_PThread AND Threads_FOUND)
    target_link_libraries(${_cimg_target} PUBLIC Threads::Threads)
    target_compile_definitions(${_cimg_target} PUBLIC cimg_use_pthread)
    if(CImg_USE_FFTW3 AND FFTW3_FOUND)
      find_library(
        FFTW3_THREADS
        NAMES fftw3_threads
        HINTS ${FFTW3_LIBRARY_DIRS} REQUIRED)
      target_link_libraries(${_cimg_target} PUBLIC ${FFTW3_THREADS})
    endif()
  endif()

  option(CImg_USE_TIFF "Use the TIFF library" ON)
  find_package(TIFF)
  if(CImg_USE_TIFF AND TIFF_FOUND)
    target_link_libraries(${_cimg_target} PUBLIC TIFF::TIFF)
    target_compile_definitions(${_cimg_target} PUBLIC cimg_use_tiff)
  endif()

  option(CImg_USE_X11 "Use the X11 libraries" ON)
  find_package(X11)
  if(CImg_USE_X11
     AND X11_FOUND
     AND X11_XShm_FOUND
     AND X11_Xrandr_FOUND)
    target_link_libraries(${_cimg_target} PUBLIC X11::X11 X11::Xrandr)
    target_include_directories(${_cimg_target} PUBLIC ${X11_XShm_INCLUDE_PATH})
    target_compile_definitions(
      ${_cimg_target} PUBLIC cimg_display=1 cimg_use_xshm cimg_use_xrandr)
  endif()

  option(CImg_USE_ZLIB "Use the ZLIB library" ON)
  find_package(ZLIB)
  if(CImg_USE_ZLIB AND ZLIB_FOUND)
    target_link_libraries(${_cimg_target} PUBLIC ZLIB::ZLIB)
    target_compile_definitions(${_cimg_target} PUBLIC cimg_use_zlib)
  endif()

endfunction()
