clc;
clear all;
close all;

% File directory
mother_drive = 'D:\VR_Headfix_Data_Ephys';

addpath(genpath([mother_drive '\program\MClust-3.5']));
addpath([mother_drive '\program']);
motherROOT = [mother_drive '\raw'];
motherROOT = 'D:\VR_Headfix_Data_Ephys\raw';

thisRID = %rat #
thisSID = %session #
thisTTID = % TT #
thisCLID = % Cluster # 

UEtoNlxEvent = ([motherROOT '\Rat' thisRID '\Rat' thisRID '_' thisSID '\Events.csv']);

filename = [UEtoNlxEvent];
delimiter = ',';
startRow = 2;
formatSpec = '%*s%*s%*s%f%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');

fclose(fileID);

Events = table(dataArray{1:end-1}, 'VariableNames', {'Timestamp','Event'});
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

Timestamp = Events{:, 1};
Event = Events{:, 2};

str1 = 'TTL Input on AcqSystem1_0 board 0 port 2 value (0x0010).';
str2 = 'TTL Input on AcqSystem1_0 board 0 port 2 value (0x0040).';
str3 = 'TTL Input on AcqSystem1_0 board 0 port 3 value (0x0004).';
str4 = 'TTL Input on AcqSystem1_0 board 0 port 3 value (0x0008).';
str5 = 'TTL Input on AcqSystem1_0 board 0 port 2 value (0x0050).';

TTL1 = find(strcmp(Event, str1));
TTL2 = find(strcmp(Event, str2));
TTL3 = find(strcmp(Event, str3));
TTL4 = find(strcmp(Event, str4));
TTL5 = find(strcmp(Event, str5));


TTL1Time = Timestamp(TTL1);
TTL2Time = Timestamp(TTL2);
TTL3Time = Timestamp(TTL3);
TTL4Time = Timestamp(TTL4);
TTL5Time = Timestamp(TTL5);

TTL1TimeT = (((TTL1Time-min(TTL1Time)))./1000000);

 %Import cluster data

WinClusterID =([motherROOT '\rat' thisRID '\rat' thisRID '_' thisSID '\TT' thisTTID '\T' thisTTID '.' thisCLID]);
delimiter = ',';
startRow = 14;
formatSpec = '%f%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%f%[^\n\r]';
fileID = fopen(WinClusterID,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
SpikeIndex = dataArray{:, 1};
SpikeTime = dataArray{:, 2};

%Importing behavior data

UnrealFile =([motherROOT '\Rat' thisRID '\Rat' thisRID '_' thisSID '\Rat' thisRID '_' thisSID '.csv']);
delimiter = ',';
formatSpec = '%s%f%*s%f%[^\n\r]';
fileID = fopen(UnrealFile,'r');

dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN, 'ReturnOnError', false);

fclose(fileID);

X = dataArray{:, 1};
Time = dataArray{:, 2};
Position = dataArray{:, 3};
RewardEvent = 'Reward';
Position([1:end])=((Position(1:end))./20);

clearvars filename delimiter formatSpec fileID dataArray ans;


Position(Position<0) = 0;
Filtered = ~isnan(Position);
FilteredPositionIndex = find(Filtered==1);
FilteredTime = Time(FilteredPositionIndex);
FilteredPosition = Position(FilteredPositionIndex);

for n=1:(length(FilteredPosition)-1)
    
    Teleport(n) = (FilteredPosition(n)-FilteredPosition(n+1))>50;
    Reset(n+1) = (FilteredPosition(n)-FilteredPosition(n+1))>25;
    ttt(n+1) =     abs(FilteredPosition(n)-FilteredPosition(n+1))>150;
end

Teleport = find(Teleport==1);
Reset = find(Reset==1);
ttt = find(ttt==1);

load('session_config.mat')

configStr = {'configA', 'configB', 'configC', 'configD', 'configE', 'configF', 'configH'};

stIter = get_sessionType(thisRID, thisSID);
stIter = get_config_type(thisRID, thisSID);
thisconfigType = configStr{stIter};

