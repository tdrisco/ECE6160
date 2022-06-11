% This function will return the percentage of matching
% outputs
function acc = GetAccuracy(est_output, test_output)
    acc = -1;
    [rw,clm] = size(est_output);
    
    % Verify the outputs are the same size
    if (size(est_output) ~= size(test_output))
        disp('GetAccuracy Error: outputs must be the same size.');
        return;
    end
    
    numCorrect = 0;
    for j=1:clm
        % Check each row. If the loop breaks prematurely
        % then something did not match.
        % There is a margin of error for outputs close
        % to a 0 or 1.
        k = 1;
        while (k <= rw)
            switch test_output(k,j)
                case 0
                    if (est_output(k,j) < 0.25)
                        k = k + 1;
                    else
                        break;
                    end
                case 1
                    if (est_output(k,j) > 0.75)
                        k = k + 1;
                    else
                        break;
                    end
                otherwise
                    disp('Error: Non-binary output in test_output');
                    return;
            end
        end
        
        if (k > rw)
            numCorrect = numCorrect + 1;
        end
    end
    acc = numCorrect / clm;
end