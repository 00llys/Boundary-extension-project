sca;clear;clc;
rng('default');rng('shuffle');
ScreenNumber = 0 ;
Screen('Preference', 'SkipSyncTests', 1);
keys = setupKeys();
    space = keys.SpaceKey;
    esc = keys.EscKey;
    left = keys.KeyLeft;
    right = keys.KeyRight;
     
    
responkey = [37, 39];

[subid, outputname, trials] = createOutputFile(); 

outfile = fopen(outputname,'w');
fprintf(outfile, ['subid\t nblocks\t TestImg\t BEscore\t RT\t ImgIP\t BE_Memorability\t' ...
    'memory_TestImg\t right_answer\t correct\t memoryRT\t memory_ImgIP\t Memorability\t \n']);

gray = [127 127 127]; white = [255 255 255]; black = [0 0 0];
bgcolor = gray; textcolor = black;
[w, rect, center] = setupScreen(ScreenNumber, bgcolor); %rect =[0 0 1920 1080];
Screen('GetFlipInterval', w);

% 화면 해상도의 중앙 좌표 계산
[screenXpixels, screenYpixels] = Screen('WindowSize', w); % 화면의 가로 및 세로 픽셀 크기를 얻음
cx = screenXpixels / 2;
cy = screenYpixels / 2;

% 이미지를 중앙에 350x350 픽셀로 배치하기 위한 사각형 위치 계산
rectWidth = 350;
rectHeight = 350;
imagerect = [cx - rectWidth/2, cy - rectHeight/2, cx + rectWidth/2, cy + rectHeight/2]; % 중앙에 위치하는 사각형



