library(future)

THIS_PID <- Sys.getpid()

plan(multiprocess, workers = 4)
rm(x)

a <- 2

x %<-% {
  Sys.sleep(10)
  2*a
}

x

i <- 1
# loop for a long time
while (i < 100) {
  ## if x is not yet resolved, print a growing message
  if (!resolved(futureOf(x))) {
    cat(paste0("\rwaiting for x... ", strrep("*", i)))
    ## if bored, make a plot
    if (i == 10) plot(mtcars$hp, mtcars$disp, col = mtcars$cyl, pch = 18, cex = 3)
    i <- i + 1
  } else {
    cat("\r\n")
    print(x)
    break
  }
}






####

rm(v)
v <- new.env()
for (ii in letters[1:3]) {
  v[[ii]] %<-% {
    Sys.sleep(5)
    Sys.getpid()
  }
}
v <- as.list(v)
str(v)

## lazy evaluation

y %<-% {
  Sys.sleep(3)
  Sys.getpid()
} %lazy% TRUE
y

broken_y %<-% {
  Sys.sleep(3)
  log("foo")
} %lazy% TRUE
broken_y
broken_y

####

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
b

## explicitly allow multiprocess for nested futures
plan(list(tweak(multiprocess, workers = 2L), tweak(multiprocess, workers = 2L)))
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
b

## chaining

library(future)
plan(multiprocess)

## unresolved futures can't be chained since they are not shared

last %<-% {
  Sys.sleep(5)
  first + 1
} 
first %<-% {
  Sys.sleep(5)
  1
} 
last

## must ensure they are resolved first -- okay when sequential since they are the same env

plan(sequential)
last %<-% {
  Sys.sleep(5)
  first + 1
} %lazy% TRUE
first %<-% {
  Sys.sleep(5)
  1
} %lazy% TRUE
last

## not if multiprocess

plan(multiprocess)
last %<-% {
  Sys.sleep(5)
  first + 1
} %lazy% TRUE
first %<-% {
  Sys.sleep(5)
  1
} %lazy% TRUE
last

## Force first to be resolved

plan(multiprocess)
last %<-% {
  Sys.sleep(5)
  first + 1
} %lazy% TRUE
first %<-% {
  Sys.sleep(5)
  1
} %lazy% TRUE
resolved(futureOf(first))
force(first) ## force first to be resolved
last

## Don't use lazy evaluation

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

## mandelbrot
plan(multiprocess, workers = 12)
demo("mandelbrot", package = "future", ask = FALSE)

### dash

z <- 5

Sys.sleep(10)
a <- 10^z
b <- "banana"
nums <- runif(a)

Rcade::games$Mariohtml5


### promises
library(future)
library(promises)
library(tibble)

longRunningFunction <- function(value) {
  Sys.sleep(5)
  return(value)
}

a <- future(longRunningFunction(tibble(number = 1:100)), lazy = TRUE)

values(a)

b <- a %...>%
  print()                                  # Time: 5s
b

print("User interaction")                  # Time: 0s

library(shiny)
