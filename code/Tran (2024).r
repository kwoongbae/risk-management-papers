# Fitting s(t), i(t) to the data.
population <- 261

timeline <- c(0.0000, 0.0397, 0.0822, 0.1247, 0.1671, 0.2096, 0.2521, 0.3370)
susceptible <- c(254, 235, 201, 153, 121, 108, 97, 83)
infected <- c(7, 14, 22, 29, 21, 8, 8, 0)

s_ratio <- susceptible / population
i_ratio <- infected / population

plot(timeline, s_ratio, type = "p", col = "blue", ylim = c(0, 1),
     xlab = "Timeline (0 to 1)", ylab = "Proportion of Population",
     main = "S(t) Ratio (Susceptible)")
lines(smooth.spline(timeline, s_ratio), col = "black", lwd = 2)

plot(timeline, i_ratio, type = "p", col = "red", ylim = c(0, 0.15),
     xlab = "Timeline (0 to 1)", ylab = "Proportion of Population",
     main = "I(t) Ratio (Infected)")
lines(smooth.spline(timeline, i_ratio), col = "black", lwd = 2)

# Log-likelihood function
estimate_parameters <- function(timeline, s_ratio, i_ratio, population){
  loss_function <- function(params){
    beta <- params[1]
    alpha <- params[2]
    
    predicted_i <- -diff(s_ratio) / diff(timeline) / beta
    predicted_r <- alpha*i_ratio[-length(i_raio)]
    
    residuals <- sum((predicted_i - i_ratio[-1])^2 + (predicted_r - diff(1 - s_ratio))^2)
    return(residuals)
  }
  
  initial_guess <- c(0.1, 0.1)
  
  result <- optim(initial_guess, loss_function, method = "L-BFGS-B", lower = c(0,0), upper = c(10,10))
  
  
                  
}


0.3257/(254/261)
0.6743/(254/261)
0.3257+0.6743
