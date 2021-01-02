# Using Python in R Markdwon
#### Create virtual environment
Make sure your Python has the virtualenv package installed
```sh
$ pip install virtualenv
```

Navigate to your RStudio project using the following command:
```sh
$ cd <project-dir>
```
Create a virtual environment within your project directory:
```sh
$ virtualenv python
```
To activate the virtual environment, run the following command:
```sh
$ source python/bin/activate
````
Within your virtual environment, install the necessary packages:
```sh
$ pip install lemmy pandas spacy
````

#### Using reticulate
In your R console, run: ----- in project
```sh
usethis::edit_r_profile('project')
```
This will open the .Rprofile file. To configure reticulate to point to the Python executable in your virtualenv, add the following content to the .Rprofile file:
```sh
Sys.setenv(RETICULATE_PYTHON = "python/bin/python")
```
Restart R session.  You can verify that reticulate is configured for the correct version of Python using the following command in your R console:
```sh
reticulate::py_config()
```

#### Load necessary python packages
```sh
py_install("pandas", pip = TRUE)
py_install("lemmy", pip = TRUE)
py_install("spacy", pip = TRUE)
```
Within your virtual environment, run the following in the terminal to download the relevant spaCy model:
```sh
python -m spacy download da_core_news_sm
```

   

