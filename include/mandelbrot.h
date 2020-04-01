#ifndef MANDELBROTH
#define MANDELBROTH

#include <fstream>
#include <complex>
#include <string>

namespace fractal {

    class Mandelbrot {
        public:
            Mandelbrot(int w, int h): width(w), height(h) {}
            int height, width;

            int computePoint(int x, int y);
            void writeToFile(std::string path);
    };

}

#endif