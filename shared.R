library(future)
plan(sequential)

## must ensure they are resolved first -- okay when sequential since they are the same env

last %<-% {
  Sys.sleep(5)
  first + 1
}
first %<-% {
  Sys.sleep(5)
  1
} 
last

rm(first)
rm(last)

## unresolved futures can't be chained since they are not shared
## globals are defined at the same time as the future is declared

## Force first to be resolved

plan(multiprocess)
last %<-% {
  Sys.sleep(5)
  first + 1
} 
first %<-% {
  Sys.sleep(5)
  1
}
resolved(futureOf(first))
force(first) ## force first to be resolved
last ## still fails -- globals for last are defined when future is defined

rm(first)
rm(last)

## Define in the right order

plan(multiprocess)
first %<-% {
  Sys.sleep(5)
  1
} 
last %<-% {
  Sys.sleep(5)
  first + 1
}
last ## works

rm(first)
rm(last)


library(future)
plan(multiprocess)
library(dplyr)
f %<-% {
  mtcars %>% 
    filter(cyl == 4)
}
unloadNamespace("dplyr")
f

find("filter")
library(dplyr)
find("filter")
