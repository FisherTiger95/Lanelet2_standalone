cmake_minimum_required(VERSION 3.5.1)
project(lanelet2)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_SOURCE_DIR}/cmake)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++14 -fPIC")

###################
## Find packages ##
###################
option(USE_PYTHON3 "Use python 3 to build libraries." OFF)
if (USE_PYTHON3)
  find_package(Boost REQUIRED COMPONENTS python serialization system filesystem)
  find_package(PythonLibs 3.6 REQUIRED)
  include_directories(${PYTHON_INCLUDE_DIRS})
else()
  find_package(Boost REQUIRED COMPONENTS serialization system filesystem program_options)
  include_directories(${Boost_INCLUDE_DIRS}) 
endif()

find_package(Eigen3 REQUIRED)
include_directories(${EIGEN3_INCLUDE_DIR})

find_package(GeographicLib REQUIRED)
include_directories(${GeographicLib_INCLUDE_DIRS})

find_package(pugixml REQUIRED)
include_directories(${PUGIXML_INCLUDE_DIRS})

###########
## Build ##
###########
set(MODUELS core io projection routing traffic_rules geometry) #validation)
set(LINKED_LIBRARIES "")

foreach(SUBMODULE ${MODUELS})
  if (NOT SUBMODULE STREQUAL "geometry")
    include_directories(${CMAKE_CURRENT_SOURCE_DIR}/${PROJECT_NAME}_${SUBMODULE}/include)
    set(LIBRARY_NAME ${PROJECT_NAME}_${SUBMODULE})
    
    set(SRCS_DIR ${CMAKE_CURRENT_SOURCE_DIR}/${PROJECT_NAME}_${SUBMODULE}/src)
    #if (SUBMODULE STREQUAL "validation")
    #  list(APPEND SRCS_DIR ${CMAKE_CURRENT_SOURCE_DIR}/${PROJECT_NAME}_${SUBMODULE}/src/validators)  
    #endif()
    
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
  endif()
endforeach()

# build each python api binding submodule
if(USE_PYTHON3)
  foreach(SUBMODULE ${MODUELS})
    set(API_LIBRARY_NAME "${PROJECT_NAME}_${SUBMODULE}_pyapi")
    add_library(${API_LIBRARY_NAME} SHARED
      lanelet2_python/python_api/${SUBMODULE}.cpp  # binding codes
    )
    target_compile_definitions(${API_LIBRARY_NAME} PRIVATE -DPYTHON_API_MODULE_NAME=lib${API_LIBRARY_NAME})
    target_link_libraries(${API_LIBRARY_NAME}
      ${Boost_LIBRARIES}
      ${PYTHON_LIBRARY}
      ${LINKED_LIBRARIES}
    )
  endforeach()
endif()

# validation binary
#add_executable(${PROJECT_NAME}_validate
#  ${CMAKE_CURRENT_SOURCE_DIR}/${PROJECT_NAME}_validation/tools/${PROJECT_NAME}_validate/main.cpp
#)
#target_link_libraries(${PROJECT_NAME}_validate
#  ${LINKED_LIBRARIES}
#)

#############
## INSTALL ##
#############
message("install dir:" ${CMAKE_INSTALL_PREFIX})
foreach(SUBMODULE ${MODUELS})
  if (NOT SUBMODULE STREQUAL "geometry")
    install(TARGETS ${PROJECT_NAME}_${SUBMODULE} DESTINATION lib)
    install(DIRECTORY ${PROJECT_NAME}_${SUBMODULE}/include/ DESTINATION include/)
  endif()
endforeach()
install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/cmake/ # source directory
        DESTINATION share/${PROJECT_NAME}/cmake/ # target directory
)
#install(TARGETS ${PROJECT_NAME}_validate DESTINATION bin)
