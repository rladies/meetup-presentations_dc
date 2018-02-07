# Plumber Script Example 1

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

# Plumber Script Example 2
# devtools::install_github("hadley/pillar")
# devtools::install_github("ropenscilabs/skimr")

library(skimr)

#' Return summary of
#' @param spec If provided, filter the data to only this species (e.g. 'setosa')
#' @get /iris_summary
function(spec){
  return(skim(iris))
}
