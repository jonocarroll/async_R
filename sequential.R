library(future)
plan(sequential)

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

## LAZY

rm(a)
rm(b)

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
