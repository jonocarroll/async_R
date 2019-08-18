library(future)
plan(multiprocess)

THIS_PID <- Sys.getpid()

a %<-% {
  Sys.getpid()
}
b %<-% {
  ## nested futures are sequential
  b1 %<-% {
    Sys.getpid()
  }
  b2 %<-% {
    Sys.getpid()
  }
  c(b.pid = Sys.getpid(), b1.pid = b1, b2.pid = b2)
}
THIS_PID
a
b ## THESE ALL HAVE THE SAME PID

rm(a)
rm(b)

