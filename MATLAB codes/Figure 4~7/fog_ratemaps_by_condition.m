clc
clear all
close all

mother_drive = 'D:\VR_Headfix_Data_Ephys';

addpath(genpath([mother_drive '\program\MClust-3.5']));
addpath([mother_drive '\program']);
motherROOT = [mother_drive '\raw'];
cd(motherROOT);

load('fog_filtered_by_significanceID.mat')

Indices = [FilteredCA1' FilteredCA3']';

cd('D:\VR_Headfix_Data_Ephys\raw\Fog_FieldMatrix (Filtered_by_HWCriterion)')

thisRegionSite = [];
for i = 1:length(Indices)
    clusterID = cell2mat(Indices(i));
    findHYPHEN = find((clusterID) == '-');
    thisRID = (clusterID(1, 1:findHYPHEN(1) - 1));
    thisTTID = (clusterID(1, findHYPHEN(2) + 1:findHYPHEN(3) - 1));
    thisCLID = (clusterID(1, findHYPHEN(3) + 1:end));
    
    stIter = get_regionSite(thisRID, thisTTID);
    
    fileID = [clusterID];
    load([fileID '.mat'])
    
    stdRM(i,:) = baselineskaggsrateMat(1,1:100)/nanmax([baselineskaggsrateMat(1,1:100)  amb0skaggsrateMat(1,1:100) amb1skaggsrateMat(1,1:100) amb2skaggsrateMat(1,1:100)]);
    amb0RM(i,:) = amb0skaggsrateMat(1,1:100)/nanmax([baselineskaggsrateMat(1,1:100)  amb0skaggsrateMat(1,1:100) amb1skaggsrateMat(1,1:100) amb2skaggsrateMat(1,1:100)]);
    amb1RM(i,:) = amb1skaggsrateMat(1,1:100)/nanmax([baselineskaggsrateMat(1,1:100)  amb0skaggsrateMat(1,1:100) amb1skaggsrateMat(1,1:100) amb2skaggsrateMat(1,1:100)]);
    amb2RM(i,:) = amb2skaggsrateMat(1,1:100)/nanmax([baselineskaggsrateMat(1,1:100)  amb0skaggsrateMat(1,1:100) amb1skaggsrateMat(1,1:100) amb2skaggsrateMat(1,1:100)]);
    
    stdSIS(i,:) = baselineSpaInfoScore;
    amb0SIS(i,:) = amb0SpaInfoScore;
    
    stdFR(i,:) = baselineAvgFR;
    amb0FR(i,:) = amb0AvgFR;
    amb1FR(i,:) = amb1AvgFR;
    amb2FR(i,:) = amb2AvgFR;
    
    baselineAvgFR = [];
    amb0AvgFR = [];
    amb1AvgFR = [];
    amb2AvgFR = [];
    p = [];
    baselineSpaInfoScore = [];
    amb0SpaInfoScore = [];
    baselineskaggsrateMat = [];
    amb0skaggsrateMat = [];
    amb1skaggsrateMat = [];
    amb2skaggsrateMat = [];
    
    StdAmb0R = [];
    StdAmb1R = [];
    StdAmb2R = [];
    StdAmb0RDI = [];
    Amb02RDI = [];
    Amb12RDI = [];
    stIter = [];
    fileID = [];
    clusterID = [];
    findHYPHEN = [];
    thisRID = [];
    thisTTID = [];
    thisCLID = [];
end

stbCA1Std = [];
stbCA1fog0 = [];
stbCA1fog15 = [];
stbCA1fog30 = [];

stbCA3Std = [];
stbCA3fog0 = [];
stbCA3fog15 = [];
stbCA3fog30 = [];

grpCA1Std = [];
grpCA1fog0 = [];
grpCA1fog15 = [];
grpCA1fog30 = [];

stbCA1Std = stdRM(stbCA1, 1:100);
stbCA1fog0= amb0RM(stbCA1, 1:100);
stbCA1fog15 = amb1RM(stbCA1, 1:100);
stbCA1fog30 = amb2RM(stbCA1, 1:100);

grpCA1Std = stdRM(grpCA1, 1:100);
grpCA1fog0= amb0RM(grpCA1, 1:100);
grpCA1fog15 = amb1RM(grpCA1, 1:100);
grpCA1fog30 = amb2RM(grpCA1, 1:100);

stbCA3Std = stdRM(stbCA3, 1:100);
stbCA3fog0= amb0RM(stbCA3, 1:100);
stbCA3fog15 = amb1RM(stbCA3, 1:100);
stbCA3fog30 = amb2RM(stbCA3, 1:100);

VcxStd = stdRM(1:length(FilteredV2), 1:100);
Vcxfog0= amb0RM(1:length(FilteredV2), 1:100);
Vcxfog15 = amb1RM(1:length(FilteredV2), 1:100);
Vcxfog30 = amb2RM(1:length(FilteredV2), 1:100);


stbCA1MaxPeakIndex = [];
stbCA1MaxPeakPosition = [];
grpCA1MaxPeakIndex = [];
grpCA1MaxPeakPosition = [];
stbCA3MaxPeakIndex = [];
stbCA3MaxPeakPosition = [];

i = [];
for i=1:length(stbCA1);
[stbCA1MaxPeakPosition(i) stbCA1MaxPeakIndex(i)] = max(stbCA1Std(i,:)); 
end

i = [];
for i=1:length(grpCA1);
[grpCA1MaxPeakPosition(i) grpCA1MaxPeakIndex(i)] = max(grpCA1Std(i,:)); 
end

