module point;

import std.format;

class Point {

    private float x, y;

    this(float x, float y) {
        this.x = x;
        this.y = y;
    }

    float getX() {
        return this.x;
    }

    float getY() {
        return this.y;
    }

    void setLocation(float x, float y) {
        this.x = x;
        this.y = y;
    }

    override string toString() {
        return format("[%d, %d]", x, y);
    }
}