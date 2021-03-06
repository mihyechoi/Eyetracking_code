% Please set up profer cd - psyscope file saved 
cd('/Users/Desktop/Research/psyscope')

allfnames = dir('2019*.mat');

psyscope_Groupdata = zeros(length(allfnames),2);
psyscope_allgroup = zeros(length(allfnames),1);
psyscope_alltrialdata = zeros(2,20,length(allfnames));
psyscope_alltrialdata2 = zeros(length(allfnames),40);
psyscope_alldiff=zeros(length(allfnames),2);
psyscope_allrtdiff=[];


for fnum=1:length(allfnames);
    fname = allfnames(fnum).name;
    load(fname);
   
   %% practice phase coding
    originalpracmat= [alldata(18:27,4) alldata(18:27,9) alldata(18:27,10) alldata(18:27,12)]; % firstsound/type/RT/response
    pracmat= [originalpracmat(:,2) originalpracmat(:,4)];
    pracmat= strrep(pracmat,'same','1'); pracmat= strrep(pracmat,'diff','2'); 
 
    same = [];
    diff = [];
    for t = 1:length(pracmat);
    if pracmat{t}== '1', same=[same; pracmat(t,1) pracmat(t,2) originalpracmat(t,3)];
        elseif pracmat{t}== '2', diff=[diff; pracmat(t,1) pracmat(t,2) originalpracmat(t,3)];
    end
    end
    
    all = [same(:,1:2); diff(:,1:2)];
    
    samecorr=[];
    diffcorr=[];
   for t = 1:length(all);
       if all{t}== '1' & all{t+length(all)}== '[z]', samecorr = [samecorr;1];
       elseif all{t}== '1' &  all{t+length(all)}== '[/]', samecorr = [samecorr;0];
       elseif all{t}== '2' & all{t+length(all)}=='[/]', diffcorr = [diffcorr;1];
       elseif all{t}== '2' &  all{t+length(all)}=='[z]', diffcorr = [diffcorr;0];    
       end
   end
   
    %% test phase coding for analysis 
   
    orignialtstmat= [alldata(28:end,4)  alldata(28:end,9) alldata(28:end,10) alldata(28:end,12)]; % firstsound/type/RT/response
    tstmat= [orignialtstmat(:,2) orignialtstmat(:,4) orignialtstmat(:,1)];
    tstmat = strrep(tstmat,'8spk3_ba4_length_15_f_band.aiff @ :stim:','ba');
    tstmat = strrep(tstmat,'1spk3_ba4_length_100_band.aiff @ :stim:','pa');
    tstmat= strrep(tstmat,'same','1'); tstmat= strrep(tstmat,'diff','2'); 
       
    tstsame = [];
    tstdiff = [];
    for t = 1:length(tstmat);
    if tstmat{t}== '1', tstsame=[tstsame; tstmat(t,1) tstmat(t,2) tstmat(t,3)];
        elseif tstmat{t}== '2', tstdiff=[tstdiff; tstmat(t,1) tstmat(t,2) tstmat(t,3)];
    end
    end
    
    tstrt_same=[];
    tstrt_diff=[];
    for t = 1:length(tstmat);
    if tstmat{t}== '1', tstrt_same=[tstrt_same; orignialtstmat(t,3)];
        elseif tstmat{t}== '2', tstrt_diff=[tstrt_diff; orignialtstmat(t,3)];
    end
    end
    
    tstall = [tstsame(:,1:2); tstdiff(:,1:2)];
   
    tstsamecorr=[];
    tstdiffcorr=[];
   for t = 1:length(tstall);
       if tstall{t}== '1' & tstall{t+length(tstall)}=='[z]', tstsamecorr = [tstsamecorr;1];
       elseif tstall{t}== '1' &  tstall{t+length(tstall)}== '[/]', tstsamecorr = [tstsamecorr;0];
       elseif tstall{t}=='2' & tstall{t+length(tstall)}=='[/]', tstdiffcorr = [tstdiffcorr;1];
       elseif tstall{t}=='2' &  tstall{t+length(tstall)}=='[z]', tstdiffcorr = [tstdiffcorr;0];    
       end
   end
   
   
   bp_tstdiffcorr= [];
   pb_tstdiffcorr=[];
   for  t = 1:length(tstdiffcorr);
       if tstdiff{t+length(tstdiffcorr)+length(tstdiffcorr)}=='pa', pb_tstdiffcorr=[pb_tstdiffcorr;tstdiffcorr(t,1)];
       else tstdiff{t+length(tstdiffcorr)+length(tstdiffcorr)} =='ba',  bp_tstdiffcorr=[bp_tstdiffcorr;tstdiffcorr(t,1)]; 
       end
   end
   
  allcorr =[];
  allrespons= cell2mat(tstmat);
     for t = 1:length(allrespons);
       if allrespons(t,1)== '1' & allrespons(t,2:4)== '[z]', allcorr = [allcorr;1];
       elseif allrespons(t,1)== '1' &  allrespons(t,2:4)== '[/]', allcorr = [allcorr;0];
       elseif allrespons(t,1)== '2' & allrespons(t,2:4)=='[/]', allcorr = [allcorr;1];
       elseif allrespons(t,1)== '2' &  allrespons(t,2:4)=='[z]', allcorr = [allcorr;0];    
       end
     end
     
  %% Data visualization - individual data 
   praccorr = [mean(samecorr) mean(diffcorr)];
   tstcorr = [mean(tstsamecorr) mean(tstdiffcorr)];
   tstrt = [mean(cell2mat(tstrt_same)) mean(cell2mat(tstrt_diff))];
   tstrtdiffscore= mean(cell2mat(tstrt_diff))- mean(cell2mat(tstrt_same));
   tstdiff = [mean(bp_tstdiffcorr) mean(pb_tstdiffcorr)]; % ba-pa , pa-ba
   
   figure
   subplot(1,6,1:2);
   hold on
   Prac(1)= bar(1, praccorr(1), 'y', 'BarWidth', 0.5, 'LineWidth', 5);
   Prac(2)= bar(2, praccorr(2), 'b', 'BarWidth', 0.5,'LineWidth', 5);
   title(fname);
   set(gca,'ytick',[0:.1:1.1]);
   set(gca,'ylim',[0 1.1]);
   set(gca,'ytick',[0 0.2 0.4 0.6 0.8 1.0]);
   set(gca,'xtick',[1 2]);
   xl=[{'same'},{'diff'}];
   set(gca,'XTicklabel', xl, 'Fontsize',12);
   ylabel('Percent of correct responses','Fontsize',18);
   
   subplot(1,6,3:4) 
   hold on 
   Test(1)= bar(1, tstcorr(1), 'y', 'BarWidth', 0.5, 'LineWidth', 5);
   Test(2)= bar(2, tstcorr(2), 'b', 'BarWidth', 0.5,'LineWidth', 5);
   set(gca,'ylim',[0 1.1]);
   set(gca,'xtick',[1 2]);
   set(gca,'ytick',[0:.1:1.1]);
   title('test');
   set(gca,'XTicklabel', xl, 'Fontsize',12);
 
   subplot(1,6,5:6) 
   hold on 
   TestRT(1)= bar(1, tstrt(1), 'y', 'BarWidth', 0.5, 'LineWidth', 5);
   TestRT(2)= bar(2, tstrt(2), 'b', 'BarWidth', 0.5,'LineWidth', 5);
   set(gca,'ylim',[0 2000]);
   set(gca,'xtick',[1 2]);
  % set(gca,'ytick',[0 0.2 0.4 0.6 0.8 1.0]);
   title('TEST RT');
   set(gca,'XTicklabel', xl, 'Fontsize',12);
   
 psyscope_Groupdata(fnum,:)= [tstcorr];
 psyscope_allgroup(fnum,:)= [mean(allcorr)];
 psyscope_alltrialdata(:,:,fnum) = [(tstsamecorr)'; (tstdiffcorr)'];
 psyscope_alltrialdata2(fnum,:) = [(tstsamecorr)' (tstdiffcorr)'];
 psyscope_alldiff(fnum,:)=[tstdiff];
 psyscope_allrtdiff(fnum,:)=[tstrtdiffscore];
 
