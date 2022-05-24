clear all; close all %% Clear workspace
folderName = uigetdir; %% Prompt user for directory
folder = dir([folderName '/*Stack*']); %% Select folder containing folders of images

Count_3D = zeros(length(folder), 1); %% Create a series of 
Count_2D = zeros(length(folder), 1); %% empty matrices
Mean_Count = zeros(length(folder), 1); %% to hold counter
Folder_Name = cell(length(folder), 1); %% results as they 
Mean_Count_2D = zeros(length(folder), 1); %% are calculated

for i = 1 : length(folder) %% Iterate over subfolders
    tic % Start Timer
    file = fullfile([folderName '/' folder(i).name ]); %% Get each image
    
    [Mean_Count(i), Count_2D(i), Mean_Count_2D(i), Count_3D(i)] = cellCounter(file); %% Run function on image
    Folder_Name{i} = folder(i).name; %% Collect folder name for table
    
    toc % End Timer
end

table = table(Folder_Name, Mean_Count, Count_2D, Mean_Count_2D, Count_3D); %% Build table with all counts
writetable(table, 'Cell Counter Results.xls'); %% Write the table to an excel file