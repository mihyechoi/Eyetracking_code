clear all; close all; clc;

Fs = 44100;
ts=1/Fs;
t=0:ts:0.4;
A=1;
phaseV=20;

fc=[392;392;440;392;524;524;495;
    392;392;440;392;588;588;524;
    392;392;784;660;524;524;495;440;
    699;699;660;524;588;588;524];
   
% 260 294 330 349 392 440 495 524 588 660 699 784 880 988
% c   d   e   f   g   a   b   c   d   e   f   g   a   b


d_vector =[];
for j=1:length(fc)
    d= A*cos(2*pi*fc(j,1)*t + phaseV);
    %sound(d,Fs);
    %pause(0.5);
    values=0:1/Fs:0.5;
    silence= sin(2*pi*0*values);
    d.silence= [d, silence];
    d_vector=[d_vector, d.silence];
end

wavwrite(d_vector,Fs,16,'test.wav')

wavwrite(d,Fs,16,'test.wav')
   