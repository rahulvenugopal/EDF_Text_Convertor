function [output_fileName] = NPhy_Sleep_StageListCreator(input_fileName)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NPhy_Sleep_StageListCreator ver 2.3
% Dept of Neurophysiology
% 
% Purpose:  To extract sleep stage scorings from EDF scoring files created
%           using POLYMAN/BESS and write them as a list into a text file
% 
% Usage: output_fileName = NPhy_Sleep_StageListCreator(input_fileName)
% 
% Input: input_fileName - (string) unique part of file name
% 
% Output: output_fileName - (string) output sleep stage filename
% 
% Steps:    Read EDF file annotations with scoring info
%           Open a text file in append mode
%           Scan and extract the annotations into 3 columns
%           Identify the sleep stage for each 30s epoch
%           Write to the text file as a list
% 
% Created on: 6 March 2013; by Dr Arun Sasidharan
% 
% Modified on: 11 March 2013; by Dr Arun Sasidharan; Removed the separation
% 	 into separate column vectors
% 
% Modified on: 05 May 2013; by Dr Arun Sasidharan; Changed delimiter to
%   comma as batch conversion of scorings from EDF are in CSV format; Bug
%   fixes
% 
% Modified on: 11 May 2013; by Dr Arun Sasidharan; Incorporated EDF to
%   ASCII conversion step 
%   (Ref: NIMHANS_EDF_to_ASCII_BatchConvertor ver 1.0) 
%   and then removed ASCII files not containing sleep annotations
% 
% Modified on: 30 March 2014; by Dr Arun Sasidharan; Added provision for 
%   scorings with movements scored and assign appropriate sleep stage 
%   for that epoch 
% 
% Modified on: 04 Nov 2014; by Dr Arun Sasidharan; Made changes to run as a
%   function
% 
% Modified on: 28 Oct 2015; by Dr Arun Sasidharan; Added output fileneame
%   as an output.
% 
% Modified on: 10 Jan 2018; by Dr Arun Sasidharan; now reading annotations 
%   using ReadEDF.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Get the Inputs
if ischar(input_fileName)
    subject_Name = input_fileName;
elseif iscell(input_fileName)
    subject_Name = char(input_fileName);
end

%% Get the list of Sleep scoring files
    % NOTE: These files when created from Polyman contain "scored" and 
    %       "annotations" in their names
sleepStage_fileName_cue =...
    ['*',subject_Name,'*.edf'];
sleepStage_fileName =...
    ls(sleepStage_fileName_cue);                                            % Get the file name that matches subject name from current folder

%%%%%%%%%%%%%%%%%%%%%%%%% DEPRECIATED %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Convert EDF file TO ASCII format
    % NOTE: The format is: edf2ascii<space><filename>
% function_path = fileparts(which('NPhy_Sleep_StageListCreator'));
% system([function_path,'\','edf2ascii.exe ',sleepStage_fileName]);
% 
% delete([sleepStage_fileName(1:(end-4)),'_data.txt']);
% delete([sleepStage_fileName(1:(end-4)),'_signals.txt']);
% delete([sleepStage_fileName(1:(end-4)),'_header.txt']);              

%% Scan the annotation file and get the data into 3 columns 
% annotation_fileID =...
%     fopen([sleepStage_fileName(1:(end-4)),'_annotations.txt']);
% C_annotation_data = textscan(annotation_fileID, '%s %s %s',... 
%      'delimiter', ',', 'Headerlines', 1);                               % The first row is header and hence omitted 
% fclose(annotation_fileID); 
% delete([sleepStage_fileName(1:(end-4)),'_annotations.txt']);
%%%%%%%%%%%%%%%%%%%%%%%%% DEPRECIATED %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Open a text file in append mode, where sleep stage list is written
output_fileName = [sleepStage_fileName(1:(end-4)),'_SleepStageList.txt'];
sleepStage_fileID = fopen(output_fileName,'a');    

%% Read annotations using ReadEDF.m
[~, header] = ReadEDF(sleepStage_fileName);

%% Loop for each row    
epoch_no = 1;                                                           % Initialize the epoch number
for row_no = 1:length(header.annotation.event);
    duration = header.annotation.duration(row_no);
    annotation = header.annotation.event{row_no};
    event = 'none';
    % If scored as 'Movement', assign the current epoch same as next
    %   epoch's stage. Ref: AASM-2012. Add 'Movement time' as event
    %   with duration in next column.
    if strcmp(header.annotation.event{row_no},'Movement time')
        annotation = header.annotation.event{row_no+1};
        event = 'Movement';            
    end
    if rem(duration,30)==0;                                             % Make sure that duration of annotation is a multiple of 30s (i.e. sleep stage)
        nStageEpochs = duration/30;                                     % Number of times the epoch is repeated 

        %% Write the sleep stage as a single line for each 30s epoch

        for n = 1:nStageEpochs
            fprintf(sleepStage_fileID,'%s\t%s\t%d\n',...
                annotation,event,duration);
            % Don't add duration to continuous epochs of same stage
            duration = [];
            epoch_no = epoch_no+1;                                      % Increment the Epoch number
        end
    end
end
fclose(sleepStage_fileID);                                              % Close the text file 

%% END
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%