imgfiles_OL = [dir(fullfile("stimuli\low_oldLand\",'*.jpg'));dir(fullfile("stimuli\high_oldLand\",'*.jpg'))]; 
imgfiles_OA = [dir(fullfile("stimuli\low_oldAni\",'*.jpg'));dir(fullfile("stimuli\high_oldAni\",'*.jpg'))];
imgfiles_NL = [dir(fullfile("stimuli\low_newLand\",'*.jpg'));dir(fullfile("stimuli\high_newLand\",'*.jpg'))];
imgfiles_NA = [dir(fullfile("stimuli\low_newAni\",'*.jpg'));dir(fullfile("stimuli\high_newAni\",'*.jpg'))];
imgfiles_L = [imgfiles_OL;imgfiles_NL]; imgfiles_A = [imgfiles_OA;imgfiles_NA];

lowold_animal = loadImages(w, "stimuli\low_oldAni\", '*.jpg'); highold_animal = loadImages(w, "stimuli\high_oldAni\", '*.jpg');
lowold_landscape = loadImages(w, "stimuli\low_oldLand\", '*.jpg'); highold_landscape = loadImages(w, "stimuli\high_oldLand\", '*.jpg');
lownew_animal = loadImages(w, "stimuli\low_newAni\", '*.jpg'); highnew_animal = loadImages(w, "stimuli\high_newAni\", '*.jpg');
lownew_landscape = loadImages(w, "stimuli\low_newLand\", '*.jpg'); highnew_landscape = loadImages(w, "stimuli\high_newLand\", '*.jpg');

highsti = [highold_landscape highnew_landscape highold_animal highnew_animal]; 
lowsti = [lowold_landscape lownew_landscape lowold_animal lownew_animal];

old_animal = [lowold_animal highold_animal] ; new_animal = [lownew_animal highnew_animal];
old_landscape = [lowold_landscape highold_landscape]; new_landscape = [lownew_landscape highnew_landscape];
masking = loadImages(w, "sungoi\", 'Sc*.jpg'); landscape = [old_landscape new_landscape]; animal = [old_animal new_animal]; % [low-old high-old low-new high-new] 순서 [25 25 25 25]
maskingSti = zeros(200, 5);
for i = 1:200 % masking 자극 무선화
    maskingSti(i,:) = randperm(40,5);
end
maskingSti = maskingSti'; mask = masking(maskingSti);

imageInstruction = {'inst_full.png' 'inst_5.png', 'inst_fix.png', 'inst_p.png', 'inst_memory.png',...
'inst_cor.png', 'inst_incorr.png'}; % 예시 패턴
imagefixation = {'fixation.png'};
imgspacebar = {'spacebar.png'};
imagecorrect = {'inst_cor.png','inst_incor.png'};
% 지시사항 관련 이미지 instruction.inst_1 이렇게 사용
instruction = loadTextures(w, 'sungoi\', imageInstruction);
fixation = loadTextures(w, 'sungoi\', imagefixation);fixation=fixation.fixation;
spacebar = loadTextures(w, 'sungoi\', imgspacebar);spacebar=spacebar.spacebar;
correct = loadTextures(w, 'sungoi\', imagecorrect);
incorrect=correct.inst_incor;correct=correct.inst_cor;

% 실험 변수 초기화
[~, keyResponse, RT, imgIP, img, beMemorability] = initializeExperiment(trials/2);
[~, m_keyResponse, m_RT, m_imgIP, m_img, corAnswer, Memorability, m_correct, m_answer] = initializeExperiment_mem(trials);
fixation_t = 0.35; % 350ms 제시
target_t = 0.25; % 250ms 제시
masking_t = 0.05; respond_t = 1;
image_t = 0.25; image_ts = 0.25;
Flip=zeros(1,10); Flip_p=zeros(1,10);
slack = Screen('GetFlipInterval', w)/2;% 화면 갱신 간격 계산/2 = slack 계산

%%%%%%%%%%%%%%%% BE 테스트를 100장만 하는 게 괜찮을지, 시간 계산 및 피로도를 생각해보기
% 200장 BE테스트 -> 시행당 평균 3초 = 10분 소요
% 400장 기억테스트 -> 시행당 평균 3초 = 1200초 20분 소요
% 문제는 200장을 기억해서 400장을 테스트할 수 있는가...

% 100장 BE테스트 -> 시행당 평균 3초 = 5분 소요
% 200장 기억테스트 -> 시행당 평균 3초 = 10분 소요

% 400장 BE테스트 -> 시행당 평균 3초 = 20분 소요


% 150장 BE테스트 -> 시행당 평균 3초 = 450초 8분 소요
% 300장 기억테스트 -> 시행당 평균 3초 = 900초 15분 소요

allstimuli = [old_landscape old_animal new_landscape new_animal];
bestimuli = Shuffle([old_landscape old_animal]); % target
memstimuli = Shuffle(allstimuli);

%% Instruction
showTextureAndWaitForKey(w, instruction.inst_5, rect, space, esc, outfile);
showTextureAndWaitForKey(w, instruction.inst_p, rect, space, esc, outfile);

%% 연습 시행

% 연습시행 자극 불러오기 및 변수 생성
prac_g = loadImages(w, "practice_st\", 'g_*.jpg');
prac_s = loadImages(w, "practice_st\", 's_*.jpg');
prac_cg = loadImages(w, "practice_st\", 'cg_*.jpg');
prac_cs = loadImages(w, "practice_st\", 'cs_*.jpg');

P_stimuli = [prac_g prac_s]; % target
P_targetsti = [prac_cg prac_cs];

P_stimuli(2,:) = P_targetsti;

Bs = repmat([1 2 2 1], 1, 12);


for N = 1:24
    % ready
    showTextureAndWaitForKey(w, spacebar, rect, space, esc, outfile);

    % present stimuli
    Screen('DrawTexture', w, P_stimuli{Bs(N),N}); % target
    Flip(1) = Screen('Flip',w);
    Flip(1) = Screen('Flip', w, Flip(1) + target_t - slack);

    % present masking     
    Screen('DrawTexture', w, mask{1,N});
    Flip(2) = Screen('Flip', w, Flip(1) + masking_t - slack);
    for m = 2:5
        Screen('DrawTexture', w, mask{m,N});
        Flip(m+1) = Screen('Flip', w, Flip(m) + masking_t - slack);
    end
    Flip(7) = Screen('Flip',w, Flip(6) + masking_t - slack);

    % % 각 이미지의 제시 시간 계산(확인코드)
    % displayDurations = diff([Flip, GetSecs]);
    % 
    % % 제시 시간 출력
    % for i = 1:length(displayDurations)
    %     fprintf('Image %d displayed for %f seconds.\n', i, displayDurations(i));
    % end

    % present target & respond 
    timeStart = GetSecs;
    Screen('DrawTexture', w, P_stimuli{Bs(N+2),N});
    Screen('Flip', w); WaitSecs(1);
    Screen('DrawText',w,'Closer   <---           --->   Further', center(1)*1/2+150,center(2)*3/2, textcolor);
    Screen('Flip', w);
    answer = Bs(N+2);
    while 1
        [KeyIsDown, secs, KeyCode] = KbCheck;
        if KeyIsDown
            if KeyCode(right) || KeyCode(left)
                P_keyResponse = find(KeyCode);        % 눌린 키 기록
                Screen('Flip',w);
                break;
            elseif KeyCode(esc)
                ShowCursor;
                fclose(outfile);
                Screen('CloseAll');
                return;
            end
        end
        WaitSecs(0.001); % CPU 부담을 줄이기 위해 짧은 대기 시간 추가
    end
    if (P_keyResponse==responkey(1)&&answer==1)||(P_keyResponse==responkey(2)&&answer==3)
        Screen('DrawTexture',w,incorrect,rect);
        Screen('Flip', w);
        WaitSecs(1);
    else
        Screen('DrawTexture',w,correct,rect);
        Screen('Flip', w);
        WaitSecs(0.5);
    end
end

%% BE Test
showTextureAndWaitForKey(w, instruction.inst_5, rect, space, esc, outfile);
showTextureAndWaitForKey(w, instruction.inst_full, rect, space, esc, outfile);

for N = 1: trials
    % fixation
    Screen('DrawTexture', w, fixation);
    flip=Screen('flip',w);
    Screen('Flip', w, flip + fixation_t - slack);

    % ready
    showTextureAndWaitForKey(w, spacebar, rect, space, esc, outfile);

    % present stimuli
    Screen('DrawTexture', w, bestimuli{N}, [], imagerect); % target
    Flip(1) = Screen('Flip',w);
    Flip(1) = Screen('Flip', w, Flip(1) + target_t - slack);

    % present masking     
    Screen('DrawTexture', w, mask{1,N});
    Flip(2) = Screen('Flip', w, Flip(1) + masking_t - slack);
    for m = 2:5
        Screen('DrawTexture', w, mask{m,N});
        Flip(m+1) = Screen('Flip', w, Flip(m) + masking_t - slack);
    end
    Flip(7) = Screen('Flip',w, Flip(6) + masking_t - slack);


    % present target & respond 
    Screen('DrawTexture', w, bestimuli{N}, [], imagerect);
    Screen('Flip', w); WaitSecs(1);
    Screen('DrawText',w,'Closer   <---           --->   Further', center(1)*1/2+150,center(2)*3/2, textcolor);
    Screen('Flip', w);
    timeStart = GetSecs;
    while 1
    [KeyIsDown, secs, KeyCode] = KbCheck;
    if KeyIsDown
        % 오른쪽 또는 왼쪽 방향키가 눌렸는지 확인
        if KeyCode(right) || KeyCode(left)
            RT(N) = (GetSecs - timeStart) * 1000; % 반응 시간 기록
            % 눌린 키가 오른쪽 또는 왼쪽 방향키일 경우에만 keyResponse에 기록
            if KeyCode(right)
                keyResponse(N) = right;  % 오른쪽 키 코드를 저장
            elseif KeyCode(left)
                keyResponse(N) = left;   % 왼쪽 키 코드를 저장
            end
            flip = Screen('Flip',w);
            break;
        elseif KeyCode(esc)
            ShowCursor;
            fclose(outfile);
            Screen('CloseAll');
            return;
        end
    end
    WaitSecs(0.001); % CPU 부담을 줄이기 위해 짧은 대기 시간 추가
    end

    if ismember(bestimuli{N},cell2mat(old_landscape))==1
        imgIP{N} = 'Landscape';
        img{N} = imgfiles_OL(bestimuli{N}-60).name;
    elseif ismember(bestimuli{N},cell2mat(old_animal))==1
        imgIP{N} = 'Animal';
        img{N} = imgfiles_OA(bestimuli{N}-10).name;
    end


    if ismember(bestimuli{N},cell2mat(highsti))==1
        beMemorability{N} = 'high';
    elseif ismember(bestimuli{N},cell2mat(lowsti))==1
        beMemorability{N} = 'low';
    end
                %'subid\t nblocks\t TestImg\t BEscore\t RT\t ImgIP\t 
                % memory_TestImg\t correct_answer\t response\t memoryRT\t memory_ImgIP\t \n'
fprintf(outfile,'%s\t %d\t %s\t %d\t %6.2f\t %s\t %s\t %s\t %s\t %d\t %d\t %s\t %s\t \n', ...
    subid, trials, img{N}, keyResponse(N)-38, RT(N), imgIP{N}, beMemorability{N}, NaN, NaN, NaN, NaN, NaN, NaN);


end

%% M test
showTextureAndWaitForKey(w, instruction.inst_memory, rect, space, esc, outfile) % memory test instruction
showTextureAndWaitForKey(w, spacebar, rect, space, esc, outfile);


for N = 1:(trials*2)
% present target & respond 
    Screen('DrawTexture', w, memstimuli{N}, [], imagerect);
    Screen('DrawText',w,'Old   <---           --->   New', center(1)*1/2+150,center(2)*3/2, textcolor);
    Screen('Flip', w); timeStart = GetSecs;
    while 1
    [KeyIsDown, secs, KeyCode] = KbCheck;
    if KeyIsDown
        % 오른쪽 또는 왼쪽 방향키가 눌렸는지 확인
        if KeyCode(right) || KeyCode(left)
            m_RT(N) = (GetSecs - timeStart) * 1000; % 반응 시간 기록
            % 눌린 키가 오른쪽 또는 왼쪽 방향키일 경우에만 keyResponse에 기록
            if KeyCode(right)
                m_keyResponse(N) = right;  % 오른쪽 키 코드를 저장
            elseif KeyCode(left)
                m_keyResponse(N) = left;   % 왼쪽 키 코드를 저장
            end
            Screen('Flip',w);
            break;
        elseif KeyCode(esc)
            ShowCursor;
            fclose(outfile);    
            Screen('CloseAll');
            return;
        end
    end
    WaitSecs(0.001); % CPU 부담을 줄이기 위해 짧은 대기 시간 추가
    end
    if ismember(memstimuli{N},cell2mat(old_landscape))==1 % 이건 v2에서서 자극 수 정하는 대로 수정해야 함
        m_imgIP{N} = 'Landscape';
        m_img{N} = imgfiles_L(memstimuli{N}-60).name;
        corAnswer{N} = 'old';
        m_answer(N) = 37;
    elseif ismember(memstimuli{N},cell2mat(new_landscape))==1
        m_imgIP{N} = 'Landscape';
        m_img{N} = imgfiles_L(memstimuli{N}-160).name;
        corAnswer{N} = 'new';
        m_answer(N) = 39;
    elseif ismember(memstimuli{N},cell2mat(old_animal))==1
        m_imgIP{N} = 'Animal';
        m_img{N} = imgfiles_A(memstimuli{N}-10).name;
        corAnswer{N} = 'old';
        m_answer(N) = 37;
    elseif ismember(memstimuli{N},cell2mat(new_animal))==1
        m_imgIP{N} = 'Animal';
        m_img{N} = imgfiles_A(memstimuli{N}-110).name;
        corAnswer{N} = 'new';
        m_answer(N) = 39;
    end
    if ismember(memstimuli{N},cell2mat(highsti))==1
        Memorability{N} = 'high';
    elseif ismember(memstimuli{N},cell2mat(lowsti))==1
        Memorability{N} = 'low';
    end
    if m_answer(N)==m_keyResponse(N)
        m_correct(N) = 1;
    elseif m_answer(N)~=m_keyResponse(N)
        m_correct(N) = 0;
    end
                %'subid\t nblocks\t TestImg\t BEscore\t RT\t ImgIP\t BE_Memorability\t
                % memory_TestImg\t correct_answer\t response\t memoryRT\t memory_ImgIP\t Memorability\t \n'
fprintf(outfile, '%s\t %d\t %s\t %d\t %d\t %s\t %s\t %s\t %s\t %d\t %6.2f\t %s\t %s\t \n', ...
    subid, trials, NaN, NaN, NaN, NaN,  NaN, m_img{N}, corAnswer{N}, m_correct(N), m_RT(N), m_imgIP{N}, Memorability{N});
    % fixation
    Screen('DrawTexture', w, fixation);flip = Screen('Flip', w);
    Screen('Flip', w, flip + fixation_t - slack);
end


%% 저장 및 종료
WaitSecs(1);
subid = [subid,'.mat'];
save(subid);
Screen('CloseAll');
fclose(outfile);
sca;













