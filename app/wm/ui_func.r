box <- function(input,style=""){
  div(style=paste0("
    margin: 10px 0px 5px 0px;
    border: 1px solid #FFA500;
    border-top: 2px solid #FFA500;
    padding: 15px 10px 10px 10px;
    background: #fff;
    width: 100%;
    border-radius: 5px;",style),
    input
  )
}
