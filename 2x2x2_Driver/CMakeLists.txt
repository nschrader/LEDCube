#
# CMakeLists - Copyright (C) 2014 Nick Schrader
#

cmake_minimum_required(VERSION 2.8)
project(2x2x2_Driver C)
set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/modules)
include(UseVala)

if(CMAKE_BUILD_TYPE STREQUAL "Debug")
	list(APPEND VALA_OPTIONS "-g")
endif()

find_package(Vala "0.18.1" REQUIRED)
find_package(GLIB REQUIRED COMPONENTS gobject gio)
find_package(GTK3 REQUIRED)
find_package(Cairo REQUIRED)
include_directories(${GLIB_INCLUDE_DIRS} ${GTK3_INCLUDE_DIRS} ${CAIRO_INCLUDE_DIR})

vala_precompile(VALA_C ControlWin.vala LEDCube.vala R_3.vala PACKAGES posix gtk+-3.0 OPTIONS "--enable-experimental" ${VALA_OPTIONS})
add_executable(2x2x2 ${VALA_C})
target_link_libraries(2x2x2 m ${GLIB_LIBRARIES} ${GLIB_GOBJECT_LIBRARIES} 
	${GTK3_LIBRARIES} ${CAIRO_LIBRARIES} ${GLIB_GIO_LIBRARIES})
