# Political promises
Exam project for Cultural Data Science 2020

### Contributors
Frida Hæstrup and Marie Mortensen

### Prerequisites
To run the script it is required that R and RStudio is installed as well as Python 3.

Link to softwares and interfaces

R: https://cran.r-project.org/mirrors.html

RStudio: https://rstudio.com/products/rstudio/download/

Python3: https://www.python.org/downloads/ 

### File description
This repository is organized as follows: in the folder 'scripts' you will find the primary script that cofigures scraping, data transformation, lemmatization and data visualization in one. The folder 'functions' contains an r file with all necessary packages and functions that are 'sourced' in the above-mentioned script. The folder 'figures' is where the rendered html file of the script and other figures produced through the script are saved. Below, we have provided a guide that takes you through the script.

### Usage 
In order to run the script, clone this git repository by opening your terminal and change your directory to where you would like to have these files. Use cd to change it. An example could be 

```cd path/to/your/repository```

When you have changed directory, please excecute the following code in your terminal 

```git clone https://github.com/marmor97/CDS-exam``` 

Now open your RStudio and start to source the file that contains packages and necessary functions
 
 ```r
 source("packages_functions.R")
 ```
 
Afterwards, please run the r 'chunks' below the section and make sure you run all code in one chunk before continuing to the next chunk.

When you reach the point in RStudio where Python code will be excecuted make sure that you have Python3 downloaded on your computer.

