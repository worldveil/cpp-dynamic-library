.PHONY=clean

# create the main file by linking with the object file already created
# since src/mandelbrot.o is a dependency, make will execute that task first
# if src/mandelbrot.o was changed AFTER src/main was created
main: src/mandelbrot.o
	clang++ src/main.cpp -o src/main src/mandelbrot.o -I ./include

# create an object file
src/mandelbrot.o:
	clang++ -c src/mandelbrot.cpp -o src/mandelbrot.o -I ./include

# | true just means the command will always succeed and further steps will be
# run, no matter what
clean:
	rm src/*.o | true  
	rm lib/*.dylib | true
	rm lib/*.o | true
	rm *.ppm | true

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

####### If you want to name your library an arbitrary name...
# lib/whatever.o:
# 	clang++ -dynamiclib -o lib/whatever.o src/mandelbrot.cpp -I ./include
# src/client: lib/whatever.o
# 	clang++ src/client.cpp -o src/client -L ./lib -I ./include -l whatever.o