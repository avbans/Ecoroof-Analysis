#PROJECT: 
Ecoroof Water Quality Analysis by Alex Vijay Bans

#PROJECT DESCRIPTION: 
There were 2 goals to this project. The first goal was to analyze the runoff hydrology and chemistry of a seven-year-old ecoroof 
on top of a commercial building compared to a segment of conventional roof on the same commercial building using inferential statistical methods. 
The second goal of this project was to directly be able to pipe the results of this 
analysis to create interactive dashboards using PowerBI for stakeholders to explore the data further. 

#INSTALLING THE PROJECT: 
Once the project is downloaded from GITHUB. Click on "Ecoroof Analysis.RProj"
project file to access the analysis. 
Use renv::restore() to load the appropriate packages and package versions. You may have to install the packages that you may not have. 

#HOW TO USE THIS PROJECT: 
Besides the README, renv folder/renv.lock file, and project file, there are 3 main files that you will need to pay attention to. 
These files are: "01_Input", "02_Scripts", and "03_Output".

"01_Input" is where the data used for this project is stored. 
Inside of it there is a csv containing precipitation measurements for the project. There are also separate files for the discharge measurements, 
runoff sampling, and an archive of depreciated data. 
"02_Scripts" contain the scripts that were used to process the data, manipulate them, visualize them, and export them. 
"Master_Script.R" is the main script you will need, and it will run all other scripts for you. From this script you can see what scripts 
were used in the project, and where they are nested in the file structure.The annotations in the script will explain what was accomplished. 
There is also an archive folder for depreciated scripts and tests. 
"03_Output" will start off empty, but will be populated with the results of the analysis. 
Please note that the rendering from the graphing increases the 
processing time of the outputs. I hope to address this in the future. 
See "Data Analysis Results Report.html" in the "03_Output" folder 
for a summary of the project introductions, methods, and an explanation of which 
graph or table correspondances to which result found. 
Due to the length of time it takes to compile the results, figures and tables 
were exported along with the Markdown folder instead of being directly 
embedded into the report. 

#HOW TO CONTRIBUTE: 
Please direct any questions or suggestions directly to me at avbans93@gmail.com. 

