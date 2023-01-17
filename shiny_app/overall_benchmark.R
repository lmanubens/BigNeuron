load('groupsdf.Rdata')
# groupsdf$algorithm[groupsdf$algorithm=="app2"] <- "none"#"app2"
# groupsdf$algorithm[groupsdf$algorithm=="app2new1"] <- "none"#"app2"
# groupsdf$algorithm[groupsdf$algorithm=="app2new2"] <- "app2"
# groupsdf$algorithm[groupsdf$algorithm=="app2new3"] <- "none"#"app2"
groupsdf$algorithm[groupsdf$algorithm=="Advantra"] <- "none"
groupsdf$algorithm[groupsdf$algorithm=="Advantra_updated"] <- "Advantra"
groupsdf$algorithm[groupsdf$algorithm=="neutube"] <- "none"
groupsdf$algorithm[groupsdf$algorithm=="neutube_updated"] <- "neutube"
groupsdf$algorithm[groupsdf$algorithm=="pyzh"] <- "none"
groupsdf$algorithm[groupsdf$algorithm=="pyzh_updated"] <- "pyzh"
groupsdf$algorithm[groupsdf$algorithm=="LCMboost"] <- "none"
groupsdf$algorithm[groupsdf$algorithm=="LCMboost_updated"] <- "LCMboost"
# groupsdf$algorithm[groupsdf$algorithm=="LCMboost_3"] <- "LCMboost"
groupsdf$algorithm[groupsdf$algorithm=="fastmarching_spanningtree"] <- "none"
groupsdf$algorithm[groupsdf$algorithm=="fastmarching_spanningtree_updated"] <- "fastmarching_spanningtree"
groupsdf$algorithm[groupsdf$algorithm=="axis_analyzer"] <- "none"
groupsdf$algorithm[groupsdf$algorithm=="axis_analyzer_updated"] <- "axis_analyzer"
groupsdf$algorithm[groupsdf$algorithm=="NeuronChaser"] <- "none"
groupsdf$algorithm[groupsdf$algorithm=="NeuronChaser_updated"] <- "NeuronChaser"
groupsdf$algorithm[groupsdf$algorithm=="meanshift"] <- "none"
groupsdf$algorithm[groupsdf$algorithm=="meanshift_updated"] <- "meanshift"
groupsdf$algorithm[groupsdf$algorithm=="NeuroGPSTree"] <- "none"
groupsdf$algorithm[groupsdf$algorithm=="NeuroGPSTree_updated"] <- "NeuroGPSTree"
# groupsdf$algorithm[groupsdf$algorithm=="EnsembleNeuronTracerBasic"] <- "none"
groupsdf$algorithm[groupsdf$algorithm=="ENT_updated"] <- "ENT"#"EnsembleNeuronTracerBasic"

# groupsdf$algorithm[grep("_MST_Tracing_Ws_21_th_170", groupsdf$paths)] <- "none"
groupsdf$algorithm[grep("_MST_Tracing_Ws_21_th_200", groupsdf$paths)] <- "none"

groupsdf$dataset <- substring(groupsdf$dataset,12)

groupsdf$dataset[groupsdf$dataset=="chick_uw"] <- "Chicken UW"
groupsdf$dataset[groupsdf$dataset=="frog_scrippts"] <- "Frog Scripps"
groupsdf$dataset[groupsdf$dataset=="fruitfly_larvae_gmu"] <- "Fly larvae GMU"
groupsdf$dataset[groupsdf$dataset=="human_allen_confocal"] <- "Human Allen"
groupsdf$dataset[groupsdf$dataset=="human_culturedcell_Cambridge_in_vitro_confocal_GFP"] <- "Human cultured CU"
groupsdf$dataset[groupsdf$dataset=="janelia_flylight_part1"] <- "Flylight"
groupsdf$dataset[groupsdf$dataset=="janelia_flylight_part2"] <- "Flylight"
groupsdf$dataset[groupsdf$dataset=="mouse_culturedcell_Cambridge_in_vivo_2_photon_PAGFP"] <- "Mouse cultured CU"
groupsdf$dataset[groupsdf$dataset=="mouse_korea"] <- "Mouse KIT"
groupsdf$dataset[groupsdf$dataset=="mouse_RGC_uw"] <- "Mouse RGC UW"
groupsdf$dataset[groupsdf$dataset=="mouse_tufts"] <- "Mouse Allen"
groupsdf$dataset[groupsdf$dataset=="silkmoth_utokyo"] <- "Silkmoth UT"
groupsdf$dataset[groupsdf$dataset=="taiwan_flycirciut"] <- "Flycircuit"
groupsdf$dataset[groupsdf$dataset=="utokyo_fly"] <- "Fly UT"
groupsdf$dataset[groupsdf$dataset=="zebrafish_adult_RGC_UW"] <- "Zebrafish RGC UW"
groupsdf$dataset[groupsdf$dataset=="zebrafish_horizontal_cells_UW"] <- "Zebrafish HC UW"
groupsdf$dataset[groupsdf$dataset=="zebrafish_larve_RGC_UW"] <- "Zebrafish larvae RGC UW"

