function [keys] = setupKeys()
    KbName('UnifyKeyNames');
    keys.KeyUp = KbName('UpArrow');
    keys.KeyRight = KbName('RightArrow');
    keys.KeyDown = KbName('DownArrow');
    keys.KeyLeft = KbName('LeftArrow');
    keys.SpaceKey = KbName('Space');
    keys.EscKey = KbName('ESCAPE');
    keys.KeyS = KbName('s');
    keys.KeyD = KbName('d');
end
%keys = setupKeyCodes();
% 예시: 'Space' 키 코드 사용
%spaceKeyCode = keys.SpaceKey;
% 이후에 키 입력을 체크하는 데 spaceKeyCode 사용