function [delayLine] = DelayLine_Write(delayLine, writePointer, inputSample)
% writes to delay line (updates contents) but does NOT read or update pointers
% ie. does NOT tick

delayLine(1, writePointer) = inputSample;
end
