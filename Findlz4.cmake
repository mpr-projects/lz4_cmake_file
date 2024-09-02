# mpr: adapted from https://gitea.osmocom.org/osmith/wireshark/src/branch/master/cmake/modules/Findlz4.cmake
#      and https://github.com/Kitware/VTK/blob/master/CMake/FindLZ4.cmake
#
# - Find lz4
# Find lz4 includes and library
#
#  lz4_INCLUDE_DIRS - where to find lz4.h, etc.
#  lz4_LIBRARIES    - List of libraries when using lz4.
#  lz4_FOUND        - True if lz4 found.
#  lz4_DLL_DIR      - (Windows) Path to the lz4 DLL
#  lz4_DLL          - (Windows) Name of the lz4 DLL

find_package(PkgConfig)
pkg_search_module(lz4 lz4 liblz4)

find_path(lz4_INCLUDE_DIR
  NAMES lz4.h
  HINTS "${lz4_INCLUDEDIR}" "${lz4_HINTS}/include"
  PATHS
  /usr/local/include
  /usr/include
)

find_library(lz4_LIBRARY
  NAMES lz4 liblz4
  HINTS "${lz4_LIBDIR}" "${lz4_HINTS}/lib"
  PATHS
  /usr/local/lib
  /usr/lib
)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args( lz4 DEFAULT_MSG lz4_LIBRARY lz4_INCLUDE_DIR )

if( lz4_FOUND )
  include( CheckIncludeFile )
  include( CMakePushCheckState )

  set( lz4_INCLUDE_DIRS ${lz4_INCLUDE_DIR} )
  set( lz4_LIBRARIES ${lz4_LIBRARY} )

  cmake_push_check_state()
  set( CMAKE_REQUIRED_INCLUDES ${lz4_INCLUDE_DIRS} )
  check_include_file( lz4frame.h HAVE_lz4FRAME_H )
  cmake_pop_check_state()

  if (NOT TARGET lz4::lz4)
    add_library(lz4::lz4 UNKNOWN IMPORTED)
    set_target_properties(lz4::lz4 PROPERTIES
      IMPORTED_LOCATION "${lz4_LIBRARY}"
      INTERFACE_INCLUDE_DIRECTORIES "${lz4_INCLUDE_DIR}")
  endif ()

else()
  set( lz4_INCLUDE_DIRS )
  set( lz4_LIBRARIES )
endif()

mark_as_advanced( lz4_LIBRARIES lz4_INCLUDE_DIRS )
