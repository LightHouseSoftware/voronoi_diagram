module cell;

import point;
import std.algorithm.iteration;
import std.conv;
import std.container.array;
import dlib.image;

class Cell {

    private Point[] points;
    private Point massCenter;
    private Color4f color;

    this(Point massCenter, Color4f color) {
        this.massCenter = massCenter;
        this.color = color;
    }

    void addPoint(Point point) {
        this.points ~= point;
    }

    // пересчитать центр масс
    void recalcMassCenter() {
        auto x = points.map!(point => point.getX).sum;
        auto y = points.map!(point => point.getY).sum;

        this.massCenter.setLocation(x/points.length, y/points.length);
    }

    Point getMassCenter() {
        return this.massCenter;
    }

    Point[] getPoints() {
        return this.points;
    }

    Color4f getColor() {
        return this.color;
    }

    void clearPoints() {
        this.points.length = 0;
    }
}