end

psyscope_conditions= [];
for t=1:length(allfnames);
   psyscope_conditions=[psyscope_conditions;cellstr(allfnames(t).name)];
end
psyscope_conditions= strrep(psyscope_conditions,'2019_',''); psyscope_conditions= strrep(psyscope_conditions,'.mat',''); 

bimodal = cell2mat(strfind(psyscope_conditions,'bimodal')); bimodalgroup = psyscope_Groupdata(1:sum(bimodal),:);
unimodal = cell2mat(strfind(psyscope_conditions,'unimodal')); unimodalgroup = psyscope_Groupdata(end-sum(unimodal)+1:end,:);

BISAME =bimodalgroup(:,1);
BIDIFF =bimodalgroup(:,2);
UISAME =unimodalgroup(:,1);
UIDIFF =unimodalgroup(:,2);

 %% Data visualization - group data (bimodal vs. unimodal)
figure
meanbi = mean(bimodalgroup);
meanui = mean(unimodalgroup);
groupdiff = [meanbi meanui]; % same vs diff
groupdiff = [groupdiff(1,1) groupdiff(1,3) groupdiff(1,2) groupdiff(1,4)] % bi-same, uni-same, bi-diff,uni-diff

bi_diff=bimodalgroup(:,2)
ui_diff=unimodalgroup(:,2)
[h,p,c,s] = ttest2(bi_diff,ui_diff)
[p,h,stats]=ranksum(bi_diff,ui_diff)

