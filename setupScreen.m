function [w, rect, center] = setupScreen(ScreenNumber, bgcolor)
    [w, rect] = Screen('OpenWindow', ScreenNumber, bgcolor);
    Screen('FillRect', w, bgcolor);
    center = [rect(3)/2 rect(4)/2];
    HideCursor;
    Screen('TextSize',w,50);
    % 추가적인 화면 설정 코드
end
