function [allStimuli, keyResponse, RT, imgIP, img, beMemorability] = initializeExperiment(nTrials)
    allStimuli = zeros(1, nTrials); % 예시 초기화, 실제 구현에 따라 달라질 수 있음
    keyResponse = zeros(1, nTrials);
    RT = zeros(1, nTrials);
    imgIP = num2cell(zeros(1,nTrials,1));
    img = num2cell(zeros(1,nTrials,1));
    beMemorability = num2cell(zeros(1,nTrials,1));
end
