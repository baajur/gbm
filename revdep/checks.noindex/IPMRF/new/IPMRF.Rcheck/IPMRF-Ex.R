pkgname <- "IPMRF"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
library('IPMRF')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
base::assign(".old_wd", base::getwd(), pos = 'CheckExEnv')
cleanEx()
nameEx("ipmgbmnew")
### * ipmgbmnew

flush(stderr()); flush(stdout())

### Name: ipmgbmnew
### Title: IPM casewise with gbm object by 'gbm' for new cases, whose
###   responses do not need to be known
### Aliases: ipmgbmnew
### Keywords: tree multivariate

### ** Examples


## Not run: 
##D library(party)
##D library(gbm)
##D gbm=gbm(score ~ ., data = readingSkills, n.trees=50, shrinkage=0.05, interaction.depth=5, 
##D         bag.fraction = 0.5, train.fraction = 0.5, n.minobsinnode = 1, 
##D         cv.folds = 0, keep.data=F, verbose=F)
##D apply(ipmgbmnew(gbm,readingSkills[,-4],50),FUN=mean,2)->gbm_ipm
##D gbm_ipm
## End(Not run)



cleanEx()
nameEx("ipmparty")
### * ipmparty

flush(stderr()); flush(stdout())

### Name: ipmparty
### Title: IPM casewise with CIT-RF by 'party' for OOB samples
### Aliases: ipmparty
### Keywords: tree multivariate

### ** Examples

#Note: more examples can be found at 
#https://bmcbioinformatics.biomedcentral.com/articles/10.1186/s12859-017-1650-8

## -------------------------------------------------------
## Example from \code{\link[party]{varimp}} in \pkg{party}
## Classification RF
## -------------------------------------------------------

## Not run: 
##D library(party)
##D 
##D #from help in varimp by party package
##D set.seed(290875)
##D readingSkills.cf <- cforest(score ~ ., data = readingSkills,
##D control = cforest_unbiased(mtry = 2, ntree = 50))
##D 
##D # standard importance
##D varimp(readingSkills.cf)
##D 
##D # the same modulo random variation
##D varimp(readingSkills.cf, pre1.0_0 = TRUE)
##D 
##D # conditional importance, may take a while...
##D varimp(readingSkills.cf, conditional = TRUE)
## End(Not run)

#IMP based on CIT-RF (party package)
library(party)

ntree<-50
#readingSkills: data from party package
da<-readingSkills[,1:3] 
set.seed(290875)
readingSkills.cf3 <- cforest(score ~ ., data = readingSkills,
control = cforest_unbiased(mtry = 3, ntree = 50))

#IPM case-wise computed with OOB with party
pupf<-ipmparty(readingSkills.cf3 ,da,ntree)
 
#global IPM
pua<-apply(pupf,2,mean) 
pua

## -------------------------------------------------------
## Example from \code{\link[randomForestSRC]{var.select}} in \pkg{randomForestSRC} 
## Multivariate mixed forests
## -------------------------------------------------------

## Not run: 
##D library(randomForestSRC)
##D 
##D #from help in var.select by randomForestSRC package
##D mtcars.new <- mtcars
##D mtcars.new$cyl <- factor(mtcars.new$cyl)
##D mtcars.new$carb <- factor(mtcars.new$carb, ordered = TRUE)
##D mv.obj <- rfsrc(cbind(carb, mpg, cyl) ~., data = mtcars.new,
##D importance = TRUE)
##D var.select(mv.obj, method = "vh.vimp", nrep = 10) 
##D 
##D #different variables are selected if var.select is repeated 
##D 
## End(Not run)

#IMP based on CIT-RF (party package)
library(randomForestSRC)
mtcars.new <- mtcars

ntree<-500
da<-mtcars.new[,3:10] 
mc.cf <- cforest(carb+ mpg+ cyl ~., data = mtcars.new,
control = cforest_unbiased(mtry = 8, ntree = 500))

#IPM case-wise computing with OOB with party
pupf<-ipmparty(mc.cf ,da,ntree) 

#global IPM
pua<-apply(pupf,2,mean) 
pua

#disp and hp are consistently selected as more important if repeated





cleanEx()
nameEx("ipmpartynew")
### * ipmpartynew

flush(stderr()); flush(stdout())

### Name: ipmpartynew
### Title: IPM casewise with CIT-RF by 'party' for new cases, whose
###   responses do not need to be known
### Aliases: ipmpartynew
### Keywords: tree multivariate

### ** Examples

#Note: more examples can be found at 
#https://bmcbioinformatics.biomedcentral.com/articles/10.1186/s12859-017-1650-8

## -------------------------------------------------------
## Example from \code{\link[party]{varimp}} in \pkg{party}
## Classification RF
## -------------------------------------------------------


library(party)


#IMP based on CIT-RF (party package)
ntree=50
#readingSkills: data from party package
da=readingSkills[,1:3] 
set.seed(290875)
readingSkills.cf3 <- cforest(score ~ ., data = readingSkills,
control = cforest_unbiased(mtry = 3, ntree = 50))

#new case
nativeSpeaker='yes'
age=8
shoeSize=28
da1=data.frame(nativeSpeaker, age, shoeSize)

