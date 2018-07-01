function [ samples ] = applyWindow(samples, window, plot)
% samples = applyWindow(samples, window)
% Possible windows:
% 'flattop'
% 'nuttal'
% 'hamming'
% 'kayser'

    switch window
        case 'flattop'
            signal = flattopwin(length(samples));
        case 'nuttal'
            signal = nuttallwin(length(samples));
        case 'hamming'
            signal = hamming(length(samples));
        case 'kaiser'
            signal = kaiser(length(samples), 38);
        otherwise
            display('Error in applyWindow: invalid window selected!');
            return;
    end

    if(plot == true)
       wvtool(signal); 
    end
    
    if(size(samples, 2) > size(samples, 1))
        samples = samples .* signal';
    else
        samples = samples .* signal;
    end
end

