library(future)
plan(multiprocess)

a <- 2

x %<-% {
  Sys.sleep(10)
  2*a
}

# WHEN WILL IT BE RESOLVED?

resolved(futureOf(x))
resolved(futureOf(x))
resolved(futureOf(x))
resolved(futureOf(x))
resolved(futureOf(x))
resolved(futureOf(x))

# WE CAN USE THE SESSION WHILE WE WAIT

x %<-% {
  Sys.sleep(10)
  2*a
}

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

rm(x)
rm(i)
rm(a)
