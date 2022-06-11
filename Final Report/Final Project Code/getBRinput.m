% Get the input used for a breaker.
% Inputs:
%   norm_input: This is the normalized input of the system.
%   index_and_wgts: This is a 2 * N matrix where row 1 is the
%       indexes of interest and row 2 is the weights for those
%       indexes.
function BRinput = getBRinput(norm_input, index_and_wgts)
    N = size(index_and_wgts,2);
    clm = size(norm_input,2);
    BRinput = zeros(N,clm);
    
    for c = 1:clm
        for r = 1:N
            BRinput(r,c) = ...
                norm_input(index_and_wgts(1,r),c) ...
                * index_and_wgts(2,r);
        end
    end
end