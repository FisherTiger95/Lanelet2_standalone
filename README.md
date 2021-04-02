# lanelet2_standalone
This is a standalone lanelet2 c++ package for the Lanelet2 library, which does not require ROS and catkin.
## Dependencies
- `Boost` (from 1.58, for lanelet2_io)
- `eigen3`
- `pugixml` (for lanelet2_io)
- `geographiclib` (for lanelet2_projection)

Install the dependencies above:
```sh
sudo apt-get install libboost-dev libeigen3-dev libgeographic-dev libpugixml-dev
```

## Installing
```sh
cd lanelet2_standalone
mkdir build
cd build
cmake ..
make
sudo make install
```
