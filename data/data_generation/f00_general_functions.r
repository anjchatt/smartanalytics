
iterative_prob <- function(pdf){
  Pt <- pdf[1]
  Pt_1 <- 0
  Pit_1 <- 0
  if(Pt == 0){
    Pit <- 0
  }else{
    Pit <- Pt
  }
  
  Pt_1 <- Pt
  Pit_1 <- Pit
  
  prob <- rep(0, length(pdf))
  prob[1] <- Pit
  
  for(i in 2:length(pdf)){    
    Pt <- pdf[i]
    if(Pt == 0){
      Pit <- 0
    }else if(Pt_1 == 0){
      Pit <- Pt
      Pt_1 <- Pt
      Pit_1 <- Pit
    }else{
      Pit <- Pt/Pt_1*Pit_1/(1-Pit_1)
      Pt_1 <- Pt
      Pit_1 <- Pit
    }
    prob[i] <- Pit
  }
  prob
}
