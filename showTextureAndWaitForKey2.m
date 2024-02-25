function showTextureAndWaitForKey2(window, texture, rect, spaceKey, escKey, outfile, que_w,attentionback)
    Screen('DrawTexture', window, texture, rect);
    Screen('DrawTexture', window, que_w,attentionback);
    Screen('Flip', window);
    
    while 1
        [KeyIsDown, ~, KeyCodes] = KbCheck;
        if KeyIsDown
            if KeyCodes(spaceKey)
                WaitSecs(0.2);
                break;
            elseif KeyCodes(escKey)
                ShowCursor;
                fclose(outfile);
                Screen('CloseAll');
                error('사용자가 실험을 중단했습니다.');
            end
        end
    end
end