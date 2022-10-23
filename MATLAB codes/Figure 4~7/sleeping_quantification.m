clear all; clc; close all; fclose all;

% add path

mother_drive = 'D:\VR_Headfix_Data_Ephys';
addpath(genpath([mother_drive '\program\MClust-3.5']));
addpath([mother_drive '\program']);
motherROOT = [mother_drive '\raw'];

if ~exist(motherROOT, 'dir') mkdir (motherROOT); end
saveROOT = [motherROOT '\clusterSleeping']; 
if ~exist(saveROOT) mkdir(saveROOT); end

%Load basic param

cd(motherROOT);
load('sorted_by_bootstrapping_fog.mat')
Indices = [stbCA1_ID' grpCA1_ID' stbCA3_ID' grpCA3_ID']';
cd(saveROOT);

for clRUN =  1 : length(Indices);
    
    clusterID = Indices{clRUN};
    load([clusterID '_sleep.mat'])
    
    if isempty(prepost_r)
        prepost_r = nan;
    end
    
    sleep_r(clRUN) = prepost_r;
  
    prepost_r = [];
end


h1 = histogram(sleep_r);
h1.Normalization = 'probability';
h1.BinWidth = 0.01;
axis([0.7 1.01 0 0.85])

xlabel ('presleep vs. postsleep')
ylabel ('probability') 