subplot(1,2,1)
hold on
GROUP(1)= bar(1, groupdiff(1), 'g', 'BarWidth', 0.5, 'LineWidth', 5);
GROUP(2)= bar(2, groupdiff(2), 'b', 'BarWidth', 0.5,'LineWidth', 5);
totalMTerror1 = [std(bimodalgroup(:,1))/sqrt(sum(~isnan(bimodalgroup(:,1)))) std(bimodalgroup(:,2))/sqrt(sum(~isnan(bimodalgroup(:,2))))];
errorbar(groupdiff(1,1:2),totalMTerror1,'LineStyle','none','Color','k','LineWidth',2);
ylabel('Prop of correct trials','Fontsize',36);
set(gca,'ylim',[0 1]);
set(gca,'ytick',[0:.1:1],'Fontsize',20);
set(gca,'xtick', [1 2]);
tick = [{'Bimodal'},{'Unimodal'}];
set(gca,'xticklabel',tick,'Fontsize',24);
title(' "Same" trial type' ,'Fontsize',42)
hold on
plot(1,bimodalgroup(:,1),'o','Markersize',15,'color','k');
plot(2,unimodalgroup(:,1),'o','Markersize',15,'color','k');


subplot(1,2,2)
hold on
GROUP(1)= bar(1, groupdiff(3), 'g', 'BarWidth', 0.5, 'LineWidth', 5);
GROUP(2)= bar(2, groupdiff(4), 'b', 'BarWidth', 0.5,'LineWidth', 5);
totalMTerror2 = [std(unimodalgroup(:,1))/sqrt(sum(~isnan(unimodalgroup(:,1)))) std(unimodalgroup(:,2))/sqrt(sum(~isnan(unimodalgroup(:,2))))];
errorbar(groupdiff(1,3:4),totalMTerror2,'LineStyle','none','Color','k','LineWidth',2);
set(gca,'ylim',[0 1]);
set(gca,'ytick',[0:.1:1],'Fontsize',20);
set(gca,'xtick', [1 2]);
set(gca,'xticklabel',tick,'Fontsize',24);
title(' "Diff" trial type' ,'Fontsize',42);
hold on
plot(1,bimodalgroup(:,2),'o','Markersize',15,'color','k');
plot(2,unimodalgroup(:,2),'o','Markersize',15,'color','k');

 bitotal = psyscope_allgroup(1:sum(bimodal),:);
 unitotal= psyscope_allgroup(end-sum(unimodal)+1:end,:);
 
[h,p,c,s] = ttest2(bitotal,unitotal)

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

