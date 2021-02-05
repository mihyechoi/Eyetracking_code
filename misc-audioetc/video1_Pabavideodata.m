close all; clear all; clc

cd('/Users/MihyeC/Documents/MATLAB/PABAexp3codingagreement')

allfnames = dir('*.xlsx');

idinf= 1; % id 
trial= 2; % from 1 to 8
evtonset= 3; % time = ms 
eyecoded= 4; % look or away

totalData = zeros(length(allfnames),8);

for fnum=1:length(allfnames);
    
    fname = allfnames(fnum).name;
    [~,~,raw] = xlsread(fname);
   
    datarange = raw(2:end,1:4)
    videodata_trial = cell2mat(datarange(:,trial));
    videodata_time = cell2mat(datarange(:,evtonset));
    videodata_eyecoded = cell2mat(datarange(:,eyecoded));
    
    lookingcoded = [];
    for t=1:length(videodata_eyecoded);
        if videodata_eyecoded(t,:)== 'look', lookingcoded = [lookingcoded;1];
        elseif videodata_eyecoded(t,:)== 'away', lookingcoded = [lookingcoded;0];
        end
    end
    
    alldata = [videodata_trial videodata_time lookingcoded];
    
    % calculate looking time of each trial ---- need to work
    lookingtime = []
    awaytime  = [];
    for t=1:length(videodata_trial);
        if alldata(t,1)==1 alldata(t,3)==1,
            videodata_time(t,1) < max(videodata_time) & videodata_trial(t,1) == videodata_trial(t+1,1) & videodata_eyecoded(t,1)== 'look',
            lookingtime = [lookingtime; videodata_trial(t,1); videodata_time(t+1,1) - videodata_time(t,1)]
        elseif videodata_time(t,1) < max(videodata_time) & videodata_trial(t,1) == videodata_trial(t+1,1) & videodata_eyecoded(t,1)== 'away'
            awaytime = [awaytime; videodata_trial(t,1); videodata_time(t+1,1) - videodata_time(t,1)]
        end
    end
    
            
  
    
    %% figure
  figure('position',[50 50 1200 1000]);
  
  subplot(1,8,1:2);
  NAltlook = (AOIdatamsec(1,1:3));
  Altlook = (AOIdatamsec(1,4:6));

  MeanTest = ([nanmean(Altlook); nanmean(NAltlook)]);
  firstb = bar(MeanTest); 
  hold on
  MTerror = [nanstd(Altlook)/sqrt(sum(~isnan(Altlook))) nanstd(NAltlook)/sqrt(sum(~isnan(NAltlook)))];
  text(1:2,MeanTest,num2str(MeanTest),'HorizontalAlignment','center','VerticalAlignment','bottom')
  xl=[{'A'},{'N'}];
  set(gca,'XTicklabel',xl,'Fontsize',15); 
  set(gca,'ylim',[0 16500]);
  ylabel('looking time (ms)');
  set(gca,'YTick',[0 5000 10000 15000]);
  msylabel = [{'0'};{'5000'};{'10000'};{'15000'}];
  set(gca,'YTicklabel',msylabel, 'Fontsize',15);
  firstb.BarWidth = .5;
  errorbar(MeanTest,MTerror,'LineStyle','none','Color','k','LineWidth',2);
    
  subplot(1,8,3:5);
  secondb = bar(BarData,'FaceColor',[0 .5 .5],'EdgeColor',[0 .9 .9],'LineWidth',1.5);
  title(fname);  
  text(1:8,BarData,num2str(BarData),'HorizontalAlignment','center','VerticalAlignment','bottom')
  set(gca,'XTick',1:8);
  set(gca,'YTick',[0 5000 10000 15000]);
  set(gca,'YTicklabel',[], 'Fontsize',15);
  set(gca,'ylim',[0 16500]);
  set(gca,'XTicklabel', sxl, 'Fontsize',10);
  
  subplot(1,8,6:8);
  hold on
  type1 = [BarData(1,1);BarData(4,1);BarData(5,1);BarData(7,1)]; %type 1 = T3N OR T6N - Non-alternation, T3A OR T6A = Alternation
  type2 = [BarData(2,1);BarData(3,1);BarData(6,1);BarData(8,1)];
  plot(type1,'b-o');
  plot(type2,'r-*');
  legend('type1; N in N-begin test','type2; A in N-begin test');
  set(gca,'xlim',[0 5]);
  set(gca,'ylim',[0 16500]);
  set(gca,'ytick',[0 5000 10000 15000]);
  set(gca,'YTicklabel',[], 'Fontsize',15);
  set(gca,'xtick',1:4);
  set(gca,'XTicklabel',[{'First'},{'Second'},{'Third'},{'Forth'}]);

  
  totalData(fnum,:) = AOIdatamsec;  

 
end

figure
hold on
  totalAltlook = (totalData(:,4:6));
  totalNAltlook = (totalData(:,1:3));
  totalMeanTest = ([nanmean((nanmean(totalAltlook))); nanmean((nanmean(totalNAltlook)))]);
  totalfirstb = bar(totalMeanTest); %[nanmean(Altlook); nanmean(NAltlook)]); 
  hold on
  totalMTerror = [nanstd(totalAltlook)/sqrt(sum(~isnan(totalAltlook))) nanstd(totalNAltlook)/sqrt(sum(~isnan(totalNAltlook)))];
  ylabel('looking time (ms)');
  text(1:2,totalMeanTest,num2str(totalMeanTest),'HorizontalAlignment','center','VerticalAlignment','bottom')
  xl=[{'Alternation'},{'Non-Alternation'}];
  set(gca,'XTicklabel', xl, 'Fontsize',15); 
  set(gca,'XTick',[1 2]);
  set(gca,'ylim',[0 16500]);
  totalfirstb.BarWidth = .5;
  errorbar(totalMeanTest,totalMTerror,'LineStyle','none','Color','k','LineWidth',2);


