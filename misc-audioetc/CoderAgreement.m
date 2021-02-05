close all; clear all; clc

cd('/Users/MihyeC/Documents/MATLAB/PABAexp3codingagreement')
d = dir('D_33_5_*.xlsx');

% need to change number of row (= size of matcromat)
alldata = zeros(133859,3,length(d));

for fnum=1:length(d);
    
    fname = d(fnum).name;
    [~,~,raw] = xlsread(fname);
    
    eyecodingms=raw(2:end,2:4);
    rawdata_trial = cell2mat(eyecodingms(:,1));
    rawdata_time = cell2mat(eyecodingms(:,2));
    rawdata_eyecoded = cell2mat(eyecodingms(:,3));
    
    eyecoded = [];
    for t=1:length(rawdata_eyecoded);
        if rawdata_eyecoded(t,:)== 'look', eyecoded = [eyecoded;1];
        elseif rawdata_eyecoded(t,:)== 'away', eyecoded = [eyecoded;0];
        end
    end
    
    % time (ms) with look (1) or away (0)
   alleyecoded = [rawdata_trial rawdata_time eyecoded];
 
   %% macro

 macromat= [];
 for t =1:length(alleyecoded); 
     if alleyecoded(t,2) < max(alleyecoded(:,2)) && alleyecoded(t,1)==alleyecoded(t+1,1) 
        for j = 0:(alleyecoded(t+1,2)-alleyecoded(t,2)-1)
         macromat = [macromat;[alleyecoded(t,1) alleyecoded(t,2)+j alleyecoded(t,3)]];
        end
     elseif alleyecoded(t,2) == max(alleyecoded(:,2));
         macromat = [macromat;[alleyecoded(t,1) alleyecoded(t,2) alleyecoded(t,3)]]; 
     end
     
         
 end
 
 alldata(:,:,fnum) = macromat;
 
end
 
% coder agreement 
coderagreement = [];
for t= 1:length(alldata);
    if alldata(t,3,1) == alldata(t,3,2), coderagreement = [coderagreement;1];
    else coderagreement = [coderagreement;0];
    end
end

coderagr = mean(coderagreement)*100; 