#IPM case-wise computed for new cases for party package
pupfn=ipmpartynew(readingSkills.cf3,da1,ntree)
pupfn



cleanEx()
nameEx("ipmranger")
### * ipmranger

flush(stderr()); flush(stdout())

### Name: ipmranger
### Title: IPM casewise with RF by 'ranger' for OOB samples
### Aliases: ipmranger
### Keywords: tree multivariate

### ** Examples

#Note: more examples can be found at 
#https://bmcbioinformatics.biomedcentral.com/articles/10.1186/s12859-017-1650-8

## Not run: 
##D library(ranger)
##D num.trees=500
##D rf <- ranger(Species ~ ., data = iris,keep.inbag = TRUE,num.trees=num.trees)
##D 
##D IPM=apply(ipmranger(rf,iris[,-5],num.trees),FUN=mean,2)
## End(Not run)



cleanEx()
nameEx("ipmrangernew")
### * ipmrangernew

flush(stderr()); flush(stdout())

### Name: ipmrangernew
### Title: IPM casewise with RF by 'ranger' for new cases, whose responses
###   do not need to be known
### Aliases: ipmrangernew
### Keywords: tree multivariate

### ** Examples


## Not run: 
##D library(ranger)
##D num.trees=500
##D rf <- ranger(Species ~ ., data = iris,keep.inbag = TRUE,num.trees=num.trees)
##D 
##D IPM_complete=apply(ipmrangernew(rf,iris[,-5],num.trees),FUN=mean,2)
## End(Not run)



cleanEx()
nameEx("ipmrf")
### * ipmrf

flush(stderr()); flush(stdout())

### Name: ipmrf
### Title: IPM casewise with CART-RF by 'randomForest' for OOB samples
### Aliases: ipmrf
### Keywords: tree multivariate

### ** Examples

#Note: more examples can be found at 
#https://bmcbioinformatics.biomedcentral.com/articles/10.1186/s12859-017-1650-8

## Not run: 
##D 
##D library(mlbench)
##D #data used by Breiman, L.: Random forests. Machine Learning 45(1), 5--32 (2001)
##D data(PimaIndiansDiabetes2) 
##D Diabetes <- na.omit(PimaIndiansDiabetes2)
##D 
##D set.seed(2016)
##D require(randomForest)
##D ri<- randomForest(diabetes  ~ ., data=Diabetes, ntree=500, importance=TRUE,
##D keep.inbag=TRUE,replace = FALSE) 
##D 
##D #GVIM and PVIM (CART-RF)
##D im=importance(ri)
##D im
##D #rank
##D ii=apply(im,2,rank)
##D ii
##D 
##D #IPM based on CART-RF (randomForest package)
##D da=Diabetes[,1:8]
##D ntree=500
##D #IPM case-wise computed with OOB 
##D pupf=ipmrf(ri,da,ntree) 
##D 
##D #global IPM
##D pua=apply(pupf,2,mean) 
##D pua
##D 
##D #IPM by classes
##D attach(Diabetes)
##D puac=matrix(0,nrow=2,ncol=dim(da)[2])
##D puac[1,]=apply(pupf[diabetes=='neg',],2,mean) 
##D puac[2,]=apply(pupf[diabetes=='pos',],2,mean) 
##D colnames(puac)=colnames(da)
##D rownames(puac)=c( 'neg', 'pos')
##D puac
##D 
##D #rank IPM 
##D #global rank 
##D rank(pua) 
##D #rank by class
##D apply(puac,1,rank) 
## End(Not run)



cleanEx()
nameEx("ipmrfnew")
### * ipmrfnew

flush(stderr()); flush(stdout())

### Name: ipmrfnew
### Title: IPM casewise with CART-RF by 'randomForest' for new cases, whose
###   responses do not need to be known
### Aliases: ipmrfnew
### Keywords: tree multivariate

### ** Examples

#Note: more examples can be found at 
#https://bmcbioinformatics.biomedcentral.com/articles/10.1186/s12859-017-1650-8


library(mlbench)
#data used by Breiman, L.: Random forests. Machine Learning 45(1), 5--32 (2001)
data(PimaIndiansDiabetes2) 
Diabetes <- na.omit(PimaIndiansDiabetes2)

set.seed(2016)
require(randomForest)
ri<- randomForest(diabetes  ~ ., data=Diabetes, ntree=500, importance=TRUE,
keep.inbag=TRUE,replace = FALSE) 

#new cases
da1=rbind(apply(Diabetes[Diabetes[,9]=='pos',1:8],2,mean),
apply(Diabetes[Diabetes[,9]=='neg',1:8],2,mean))


#IPM case-wise computed for new cases for randomForest package
ntree=500
pupfn=ipmrfnew(ri, as.data.frame(da1),ntree)
pupfn




### * <FOOTER>
###
cleanEx()
options(digits = 7L)
base::cat("Time elapsed: ", proc.time() - base::get("ptime", pos = 'CheckExEnv'),"\n")
grDevices::dev.off()
###
### Local variables: ***
### mode: outline-minor ***
### outline-regexp: "\\(> \\)?### [*]+" ***
### End: ***
quit('no')
