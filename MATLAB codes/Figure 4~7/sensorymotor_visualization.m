clear all; clc; close all; fclose all;

% add path

mother_drive = 'D:\VR_Headfix_Data_Ephys';
addpath(genpath([mother_drive '\program\MClust-3.5']));
addpath([mother_drive '\program']); 
motherROOT = [mother_drive '\raw'];
cd(motherROOT);

load ('sensory_gain.mat');
Indices = [];
Indices = convertStringsToChars(TotalSampled); 
regionStr = {'CA1', 'CA3a', 'CA3b', 'CA3c', 'DG', 'V1', 'V2', 'etc'}; 
cd('D:\VR_Headfix_Data_Ephys\raw\sensory_gain_results')

thisRegionSite = [];
for i = 1:length(Indices)
    clusterID = cell2mat(Indices(i));
    findHYPHEN = find((clusterID) == '-');
    thisRID = (clusterID(1, 1:findHYPHEN(1) - 1));
    thisTTID = (clusterID(1, findHYPHEN(2) + 1:findHYPHEN(3) - 1));
    thisCLID = (clusterID(1, findHYPHEN(3) + 1:end));
    stIter = get_regionSite(thisRID, thisTTID);
    thisSID = (clusterID(1, findHYPHEN(1) + 1:findHYPHEN(2) - 1));
    
    if str2double(thisCLID) < 10
        zero_filter = nonzeros(thisCLID);
        thisCLID = zero_filter(2);
    end
    
    fileID = [thisRID '-' thisSID '-' thisTTID '-' thisCLID];
    load([fileID '_sensoryGain.mat'])
    
    
    ForestStdSIS(i) = ForeststdSpaInfoScore;
    ForestStdAvFR(i) = ForeststdAvgFR;
    
    ForestGain2xSIS(i) = ForestGain2xSpaInfoScore;
    ForestGain2xAvFR(i) = ForestGain2xAvgFR;
    
    CityStdSIS(i) = CitystdSpaInfoScore;
    CityStdAvFR(i) = CitystdAvgFR;
    
    CityGain2xSIS(i) = CityGain2xSpaInfoScore;
    CityGain2xAvFR(i) = CityGain2xAvgFR;
    
    Forestp(i) = ForestR;
    Cityp(i) = CityR;
    
    ForestDelta(i,1) = ForestDelta1;
    ForestDelta(i,2) = ForestDelta2;
    
    CityDelta(i,1) = CityDelta1;
    CityDelta(i,2) = CityDelta2;
    
    thisRegionSite(i) = stIter;
    
    ForestStdcent(i,1) = ForestStdcent1;
    ForestStdcent(i,2) = ForestStdcent2;
    
    ForestGain2xcent(i,1) = ForestGain2xcent1;
    ForestGain2xcent(i,2) = ForestGain2xcent2;
    
    
    CityStdcent(i,1) = CityStdcent1;
    CityStdcent(i,2) = CityStdcent2;
    
    CityGain2xcent(i,1) = CityGain2xcent1;
    CityGain2xcent(i,2) = CityGain2xcent2;
    
    ForeststdSpaInfoScore = [];
    ForeststdAvgFR = [];
    ForestGain2xSpaInfoScore = [];
    ForestGain2xAvgFR = [];
    CitystdSpaInfoScore = [];
    CitystdAvgFR = [];
    CityGain2xSpaInfoScore = [];
    CityGain2xAvgFR = [];
    ForestR = [];
    CityR = [];
    stIter = [];
    ForestDelta1 = [];
    ForestDelta2 = [];
    CityDelta1 = [];
    CityDelta2 = [];
    
end

minSI = 0.1;

CA1Forestidx =  intersect([1:102],find(ForestStdSIS >= minSI & ForestStdAvFR >= 0.5));
CA3Forestidx =  intersect([103:156],find(ForestStdSIS >= minSI & ForestStdAvFR >= 0.5));

CA1Forestidx = intersect(CA1Forestidx, find(ForestStdAvFR <= 6));
CA3Forestidx = intersect(CA3Forestidx, find(ForestStdAvFR <= 6));

CA1ForestGain2xidx =  intersect([1:102],find(ForestGain2xSIS >= minSI & ForestGain2xAvFR >= 0.5));
CA3ForestGain2xidx =  intersect([103:156],find(ForestGain2xSIS >= minSI & ForestGain2xAvFR >= 0.5));

