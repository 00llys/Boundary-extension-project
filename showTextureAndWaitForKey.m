function showTextureAndWaitForKey(window, texture, rect, spaceKey, escKey, outfile)
    Screen('DrawTexture', window, texture, rect);
    Screen('Flip', window);
    
    while 1
        [KeyIsDown, ~, KeyCode] = KbCheck;
        if KeyIsDown
            if KeyCode(spaceKey)
                WaitSecs(0.2);
                break;
            elseif KeyCode(escKey)
                ShowCursor;
                fclose(outfile);
                Screen('CloseAll');
                error('사용자가 실험을 중단했습니다.');
            end
        end
    end
end
