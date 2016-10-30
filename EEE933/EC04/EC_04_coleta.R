# Carrega a biblioteca com as funções
if(!require(devtools)){
  install.packages("devtools")
  library(devtools)
  devtools::install_github("fcampelo/ExpDE", ref = "devel")
  library(ExpDE)
}
if(!require(ExpDE)){
  devtools::install_github("fcampelo/ExpDE", ref = "devel")
  install.packages("ExpDE")
  library(ExpDE)
}

# Limpa as variáveis armazenadas no workspace
rm(list = ls())

# Limpa o console
cat("\014") 

# Número de amostras definido a partir da análise de potência a priori
n <- 491

# Parâmetros fixos do algoritmo de evolução diferencial
selpars <- list(name = "selection_standard")
stopcrit <- list(names = "stop_maxeval", maxevals = 100000, maxiter = 2000)
probpars <- list(name = "rastrigin",
                 xmin = seq(-100, -10, 10),
                 xmax = seq(10, 100, 10))
seed <- NULL
showpars <- list(show.iters = "dots", showevery = 50)

# Realiza a coleta de dados para o número de amostras desejado
iter <- 1
fbest1<-c()
fbest2<-c()
fbest3<-c()
fbest4<-c()

while(iter<=n){
  ## Config 1
  recpars <- list(name = "recombination_arith")
  mutpars <- list(name = "mutation_none")
  popsize <- 500
  out1 <- ExpDE(popsize, mutpars, recpars, selpars, stopcrit, probpars, seed, showpars)
  fbest1 <- c(fbest1,out1$Fbest)
  
  ## Config 2
  recpars <- list(name = "recombination_none")
  mutpars <- list(name = "mutation_wgi", f = 1)
  popsize <- 500
  out2 <- ExpDE(popsize, mutpars, recpars, selpars, stopcrit, probpars, seed, showpars)
  fbest2 <- c(fbest2,out2$Fbest)
  
  ## Config 3
  recpars <- list(name = "recombination_exp", cr = 0.6)
  mutpars <- list(name = "mutation_best", f = 2)
  popsize <- 130
  out3 <- ExpDE(popsize, mutpars, recpars, selpars, stopcrit, probpars, seed, showpars)
  fbest3 <- c(fbest3,out3$Fbest)
  
  ## Config 4
  recpars <- list(name = "recombination_blxAlphaBeta", alpha = 0.1, beta = 0.4)
  mutpars <- list(name = "mutation_rand", f = 3)
  popsize <- 80
  out4 <- ExpDE(popsize, mutpars, recpars, selpars, stopcrit, probpars, seed, showpars)
  fbest4 <- c(fbest4,out4$Fbest)
  
  iter <- iter +1
  
  cat("Iteração =",iter)
}

df <- data.frame(fbest1,fbest2,fbest3, fbest4)
colnames(df) <- c('Config1', 'Config2','Config3','Config4')
summary(df)

# Salva em .csv com as saídas Fbest para cada configuração em uma coluna distinta
write.csv(file="data.csv", x=df)