function [outputSample] = DelayLine_Read(delayLine, readPointer)
% reads delay line contents but does NOT update contents read and write pointers
% ie. does NOT tick

outputSample = delayLine(1, readPointer);
end