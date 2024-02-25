function stimuli = loadImages(w, imageFolder, imagePattern)
    imgFiles = dir(fullfile(imageFolder, imagePattern));
    numFiles = length(imgFiles);
    stimuli = cell(1, numFiles);
    for i = 1:numFiles
        imgPath = fullfile(imageFolder, imgFiles(i).name);
        imgData = imread(imgPath);
        stimuli{i} = Screen('MakeTexture', w, imgData);
    end
end
