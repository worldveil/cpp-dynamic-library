.PHONY=clean

# create the main file by linking with the object file already created
# since src/mandelbrot.o is a dependency, make will execute that task first
# if src/mandelbrot.o was changed AFTER src/main was created
main: src/mandelbrot.o
	clang++ src/main.cpp -o src/main src/mandelbrot.o -I ./include

# create an object file
src/mandelbrot.o:
	clang++ -c src/mandelbrot.cpp -o src/mandelbrot.o -I ./include

clean:
	rm src/*.o
	rm lib/*.dylib

# create a dynamic library on Mac OSX, verify with:
#   $ file lib/libmandelbrot.dylib
#   $ nm -C lib/libmandelbrot.dylib | grep writeToFile
#
# Also the naming is important! must name with libxxxx prefix...
lib/libmandelbrot.dylib:
	clang++ -dynamiclib -o lib/libmandelbrot.dylib src/mandelbrot.cpp -I ./include

# finally, our example of compiling a file using the functions in mandelbrot.cpp ... without that file!
# the objects needed to compile this are found in the dylib at runtime and loaded into program memory then
src/client: lib/libmandelbrot.dylib
	clang++ src/client.cpp -o src/client -L ./lib -l mandelbrot -I ./include