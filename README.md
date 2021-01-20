# Political promises
Exam project for Cultural Data Science 2020

### Contributors
Frida Hæstrup and Marie Mortensen

### Prerequisites
To run the script it is required that you have R version 3.6.1, RStudio version 1.3.1093, Python version 3.8 installed.
Link to softwares and interfaces:

R: https://cran.r-project.org/bin/macosx/ 

Python: https://www.python.org/downloads/mac-osx/ 

RStudio: https://rstudio.com/products/rstudio/download/

### File description
This repository is organized as follows: in the folder 'scripts' you will find the primary script that cofigures scraping, data transformation, lemmatization and data visualization in one. The folder 'functions' contains an r file with all necessary packages and functions that are 'sourced' in the above-mentioned script. The folder 'figures' is where the rendered html file of the script and other figures produced through the script are saved. Below, we have provided a guide that takes you through the script.

### Usage 
In order to run the script, clone this git repository by opening your terminal and change your directory to where you would like to have these files. Use cd to change it. An example could be 

```cd path/to/your/repository```

When you have changed directory, please excecute the following code in your terminal 

```git clone https://github.com/marmor97/CDS-exam``` 

Now open your RStudio and start to source the file that contains packages and necessary functions
 
 ```r
 source("functions/functions_packages.R")
 ```
 
Afterwards, please run the r 'chunks' below the section and make sure you run all code in one chunk before continuing to the next chunk.

Note that when you reach the chunk where 'reticulate' executes Python code in R, Python version 2.7 or newer and R version 3.0 or newer are required. Please make sure you have these correct versions installed. Follow the guide above (*reticulate_guide.md*) to succesfully set up and use 'reticulate' within R. 


