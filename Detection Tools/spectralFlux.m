function [ spectralFlux ] = spectralFlux( spectrum1, spectrum2 )
%SPECTRALFLUX Calculates spectral flux between two spectra
    
    % normalize
    spectrum1 = spectrum1/sum(spectrum1);
    spectrum2 = spectrum2/sum(spectrum2+eps);
    
    spectralFlux = sum((spectrum2-spectrum1).^2);

end

