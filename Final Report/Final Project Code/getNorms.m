% This function will get the means of the absolute
% values of the inputs.
function norms = getNorms(input,output)
    [rw,clm] = size(input);
    outrw = size(output,1);
    
    N = 0;
    Sum = zeros(rw,1);
    for j = 1:clm
        if (output(:,j) == ones(outrw,1))
            Sum = Sum + abs(input(:,j));
            N = N + 1;
        end
    end
    
    if (N == 0)
        disp('Failure to find norms.');
        norms = ones(rw,1);
    else
        norms = Sum / N;
    end
end