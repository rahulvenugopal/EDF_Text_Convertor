# -*- coding: utf-8 -*-
"""
Created on Wed Jan 19 13:54:44 2022

- Get the text file spit out by MATLAB
- Remove columns and reatian only the sleep stages one
- Replace the string by numbers
- Looping for batch processing multiple text files
@author: Rahul Venugopal
"""

#%% Load the text file and start spliting

# Get all text files
from glob import glob
filelist = glob('*.txt')

for files in filelist:
    # Load data
    f = open(files,"r")
    lines = f.readlines()

    result=[]

    for rows in lines:
        result.append(rows.split(' ')[2])
    f.close()

    stage_list = []
    for slices in result:
        stage_list.append(slices.split('\t')[0])

    # string repalce
    stage_list = list(map(lambda stage_list: str.replace(stage_list, "W", "0"),
                          stage_list))

    stage_list = list(map(lambda stage_list: str.replace(stage_list, "N1", "1"),
                          stage_list))


    stage_list = list(map(lambda stage_list: str.replace(stage_list, "N2", "2"),
                          stage_list))


    stage_list = list(map(lambda stage_list: str.replace(stage_list, "N3", "3"),
                          stage_list))


    stage_list = list(map(lambda stage_list: str.replace(stage_list, "R", "5"), stage_list))

    # writing varibale to a text file
    # open file
    with open(files, 'w+') as f:

        # write elements of list
        for items in stage_list:
            f.write('%s\n' %items)

        print("File %s written successfully" %files)

    # close the file
    f.close()