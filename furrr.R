library(furrr)
plan(multiprocess, workers = 4)
set.seed(1)

n <- 1e4

nums <- furrr::future_map(
  seq_len(n), 
  ~rnorm(.x, mean = 100, sd = 10), 
  .progress = TRUE
)

plot(seq_len(n), purrr::map(nums, mean), type = "l")
abline(h = 100, col = "red")
