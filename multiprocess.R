library(future)
plan(multiprocess)

(THIS_PID <- Sys.getpid())

a %<-% {
  Sys.sleep(2)
  Sys.getpid()
}

b %<-% {
  Sys.sleep(2)
  Sys.getpid()
}
a
b

rm(a)
rm(b)

## LAZY

(THIS_PID <- Sys.getpid())

a %<-% {
  Sys.sleep(2)
  Sys.getpid()
} %lazy% TRUE

b %<-% {
  Sys.sleep(2)
  Sys.getpid()
} %lazy% TRUE
a
b

rm(a)
rm(b)

