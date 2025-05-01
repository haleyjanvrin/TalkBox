function [delayLine] = DelayLine_Read(delayLine, writePointer)
% writes to delay line (updates contents) but does NOT read or update pointers
% ie. does NOT tick

delayLine(writePointer) = inputSample;
end