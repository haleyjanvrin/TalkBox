function [fDelays, bDelays] = junction(k, fDelays, bDelays, r, writePointer, readPointer, numSections)
% ----------------------------------------------------------------------------------------------------------------------------
% [forwardOut, backwardOut] = junction(k, fDelays, bDelays, r)
% ----------------------------------------------------------------------------------------------------------------------------
%
% Function used to obtain the output samples from a junction between cylindrical sections. 
% Computes outputs for both the forward wave and backward wave.
%
% INPUTS:
%   -   k (integer):    junction index. junction k is the intersection between
%                       section k and section k + 1
%   -   fDelays (float vector): forward wave delay lines
%   -   bDelays (float vector): backward wave delay lines
%   -   r (float vector): reflection coefficients for k junctions
%   -   writePointer (integer): write pointer for the delay lines
%   -   readPointer (integer): read pointer for the delay lines
%   -   numSections (integer): number of sections in the vocal tract
% OUTPUTS:
%   -   fDelays (float vector): updated forward wave delay lines
%   -   bDelays (float vector): updated backward wave delay lines
% ------------------------------------------------------------------------- 

% gets input from previous delay line
kBack = numSections - k + 1;
inputForward = DelayLine_Read(fDelays{1, k}, readPointer);
inputBackward = DelayLine_Read(bDelays{1, kBack}, readPointer);
r_coeff = r(1, k);

% computes junction
forwardOut = ((1 + r_coeff) * inputForward) + ((-r_coeff) * inputBackward);
backwardOut = ((1 - r_coeff) * inputBackward) + (r_coeff * inputForward);

% writes to next delay line
fDelays{1, k+1} = DelayLine_Write(fDelays{1, k+1}, writePointer, forwardOut);
bDelays{1, kBack} = DelayLine_Write(bDelays{1, kBack}, writePointer, backwardOut);
end


