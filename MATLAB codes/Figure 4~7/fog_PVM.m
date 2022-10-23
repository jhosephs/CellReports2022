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

cd('D:\VR_Headfix_Data_Ephys\raw\Fog_FieldMatrix')

thisRegionSite = [];

for i = 1:length(Indices)
    clusterID = cell2mat(Indices(i));
    findHYPHEN = find((clusterID) == '-');
    thisRID = (clusterID(1, 1:findHYPHEN(1) - 1));
    thisTTID = (clusterID(1, findHYPHEN(2) + 1:findHYPHEN(3) - 1));
    thisCLID = (clusterID(1, findHYPHEN(3) + 1:end));
    thisSID = (clusterID(1, findHYPHEN(1) + 1:findHYPHEN(2) - 1));
    
    stIter = get_regionSite(thisRID, thisTTID);
    
    SI(i) =  (str2double(thisSID));
    fileID = [clusterID];
    load([fileID '.mat'])
    
    thisRegionSite(i) = stIter;
    
    CorStdvsFog(i,1) = StdAmb0R;
    CorStdvsFog(i,2) = StdAmb1R;
    CorStdvsFog(i,3) = StdAmb2R;
    
    CorWithinFog(i,1) = Amb01R;
    CorWithinFog(i,2) = Amb02R;
    CorWithinFog(i,3) = Amb12R;
    
    
    baselineskaggsrateMat(isnan(baselineskaggsrateMat)) = 0;
    amb0skaggsrateMat(isnan(amb0skaggsrateMat)) = 0;
    amb1skaggsrateMat(isnan(amb1skaggsrateMat)) = 0;
    amb2skaggsrateMat(isnan(amb2skaggsrateMat)) = 0;
    
    
    
    stdRM(i,:) = baselineskaggsrateMat(1,1:100)/nanmax([baselineskaggsrateMat(1,1:100)]);
    amb0RM(i,:) = amb0skaggsrateMat(1,1:100)/nanmax([amb0skaggsrateMat(1,1:100)]);
    amb1RM(i,:) = amb1skaggsrateMat(1,1:100)/nanmax([amb1skaggsrateMat(1,1:100)]);
    amb2RM(i,:) = amb2skaggsrateMat(1,1:100)/nanmax([amb2skaggsrateMat(1,1:100)]);

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

%%


CA1Std = stdRM([CA1stb' CA1grp']', 1:100);
CA1fog0= amb0RM([CA1stb' CA1grp']', 1:100);
CA1fog15 = amb1RM([CA1stb' CA1grp']', 1:100);
CA1fog30 = amb2RM([CA1stb' CA1grp']', 1:100);

CA3Std = stdRM([CA3stb' CA3grp']', 1:100);
CA3fog0= amb0RM([CA3stb' CA3grp']', 1:100);
CA3fog15 = amb1RM([CA3stb' CA3grp']', 1:100);
CA3fog30 = amb2RM([CA3stb' CA3grp']', 1:100);


CA1Std(isnan(CA1Std))= 0;
CA1fog0(isnan(CA1fog0))= 0;
CA1fog15(isnan(CA1fog15))= 0;
CA1fog30(isnan(CA1fog30))= 0;

CA3Std(isnan(CA3Std))= 0;
CA3fog0(isnan(CA3fog0))= 0;
CA3fog15(isnan(CA3fog15))= 0;
CA3fog30(isnan(CA3fog30))= 0;


CA1PCstd0 = [];
CA1PCstd1 = [];
CA1PCstd2 = [];

mxbin = 100;

for i= 1 : mxbin
for j = 1 : mxbin
  
    r = corrcoef(CA1Std(:,i) , CA1fog0(:,j));
    CA1PCstd0(i,j) = r(2);
    r = [];
    r = corrcoef(CA1Std(:,i) , CA1fog15(:,j));
    CA1PCstd1(i,j) = r(2);
    r = [];
    r = corrcoef(CA1Std(:,i) , CA1fog30(:,j));
    CA1PCstd2(i,j) = r(2);
    
    end
end


figure();
subplot(1,3,1)
imagesc(CA1PCstd0)

title('std vs 0%')

subplot(1,3,2)
imagesc(CA1PCstd1)

title('std vs 15%')


subplot(1,3,3)
imagesc(CA1PCstd2)

title('std vs 30%')

colormap hot

x0=500;
y0=300;
width=450;
height=300;
set(gcf,'units','points','position',[x0,y0,width,height])





