#include "mandelbrot.h"
#include <string>

int main() {
    fractal::Mandelbrot m(400, 400);
    m.writeToFile("test.ppm");
}