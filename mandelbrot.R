library(future)
plan(multiprocess, workers = 4)
options("future.demo.mandelbrot.resolution" = 2000L)
demo("mandelbrot", package = "future", ask = FALSE)
