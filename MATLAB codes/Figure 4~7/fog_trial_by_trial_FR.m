clc
clear all
close all

cd('D:\VR_Headfix_Data_Ephys\raw')
load('fog_p_cellID')


mn = -0.75;
mx = 0.75;
FilteredcellID = [CA1GrpID' CA1rrmapID']';
wid = 3;

fog0FR = [];
fog1FR = [];
fog2FR = [];

for i=1:length(FilteredcellID)
    
    fileID = [cell2mat(FilteredcellID(i))];
    cd('D:\VR_Headfix_Data_Ephys\raw\FogLap_by_Lap (mat)')
    load([fileID '.mat'])
    
    fileID = [cell2mat(FilteredcellID(i)) '_trial(inclusive)'];
    cd('D:\VR_Headfix_Data_Ephys\raw\FogLap_by_Lap (mat)\CosSIM')
    load([fileID '.mat'])
    
    zAvgF = normalize(inFieldFR);
    zAvgF2 = normalize(AvgF);
    
    FogTI = min([amb0Trial amb1Trial amb2Trial]);
    
    fog0FR(i,:) = [zAvgF((FogTI-14):1:FogTI-1) zAvgF(amb0Trial(1:13))];
    fog1FR(i,:) = [zAvgF((FogTI-14):1:FogTI-1) zAvgF(amb1Trial(1:13))];
    fog2FR(i,:) = [zAvgF((FogTI-14):1:FogTI-1) zAvgF(amb2Trial(1:13))];
    
    fog0FR2(i,:) = [zAvgF2((FogTI-14):1:FogTI-1) zAvgF2(amb0Trial(1:13))];
    fog1FR2(i,:) = [zAvgF2((FogTI-14):1:FogTI-1) zAvgF2(amb1Trial(1:13))];
    fog2FR2(i,:) = [zAvgF2((FogTI-14):1:FogTI-1) zAvgF2(amb2Trial(1:13))];
    
    AvgF = [];
    FogTI = [];
    zAvgF = [];
    inFieldFR = [];
    amb0Trial = [];
    amb1Trial = [];
    amb2Trial = [];
    
end

tAvFr = [];
tAverr = [];
tAvFr2 = [];
tAverr2 = [];

x = [];
e = [];

x=[];
e=[];
for k = 1 : fr
    tAvFr(k) = nanmean(fog0FR(:,k))
    tAverr(k) = nanstd(fog0FR(:,k))/sqrt(length(FilteredcellID));
    tAvFr2(k) = nanmean(fog0FR(:,k))
    tAverr(k) = nanstd(fog0FR(:,k))/sqrt(length(FilteredcellID));
end

subplot(1,3,1)
x = smoothdata(tAvFr,'gaussian', 5);
e = tAverr;

plot(x,'o', 'MarkerFaceColor','b')
title('CA1: fog-0%','FontWeight','bold','FontSize',9)
ylabel('Average FR','FontWeight','bold','FontSize',9);
xlabel('Trial #','FontWeight','bold','FontSize',9);

ylim([mn mx])
xlim([0 fr])
xline(15,'r:')

hold on

er = errorbar(1:1:fr,x,e);
er.Color = [0 0 0];
er.LineStyle = 'none';

tAvFr = [];
tAverr = [];
x = [];
e = [];

x=[];
e=[];

for k = 1 : fr
    tAvFr(k) = nanmean(fog1FR(:,k))
    tAverr(k) = nanstd(fog1FR(:,k))/sqrt(length(FilteredcellID));
    tAvFr2(k) = nanmean(fog1FR(:,k))
    tAverr(k) = nanstd(fog1FR(:,k))/sqrt(length(FilteredcellID));
end

subplot(1,3,2)
x = smoothdata(tAvFr,'gaussian', 5);
e = tAverr;

plot(x,'o', 'MarkerFaceColor','b')
title('CA1: fog-15%','FontWeight','bold','FontSize',9)
ylabel('Average FR','FontWeight','bold','FontSize',9);
xlabel('Trial #','FontWeight','bold','FontSize',9);

ylim([mn mx])
xlim([0 fr])
xline(15,'r:')

hold on

er = errorbar(1:1:fr,x,e);
er.Color = [0 0 0];
er.LineStyle = 'none';

tAvFr = [];
tAverr = [];
x = [];
e = [];

for k = 1 : fr
    tAvFr(k) = nanmean(fog2FR(:,k))
    tAverr(k) = nanstd(fog2FR(:,k))/sqrt(length(FilteredcellID));
    tAvFr2(k) = nanmean(fog2FR(:,k))
    tAverr(k) = nanstd(fog2FR(:,k))/sqrt(length(FilteredcellID));
end

subplot(1,3,3)
x = smoothdata(tAvFr,'gaussian', 5);
e = tAverr;

plot(x,'o', 'MarkerFaceColor','b')
title('CA1: fog-30%','FontWeight','bold','FontSize',9)
ylabel('Average FR','FontWeight','bold','FontSize',9);
xlabel('Trial #','FontWeight','bold','FontSize',9);

ylim([mn mx])
xlim([0 fr])
xline(15,'r:')

hold on

er = errorbar(1:1:fr,x,e);
er.Color = [0 0 0];
er.LineStyle = 'none';

FilteredcellID = [];
FilteredcellID = [CA1stableID']';
wid = 3;

fog0FR = [];
fog1FR = [];
fog2FR = [];

x0=100;
y0=100;
width=400;
height=130;
set(gcf,'units','points','position',[x0,y0,width,height])
