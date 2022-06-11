% This function will normalize inputs
function norm_input = normalizeInput(norms, input)
    [rw,clm] = size(input);
    norm_input = zeros(rw,clm);
    
    for j = 1:clm
        for k = 1:rw
            norm_input(k,j) = input(k,j) / norms(k,1);
        end
    end
end