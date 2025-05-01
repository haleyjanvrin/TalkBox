# TalkBox
Digital talkbox in MATLAB based on the Kelly-Lochbaum acoustic tube model.  
Created for MUMT307: Audio Computing final project. Work in progress.

# Project files:
Digital_Talkbox.m - Talkbox is run from here. User selects the input audio file and vocal tract vowel shape.  
  
Other files:   
DelayLine_SetLength - Initializes the read pointer for a delay line  
DelayLine_Read.m - Reads from a delay line only  
DelayLine_Write.m - Writes to a delay line only 
DelayLine_TickOnly.m - Advances read and write pointers only  
junction.m - Computes the output for the forward and backward wave at a junction between acoustic tube sections   
trumpet.wav - sample audio input file