%Cumulative distance

ForestAnimalIndices = find(FilteredPosition<500);
CityAnimalIndices = find(FilteredPosition>500 & FilteredPosition<1000);

for i=2:length(ForestAnimalIndices)
    ForestIndiceDifference(i) = (ForestAnimalIndices(i)) - (ForestAnimalIndices(i-1));
end

for i=2:length(CityAnimalIndices)
    CityIndiceDifference(i) = (CityAnimalIndices(i)) - (CityAnimalIndices(i-1));
end

if isempty(ForestAnimalIndices)
    ForestTrialEndIndiceMarker = 0;
    ForestIndiceDifference = nan;
    ForestStartIndex = nan;
    
else
    ForestTrialEndIndiceMarker = (find(ForestIndiceDifference > 1)-1);
    ForestTrialEndIndiceMarker = ForestAnimalIndices(ForestTrialEndIndiceMarker);
    ForestTrialEndIndiceMarker = [(ForestTrialEndIndiceMarker)'  ForestAnimalIndices(end)];
end

if isempty(CityAnimalIndices)
    CityTrialEndIndiceMarker = 0;
    CityIndiceDifference = nan;
    CityStartIndex = nan;
else
    CityTrialEndIndiceMarker = (find(CityIndiceDifference > 1)-1);
    CityTrialEndIndiceMarker = CityAnimalIndices(CityTrialEndIndiceMarker);
    CityTrialEndIndiceMarker = [(CityTrialEndIndiceMarker)'  CityAnimalIndices(end)];
end


for k=2:length(FilteredPosition);
    Distance(k)= abs(FilteredPosition(k)-FilteredPosition(k-1));
end


Reset = Reset(2:length(Reset));


for n=1:length(Reset);
    if (FilteredPosition(Reset(n))>450);
        CityStartIndex(n) = Reset(n);
    else
        ForestStartIndex(n) = Reset(n);
    end
end

Distance = Distance(2:end);
Distance(abs(Distance)>70) = 0;
Distance(CityTrialEndIndiceMarker+1) = 0;

Cycle= find(Teleport==1);
ResetIndices = find(Reset==1);
CycleTime=Time(Cycle);

ForestStartIndex(ForestStartIndex==0)=[];
CityStartIndex(CityStartIndex==0)=[];

ITIEndIndex = [Teleport(1:length(Teleport)) ttt(length(ttt))-1];
ITIStartIndex = sort([ForestTrialEndIndiceMarker CityTrialEndIndiceMarker]);
ITIStartIndex = [(ITIStartIndex(1:length(ITIStartIndex)-1))+1 ttt(length(ttt)-1)];

for k=1:length(Distance);
    CumulativeDistance(k) = sum(Distance(1:k));
end

CumulativeDistance = [0 , CumulativeDistance];

for n=2:length(CumulativeDistance);
    Instantenous_velocity(n-1) = (((CumulativeDistance(n) - CumulativeDistance(n-1)))) ;
end

Instantenous_velocity = [ 0 Instantenous_velocity ];

Moving_window = 15;
Smoothed_velocity = movmean(Instantenous_velocity,Moving_window);
Smoothed_velocity = Smoothed_velocity.*30;

Velocity_FilterIndex = find(Smoothed_velocity>=5);
Rest_FilterIndex = find(Smoothed_velocity<5);

FSpikeTime = interp1(TTL1Time, TTL1Time, SpikeTime, 'nearest');

if CityTrialEndIndiceMarker == 0
    for i = 1:length(FilteredPosition)
        if  FilteredPosition(i) > 999
            FilteredPosition (i) = FilteredPosition (i) - 500;
        else
            FilteredPosition(i) = FilteredPosition (i);
        end
    end
end
    
if ForestTrialEndIndiceMarker == 0 
FilteredPosition = FilteredPosition - 500;
end
  

for k = 2:1:length(ITIEndIndex);
    
cFilteredTime(ITIEndIndex(k-1)+1:ITIEndIndex(k)) = k; 
cFilteredPosition(ITIEndIndex(k-1)+1:ITIEndIndex(k)) = FilteredPosition(ITIEndIndex(k-1)+1:ITIEndIndex(k));
end
    
cFilteredTime(Teleport(1): ITIEndIndex(1)) = 1;
csFilteredTime = cFilteredTime;

% Filtering

Filtered_TTL1Time = TTL1Time(Velocity_FilterIndex);
aVelocity_FilterIndex = Velocity_FilterIndex;
aVelocity_FilterIndex(aVelocity_FilterIndex > length(cFilteredTime)) = [];

cFilteredTime = cFilteredTime(aVelocity_FilterIndex);
[SpikeTime,pos]=intersect(Filtered_TTL1Time, FSpikeTime);
cSpikeTime = cFilteredTime(pos);

% Spike-Position parsing

FilteredPosition(Rest_FilterIndex) = nan;
TTL1TimeT(Rest_FilterIndex) = nan;
AFilteredPosition = FilteredPosition;

[NaNIndex, col] = find(isnan(AFilteredPosition));
AFilteredPosition = AFilteredPosition(~isnan(AFilteredPosition));

SpikePosition = interp1(Filtered_TTL1Time, AFilteredPosition, SpikeTime, 'nearest');
SpikeTimeT = (((SpikeTime-min(TTL1Time)))./1000000);
Frequency = length(SpikeTime)/max(TTL1TimeT);
SpikeData = [SpikeTime, SpikePosition];

SpikeCell = cell(2,length(ITIEndIndex)-1);
UnrealCell = cell(2,length(ITIEndIndex)-1);

for n=1:length(ITIEndIndex)-1
    
    SpikeFilter = (TTL1TimeT(ITIEndIndex(n)+1)<SpikeTimeT & TTL1TimeT(ITIEndIndex(n+1))>SpikeTimeT);
    SpikeFilter = find(SpikeFilter==1); 
    
SpikeCell{1,n} = cSpikeTime(SpikeFilter)';
SpikeCell{2,n} = SpikePosition(SpikeFilter);

UnrealCell{2,n} = cFilteredPosition((ITIEndIndex(n)+1):ITIEndIndex(n+1))';
UnrealCell{1,n} = csFilteredTime((ITIEndIndex(n)+1):ITIEndIndex(n+1))';

end

totalTime = vertcat(UnrealCell{1, [stdTrial amb0Trial amb1Trial amb2Trial]});
totalPosition = vertcat(UnrealCell{2, [stdTrial amb0Trial amb1Trial amb2Trial]});

totalSpikeTime = vertcat(SpikeCell{1, [stdTrial amb0Trial amb1Trial amb2Trial]});
totalSpikePosition = vertcat(SpikeCell{2, [stdTrial amb0Trial amb1Trial amb2Trial]});

%%%%

stdTrialTime = vertcat(UnrealCell{1, stdTrial});
stdTrialPosition = vertcat(UnrealCell{2, stdTrial});

stdTrialSpikeTime = vertcat(SpikeCell{1, stdTrial});
stdTrialSpikePosition = vertcat(SpikeCell{2, stdTrial});

amb0TrialTime = vertcat(UnrealCell{1, amb0Trial});
amb0TrialPosition = vertcat(UnrealCell{2, amb0Trial});

amb0TrialSpikeTime = vertcat(SpikeCell{1, amb0Trial});
amb0TrialSpikePosition = vertcat(SpikeCell{2, amb0Trial});

amb1TrialTime = vertcat(UnrealCell{1, amb1Trial});
amb1TrialPosition = vertcat(UnrealCell{2, amb1Trial});

amb1TrialSpikeTime = vertcat(SpikeCell{1, amb1Trial});
amb1TrialSpikePosition = vertcat(SpikeCell{2, amb1Trial});

amb2TrialTime = vertcat(UnrealCell{1, amb2Trial});
amb2TrialPosition = vertcat(UnrealCell{2, amb2Trial});

amb2TrialSpikeTime = vertcat(SpikeCell{1, amb2Trial});
amb2TrialSpikePosition = vertcat(SpikeCell{2, amb2Trial});

mod = 3; % Bin size

XsizeOfVideo = 600;
YsizeOfVideo = 200;
samplingRate = 30;
scaleForRateMap = 5;

binXForRateMap = XsizeOfVideo / scaleForRateMap;
binYForRateMap = YsizeOfVideo / scaleForRateMap;

% std

SpikePositionY = ones(length(stdTrialSpikePosition),1);
FilteredPositionY = ones(length(stdTrialPosition), 1);

if isempty(stdTrialSpikePosition)
    stdoccMat(1:40, 1:115) = 0;
    stdspkMat(1:40, 1:115) = 0;
    stdrawMat(1:40, 1:115) = nan;
    stdskaggsrateMat(1:40, 1:115) = nan;
    stdSpaInfoScore = 0;
    stdMaxFR = 0;
    stdAvgFR = 0;
    stdnumOfSpk = 0;
    RawstdAvFR=0;
    
else
    [stdoccMat, stdspkMat, stdrawMat, stdskaggsrateMat] = abmFiringRateMap( ...
        [stdTrialSpikeTime, stdTrialSpikePosition, SpikePositionY],...
        [stdTrialTime, stdTrialPosition, FilteredPositionY],...
        binYForRateMap, binXForRateMap, scaleForRateMap, samplingRate);
    stdSpaInfoScore = GetSpaInfo(stdoccMat, stdskaggsrateMat);
    stdMaxFR = nanmax(nanmax(stdskaggsrateMat));
    stdAvgFR = nanmean(nanmean(stdskaggsrateMat));
    stdnumOfSpk = length(stdTrialSpikeTime);
    RawstdAvFR = nanmean(nanmean(stdrawMat));
end

if length(stdTrialSpikeTime) < 30
    stdSpaInfoScore = -1;
    
end

if stdSpaInfoScore < 0.05 | RawstdAvFR <0.05
    stdArray(1:((575/(500/(300/mod))))) = 0;
end


SpikePositionY = [];
FilteredPositionY = [];


% amb0

SpikePositionY = ones(length(amb0TrialSpikePosition),1);
FilteredPositionY = ones(length(amb0TrialPosition), 1);

if isempty(amb0TrialSpikePosition)
    amb0occMat(1:40, 1:115) = 0;
    amb0spkMat(1:40, 1:115) = 0;
    amb0rawMat(1:40, 1:115) = nan;
    amb0skaggsrateMat(1:40, 1:115) = nan;
    amb0SpaInfoScore = 0;
    amb0MaxFR = 0;
    amb0AvgFR = 0;
    amb0numOfSpk = 0;
    Rawamb0AvFR = 0;
else
    [amb0occMat, amb0spkMat,  amb0rawMat, amb0skaggsrateMat] = abmFiringRateMap( ...
        [amb0TrialSpikeTime, amb0TrialSpikePosition, SpikePositionY],...
        [amb0TrialTime, amb0TrialPosition, FilteredPositionY],...
        binYForRateMap, binXForRateMap, scaleForRateMap, samplingRate);
    amb0SpaInfoScore = GetSpaInfo(amb0occMat, amb0skaggsrateMat);
    amb0MaxFR = nanmax(nanmax(amb0skaggsrateMat));
    amb0AvgFR = nanmean(nanmean(amb0skaggsrateMat));
    amb0numOfSpk = length(amb0TrialSpikeTime);
    Rawamb0AvFR = nanmean(nanmean(amb0rawMat));
    
end

if length(amb0TrialSpikeTime) < 30
    amb0SpaInfoScore = -1;
    
end

if amb0SpaInfoScore < 0.05 | Rawamb0AvFR <0.05
    amb0Array(1:((575/(500/(300/mod))))) = 0;
end

SpikePositionY = [];
FilteredPositionY = [];

% amb1

SpikePositionY = ones(length(amb1TrialSpikePosition),1);
FilteredPositionY = ones(length(amb1TrialPosition), 1);

if isempty(amb1TrialSpikePosition)
    amb1occMat(1:40, 1:115) = 0;
    amb1spkMat(1:40, 1:115) = 0;
    amb1rawMat(1:40, 1:115) = nan;
    amb1skaggsrateMat(1:40, 1:115) = nan;
    amb1SpaInfoScore = 0;
    amb1MaxFR = 0;
    amb1AvgFR = 0;
    amb1numOfSpk = 0;
    Rawamb1AvFR = 0;
else
    [amb1occMat, amb1spkMat,  amb1rawMat, amb1skaggsrateMat] = abmFiringRateMap( ...
        [amb1TrialSpikeTime, amb1TrialSpikePosition, SpikePositionY],...
        [amb1TrialTime, amb1TrialPosition, FilteredPositionY],...
        binYForRateMap, binXForRateMap, scaleForRateMap, samplingRate);
    amb1SpaInfoScore = GetSpaInfo(amb1occMat, amb1skaggsrateMat);
    amb1MaxFR = nanmax(nanmax(amb1skaggsrateMat));
    amb1AvgFR = nanmean(nanmean(amb1skaggsrateMat));
    amb1numOfSpk = length(amb1TrialSpikeTime);
    Rawamb1AvFR = nanmean(nanmean(amb1rawMat));
    
end

if length(amb1TrialSpikeTime) < 30
    amb1SpaInfoScore = -1;
    
end

if amb1SpaInfoScore < 0.05 | Rawamb1AvFR <0.05
    amb1Array(1:((575/(500/(300/mod))))) = 0;
end

SpikePositionY = [];
FilteredPositionY = [];

% amb2

SpikePositionY = ones(length(amb2TrialSpikePosition),1);
FilteredPositionY = ones(length(amb2TrialPosition), 1);

if isempty(amb2TrialSpikePosition)
    amb2occMat(1:40, 1:115) = 0;
    amb2spkMat(1:40, 1:115) = 0;
    amb2rawMat(1:40, 1:115) = nan;
    amb2skaggsrateMat(1:40, 1:115) = nan;
    amb2SpaInfoScore = 0;
    amb2MaxFR = 0;
    amb2AvgFR = 0;
    amb2numOfSpk = 0;
    Rawamb2AvFR = 0;
    
else
    [amb2occMat, amb2spkMat,  amb2rawMat, amb2skaggsrateMat] = abmFiringRateMap( ...
        [amb2TrialSpikeTime, amb2TrialSpikePosition, SpikePositionY],...
        [amb2TrialTime, amb2TrialPosition, FilteredPositionY],...
        binYForRateMap, binXForRateMap, scaleForRateMap, samplingRate);
    amb2SpaInfoScore = GetSpaInfo(amb2occMat, amb2skaggsrateMat);
    amb2MaxFR = nanmax(nanmax(amb2skaggsrateMat));
    amb2AvgFR = nanmean(nanmean(amb2skaggsrateMat));
    amb2numOfSpk = length(amb2TrialSpikeTime);
    Rawamb2AvFR = nanmean(nanmean(amb2rawMat));
end

if length(amb2TrialSpikeTime) < 30
    amb2SpaInfoScore = -1;
    
end

if amb2SpaInfoScore < 0.05 | Rawamb2AvFR <0.05
    amb2Array(1:((575/(500/(300/mod))))) = 0;
end


stdSkewness = [];
amb0Skewness = [];
amb1Skewness = [];
amb2Skewness = [];

stdSecondSkewness = [];
amb0SecondSkewness = [];
amb1SecondSkewness = [];
amb2SecondSkewness = [];

stdArray = stdrawMat(1,1:115);
amb0Array = amb0rawMat(1,1:115);
amb1Array = amb1rawMat(1,1:115);
amb2Array = amb2rawMat(1,1:115);

stdArrayforSkewness = round(stdArray*1000);
amb0ArrayforSkewness = round(amb0Array*1000);
amb1ArrayforSkewness = round(amb1Array*1000);
amb2ArrayforSkewness = round(amb2Array*1000);

RawstdMaxFR = nanmax(stdArray);
Rawamb0MaxFR = nanmax(amb0Array);
Rawamb1MaxFR = nanmax(amb1Array);
Rawamb2MaxFR = nanmax(amb2Array);

StdAmbRDI =  abs((RawstdAvFR-Rawamb0AvFR))/(RawstdAvFR+Rawamb0AvFR); % Selecitity index has been adjusted to RMI 
Amb01RDI =  abs((Rawamb1AvFR-Rawamb0AvFR))/(Rawamb1AvFR+Rawamb0AvFR); 
Amb02RDI =  abs((Rawamb2AvFR-Rawamb0AvFR))/(Rawamb2AvFR+Rawamb0AvFR); 
NormRD = [Rawamb0AvFR/RawstdAvFR Rawamb1AvFR/RawstdAvFR Rawamb2AvFR/RawstdAvFR];

stdArray = stdrawMat(1,1:115);
amb0Array = amb0rawMat(1,1:115);
amb1Array = amb1rawMat(1,1:115);
amb2Array = amb2rawMat(1,1:115);

RawStdMaxFR = nanmax(stdArray);
RawAmb0MaxFR = nanmax(amb0Array);
Range = nanmax([stdSArray amb0SArray]);

figure(1);
subplot(2,2,1)
set(gcf,'renderer','Painters')
xlabel('Position (cm)','FontWeight','bold','FontSize',9);
ylabel('Time (s)','FontWeight','bold','FontSize',9);
hold on
plot((totalSpikePosition./5*3),(totalSpikeTime), 'MarkerSize',4,'Marker','.','LineWidth',2,'LineStyle','none',...
    'Color',[0.4 0.4 0.4]);
hold on
plot((amb0TrialSpikePosition./5*3),(amb0TrialSpikeTime), 'MarkerSize',4,'Marker','.','LineWidth',2,'LineStyle','none',...
    'Color',[1 0 0]);
hold on
plot((stdTrialSpikePosition./5*3),(stdTrialSpikeTime), 'MarkerSize',4,'Marker','.','LineWidth',2,'LineStyle','none',...
    'Color',[0 0 0]);
set(gca,'YDir','reverse');
axis([0 348 0 csFilteredTime(end)*1]);

subplot(2,2,2)
imagesc(stdSArray)
Array = stdSArray;
thisAlphaZ = Array;
thisAlphaZ(isnan(Array)) = 0;
thisAlphaZ(~isnan(Array)) = 1;
hold on
alpha(thisAlphaZ);axis off;
j=1;
minmaxColor = get(gca, 'CLim');
if minmaxColor(1) == -1 && minmaxColor(2) == 1
    minmaxColor(2)=0.1;
end
maxColor(j) = minmaxColor(2);
j=j+1;
hold on
MAXcolor=max(maxColor);
if MAXcolor<1
    MAXcolor=1;
end

set(gca,'CLim', [0 maxColor(1)]);
caxis([0 Range])

subplot(2,2,3)

plot(stdSArray,'Marker','none','LineWidth',2, 'Color',[0 0 0]);
hold on
plot(amb0SArray,'Marker','none','LineWidth',2, 'Color',[1 0 0])

subplot(2,2,4)

imagesc(amb0SArray)
colormap jet

Array = amb0SArray;

thisAlphaZ = Array;
thisAlphaZ(isnan(Array)) = 0;
thisAlphaZ(~isnan(Array)) = 1;
hold on

alpha(thisAlphaZ);axis off;
j=1;
minmaxColor = get(gca, 'CLim');
if minmaxColor(1) == -1 && minmaxColor(2) == 1
    minmaxColor(2)=0.1;
end

maxColor(j) = minmaxColor(2);
j=j+1;

hold on

MAXcolor=max(maxColor);
if MAXcolor<1
    MAXcolor=1;
end

set(gca,'CLim', [0 maxColor(1)]);
caxis([0 Range])
colorbar

x0=250;
y0=100;
width=350;
height=150;
set(gcf,'units','points','position',[x0,y0,width,height])