if (!require("RERconverge", character.only=T, quietly=T)) {
  require(devtools)
  install_github("nclark-lab/RERconverge", ref="master")
  #"ref" can be modified to specify a particular branch
}
library(RERconverge)


rerpath = find.package('RERconverge') #If this errors, there is an issue with installation
print(rerpath)