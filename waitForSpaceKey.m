function waitForSpaceKey()
    while true
        [KeyIsDown, ~, KeyCode] = KbCheck;
        if KeyIsDown
            if KeyCode(spaceKey)
                WaitSecs(0.2);
                break;
            elseif KeyCode(escKey)
                ShowCursor;
                fclose(outfile);
                Screen('CloseAll');
                return;
            end
        end
    end
end
