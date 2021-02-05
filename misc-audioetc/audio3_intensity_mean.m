cd('/Users/MihyeC/Desktop/hesitation_det/dataset/sorted-speech-silence/Actor_01_01/temp')

allfnames = dir('*.wav');
 
non= zeros(50000,60);
non_amp_duration =zeros(1, length(allfnames));
non_sum_amp= zeros(1, length(allfnames));

for fnum=1:length(allfnames);
    fname = allfnames(fnum).name;
    f= audioread(fname);
    f= f(1:50000,:);
 
    negative=[];
    positive=[];
    for t=1:length(f)
        if f(t,1)<=0, negative= [negative;f(t,1)];
        else positive=[positive;f(t,1)];
        end
    end
    
    intensity_duration = length(negative);
    sum_intensity = sum(negative)
    
    non_amp_duration(:,fnum)=intensity_duration;
    non_sum_amp(:,fnum)=sum_intensity; 
    non(:,fnum) = [f];

end 

mean_non=mean(non)

clear all; clc
cd('/Users/MihyeC/Desktop/hesitation_det/dataset/sorted-speech-silence/Actor_01_01')

allfnames = dir('*.wav');

%  yes= zeros(50000,60);
%  amp_duration =zeros(1, length(allfnames));
%  sum_amp= zeros(1, length(allfnames));
%  
% for fnum=1:length(allfnames);
%     fname = allfnames(fnum).name;
%     f= audioread(fname);
%     f= f(1:50000,:);
%     
%     negative=[];
%     positive=[];
%     for t=1:length(f)
%         if f(t,1)<=0, negative= [negative;f(t,1)];
%         else positive=[positive;f(t,1)];
%         end
%     end
%     
%     intensity_duration = legnth(negative);
%     sum_intensity = sum(negative)
%     
%     amp_duration(:,fnum)=intensity_duration;
%     sum_amp(:,fnum)=sum_intensity; 
%     yes(:,fnum) = [f];
% 
% end 
% mean_yes=mean(yes)
   
