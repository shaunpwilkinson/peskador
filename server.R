################################################################################
library(shiny)
library(lubridate)
library(zoo)

shinyServer(function(input, output){
  tmp <- tempfile(fileext = ".csv")
  test <- download.file(paste0("https://docs.google.com/spreadsheets/d/e/2PACX-1vSO-",
                               "ivIULOs5WOVwI1A0n-QPkgLiQ5bG8oTy4_NJJGQbqU15dVA5f0",
                               "oFXa6E7Op43dZz4j5T4-lWUTY/pub?gid=2135385965&single=",
                               "true&output=csv"), destfile = tmp, quiet = TRUE)
  if(test != 0) stop("Error 1")
  x <- read.csv(tmp, stringsAsFactors = FALSE)
  # remove all rows whose parent trips contain NAs
  discards <- is.na(x$station) | is.na(x$hab) | is.na(x$gear)| 
    is.na(x$weight_g) | is.na(x$trip_effort) #logical
  discards <- x$Trip_ID[discards] #indices
  discards <- x$Trip_ID %in% discards #logical
  x <- x[!discards, ] 

  output$plot1 <- renderPlot({
    indices <- match(input$site, c("Adara", "Beloi", "Biqueli", "Vemasse", "Adarai",
                                   "Uaroana", "Com", "Tutuala", "Lore"))
    x <- x[x$station %in% indices, ]
    indices <- match(input$hab, c("Reef", "FAD", "Deep", "Beach"))
    x <- x[x$hab %in% indices, ]
    indices <- match(input$gear, c("Net", "Hook & Line", "Spear"))
    indices <- unlist(list(c(1, 5, 7:11), 2:3, 4)[indices])
    x <- x[x$gear %in% indices, ]
    if(nrow(x) < 20){
      # plot(0,type='n',axes=FALSE,ann=FALSE)
      return(NULL)
    }
    newx <- aggregate(x$date, by = list(x$Trip_ID), FUN = function(x) x[1])[2]
    colnames(newx) <- "date"
    newx$tripkg <- aggregate(x$weight_g/1000, by = list(x$Trip_ID), FUN = sum)[[2]]
    newx$triphours <- aggregate(x$trip_effort, by = list(x$Trip_ID), FUN = function(x) x[1])[[2]]
    newx$date <- lubridate::ceiling_date(as.Date(newx$date), unit = "month")
    monthlyCPUE <- aggregate(newx[2:3], by = list(newx$date), FUN = sum) 
    monthlyCPUE$CPUE <- monthlyCPUE$tripkg/monthlyCPUE$triphours
    colnames(monthlyCPUE) <- c("date", "KG", "hours", "CPUE")
    monthlyCPUE <- monthlyCPUE[seq(1, nrow(monthlyCPUE) - 1), ] # remove partial month at end
    #CPUE <- zoo::zoo(monthlyCPUE[2:4], monthlyCPUE$date)
     catch <- zoo::zoo(monthlyCPUE$KG, monthlyCPUE$date)
     effort <- zoo::zoo(monthlyCPUE$hours, monthlyCPUE$date)
     CPUE <- zoo::zoo(monthlyCPUE$CPUE, monthlyCPUE$date)
    op <- par(no.readonly = TRUE)
    par(mfrow = c(3, 1), mar = c(2, 4, 0.2, 2), cex = 1.0)
    plot(catch, ylab = "Total catch (kg)", xaxt = "n", col = "orange", lwd = 2, type = "b")
    plot(effort, ylab = "Total effort (hours)", xaxt = "n", col = "darkgreen", lwd = 2, type = "b")
    plot(CPUE, ylab = "CPUE (kg/hour)", xaxt = "n", col = "blue", lwd = 2, type = "b")
    labs <- format(time(CPUE), "%b-%Y")
    axis(1, at = time(CPUE), labels = labs)
    par(op)
  })
})
