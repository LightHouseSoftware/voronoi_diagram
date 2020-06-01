# Voronoi diagram
An example implementation of the algorithm for calculating and rendering the Voronoi diagram.

![Voronoi diagram](https://lhs-blog.info/wp-content/uploads/2020/06/voronoi_diagram.png "Voronoi diagram example")

__Run example:__
```d
import std.stdio;
import std.random;
import std.format;
import dlib.image;
import voronoi;
import cell;
import point;

void main() {
    uint width = 512; 
    uint height = 512;
    auto img = image(width, height);
    auto sitesColor = Color4f(0.0f, 0.0f, 0.0f);

	  Voronoi voronoi = new Voronoi(width, height, 100);
    voronoi.toImage(img);
    //voronoi.drawSites(img, 3, sitesColor, true);
    img.savePNG("voronoi_diagram.png");
}  
```
__Detailed explanation (russian):__  
