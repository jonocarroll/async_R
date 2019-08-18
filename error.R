library(future)
plan(multiprocess)

y %<-% {
  Sys.sleep(3)
  Sys.getpid()
} 
y

broken_y %<-% {
  Sys.sleep(3)
  log("foo") # ln(string)
  Sys.getpid()
} 
broken_y

