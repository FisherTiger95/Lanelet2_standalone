cmake_minimum_required(VERSION 3.5.1)
project(lanelet2)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_SOURCE_DIR}/cmake)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++14 -fPIC")

###################
## Find packages ##
###################
find_package(Boost REQUIRED COMPONENTS serialization system filesystem program_options)
include_directories(${Boost_INCLUDE_DIRS}) 

find_package(Eigen3 REQUIRED)
include_directories(${EIGEN3_INCLUDE_DIR})

find_package(GeographicLib REQUIRED)
include_directories(${GeographicLib_INCLUDE_DIRS})

find_package(pugixml REQUIRED)
include_directories(${PUGIXML_INCLUDE_DIRS})

###########
## Build ##
###########
set(MODUELS core io projection routing traffic_rules validation)
set(LINKED_LIBRARIES "")

foreach(SUBMODULE ${MODUELS})
  include_directories(${CMAKE_CURRENT_SOURCE_DIR}/${PROJECT_NAME}_${SUBMODULE}/include)
  set(LIBRARY_NAME ${PROJECT_NAME}_${SUBMODULE})
  
  set(SRCS_DIR ${CMAKE_CURRENT_SOURCE_DIR}/${PROJECT_NAME}_${SUBMODULE}/src)
  if (SUBMODULE STREQUAL "validation")
    list(APPEND SRCS_DIR ${CMAKE_CURRENT_SOURCE_DIR}/${PROJECT_NAME}_${SUBMODULE}/src/validators)  
  endif()
  
  foreach(SRC_DIR ${SRCS_DIR})
    file(GLOB TMP_SRC ${SRC_DIR}/*.cpp)
    list(APPEND ${SUBMODULE}_SRC ${TMP_SRC})
  endforeach()

  add_library(${LIBRARY_NAME} SHARED
    ${${SUBMODULE}_SRC}
  )
  target_include_directories(${LIBRARY_NAME}
    PUBLIC   $<INSTALL_INTERFACE:include/${PROJECT_NAME}>
    PRIVATE  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/${PROJECT_NAME}_${SUBMODULE}/include/${PROJECT_NAME}_${SUBMODULE}>)
  target_link_libraries(${LIBRARY_NAME}
    ${Boost_LIBRARIES}
    ${GeographicLib_LIBRARIES}
    ${PUGIXML_LIBRARIES}
    ${LINKED_LIBRARIES}
  )
  list(APPEND LINKED_LIBRARIES ${LIBRARY_NAME})
endforeach()

# validation binary
add_executable(${PROJECT_NAME}_validate
  ${CMAKE_CURRENT_SOURCE_DIR}/${PROJECT_NAME}_validation/tools/${PROJECT_NAME}_validate/main.cpp
)
target_link_libraries(${PROJECT_NAME}_validate
  ${LINKED_LIBRARIES}
)

#############
## INSTALL ##
#############
message("install dir:" ${CMAKE_INSTALL_PREFIX})
foreach(SUBMODULE ${MODUELS})
    install(TARGETS ${PROJECT_NAME}_${SUBMODULE} DESTINATION lib)
    install(DIRECTORY ${PROJECT_NAME}_${SUBMODULE}/include/ DESTINATION include/)
endforeach()
install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/cmake/ # source directory
        DESTINATION share/${PROJECT_NAME}/cmake/ # target directory
)
install(TARGETS ${PROJECT_NAME}_validate DESTINATION bin)
