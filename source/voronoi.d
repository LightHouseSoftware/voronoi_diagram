module voronoi;

import std.stdio;
import std.random;
import std.math;
import std.conv : to;
import std.format;
import dlib.image;
import point;
import cell;

class Voronoi {

    private uint width, height, numOfPoints;
    private Cell[] cells;

    this(uint width, uint height, uint numOfPoints = 10) {
        this.width = width;
        this.height = height;
        this.numOfPoints = numOfPoints;

        auto rnd = Random(unpredictableSeed);

        // генерация сайтов и выбор цвета их ячеек
        foreach(_; 0..numOfPoints) {
            Point point = new Point(uniform(0, this.width, rnd), uniform( 0, this.height, rnd));
            auto color = Color4f(uniform(0.0f, 1.0f, rnd), uniform(0.0f, 1.0f, rnd), uniform(0.0f, 1.0f, rnd));
            this.cells ~= new Cell(point, color);
        }

        this.generate();
    }

    // генерация ячеек
    private void generate() {
        int index;

        for (int y = 0; y < height; ++y) {
            for (int x  = 0; x < width; ++x) {
                Point point = new Point(x, y);
                index = findNearSite(point);

                Cell cell = cells[index];
                cell.addPoint(point);
                this.cells[index] = cell;
            }
        }
    }

    // поиск ближайшего к точке сайта
    private int findNearSite(Point point) {
        int index = 0;
        double minDistance = distance(point, this.cells[index].getMassCenter());

        double currentDistance;
        for (int i = 0; i < numOfPoints; ++i) {
            currentDistance = distance(point, this.cells[i].getMassCenter());

            if(currentDistance < minDistance) {
                minDistance = currentDistance;
                index = i;
            }
        }

        return index;
    }

    // евклидово расстояние между точками
    private double distance(Point pointA, Point pointB) {
        auto diffX = pointA.getX - pointB.getX;
        auto diffY = pointA.getY - pointB.getY;
        return sqrt((diffX ^^ 2) + (diffY ^^ 2));
    }

    void clearCellsPoints() {
        for (int i = 0; i < cells.length; i++) {
            Cell cell = this.cells[i];
            cell.clearPoints();
            this.cells[i] = cell;
        }
    }

    // превратить массив ячеек в изображение (dlib)
    SuperImage toImage(SuperImage img, bool drawSites = false, int radius = 1, bool filledSites = false) {
        foreach (cell; this.cells) {
            foreach (point; cell.getPoints) {   
                img[point.getX.to!int, point.getY.to!int] = cell.getColor;
            }
        }

        return img;
    }

    // отрисовка сайтов
    SuperImage drawSites(SuperImage img, uint radius, Color4f color, bool filled = false) {  
        for (size_t i = 0; i < numOfPoints; i++) {
            if(filled) {
                drawFillCircle(img, color, this.cells[i].getMassCenter.getX.to!int, this.cells[i].getMassCenter.getY.to!int, radius);
            } else {
                // отрисовка круга (dlib)
                drawCircle(img, color, this.cells[i].getMassCenter.getX.to!int, this.cells[i].getMassCenter.getY.to!int, radius);
            }
        }

        return img;
    }

    // отрисовка залитого круга
    void drawFillCircle(SuperImage img, Color4f col, int x0, int y0, uint r) {
        int f = 1 - r;
        int ddF_x = 0;
        int ddF_y = -2 * r;
        int x = 0;
        int y = r;

        drawLine(img, col, x0, y0 - r, x0, y0 + r);
        drawLine(img, col, x0 - r, y0, x0 + r, y0);

        while(x < y) {
            if(f >= 0) {
                y--;
                ddF_y += 2;
                f += ddF_y;
            }
            x++;
            ddF_x += 2;
            f += ddF_x + 1;

            drawLine(img, col, x0 - x, y0 + y, x0 + x, y0 + y);
            drawLine(img, col, x0 - x, y0 - y, x0 + x, y0 - y);
            drawLine(img, col, x0 - y, y0 + x, x0 + y, y0 + x);
            drawLine(img, col, x0 - y, y0 - x, x0 + y, y0 - x);
        }
    }
}