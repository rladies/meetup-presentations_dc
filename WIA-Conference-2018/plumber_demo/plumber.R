# Plumber Functions!

#
# Iris Plot Function 1
# Base plot with species and color parameters
#

library(ggplot2)

#' Plot out data from the iris dataset
#' @param spec If provided, filter the data to only this species (e.g. 'setosa')
#' @param colors If true, add colors for each species
#' @get /iris_plot
#' @png
function(spec, colors){
  myData <- iris
  title <- "All Species"

  # Filter if the species was specified
  if (!missing(spec)){
    title <- paste0("Only the '", spec, "' Species")
    myData <- subset(iris, Species == spec)
  }

  if (missing(colors) || colors == FALSE){
    return(plot(iris$Sepal.Length, iris$Petal.Length, xlab="Sepal Length", ylab="Petal Length"))
  }

  if (!missing(colors) & colors == TRUE){
    return(plot(myData$Sepal.Length, myData$Petal.Length,
         main=title, xlab="Sepal Length", ylab="Petal Length", col=myData$Species))
  }
}

#
# Iris Plot Function 2
# Facet a Single Variable
#

#' Produce a species facetted plot of an iris data variable
#' @param var Choose from: Sepal.Width, Sepal.Length, Petal.Width, Petal.Length
#' @get /geom_hist
#' @png
function(var){
  plot <- ggplot(iris, aes_string(x = var, fill = "Species")) +
    geom_histogram(data = iris[,-5], fill = "grey", alpha = .5) +
    geom_histogram(colour = "black") +
    facet_wrap(~ Species) +
    guides(fill = FALSE) +
    theme_bw()
  print(plot)
}

#
# Iris Plot Function 3
# Facet Two Variables (Points)
#

#' Produce a species facetted plot of two iris data variables
#' @param x_var Choose from: Sepal.Width, Sepal.Length, Petal.Width, Petal.Length
#' @param y_var Choose from: Sepal.Width, Sepal.Length, Petal.Width, Petal.Length
#' @get /points_facet
#' @png
function(x_var, y_var){
  plot<- ggplot(iris, aes_string(x = x_var, y = y_var, colour = "Species")) +
    geom_point(data = iris[,-5], colour = "grey", alpha = .2) +
    geom_point() +
    facet_wrap(~ Species) +
    guides(colour = FALSE) +
    theme_bw()
  print(plot)
}
