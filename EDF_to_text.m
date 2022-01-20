% Author Rahul Venugopal on 19 Jan 2022
% Convert EDF scored file to a text file
% It uses two functions - NPhy_Sleep_StageListCreator and ReadEDF
% Below segment of code adds these two functions to path
% Added a loop to batch convert EDF files to text on 20th Jan 2022 by RVG

% Adding functions to path
selpath = uigetdir({},'Select the folder which has relevant functions')
addpath(selpath)

% select file
[file_selected,file_path] = uigetfile({'*.edf*',  'All EDF files (*.*)'},'Select the EDF files to be converted to text',...
    'MultiSelect','on')

% changing working directory to where edf file lies
cd (file_path)

% get file names
[filepath,filename,extension] = fileparts(file_selected);

for files = 1:length(filename)
    % Run the EDF to text file conversion
    NPhy_Sleep_StageListCreator(filename{files});
    sprintf('%s.edf converted successfully\n', filename{files})
end