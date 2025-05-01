function readPointer = DelayLine_SetLength(maxLength,writePointer,desiredLength)
% -------------------------------------------------------------------------
% readPointer = DelayLine_SetLength(maxLength,writePointer,desiredLength)
% -------------------------------------------------------------------------
%
% Function used to set the length of the delay line. 
% It will determine the readPointer position given a desired length and the current position of the write pointer.
%
% INPUTS:
% 	- 	maxLength (integer): maximum length of the delay line
% 	-	writePointer (integer): current position of the write pointer
%	-	desiredLength (integer): desired length
% OUTPUTS:
%	- 	readPointer (integer): updated position of the readPointer
% ------------------------------------------------------------------------- 



%%%%% YOUR CODE HERE %%%%%%
readPointer = writePointer - desiredLength;
if readPointer < 1
    readPointer = readPointer + maxLength;
end

end