PROJECT(INDEXING_COMPONENTS_BUILD)

cmake_minimum_required(VERSION 2.8)

add_custom_target(all ALL ${CMAKE_CURRENT_SOURCE_DIR}/build.sh ${CMAKE_CURRENT_SOURCE_DIR})