CA1ForestGain2xidx = intersect(CA1ForestGain2xidx, find(ForestStdAvFR <= 6 & ForestGain2xAvFR <= 6));
CA3ForestGain2xidx = intersect(CA3ForestGain2xidx, find(ForestStdAvFR <= 6 & ForestGain2xAvFR <= 6));

CA1Forestidx = unique([CA1ForestGain2xidx CA1Forestidx]);
CA3Forestidx = unique([CA3ForestGain2xidx CA3Forestidx]);

CA1Cityidx =  intersect([1:102],find(CityStdSIS >= minSI & CityStdAvFR >= 0.5));
CA3Cityidx =  intersect([103:156],find(CityStdSIS >= minSI & CityStdAvFR >= 0.5));
vcxCityidx =  intersect([157:180],find(CityStdSIS > 0.04 & CityStdAvFR >= 0.5));

CA1Cityidx = intersect(CA1Cityidx, find(CityStdAvFR <= 6));
CA3Cityidx = intersect(CA3Cityidx, find(CityStdAvFR <= 6));

CA1CityGain2xidx =  intersect([1:102],find(CityGain2xSIS >= minSI & CityGain2xAvFR >= 0.5));
CA3CityGain2xidx =  intersect([103:156],find(CityGain2xSIS >= minSI & CityGain2xAvFR >= 0.5));

CA1CityGain2xidx = intersect(CA1CityGain2xidx, find(CityStdAvFR <= 6 & CityGain2xAvFR <= 6));
CA3CityGain2xidx = intersect(CA3CityGain2xidx, find(CityStdAvFR <= 6 & CityGain2xAvFR <= 6));

CA1Cityidx = unique([CA1CityGain2xidx CA1Cityidx]);
CA3Cityidx = unique([CA3CityGain2xidx CA3Cityidx]);


subplot(1,2,1)

h = histogram([Forestp(CA1Forestidx) Cityp(CA1Cityidx)],'Normalization','probability');
h.BinWidth = 0.05;
xlim([-0.5 1])
ylim([0 0.75])
xlabel 'baseline vs. 2x gain'
ylabel 'probability'
title 'CA1'

subplot(1,2,2)

h = histogram([Forestp(CA3Forestidx) Cityp(CA3Cityidx)],'Normalization','probability');
h.BinWidth = 0.05;

xlabel 'baseline vs. 2x gain'
ylabel 'probability'
xlim([-0.5 1])
ylim([0 0.75])
title 'CA3'

figure();

subplot(1,2,1)
scatter(ForestStdcent(CA1Forestidx,1), ForestGain2xcent(CA1Forestidx,1),'bo')
hold on 
scatter(CityStdcent(CA1Cityidx,1), CityGain2xcent(CA1Cityidx,1),'bo')
hold on 
scatter(ForestStdcent(CA1Forestidx,2), ForestGain2xcent(CA1Forestidx,2),'bo')
hold on 
scatter(CityStdcent(CA1Cityidx,2), CityGain2xcent(CA1Cityidx,2),'bo')

subplot(1,2,2)

scatter(ForestStdcent(CA3Forestidx,1), ForestGain2xcent(CA3Forestidx,1),'ro')
hold on 
scatter(CityStdcent(CA3Cityidx,1), CityGain2xcent(CA3Cityidx,1),'ro')
hold on 
scatter(ForestStdcent(CA3Forestidx,2), ForestGain2xcent(CA3Forestidx,2),'ro')
hold on 
scatter(CityStdcent(CA3Cityidx,2), CityGain2xcent(CA3Cityidx,2),'ro')

[f,x] = ecdf([Forestp(CA1Forestidx) Cityp(CA1Cityidx)]);     
plot(x,f,'LineWidth',1.5)


[p,h,stats] = signrank([ForestStdcent(CA1Forestidx,1)' CityStdcent(CA1Cityidx,1)' ForestStdcent(CA1Forestidx,2)' CityStdcent(CA1Cityidx,2)'], [ ForestGain2xcent(CA1Forestidx,1)' CityGain2xcent(CA1Cityidx,1)'  ForestGain2xcent(CA1Forestidx,2)' CityGain2xcent(CA1Cityidx,2)'])
[p,h,stats] = signrank([ForestStdcent(CA3Forestidx,1)' CityStdcent(CA3Cityidx,1)' ForestStdcent(CA3Forestidx,2)' CityStdcent(CA3Cityidx,2)'], [ ForestGain2xcent(CA3Forestidx,1)' CityGain2xcent(CA3Cityidx,1)'  ForestGain2xcent(CA3Forestidx,2)' CityGain2xcent(CA3Cityidx,2)'])

