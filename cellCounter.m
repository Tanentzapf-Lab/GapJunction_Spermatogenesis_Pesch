function[Mean_Count, Count_2D, Mean_Count_2D, Count_3D] = cellCounter(file)

Count_2D = 0; %% Declare 2d count variable for an accumulative count

folder2 = dir([file '/*.tif']); %% Get subfolder directory

VecCount_2D = zeros(length(folder2), 1); %% "Vector Count 2D", for storing each plane count

for i = 1 : length(folder2) 
    image = imread(fullfile([file '/' folder2(i).name])); %% Read the image into the workspace
    
    image = histeq(image, 1000); %% Equalize the image histogram to 1000 bins
    image = imadjust(image, [.999 1.0]); %% Adjust the image so only the top .1% of values remain (thresholding)
    image = bwareaopen(image, 20); %% Remove any object spaller than 20 pixels, could need adjusting depending on images
    
    bwImage = imfill(image,'holes'); %% Fill holes in the objects in the image (important for 3D count)
        
    properties2D = regionprops(bwImage, 'Area'); %% Retrieve structure array with areas of each object in the image
    areas2D = [properties2D.Area]; %% Isolate the areas into a vector from the structure array (annoying matlab things)
    
    VecCount_2D(i) = length(areas2D); %% Save the number of areas ("number of cells") for this plane to the Vector Count
    Count_2D = Count_2D + length(areas2D); %% Add the number of cells (areas) to the accumulative 2D count
    
    imshow(bwImage); %% Show the image for special effects
    
    images(:,:,i) = image; %% Save this image plane into a 3D matrix/image for 3D counting
end

imgDist = -bwdist(~images, 'Cityblock'); %% Cityblock distance transform to prepare for watershed (weird matlab things)
imgLabel = watershed(imgDist); %% Perform watershed to separate 3D cells that may overlap together (needs lots of stacks to do effectively)

properties3D = regionprops(imgLabel, 'Area'); %% Retrieve structure array of "areas" ("volumes") of each object in the image
areas3D = [properties3D.Area]; %% Isolate the volumes into a vector from the structure array (continued annoying matlab things)
    
Count_3D = length(areas3D); %% Retrieve 3D count by finding the number of volumes present in the 3D image
Mean_Count = (Count_2D + Count_3D) / 2; %% Average the 2D and 3D counts because why not
Mean_Count_2D = mean(VecCount_2D); %% Finds the average count of cells per plane by averaging all values in the Vector Count
