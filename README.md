# BigNeuron Shiny app


<!--[![biorXiv shield](https://img.shields.io/badge/arXiv-1709.01233-red.svg?style=flat)](https://www.biorxiv.org/content/10.1101/2022.05.10.491406v1) -->
<!--[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.1246979.svg)](https://doi.org/10.5281/zenodo.1246979) -->


## Contents

- [Repo Contents](#repo-contents)
- [System Requirements](#system-requirements)
- [Installation Guide](#installation-guide)
- [Demo](#demo)
- [License](./LICENSE)
- [Issues](https://github.com/lmanubens/BigNeuron/issues)
- [Citation](#citation)

# Repo Contents

- [Shiny app code](./shiny_app): `Shiny` app code.
- [Test data](./test_upload_new_alg): Example reconstruction set for testing results of reconstructions obtained by an end-user. Notice that the provided reconstructions are exact copies of the same tree.


# System Requirements

## Hardware Requirements

The BigNeuron Shiny app requires only a standard computer with enough RAM to support the operations defined by a user. For minimal performance, this will be a computer with about 500 MB of RAM. For optimal performance, we recommend a computer with the following specs:

RAM: 500+ MB  
CPU: single core, 1.6+ GHz

The runtimes below are generated using a computer with the recommended specs (16 GB RAM, 4 cores@1.6 GHz) and internet of speed 25 Mbps.

## Software Requirements

### OS Requirements

The package development version is tested on *Linux*, *MacOS* and *Windows* operating systems. The developmental version of the package has been tested on the following systems:

Linux: Centos 8  
Mac OSX:  Monterey 12.3.1  
Windows:  10 and 11

The Shiny app should be compatible with Windows, Mac, and Linux operating systems. 
To allow upload of novel reconstruction algorithm bench testing results, the Shiny app relies on a Linux binary version of Vaa3D. Thus, this functionality is only supported when running on Linux.

Before setting up the `BigNeuron` Shiny app, users should have `R` version 4.1.0 or higher, and several packages set up from CRAN. 

#### Installing R version 4.1.0 on Centos 8

the latest version of R can be installed by adding the EPEL repository to `yum`:

```
sudo yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
sudo dnf config-manager --set-enabled powertools

sudo bash -c "$(curl -L https://rstd.io/r-install)"

vim ~/.bashrc
export PATH=$PATH:/opt/R/4.1.0/bin/

source .bashrc 
```

#### Installing R on MacOS

Download and install the corresponding binary .pkg file from:

https://cran.r-project.org/bin/macosx/

#### Installing R on Windows

Download and install the corresponding binary .exe file from:

https://cran.r-project.org/bin/windows/base/


In all cases it should install in about 20 seconds.

# Installation Guide

### Package dependencies

Users should install the following packages prior to running the Shiny app, from an `R` terminal:

```
options("repos" = c("CRAN" = "https://cran.rstudio.com",
                    "rforge" = "http://R-Forge.R-project.org"))
                    
install.packages(c('shiny', 'plotly', 'Rtsne', 'corrplot', 'heatmaply', 'ggpubr', 'nat', 'dendroextras','dendextend','factoextra','tiff','jpeg','grid','rmarkdown','rgl','moments','mclust'))
if(!require("ggbiplot")) devtools::install_github("vqv/ggbiplot")
if(!require("nat.nblast")) devtools::install_github("natverse/neuromorphr")
```

which will install in about 5 minutes on a machine with the recommended specs.

The `BigNeuron` Shiny app functions with all packages in the following versions:
```
shiny_1.6.0
plotly_4.9.4.1
Rtsne_0.15
corrplot_0.89 
heatmaply_1.2.1
ggpubr_0.4.0
nat_1.8.16
nat.nblast_1.6.5
dendroextras_0.2.3
dendextend_1.15.1
factoextra_1.0.7
tiff_0.1-8
jpeg_0.1-8.1
rmarkdown_2.9
rgl_0.106.8
moments_0.14
mclust_5.4.7 
```

If you are having an issue that you believe to be tied to software versioning issues, please drop us an [Issue](https://github.com/lmanubens/BigNeuron/issues). 

### Shiny app Installation

First download the repository code and data locally, by clicking "Code Download ZIP" or typing in a command line:

```
git clone https://github.com/lmanubens/BigNeuron.git
```

From an `R` session in the BigNeuron/shiny_app folder, type:

```
library(shiny)
runApp()
```


# Demo

## Ready-to-use web app

For interactive usage of the web app please check:

```
https://linusmg.shinyapps.io/BigNeuron_Gold166/
```

## Selecting the analyzed data

The checklists in the left and the bottom of the web app allow the users to choose specific metrics and data subsets of interest respectively.

## Dimensionality reduction

The PCA and t-SNE tabs allow to generate interactive plots of the mentioned analyses. By selecting subsets of the data or metrics of interest, the plots will automatically update.

PCA usually takes between 5 and 10 seconds depending on data subset used.
t-SNE usually takes between 2 and 30 seconds.

## Clustering

This tab allows to visualize a correlation matrix of the selected metrics, and provides hierarchical clustering trees for only morphological metrics, only image quality metrics, or both.
Finally, within this tab it is possible to visualize 2D projections of neuron images, gold standard reconstructions and automated reconstructions with and without preprocessing (sorting and merging of disconnected components).

Clustering usually takes between 5 and 10 seconds depending on data subset used.

## Sholl

This tab shows a cross-species comparison of neuron complexity, density of branch points and size (bounding box - bbx).

Sholl analysis usually takes about 5 seconds.

## Persistent Homology

This tab allows to visualize an interactive TMD distance matrix of gold standard trees. By clicking any element in the distance matrix, the persistence diagrams, barcodes and images of a pair of neurons will be showed in the page. The plots are accompanied with 3D visualizations of the trees and metadata.

Persistent Homology visualization usually takes about 10 seconds.

## Distances

This tab produces a bench marking barplot of automatic reconstruction algorithm quality. Notice that a set of automatic reconstruction algorithms must be selected to ensure this analysis provides resuls.

Bench marking visualization usually takes about 45 seconds.

## Bench marking novel algorithms in the BigNeuron Shiny app

To encourage developers to continue further automatic reconstruction algorithm development efforts and to simplify benchmarking of novel algorithms, we added to the Shiny app the possibility of uploading and interactively bench-testing reconstruction results of user-defined algorithms. The gold standard preprocessed imaging datasets can be downloaded from https://github.com/BigNeuron/Data/releases/tag/Gold166_v1. After generating single-cell reconstructions for any subset of the data, the obtained automatic reconstructions can be uploaded by specifying the dataset identity (id) of each reconstruction in the filename (see id lookup table https://github.com/lmanubens/BigNeuron/blob/main/lookup_gold166.csv) e.g.: "1.swc". Once uploaded, the user needs to name the novel reconstruction algorithm and include it in the interactive analysis and benchmarking. 


# Citation

If you use this code or data we kindly ask that you please cite [Manubens-Gil et al, 2022](https://www.biorxiv.org/content/10.1101/2022.05.10.491406v1) and [Peng et al, 2015](https://www.cell.com/neuron/fulltext/S0896-6273(15)00599-1). If you use the Vaa3D plugins please also cite [Peng et al, 2010](https://www.nature.com/articles/nbt.1612), [Peng et al, 2014](https://www.nature.com/articles/nprot.2014.011) and [Peng et al, 2014](https://www.nature.com/articles/ncomms5342). 

