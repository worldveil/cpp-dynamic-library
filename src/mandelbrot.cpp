#include <fstream>
#include <complex>
#include <string>

#include "mandelbrot.h"

namespace fractal {

    int Mandelbrot::computePoint(int x, int y) {
        std::complex<float> point((float)x / width - 1.5, (float)y / height - 0.5);
        std::complex<float> z(0, 0);
        unsigned int nb_iter = 0;
        while (abs (z) < 2 && nb_iter <= 34) {
            z = z * z + point;
            nb_iter++;
        }
        if (nb_iter < 34) return (255*nb_iter)/33;
        else return 0;
    }

    void Mandelbrot::writeToFile(std::string path) {
        std::ofstream image (path);
        if (image.is_open ()) {
            image << "P3\n" << width << " " << height << " 255\n";
            for (int i = 0; i < width; i++) {
                for (int j = 0; j < height; j++)  {
                    int val = Mandelbrot::computePoint(i, j); 
                    image << val<< ' ' << 0 << ' ' << 0 << "\n";
                }
            }
            image.close();
        }   
    }

};  