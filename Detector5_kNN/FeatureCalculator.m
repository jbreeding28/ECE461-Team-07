classdef FeatureCalculator
    %FEATURECALCULATOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods (Static)
        function [lag, HR] = harmonicity(audio,minlag,~)
        %HARMONICITY 
            r = xcorr(audio,'coeff');
            r = r(floor(length(r)/2):length(r));
            r(1:minlag) = 0;
            if(nargin==3)
                plot(r)
            end
            HR = max(r);
            lag = find(r==max(r));
        end
        
        function [ spectralFlux ] = spectralFlux( spectrum1, spectrum2 )
        %SPECTRALFLUX Calculates spectral flux between two spectra

            % normalize
            spectrum1 = spectrum1/sum(spectrum1);
            spectrum2 = spectrum2/(sum(spectrum2)+eps);

            spectralFlux = sum((spectrum2-spectrum1).^2);

        end
        
        function [ flatness ] = flatness_hiFrequency( spectrum,...
                ignoreBelowBin )
            
            spectrum = spectrum/max(spectrum);
            spectrum = spectrum(ignoreBelowBin:length(spectrum));
            spectrum(spectrum==0)=eps;
            flatness = geomean(spectrum)/mean(spectrum);
            
        end
        
%         function [ numPeaks ] = numPeaks_hiFreq(spectrum, ignoreBelowBin)
%             
%         end
        
    end
    
end

