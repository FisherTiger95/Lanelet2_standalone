# lanelet2_standalone
This is a standalone lanelet2 c++/python3 package for the [Lanelet2](https://github.com/fzi-forschungszentrum-informatik/Lanelet2) library, which does not require ROS and catkin.
## Dependencies
- `Boost` (from 1.58, for lanelet2_io)
- `eigen3`
- `pugixml` (for lanelet2_io)
- `geographiclib` (for lanelet2_projection)
- `python3.6+`

Install the dependencies above:
```sh
sudo apt-get install libboost-dev libeigen3-dev libgeographic-dev libpugixml-dev
```

## Installing
Install lanelet2 for system python3:
```sh
cd lanelet2_standalone
sudo python3 setup.py install
```
For whom wants to use the lanelet2 standalone c++ library
```sh
cd lanelet2_standalone
mkdir build
cd build
cmake ..
make
sudo make install
```
## Usage
```python
#!/usr/bin/env python
import lanelet2
from lanelet2 import core, io, projection, geometry, routing, traffic_rules
# or
from lanelet2.core import Lanelet, LineString3d, Point2d, Point3d, getId, LaneletMap, BoundingBox2d, BasicPoint2d
p = Point3d(getId(), 1, 100, 1000)
print(p)
assert p.x == 1
p.id = getId()
```