function [writePointer, readPointer] = DelayLine_TickOnly(writePointer, readPointer, maxLength)
% updates read and write pointers but does NOT read samples
% or update delay line contents

readPointer = readPointer + 1;
writePointer = writePointer + 1;
if readPointer > maxLength
    readPointer = readPointer - maxLength;
end
if writePointer > maxLength
    writePointer = writePointer - maxLength;
end
end