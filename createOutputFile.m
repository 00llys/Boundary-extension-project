function [subid, outputname, trials] = createOutputFile()
    % 실험 결과 파일 생성을 위한 사용자 입력 받기
    prompt = {'Subject''s number:','Outputfile',  'Num of Block'};
    defaults = {'','_BE_mem_v2','100'};
    answer = inputdlg(prompt, 'EXP1', 2, defaults);
    
    % 사용자가 입력을 취소한 경우 처리
    if isempty(answer)
        error('사용자 입력이 취소되었습니다.');
    end

    [subid, output, nBlocks] = deal(answer{:});
    outputname = [subid output '.xls'];
    trials = str2double(nBlocks);

    % 중복되는 파일 이름 처리
     counter = 1;
     while exist(outputname, 'file')
         fileproblem = input(['파일이 이미 존재합니다! ' ...
                             '새 이름으로 저장하려면 1을, 종료하려면 2를 입력하세요: '], 's');
         if strcmp(fileproblem, '2')
             error('사용자에 의해 중단됨.');
         elseif strcmp(fileproblem, '1') || isempty(fileproblem)
             outputname = [subid output '_' num2str(counter) '.xls'];
             counter = counter + 1;
         end
     end
 end