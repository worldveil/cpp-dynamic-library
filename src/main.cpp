#include "mandelbrot.h"
#include <string>

int main() {
    fractal::Mandelbrot m(900, 900);
    m.writeToFile("test.ppm");
}