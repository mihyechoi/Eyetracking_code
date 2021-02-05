d = dir('*.aiff');

[~,~,raw] = xlsread('RandomList.xlsx');
audiolist = raw(2:end,5);

jit= randi([50 100],192,1);
jitms= jit*0.01;

tkn =[];
silence =[];
tkn.silence =[];
allsqcsound =[];

for j=1:length(audiolist);
    tkn = d(audiolist{j}).name;
    
    fs=44100;  % sampling frequency
    duration= jitms(j,1);
    values=0:1/fs:duration;
    silence= sin(2*pi*0*values)';
    
    tkn.silence = [audioread(tkn);silence];
    
    allsqcsound = [allsqcsound;tkn.silence];
end

;
