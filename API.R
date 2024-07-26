#API.R 
library(GGally)
library(leaflet)

#Send a message
#* @get /readme
function(){
  "This is our basic API"
}

#http://localhost:PORT/readme


#Echo the parameter that was sent in
#* @param msg The message to echo back.
#* @get /echo
function(msg=""){
  list(msg = paste0("The message is: '", msg, "'"))
}

#http://localhost:PORT/echo?msg=Hey

#Find natural log of a number
#* @param BMI BMI category
#* @param GenHlth General Health category
#* @get /pred
function(BMI = 25, GenHlth = 3){
  log(as.numeric(num))
}

#http://localhost:PORT/pred?BMI=40?GenHlth=4

#Find multiple of two numbers
#* @get /info
function() {
  "Charles Lane"
  "url"
}

#http://localhost:PORT/info
