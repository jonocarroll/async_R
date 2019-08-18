library(future)
plan(multiprocess)

v <- new.env()
for (ii in letters[1:3]) {
  v[[ii]] %<-% {
    Sys.sleep(5)
    Sys.getpid()
  }
}
v <- as.list(v)
str(v)
