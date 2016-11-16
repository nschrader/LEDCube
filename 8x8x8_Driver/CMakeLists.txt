#
# CMakeLists - Copyright (C) 2014 Nick Schrader
#

cmake_minimum_required(VERSION 2.8)
project(8x8x8_Driver C)
set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/modules)
include(UseVala)

if(CMAKE_BUILD_TYPE STREQUAL "Debug")
	list(APPEND VALA_OPTIONS "-g")
else()
	list(APPEND CMAKE_C_FLAGS "-w")
endif()

find_package(Vala "0.18.1" REQUIRED)
find_package(GLIB REQUIRED COMPONENTS gobject gio)
find_package(GTK3 REQUIRED)
include_directories(${GLIB_INCLUDE_DIRS} ${GTK3_INCLUDE_DIRS})

set(CLASSES VoxelSource.vala Controller.vala LEDCube.vala R_3.vala ControlWin.vala)
set(EFFECTS GameOfLife.vala Fireworks.vala Sinelines.vala Spheremove.vala Linespin.vala Sidewaves.vala Ripples.vala IntervalDemo.vala Test.vala Clear.vala)
vala_precompile(VALA_C ${CLASSES} ${EFFECTS} PACKAGES posix gtk+-3.0 OPTIONS "--enable-experimental" ${VALA_OPTIONS})
add_executable(8x8x8 ${VALA_C})
target_link_libraries(8x8x8 m ${GLIB_LIBRARIES} ${GLIB_GOBJECT_LIBRARIES} ${GTK3_LIBRARIES} ${GLIB_GIO_LIBRARIES})