load('subsetdata_v3.Rdata')
my_data$SNR_mean[is.na(my_data$SNR_mean)] <- 3e3
my_data$CNR_mean[is.na(my_data$CNR_mean)] <- 3e3

my_data$SNR_otsu[is.na(my_data$SNR_otsu)] <- 3e3
my_data$SNR_otsu[my_data$SNR_otsu>1e10] <- 3e3
my_data$CNR_otsu[is.na(my_data$CNR_otsu)] <- 3e3



ids <- sapply(strsplit(as.character(groupsdf$paths),'/'), "[", 8)
groupsdf$ids <- ids


pdata <- cbind(my_data,groupsdf)

pdata <- pdata[pdata$group=="Auto" | pdata$group=="Consensus",]
pdata <- pdata[pdata$algorithm!="none",]

# pdata <- arrange(pdata,pdata[,which(names(pdata)=='average of bi-directional entire-structure-averages')])
pdata$dists <- pdata[,which(names(pdata)=='average.of.bi.directional.entire.structure.averages')]
# pdata$dists <- pdata[,which(names(pdata)=='percent.of.different.structure')]
# pdata$dists <- pdata[,which(names(pdata)=='entire.structure.average..from.neuron.1.to.2.')]


npdata <-  data.frame(algorithm=pdata$algorithm)
npdata$N <- NULL
for(i in 1:length(pdata$algorithm)){
  # npdata$N[i] <- sum(pdata$algorithm %in% pdata$algorithm[i])
  npdata$N[i] <- sum(pdata$algorithm == pdata$algorithm[i])
}
# aggregate(pdata$dists, list(algorithm = pdata$algorithm), length)
npdata$lab <- paste0(pdata$algorithm,' (N=',npdata$N,')')
# npdata$dists <-NULL
pdata <-  merge(pdata,npdata,by='algorithm')
pdata$algorithm <- pdata$lab

ppdata <- aggregate(pdata$dists, list(pdata$algorithm), mean)

library(ggpubr)
library(dplyr)
p <- ggbarplot(pdata, x = "algorithm", y = "dists",
               order = arrange(ppdata,ppdata$x)$Group.1,
               # order = arrange(ppdata,desc(ppdata$x))$Group.1,
               # orientation = "horiz",
               # fill = "algorithm",
               fill="steelblue",
               # order = as.character(unique(arrange(pdata,pdata$dists)$algorithm)),
               # order = reorder(algorithm,dists),
               ylab= 'average of bi-directional entire-structure-average distances',
               # ylab= 'percent of different structure',
               # ylab= 'entire structure average from neuron 1 to 2',
               add = "mean_se") +
  theme(text = element_text(size=8),
        axis.text.x = element_text(angle=45, hjust=1),
        legend.position="none")

p



overall_df <- data.frame(algorithm=unique(pdata$algorithm),
                         nr_imgs_best=rep(0,length(unique(pdata$algorithm))),
                         nr_imgs_out=rep(NA,length(unique(pdata$algorithm))))

nr_out <- unlist(strsplit(overall_df$algorithm,"N="))[seq(2,70,2)]
overall_df$nr_imgs_out <- as.numeric(gsub(")","",nr_out))

for(id in unique(pdata$ids)){
  pdata2 <- pdata[pdata$ids==id,]
  pdata2 <- pdata2[!duplicated(pdata2),]
  overall_df[overall_df$algorithm == pdata2$algorithm[which(min(pdata2$dists)==pdata2$dists)],]$nr_imgs_best <- overall_df[overall_df$algorithm == pdata2$algorithm[which(min(pdata2$dists)==pdata2$dists)],]$nr_imgs_best + 1
  # overall_df[overall_df$algorithm == pdata2$algorithm[which(min(pdata2$dists)==pdata2$dists)],]$nr_imgs_out <- grepoverall_df[overall_df$algorithm == pdata2$algorithm[which(min(pdata2$dists)==pdata2$dists)],]$algorithm
}

overall_df <- overall_df[sort(overall_df$nr_imgs_best, decreasing = T, index.return = T)$ix,]

p2 <- ggbarplot(overall_df[1:20,], x = "algorithm", y = "nr_imgs_best",
               fill="steelblue",
               ylab= 'Number of images') +
  theme(text = element_text(size=8),
        axis.text.x = element_text(angle=45, hjust=1),
        legend.position="none")

p2
