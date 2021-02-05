%% data from psyscope data 
cd('Desktop/Research/psyscope')
Korean_disLearningPsyscope

%% data from Eprime
cd('Desktop/Research/eprime')
Korean_DisLearning

%% all data together 
allsubs = [psyscope_conditions;eprime_conditions];
allgdata= [psyscope_Groupdata;eprime_Groupdata]; % same diff
samediff= allgdata;
allgroup= [psyscope_allgroup; eprime_allgroup]; % same+diff
total=allgroup;
all_alltrial2= [psyscope_alltrialdata2;eprime_alltrialdata2];
all_alldiff= [psyscope_alldiff;eprime_alldiff]; % diff trials only, ba-pa and pa-ba order
all_allrtdiff= [psyscope_allrtdiff;eprime_allrtdiff];
allsubs= strrep(allsubs,'bimodal','1');allsubs= strrep(allsubs,'unimodal','2');allsubs= strrep(allsubs,'_','');
% bimodal = 1, unimodal 2
allsub2= str2double(allsubs)
%% export excel file
alldatatable = table(allsubs, samediff, total, all_alltrial2);
excelfilename = 'dataforJAPS.txt';
writetable(alldatatable);
%% 
allallt= [allsub2 all_alltrial2]; % ID and reaction to each trial 

bimodal =[]; unimodal=[];
for t= 1:length(allsubs);
    if allsubs{t}(1)=='1', bimodal=[bimodal;allgdata(t,:)];
    elseif allsubs{t}(1)== '2', unimodal = [unimodal;allgdata(t,:)];
    end
end

BISAME =bimodal(:,1);
BIDIFF =bimodal(:,2);
UISAME =unimodal(:,1);
UIDIFF =unimodal(:,2);

figure
meanbi = mean(bimodal);
meanui = mean(unimodal);
groupdiff = [meanbi meanui]; % same vs diff
groupdiff = [groupdiff(1,1) groupdiff(1,3) groupdiff(1,2) groupdiff(1,4)]; % bi-same, uni-same, bi-diff,uni-diff

bi_diff=bimodal(:,2);
ui_diff=unimodal(:,2);
[h,p,c,s] = ttest2(bi_diff,ui_diff)
[p,h,stats]=ranksum(bi_diff,ui_diff)

subplot(1,2,1)
hold on
GROUP(1)= bar(1, groupdiff(1), 'g', 'BarWidth', 0.5, 'LineWidth', 5);
GROUP(2)= bar(2, groupdiff(2), 'b', 'BarWidth', 0.5,'LineWidth', 5);
totalMTerror1 = [std(bimodal(:,1))/sqrt(sum(~isnan(bimodal(:,1)))) std(bimodal(:,2))/sqrt(sum(~isnan(bimodal(:,2))))];
errorbar(groupdiff(1,1:2),totalMTerror1,'LineStyle','none','Color','k','LineWidth',2);
ylabel('Prop of correct trials','Fontsize',36);
set(gca,'ylim',[0 1]);
set(gca,'ytick',[0:.1:1],'Fontsize',20);
set(gca,'xtick', [1 2]);
tick = [{'Bimodal'},{'Unimodal'}];
set(gca,'xticklabel',tick,'Fontsize',24);
title(' "Same" trial type' ,'Fontsize',42);
hold on
plot(1,bimodal(:,1),'o','Markersize',15,'color','k');
plot(2,unimodal(:,1),'o','Markersize',15,'color','k');


subplot(1,2,2)
hold on
GROUP(1)= bar(1, groupdiff(3), 'g', 'BarWidth', 0.5, 'LineWidth', 5);
GROUP(2)= bar(2, groupdiff(4), 'b', 'BarWidth', 0.5,'LineWidth', 5);
totalMTerror2 = [std(unimodal(:,1))/sqrt(sum(~isnan(unimodal(:,1)))) std(unimodal(:,2))/sqrt(sum(~isnan(unimodal(:,2))))];
errorbar(groupdiff(1,3:4),totalMTerror2,'LineStyle','none','Color','k','LineWidth',2);
set(gca,'ylim',[0 1]);
set(gca,'ytick',[0:.1:1],'Fontsize',20);
set(gca,'xtick', [1 2]);
set(gca,'xticklabel',tick,'Fontsize',24);
title(' "Diff" trial type' ,'Fontsize',42);
hold on
plot(1,bimodal(:,2),'o','Markersize',15,'color','k');
plot(2,unimodal(:,2),'o','Markersize',15,'color','k');

% total response  
bitotal= mean(bimodal');
unitotal= mean(unimodal');
 
[h,p,c,s] = ttest2(bitotal,unitotal);

figure
hold on
totalbi = bar(1, mean(bitotal), 'y', 'BarWidth', 0.5, 'LineWidth', 5);
totalui = bar(2, mean(unitotal), 'b', 'BarWidth', 0.5, 'LineWidth', 5);
totalMTerror = [std(bitotal)/sqrt(sum(~isnan(bitotal))) std(unitotal)/sqrt(sum(~isnan(unitotal)))];
errorbar([mean(bitotal) mean(unitotal)],totalMTerror,'LineStyle','none','Color','k','LineWidth',2);
set(gca,'ylim',[0 1]);
set(gca,'xtick', [1 2]);
totalgroupname = [{'BI'},{'UI'}];
set(gca,'XTicklabel', totalgroupname, 'Fontsize',15);
ylabel('Prop of correct trials','Fontsize',18);

%% hitrate FA
alldata_hitfa= [allsub2 all_alltrial2]; % ID and reaction to each trial 

bimodal_hit =[]; unimodal_hit=[];
for t= 1:length(allsubs);
    if allsubs{t}(1)=='1', bimodal_hit=[bimodal_hit;alldata_hitfa(t,:)];
    elseif allsubs{t}(1)== '2', unimodal_hit = [unimodal_hit;alldata_hitfa(t,:)];
    end
end

bi_diffonly_score=bimodal_hit(:,end-19:end)';
bi_hitrate = sum(bi_diffonly_score)/size(bi_diffonly_score,1);
bi_falsealarm = sum(bi_diffonly_score==0)/size(bi_diffonly_score,1);
   
% if bi_hitrate ==0, bi_hitrate = hitrate+eps; 
% else bi_hitrate==1, bi_hitrate = hitrate-eps; end
% if bi_falsealarm ==0, bi_falsealarm = bi_falsealarm+eps; 
% else bi_falsealarm==1, bi_falsealarm = bi_falsealarm-eps; end 
%    
%    
% bi_zHit = norminv(bi_hitrate);
% bi_zFA = norminv(bi_falsealarm); 
% bi_dPrime = bi_zHit - bi_zFA;
   
ui_diffonly_score=unimodal_hit(:,end-19:end)'
ui_hitrate = sum(ui_diffonly_score)/size(ui_diffonly_score,1);
ui_falsealarm = sum(ui_diffonly_score==0)/size(ui_diffonly_score,1);



