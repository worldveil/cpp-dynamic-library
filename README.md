<img src="/mandelbrot.png" alt="" title="" width="800">

Keeping this mostly as a reference for myself since there's a few weird gotchas creating C++ libraries.

## Creating a Dynamic Library

Here we want to create a .dylib file that allows an executable to (at runtime!) look up undefined symbols and place them into program memory in order to run the executable.

The benefit being that we use less disk space because our binary is smaller, but the downside is that it's more brittle. If you've long had an executable working with a dylib and one day your dylib gets corrupted or you lose it...well you're out of luck.

Here, we compile a dylib and make a new executable that has no access to the original C++ file and prove that it works to run!

```shell
$ make src/client
$ ./src/client  # should create "test.ppm"
```

## Creating a Static Library

A static library is [very similar to an object file](https://stackoverflow.com/questions/6177498/whats-the-difference-between-object-file-and-static-libraryarchive-file). In fact static libs are really just a bunch of object files nicely stored together in an archive. 

The nice thing about compiling your execuatable with a static binary is that it takes the binary and puts it inside the executable, meaning that your executable is very portable. It will however, take up more space on disk, and if you have a number of executables (say 10) that all depend on this static lib, well you'll have 10x space used.

```shell
$ make src/client_statically_linked
$ ./src/client_statically_linked  # should still create "test.ppm"
```
## Tools

```shell
# shows the libraries this executable depends on
$ otool -L <binary-executable>

# shows the symbols this object file / binary defines, and which are undefined and need a library to define
$ nm -C <binary-executable>
```

## What's the difference in our executables?

Let's look!

```shell
# compare file sizes
$ du -h ./src/client*
 12K    ./src/client
4.0K    ./src/client.cpp
 52K    ./src/client_statically_linked

 # it's larger!

 # let's check our symbols
$ nm -C ./src/client | grep fractal::Mandelbrot::writeToFile
                 U fractal::Mandelbrot::writeToFile(std::__1::basic_string<char, std::__1::char_traits<char>, std::__1::allocator<char> >)

$ nm -C ./src/client_statically_linked | grep fractal::Mandelbrot::writeToFile
0000000100001450 T fractal::Mandelbrot::writeToFile(std::__1::basic_string<char, std::__1::char_traits<char>, std::__1::allocator<char> >)
```

Our statically linked executable is larger, as we'd expect! It contains the symbols in `mandelbrot.o`, and thus needs more disk space. 

And as we'd expect, in the statically linked executable, the `fractal::Mandelbrot::writeToFile` is defined and in the dynamically linked one it is undefined ("U").
