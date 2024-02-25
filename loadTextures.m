function textures = loadTextures(window, imageFolder, imagePatterns)
    textures = struct();
    for i = 1:length(imagePatterns)
        pattern = imagePatterns{i};
        files = dir(fullfile(imageFolder, pattern));
        for j = 1:length(files)
            [~, name, ~] = fileparts(files(j).name);  % 파일 이름에서 확장자 제거
            imgPath = fullfile(imageFolder, files(j).name);
            img = imread(imgPath);
            textures.(name) = Screen('MakeTexture', window, img);
        end
    end
end


