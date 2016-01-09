%% HIGH FREQUENCY DETECTOR

WINDOW_SIZE = 4096;
SPEC_OVERLAP = WINDOW_SIZE/2;
SAMPLE_RATE_HZ = 44100;

aveBackground = backgroungSpectrum(5, SAMPLE_RATE_HZ, WINDOW_SIZE, ...
    SPEC_OVERLAP);
