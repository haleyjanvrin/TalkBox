%% MUMT 307 FINAL PROJECT - DIGITAL TALKBOX %%
% -------------------------------------------------------------------------
% Takes an audio file as input, filters as if passing through a Kelly-Lochbaum vocal tract model (digital waveguide)
% in a sample by sample fashion

% USER INPUTS:  Line 14: set the audio file to be filtered through the talkbox
%               Line 18: set the mouth vowel shape
% -------------------------------------------------------------------------

% Vowel shapes: 
% area of each section (cm^2) of the vocal tract when making each vowel shape
% sourced from https://pubmed.ncbi.nlm.nih.gov/1939886/
A_a = [1.56	3.10 3.74 2.48 1.28	0.60 0.73 1.28 1.39 1.31 1.43 1.90 3.22 4.44 4.83 3.89 4.72 2.03 2.49];
A_ae = [1.91 2.69 4.53 2.05 1.33 1.44 2.82 4.54 4.04 3.24 2.82 3.20 4.32 5.13 4.17 4.98 6.31 5.65 7.03];
A_i = [1.20	2.73 4.11 4.63 6.05 7.62 7.64 7.99 7.09 4.55 2.63 1.81 1.10 0.69 0.85 0.80 0.50 1.10 1.65];
A_u = [3.11 5.18 6.44 6.05 5.76 6.20 5.19 3.72 3.06 2.31 1.05 1 0.67 0.92 1.57 2.30 3.78 4.24 3.89];
% from Perry Cook's thesis:
% https://www.cs.princeton.edu/~prc/PRCThesis.pdf, measurements are radii
A_i_cook = [1.1 1.75 3.70 2.5 2 0.7 0.5 0.4 0.6 0.9].^2 .* pi;

% USER INPUT: Set audio file here
filename = 'trumpet.wav';
[y, Fs] = audioread(filename);
N = length(y);

% USER INPUT: Set talkbox vowel shape here by picking a vowel shape
areas = A_i_cook;

% Config parameters
rho = 0.00114; % density of air
c = 34300; % speed of sound (cm/s)
numSections = length(areas);
tractLength = 18; % cm, average male vocal tract length
delay = (tractLength / numSections) / c * Fs; % same delay in each section
delay = round(delay); % round for simplicity
maxDelay = 4 * delay;

% REFLECTION COEFFICIENTS: calculates r for each junction
% junction k is the intersection between tube k and k+1
% ie. junction indexing ranges from 1 to numSections - 1
impedances = rho .* c ./ areas;
r = zeros(1, numSections - 1);
% calc reflection coefficient r 
for i=1:numSections-1
    Rk = impedances(1, i);
    Rk1 = impedances(1, i+1);
    r(1, i) = (Rk1 - Rk) / (Rk1 + Rk);
end

% DELAY LINES
% Initialize delay lines for forward and backward waves: each delay line is a cylindrical section
fDelays = cell(1, numSections); % forward
bDelays = cell(1, numSections); % backward
for i=1:numSections
    fDelays{1, i} = zeros(1, maxDelay);
    bDelays{1, i} = zeros(1, maxDelay);
end
% Delay lines are all same length, can use same write/read pointers
write = 1;
read = DelayLine_SetLength(maxDelay, write, delay);

% COMPUTE SAMPLE BY SAMPLE
speechOutput = zeros(1, N);
for i=1:N-1
    % first section/delay line
    fDelays{1,1} = DelayLine_Write(fDelays{1, 1}, write, y(i));

    % JUNCTIONS
    for k=1:numSections-1
        [fDelays, bDelays] = junction(k, fDelays, bDelays, r, write, read, numSections);
    end

    % last section/delay line
    output = DelayLine_Read(fDelays{1, numSections}, read);
    bDelays{1,1} = DelayLine_Write(bDelays{1, 1}, write, output);
    % speech output is taken from forward wave in last section
    speechOutput(1, i) = output;
    
    % update read and write pointers (tick)
    [write, read] = DelayLine_TickOnly(write, read, maxDelay);
end

% PLOTS
soundsc(speechOutput, Fs) % play output sound

x = linspace(0, N/Fs, N);
spectrogram(y)
title('Spectrogram: Input audio')
%spectrogram(speechOutput)
%title('Spectrogram: Filtered output audio')
figure('Color', 'white');
plot(x, y)
title('Original Signal')
xlabel('Time (s)')
ylabel('Signal')
figure('Color', 'white');
plot(x, speechOutput)
title('Filtered Signal')
xlabel('Time (s)')
ylabel('Signal')
