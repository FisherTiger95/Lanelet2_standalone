message("-- Found lanelet2")
set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR})
set(CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} --std=c++14 -fPIC")

find_package(Boost REQUIRED COMPONENTS serialization system filesystem)
find_package(Eigen3 REQUIRED)
find_package(GeographicLib REQUIRED)
find_package(pugixml REQUIRED)

set(lanelet2_INCLUDE_DIRS 
    ${Boost_INCLUDE_DIRS} 
    ${EIGEN3_INCLUDE_DIR}
    ${GeographicLib_INCLUDE_DIRS}
    ${PUGIXML_INCLUDE_DIRS}
)

set(lanelet2_LIBRARIES 
    lanelet2_core 
    lanelet2_io
    lanelet2_projection
    lanelet2_routing
    lanelet2_traffic_rules
    ${Boost_LIBRARIES}
    ${PYTHON_LIBRARY}
    ${GeographicLib_LIBRARIES}
    ${PUGIXML_LIBRARIES}
)

set(lanelet2_FOUND true)