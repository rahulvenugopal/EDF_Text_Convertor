% Author Rahul Venugopal on 19 Jan 2022
% Convert EDF scored file to a text file
% It uses two functions - NPhy_Sleep_StageListCreator and ReadEDF
% Below segment of code adds these two functions to path

selpath = uigetdir({},'Select the folder which has relevant functions')
addpath(selpath)

% select file
[file_selected,file_path] = uigetfile({'*.*',  'All Files (*.*)'},'Select the EDF file to be converted to text')
[filepath,filename,extension] = fileparts(file_selected)

% changing working directory to where edf file lies
cd (file_path)

% Run the EDF to text file conversion
NPhy_Sleep_StageListCreator(filename);