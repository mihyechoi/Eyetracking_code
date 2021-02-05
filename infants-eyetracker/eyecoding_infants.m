clear all; close all; clc
% please set up profer cd (data saved folder
cd('/Users/####/');

%% Define variable (e.g.,trial types, test begin and end, screen's resolution)
xidx = 19; % x axis from the screen from 0-1920
yidx = 20; % y axis from the screen from 0-1080
screenxmax=1920;
screenymax=1080;
FMLbgn= 7;
Alt3 = 2; Alt6 = 3; Nlt3 = 4; Nlt6 = 5; % test begin markers
TstSndEndmarker = 6;
AttenG = 1;

%% start analysis 
% for-loop below: running individual files one by one   
allfnames = dir('*.mat');
totalData = zeros(length(allfnames),8);
subjectid = zeros(length(allfnames),3);

for fnum=1:length(allfnames);
    
    fname = allfnames(fnum).name;
    load(fname);

    % limit eye location data to those within the dimensions of screensize (x:
    % 1920, y:1080) in each test trial 
    
 eyex = matdata.eyedata(:,xidx);
 eyey = matdata.eyedata(:,yidx);
 eyex = waverepair(eyex,30,0); % cutoff will be the max sequecne of nan to run to interpolate
 eyey = waverepair(eyey,30,0);
 eyex(or(eyex<1,eyex>screenxmax))=nan;
 eyey(or(eyey<1,eyey>screenymax))=nan;
    
 epochs = getepochs(matdata.marksvector,[Alt3 TstSndEndmarker; Alt6 TstSndEndmarker; Nlt3 TstSndEndmarker; Nlt6 TstSndEndmarker],0);

 Alt3Len = round(median(diff(epochs(1).epochdef'))); % epochduration (t-duration)
 Alt6Len = round(median(diff(epochs(2).epochdef')));
 Nlt3Len = round(median(diff(epochs(3).epochdef')));
 Nlt6Len = round(median(diff(epochs(4).epochdef')));
 
 blocklen = max([Alt3Len Alt6Len Nlt3Len Nlt6Len]);
 blockdata = getblocks(matdata.eyedata(:,xidx:yidx),epochs,[0 0],blocklen); 
 gazedata = [blockdata(1).data(:,:,1);blockdata(1).data(:,:,2)
             blockdata(2).data(:,:,1);blockdata(2).data(:,:,2)
             blockdata(3).data(:,:,1);blockdata(3).data(:,:,2)
             blockdata(4).data(:,:,1);blockdata(4).data(:,:,2)];
 
 % AOIdef = [X-upper,left  Y-upper,left  X-lower,right  Y-lower,right]
 AOIdef = [1 1 1920 1080];
 AOIdata = nansum(reshape(IsInAOI(gazedata,AOIdef),[blocklen,8]));
 AOIdatasec = (AOIdata./300);
 
%% see the data based on trial types 
% to categorize types of trials

     FA3 = AOIdatasec(1,1); % for example: First, Alternating, Audiotype3 trial 
     SA3 = AOIdatasec(1,2);
     FA6 = AOIdatasec(1,3);
     SA6 = AOIdatasec(1,4);
     FN3 = AOIdatasec(1,5);
     SN3 = AOIdatasec(1,6);
     FN6 = AOIdatasec(1,7);
     SN6 = AOIdatasec(1,8);
     
     % order of the test trials 
     T3N = [FN3;FA6;FA3;FN6;SN6;SA3;SN3;SA6];
     T6N = [FN6;FA3;FA6;FN3;SN3;SA6;SN6;SA3];
     T3A = [FA3;FN6;FN3;FA6;SA6;SN3;SA3;SN6];
     T6A = [FA6;FN3;FN6;FA3;SA3;SN6;SA6;SN3];
 
     % LT data based on a file's name (condition)
    if fname(end-5:end-4)== '6N', BarData=T6N; 
    elseif fname(end-5:end-4)== '3N', BarData=T3N;
    elseif fname(end-5:end-4)== '6A',BarData=T6A;
    elseif fname(end-5:end-4)== '3A' BarData=T3A;
    end 
    
    % x label for bar graph
     if fname(end-5:end-4)=='6N', sxl= [{'N6'};{'A36'};{'A63'};{'N3'};{'N3'};{'A63'};{'N6'};{'A36'}];
     elseif fname(end-5:end-4)== '3N', sxl= [{'N3'};{'A63'};{'A36'};{'N6'};{'N6'};{'A36'};{'N3'};{'A63'}]; 
     elseif fname(end-5:end-4)=='6A', sxl= [{'A63'};{'N3'};{'N6'};{'A36'};{'A36'};{'N6'};{'A63'};{'N3'}];
     elseif fname(end-5:end-4)== '3A', sxl= [{'A36'};{'N6'};{'N3'};{'A63'};{'A63'};{'N3'};{'A36'};{'N6'}]; 
     end
     
     % change low LT to Nan trial
      for t=1:length(BarData)
          if BarData(t,:) <=1, BarData(t,:) = nan;
          end      
      end
      
      %% to make individual figure
  figure('position',[50 50 1200 1000]);
  subplot(1,8,1:2);
  if fname(end-4)=='N', 
      Nltlook = [BarData(1,1);BarData(4,1);BarData(5,1);BarData(7,1)];
      Altlook = [BarData(2,1);BarData(3,1);BarData(6,1);BarData(8,1)];
  else fname(end-4)=='A',
      Nltlook = [BarData(2,1);BarData(3,1);BarData(6,1);BarData(8,1)];
      Altlook = [BarData(1,1);BarData(4,1);BarData(5,1);BarData(7,1)];
  end
  hold on
  MeanTest = ([nanmean(Altlook); nanmean(Nltlook)]);
    totalfirstb(1) = bar(1, MeanTest(1), 'BarWidth', 0.5,'FaceColor',[0.8500 0.3250 0.0980]); 
    totalfirstb(2) = bar(2, MeanTest(2), 'BarWidth', 0.5,'FaceColor', [0 0.4470 0.7410]);
  MTerror = [nanstd(Altlook)/sqrt(sum(~isnan(Altlook))) nanstd(Nltlook)/sqrt(sum(~isnan(Nltlook)))];
  text(1:2,MeanTest,num2str(MeanTest),'HorizontalAlignment','center','VerticalAlignment','bottom')
  xl=[{'A'},{'Non-A'}];
  set(gca,'XTicklabel',xl,'Fontsize',12); 
  set(gca,'XTick', [1 2 3 4 5 6 7 8]); 
  set(gca,'ylim',[0 16]);
  ylabel('Mean Looking Times (in sec) to Each of the Two Test Trial Types');
  set(gca,'YTick',[0 5 10 15]);
  set(gca,'XTick',[1 2]);
  msylabel = [{'0'};{'5'};{'10'};{'15'}];
  set(gca,'YTicklabel',msylabel, 'Fontsize',15);
  firstb.Facecolor= [.2 .6];
  errorbar(MeanTest,MTerror,'LineStyle','none','Color','k','LineWidth',2);
    
  subplot(1,8,3:5);
  hold on 
  title(fname);
  text(1:8,BarData,num2str(BarData),'HorizontalAlignment','center','VerticalAlignment','bottom')
  set(gca,'xlim',[0 9]);
  set(gca,'XTick',1:8);
  set(gca,'YTick',[0 5 10 15]);
  set(gca,'YTicklabel',[], 'Fontsize',15);
  set(gca,'ylim',[0 16.5]);
  set(gca,'XTicklabel', sxl, 'Fontsize',10);
  AltColor= [2 3 6 8];
  for t = 1:length(AltColor)
      if AltColor(t) == 2 || AltColor(t) == 3 || AltColor(t) == 6 || AltColor(t) == 8
      barHandle(AltColor(t)) = bar(AltColor(t), BarData(AltColor(t)),'BarWidth', 0.9);
      hold on
      set(barHandle(AltColor(t)), 'FaceColor',[0.8500 0.3250 0.0980]);
      end
  end
  NltColor= [1 4 5 7];
  for t = 1:length(NltColor)
      if NltColor(t) == 1 || NltColor(t) == 4 || NltColor(t) == 5 || NltColor(t) == 7
      barHandle(NltColor(t)) = bar(NltColor(t), BarData(NltColor(t)),'BarWidth', 0.9);
      hold on
      set(barHandle(NltColor(t)), 'FaceColor',[0 0.4470 0.7410]);
      end
  end
  
  subplot(1,8,6:8);
  hold on
  type1 = [BarData(2,1);BarData(3,1);BarData(6,1);BarData(8,1)];
  type2 = [BarData(1,1);BarData(4,1);BarData(5,1);BarData(7,1)]; %type 1 = T3N OR T6N - Non-alternation, T3A OR T6A = Alternation
   
  subjectmean = [mean(type1); mean(type2)];
   
  plot(type1,'r-o');
  plot(type2,'b-*');
  legend('type1; A in N-begin test','type2; N in N-begin test');
  set(gca,'xlim',[0 5]);
  set(gca,'ylim',[0 16.5]);
  set(gca,'ytick',[0 5 10 15]);
  set(gca,'YTicklabel',[], 'Fontsize',15);
  set(gca,'xtick',1:4);
  set(gca,'XTicklabel',[{'First'},{'Second'},{'Third'},{'Forth'}]);

  subject= [str2double(fname(12:15)) str2double(fname(9:10)) str2double(fname(7))]; 
  totalData(fnum,:) = BarData; 
  subjectid(fnum,:) = subject; 
end
 
%% group figure
figure
hold on
title('Eye tracking data by group')
  totalAltlook = [totalData(:,2) totalData(:,3) totalData(:,6) totalData(:,8)];  
  totalNltlook = [totalData(:,1) totalData(:,4) totalData(:,5) totalData(:,7)];
  totalMeanTest = ([nanmean((nanmean(totalAltlook))); nanmean((nanmean(totalNltlook)))]);
  totalb(1) = bar(1, totalMeanTest(1), 'BarWidth', 0.5, 'FaceColor',[0.8500 0.3250 0.0980]); %[nanmean(Altlook); nanmean(NAltlook)]);
  totalb(2) = bar(2, totalMeanTest(2), 'BarWidth', 0.5, 'FaceColor',[0 0.4470 0.7410]);
  hold on
  totalMTerror = [nanstd(totalAltlook)/sqrt(sum(~isnan(totalAltlook))) nanstd(totalNltlook)/sqrt(sum(~isnan(totalNltlook)))];
  ylabel('Mean of Looking Times (in sec)');
  text(1:2,totalMeanTest,num2str(totalMeanTest),'HorizontalAlignment','center','VerticalAlignment','bottom')
  xl=[{'Alternating'},{'Non-Alternating'}];
  set(gca,'XTicklabel', xl, 'Fontsize',15); 
  set(gca,'XTick',[1 2]);
  set(gca,'ylim',[0 16.5]);
  errorbar(totalMeanTest,totalMTerror,'LineStyle','none','Color','k','LineWidth',2);
  hold on
  
  GmeanAlt = nanmean(totalAltlook);
  GmeanNlt = nanmean(totalNltlook);
  alldata = [nanmean(totalAltlook'); nanmean(totalNltlook')];
  testtype=[{'A'},{'A'},{'Non-A'},{'Non-A'}]';


%% simple t-test
  % paired t-tests comparing the two types of test trials 
  [h,p,ci,stats] = ttest(alldata(1,:),alldata(2,:))  

%% export an analysis file FOR JASP
finalsubject= repmat(subjectid,2,1);
alldata2= [nanmean(totalAltlook') nanmean(totalNltlook')]'
JASPfinaltable = table(finalsubject,alldata2,testtype);
writetable(JASPfinaltable,'JASP.csv');
 
    %%save all figues at one
%h = get(0,'children');
% for i=1:length(h)
%   saveas(h(i), ['figure' num2str(i)], 'png');
% end
