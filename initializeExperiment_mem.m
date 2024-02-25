function [allStimuli, m_keyResponse, m_RT, m_imgIP, m_img, corAnswer, Memorability, m_correct, m_answer] = initializeExperiment_mem(nTrials)
    allStimuli = zeros(1, nTrials); % 예시 초기화, 실제 구현에 따라 달라질 수 있음
    m_keyResponse = zeros(1, nTrials);
    m_RT = zeros(1, nTrials);
    m_imgIP = num2cell(zeros(1,nTrials,1));
    m_img = num2cell(zeros(1,nTrials,1));
    corAnswer = num2cell(zeros(1,nTrials,1));
    Memorability = num2cell(zeros(1,nTrials,1));
    m_correct = NaN(1, nTrials);
    m_answer = NaN(1, nTrials);
end
