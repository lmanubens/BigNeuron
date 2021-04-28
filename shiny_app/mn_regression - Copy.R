# require(foreign)
# require(nnet)
# require(ggplot2)
# require(reshape2)
# # https://stats.idre.ucla.edu/r/dae/multinomial-logistic-regression/
# ml_b <- read.dta("https://stats.idre.ucla.edu/stat/data/hsbdemo.dta")

require(tidyr)

plotCM <- function(cm){
  cmdf <- as.data.frame(cm[["table"]])
  cmdf[["color"]] <- ifelse(cmdf[[1]] == cmdf[[2]], "green", "red")
  
  alluvial::alluvial(cmdf[,1:2]
                     , freq = cmdf$Freq
                     , col = cmdf[["color"]]
                     , alpha = 0.5
                     , hide  = cmdf$Freq == 0
  )
}


load('subsetdata.Rdata')
load('groupsdf.Rdata')

data <- my_data 

for(i in 1:length(data)){
  if(skewness(data[,i]) > 1){
    data[,i] <- log10(data[,i])
  }
  else if(skewness(data[,i]) < (-1)){
    data[,i] <- log10(max(data[,i]+1) - data[,i])
  }
}
data[is.na(data)]<-0
data[data=='-Inf']<-0

groupsdf$algorithm[groupsdf$algorithm=="app2new1"] <- "app2"
groupsdf$algorithm[groupsdf$algorithm=="app2new2"] <- "app2"
groupsdf$algorithm[groupsdf$algorithm=="app2new3"] <- "app2"
groupsdf$algorithm[groupsdf$algorithm=="Advantra_updated"] <- "Advantra"
groupsdf$algorithm[groupsdf$algorithm=="neutube_updated"] <- "neutube"
groupsdf$algorithm[groupsdf$algorithm=="pyzh_updated"] <- "pyzh"
groupsdf$algorithm[groupsdf$algorithm=="LCMboost_updated"] <- "LCMboost"
groupsdf$algorithm[groupsdf$algorithm=="LCMboost_3"] <- "LCMboost"
groupsdf$algorithm[groupsdf$algorithm=="fastmarching_spanningtree_updated"] <- "fastmarching_spanningtree"
groupsdf$algorithm[groupsdf$algorithm=="axis_analyzer_updated"] <- "axis_analyzer"
groupsdf$algorithm[groupsdf$algorithm=="NeuronChaser_updated"] <- "NeuronChaser"
groupsdf$algorithm[groupsdf$algorithm=="meanshift_updated"] <- "meanshift"
groupsdf$algorithm[groupsdf$algorithm=="NeuroGPSTree_updated"] <- "NeuroGPSTree"
groupsdf$algorithm[groupsdf$algorithm=="ENT_updated"] <- "EnsembleNeuronTracerBasic"

ml <- cbind(data,groupsdf)
ml <- ml[,c(1:58,63,65)]
# ml <- melt(ml,id=44:46)

ml$ids <- sapply(strsplit(as.character(groupsdf$paths),'/'), "[", 8)

ml <- ml[ml$algorithm!="Annotated",]
##
ml$bestalg <- ml$algorithm

for(i in unique(ml$ids)){
  bestalg <- ml[ml$`average.of.bi.directional.entire.structure.averages` == min(ml[ml$ids==i,]$`average.of.bi.directional.entire.structure.averages`),]$algorithm
  ml[ml$ids == i,]$bestalg <- bestalg[1]
}

# ml <- ml[ml$algorithm==ml$bestalg,]
# ml$algorithm <- NULL
##

# levels(ml$variable)[levels(ml$variable)=='average.of.bi.directional.entire.structure.averages'] <- 'av_bid_ent_str_av'
names(ml)[names(ml) == 'average.of.bi.directional.entire.structure.averages'] <- 'av_bid_ent_str_av'


#################
ml$soma_surface_av <- 0
ml$num_stems_av <- 0
ml$num_bifurcations_av <- 0
ml$num_branches_av <- 0
ml$num_of_tips_av <- 0
ml$overall_x_span_av <- 0
ml$overall_y_span_av <- 0
ml$overall_z_span_av <- 0
ml$average_diameter_av <- 0
ml$total_length_av <- 0
ml$total_surface_av <- 0
ml$total_volume_av <- 0
ml$max_euclidean_distance_av <- 0
ml$max_path_distance_av <- 0
ml$max_branch_order_av <- 0
ml$average_contraction_av <- 0
ml$average_fragmentation_av <- 0
ml$parent_daughter_ratio_av <- 0
ml$bifurcation_angle_local_av <- 0
ml$bifurcation_angle_remote_av <- 0
ml$ave_R_av <- 0

