#
# Fancy Iris Data ggplot functions
# https://drsimonj.svbtle.com/plotting-background-data-for-groups-with-ggplot2
#

library(ggplot2)

geom_hist_basic <- function(var){
  ggplot(iris, aes_string(x = var)) +
    geom_histogram() +
    facet_wrap(~ Species)
}


geom_hist_fancy <- function(var){
  ggplot(iris, aes_string(x = var, fill = "Species")) +
    geom_histogram(data = iris[,-5], fill = "grey", alpha = .5) +
    geom_histogram(colour = "black") +
    facet_wrap(~ Species) +
    guides(fill = FALSE) +
    theme_bw()
}

geom_hist_fancy("Sepal.Length")

points_facet <- function(x_var, y_var){
  ggplot(iris, aes_string(x = x_var, y = y_var, colour = "Species")) +
    geom_point(data = iris[,-5], colour = "grey", alpha = .2) +
    geom_point() +
    facet_wrap(~ Species) +
    guides(colour = FALSE) +
    theme_bw()
}

points_facet("Sepal.Width", "Sepal.Length")

compare_iris <- function(length, width){
  new.iris <- data.frame(Sepal.Length=length, Sepal.Width=width)
  ggplot(iris, aes_string(x = "Sepal.Width", y = "Sepal.Length", colour = "Species")) +
    geom_point(data = new.iris, colour = "black", alpha = 1) +
    geom_point(alpha = .5) +
    facet_wrap(~ Species) +
    guides(colour = FALSE) +
    theme_bw()
}