i = [];
for i=1:length(stbCA3);
[stbCA3MaxPeakPosition(i) stbCA3MaxPeakIndex(i)] = max(stbCA3Std(i,:)); 
end

stbCA1_StdSorted = [];
stbCA3_StdSorted = [];
grpCA1_StdSorted = [];

stbCA1_fog0Sorted = [];
stbCA3_fog0Sorted = [];
grpCA1_fog0Sorted = [];

stbCA1_fog15Sorted = [];
stbCA3_fog15Sorted = [];
grpCA1_fog15Sorted = [];

stbCA1_fog30Sorted = [];
stbCA3_fog30Sorted = [];
grpCA1_fog30Sorted = [];


[CA1SortedIndex ACA1idx] = sort(stbCA1MaxPeakIndex , 'ascend');
stbCA1_StdSorted = stbCA1Std(ACA1idx,:);
stbCA1_fog0Sorted = stbCA1fog0(ACA1idx,:);
stbCA1_fog15Sorted = stbCA1fog15(ACA1idx,:);
stbCA1_fog30Sorted = stbCA1fog30(ACA1idx,:);

[CA3SortedIndex ACA3idx] = sort(stbCA3MaxPeakIndex , 'ascend');
stbCA3_StdSorted = stbCA3Std(ACA3idx,:);
stbCA3_fog0Sorted = stbCA3fog0(ACA3idx,:);
stbCA3_fog15Sorted = stbCA3fog15(ACA3idx,:);
stbCA3_fog30Sorted = stbCA3fog30(ACA3idx,:);

[grpCA1SortedIndex GCA1idx] = sort(grpCA1MaxPeakIndex , 'ascend');
grpCA1_StdSorted = grpCA1Std(GCA1idx,:);
grpCA1_fog0Sorted = grpCA1fog0(GCA1idx,:);
grpCA1_fog15Sorted = grpCA1fog15(GCA1idx,:);
grpCA1_fog30Sorted = grpCA1fog30(GCA1idx,:);

[pgrpCA1SortedIndex PCA1idx] = sort(pgrpCA1MaxPeakIndex, 'ascend');
pgrpCA1_StdSorted = grpCA1Std(PCA1idx,:);
pgrpCA1_fog0Sorted = grpCA1fog0(PCA1idx,:);
pgrpCA1_fog15Sorted = grpCA1fog15(PCA1idx,:);
pgrpCA1_fog30Sorted = grpCA1fog30(PCA1idx,:);

mx = 3;
subplot(4,4,1)
imagesc(smoothdata(stbCA1_StdSorted,'Movmean',mx))
title('stbCA1: pre-fog')
xlim([0 100])

subplot(4,4,2)
imagesc(smoothdata(stbCA1_fog0Sorted,'Movmean',mx))
title('stbCA1: fog-0%')
xlim([0 100])

subplot(4,4,3)
imagesc(smoothdata(stbCA1_fog15Sorted,'Movmean',mx))
title('stbCA1: fog-15%')
xlim([0 100])

subplot(4,4,4)
imagesc(smoothdata(stbCA1_fog30Sorted,'Movmean',mx))
title('stbCA1: fog-30%')
xlim([0 100])

subplot(4,4,5)
imagesc(smoothdata(stbCA3_StdSorted,'Movmean',mx))
title('CA3: pre-fog')
xlim([0 100])

subplot(4,4,6)
imagesc(smoothdata(stbCA3_fog0Sorted,'Movmean',mx))
title('CA3: fog-0%')
xlim([0 100])

subplot(4,4,7)
imagesc(smoothdata(stbCA3_fog15Sorted,'Movmean',mx))
title('CA3: fog-15%')
xlim([0 100])

subplot(4,4,8)
imagesc(smoothdata(stbCA3_fog30Sorted,'Movmean',mx))
title('CA3: fog-30%')
xlim([0 100])

subplot(4,4,9)
imagesc(smoothdata(grpCA1_StdSorted,'Movmean',mx))
title('grpCA1: pre-fog')
xlim([0 100])

subplot(4,4,10)
imagesc(smoothdata(grpCA1_fog0Sorted,'Movmean',mx))
title('grpCA1: fog-0%')
xlim([0 100])

subplot(4,4,11)
imagesc(smoothdata(grpCA1_fog15Sorted,'Movmean',mx))
title('grpCA1: fog-15%')
xlim([0 100])

subplot(4,4,12)
imagesc(smoothdata(grpCA1_fog30Sorted,'Movmean',mx))
title('grpCA1: fog-30%')
xlim([0 100])

subplot(4,4,13)
imagesc(smoothdata(pgrpCA1_StdSorted,'Movmean',mx))
title('grpCA1: pre-fog')
xlim([0 100])

subplot(4,4,14)
imagesc(smoothdata(pgrpCA1_fog0Sorted,'Movmean',mx))
title('grpCA1: fog-0%')
xlim([0 100])

subplot(4,4,15)
imagesc(smoothdata(pgrpCA1_fog15Sorted,'Movmean',mx))
title('grpCA1: fog-15%')
xlim([0 100])

subplot(4,4,16)
imagesc(smoothdata(pgrpCA1_fog30Sorted,'Movmean',mx))
title('grpCA1: fog-30%')
xlim([0 100])

colormap jet

x0=500;
y0=250;
width=380;
height=505;
set(gcf,'units','points','position',[x0,y0,width,height])