for(i in unique(ml$ids)){
  ml[ml$ids==i,]$soma_surface_av <- rep(mean(ml[ml$ids==i,]$soma_surface),length(ml[ml$ids==i,]$soma_surface))
  ml[ml$ids==i,]$num_stems_av <- rep(mean(ml[ml$ids==i,]$num_stems),length(ml[ml$ids==i,]$num_stems))
  ml[ml$ids==i,]$num_bifurcations_av <- rep(mean(ml[ml$ids==i,]$num_bifurcations),length(ml[ml$ids==i,]$num_bifurcations))
  ml[ml$ids==i,]$num_branches_av <- rep(mean(ml[ml$ids==i,]$num_branches),length(ml[ml$ids==i,]$num_branches))
  ml[ml$ids==i,]$num_of_tips_av <- rep(mean(ml[ml$ids==i,]$num_of_tips),length(ml[ml$ids==i,]$num_of_tips))
  ml[ml$ids==i,]$overall_x_span_av <- rep(mean(ml[ml$ids==i,]$overall_x_span),length(ml[ml$ids==i,]$overall_x_span))
  ml[ml$ids==i,]$overall_y_span_av <- rep(mean(ml[ml$ids==i,]$overall_y_span),length(ml[ml$ids==i,]$overall_y_span))
  ml[ml$ids==i,]$overall_z_span_av <- rep(mean(ml[ml$ids==i,]$overall_z_span),length(ml[ml$ids==i,]$overall_z_span))
  ml[ml$ids==i,]$average_diameter_av <- rep(mean(ml[ml$ids==i,]$average_diameter),length(ml[ml$ids==i,]$average_diameter))
  ml[ml$ids==i,]$total_length_av <- rep(mean(ml[ml$ids==i,]$total_length),length(ml[ml$ids==i,]$total_length))
  ml[ml$ids==i,]$total_surface_av <- rep(mean(ml[ml$ids==i,]$total_surface),length(ml[ml$ids==i,]$total_surface))
  ml[ml$ids==i,]$total_volume_av <- rep(mean(ml[ml$ids==i,]$total_volume),length(ml[ml$ids==i,]$total_volume))
  ml[ml$ids==i,]$max_euclidean_distance_av <- rep(mean(ml[ml$ids==i,]$max_euclidean_distance),length(ml[ml$ids==i,]$max_euclidean_distance))
  ml[ml$ids==i,]$max_path_distance_av <- rep(mean(ml[ml$ids==i,]$max_path_distance),length(ml[ml$ids==i,]$max_path_distance))
  ml[ml$ids==i,]$max_branch_order_av <- rep(mean(ml[ml$ids==i,]$max_branch_order),length(ml[ml$ids==i,]$max_branch_order))
  ml[ml$ids==i,]$average_contraction_av <- rep(mean(ml[ml$ids==i,]$average_contraction),length(ml[ml$ids==i,]$average_contraction))
  ml[ml$ids==i,]$average_fragmentation_av <- rep(mean(ml[ml$ids==i,]$average_fragmentation),length(ml[ml$ids==i,]$average_fragmentation))
  ml[ml$ids==i,]$parent_daughter_ratio_av <- rep(mean(ml[ml$ids==i,]$parent_daughter_ratio),length(ml[ml$ids==i,]$parent_daughter_ratio))
  ml[ml$ids==i,]$bifurcation_angle_local_av <- rep(mean(ml[ml$ids==i,]$bifurcation_angle_local),length(ml[ml$ids==i,]$bifurcation_angle_local))
  ml[ml$ids==i,]$bifurcation_angle_remote_av <- rep(mean(ml[ml$ids==i,]$bifurcation_angle_remote),length(ml[ml$ids==i,]$bifurcation_angle_remote))
  ml[ml$ids==i,]$ave_R_av <- rep(mean(ml[ml$ids==i,]$ave_R),length(ml[ml$ids==i,]$ave_R))
}

##################

with(ml, table(variable, algorithm))
with(ml, do.call(rbind, tapply(av_bid_ent_str_av, algorithm, function(x) c(M = mean(x), SD = sd(x)))))

# https://dataaspirant.com/2017/02/03/decision-tree-classifier-implementation-in-r/
library(caret)
library(rpart.plot)

# Normalize dataset
# ml[,1:43] <- scale(ml[,1:43])
anyNA(ml)

ml$group <- NULL
ml$dataset <- NULL
ml$ids <- NULL
ml$`entire-structure-average (from neuron 1 to 2)`<- NULL
ml$`entire-structure-average (from neuron 2 to 1)`<- NULL
ml$av_bid_ent_str_av <- NULL
ml$`different-structure-average`<- NULL
ml$`percent of different-structure (from neuron 1 to 2)`<- NULL
ml$`percent of different-structure (from neuron 2 to 1)`<- NULL
ml$`percent of different-structure`<- NULL

ml <- droplevels(ml)

# ml[,1:43] <- scale(ml[,1:43])

# Create training dataset
# set.seed(3033)
intrain <- createDataPartition(y = ml$bestalg, p= 0.1, list = FALSE)
training <- ml[intrain,]
testing <- ml[-intrain,]
training <- droplevels(training)

#check dimensions of train & test set
dim(training); dim(testing);

# Training
trctrl <- trainControl(method = "repeatedcv", number = 10, repeats = 5)
# preProcessInTrain<-c("center", "scale")
# metric_used<-"algorithm"

# set.seed(3333)
dtree_fit <- train(bestalg ~., data = training, method = "rpart2",
                   parms = list(split = "information"),
                   trControl=trctrl,
                   # metric=metric_used,
                   # preProc = preProcessInTrain,
                   tuneLength = 10)

# Plot decision tree
prp(dtree_fit$finalModel, box.palette = "Blues", tweak = 1.2)

# Predict
predict(dtree_fit, newdata = testing[1,])
test_pred <- predict(dtree_fit, newdata = testing)
confusionMatrix(test_pred, as.factor(testing$bestalg)) %>% plotCM() #check accuracy

confusionMatrix(test_pred, as.factor(testing$bestalg))
CM <- confusionMatrix(test_pred, as.factor(testing$bestalg))
CM$overall[1]

######
trainset <- c(0.05,0.1,0.2,0.3,0.4,0.5,0.6,0.7)
accuracy <- c(0.778,0.869,0.959,0.962,0.940,0.939,0.949,0.966)
dfplot <-  data.frame(trainset,accuracy)

ggpubr::ggdotplot(dfplot,x='trainset',y='accuracy')

