clc
fclose all
clear all


opts = delimitedTextImportOptions("NumVariables", 49);
opts.DataLines = [2, Inf];
opts.Delimiter = ",";

opts.VariableNames = ["cellID", "task", "ratID", "sessionID", "TT", "clusterNo", "GenRegion", "stdmaxField", "stdSecondarymaxField1", "amb0maxField", "amb0SecondarymaxField1", "amb1maxField1", "amb1SecondarymaxField1", "amb2maxField1", "amb2SecondarymaxField1", "stdminField", "stdSecondaryminField1", "amb0minField", "amb0SecondaryminField1", "amb1minField1", "amb1SecondaryminField1", "amb2minField1", "amb2SecondaryminField1", "stdSpaInfoScore", "amb0SpaInfoScore", "amb1SpaInfoScore1", "amb2SpaInfoScore1", "RawstdAvFR1", "Rawamb0AvFR1", "Rawamb1AvFR1", "Rawamb2AvFR1", "stdcent", "amb0cent", "amb1cent1", "amb2cent1", "stdSecondarycent1", "amb0Secondarycent1", "amb1Secondarycent1", "amb2Secondarycent1", "stdSkew1", "stdSecondarySkew1", "amb0Skew1", "amb0SecondarySkew1", "amb1Skew1", "amb1SecondarySkew1", "amb2Skew1", "amb2SecondarySkew1", "StdAmbRDI1", "StdAmbR1"];
opts.VariableTypes = ["char", "char", "double", "double", "double", "double", "char", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
opts = setvaropts(opts, [1, 2, 7], "WhitespaceRule", "preserve");
opts = setvaropts(opts, [1, 2, 7], "EmptyFieldRule", "auto");
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

tbl = readtable("D:\VR_Headfix_Data_Ephys\raw\Fog_session\InFieldSummary(Rawmap_15%_bin3cm_Fog).csv", opts);

cellID = tbl.cellID;
task = tbl.task;
ratID = tbl.ratID;
sessionID = tbl.sessionID;
TT = tbl.TT;
clusterNo = tbl.clusterNo;
GenRegion = tbl.GenRegion;
stdmaxField = tbl.stdmaxField;
stdSecondarymaxField = tbl.stdSecondarymaxField1;
amb0maxField = tbl.amb0maxField;
amb0SecondarymaxField = tbl.amb0SecondarymaxField1;
amb1maxField = tbl.amb1maxField1;
amb1SecondarymaxField = tbl.amb1SecondarymaxField1;
amb2maxField = tbl.amb2maxField1;
amb2SecondarymaxField = tbl.amb2SecondarymaxField1;
stdminField = tbl.stdminField;
stdSecondaryminField = tbl.stdSecondaryminField1;
amb0minField = tbl.amb0minField;
amb0SecondaryminField = tbl.amb0SecondaryminField1;
amb1minField = tbl.amb1minField1;
amb1SecondaryminField = tbl.amb1SecondaryminField1;
amb2minField = tbl.amb2minField1;
amb2SecondaryminField = tbl.amb2SecondaryminField1;
stdSpaInfoScore = tbl.stdSpaInfoScore;
amb0SpaInfoScore = tbl.amb0SpaInfoScore;
amb1SpaInfoScore = tbl.amb1SpaInfoScore1;
amb2SpaInfoScore = tbl.amb2SpaInfoScore1;
RawstdAvFR = tbl.RawstdAvFR1;
Rawamb0AvFR = tbl.Rawamb0AvFR1;
Rawamb1AvFR = tbl.Rawamb1AvFR1;
Rawamb2AvFR = tbl.Rawamb2AvFR1;
stdcent = tbl.stdcent;
amb0cent = tbl.amb0cent;
amb1cent = tbl.amb1cent1;
amb2cent = tbl.amb2cent1;
stdSecondarycent = tbl.stdSecondarycent1;
amb0Secondarycent = tbl.amb0Secondarycent1;
amb1Secondarycent = tbl.amb1Secondarycent1;
amb2Secondarycent = tbl.amb2Secondarycent1;
stdSkew = tbl.stdSkew1;
stdSecondarySkew = tbl.stdSecondarySkew1;
amb0Skew = tbl.amb0Skew1;
amb0SecondarySkew = tbl.amb0SecondarySkew1;
amb1Skew = tbl.amb1Skew1;
amb1SecondarySkew = tbl.amb1SecondarySkew1;
amb2Skew = tbl.amb2Skew1;
amb2SecondarySkew = tbl.amb2SecondarySkew1;
StdAmbRDI = tbl.StdAmbRDI1;
StdAmbR = tbl.StdAmbR1;

clear opts tbl

for i = 1:length(Rawamb0AvFR)
    t = max([ RawstdAvFR(i) Rawamb0AvFR(i) Rawamb1AvFR(i) Rawamb2AvFR(i)]);
    NormFR(i,1:4) = [RawstdAvFR(i)/t  Rawamb0AvFR(i)/t Rawamb1AvFR(i)/t Rawamb2AvFR(i)/t];
end

% Specific region type indexing
CA1_index = find(strcmp(GenRegion, 'CA1'));
CA3_index = find(ismember(GenRegion, {'CA3a', 'CA3b', 'CA3c'}));
VC2_index = find(ismember(GenRegion, {'V2'}));
VC1_index = find(ismember(GenRegion, {'V1'}));

[CA1index,pos]=intersect(CA1index,CA1_index);
[CA3index,pos]=intersect(CA3index,CA3_index);
[Vcxindex,pos]=intersect(Vcxindex,VC2_index);

stdSpaInfoScore(stdSpaInfoScore < 0) = NaN;
amb0SpaInfoScore(amb0SpaInfoScore < 0) = NaN;
amb1SpaInfoScore(amb1SpaInfoScore < 0) = NaN;
amb2SpaInfoScore(amb2SpaInfoScore < 0) = NaN;

FilteredCA1 = intersect(union(find(stdSpaInfoScore >= 0.1 & RawstdAvFR >=0.5),find(amb0SpaInfoScore >= 0.1 & Rawamb0AvFR >=0.5)), CA1index);
FilteredCA3 = intersect(union(find(stdSpaInfoScore >= 0.1 & RawstdAvFR >=0.5),find(amb0SpaInfoScore >= 0.1 & Rawamb0AvFR >=0.5)), CA3index);
FilteredVcx = intersect(union(find(stdSpaInfoScore >= 0.05 & RawstdAvFR >=0.5),find(amb0SpaInfoScore >= 0.05& Rawamb0AvFR >=0.5)), Vcxindex);
filteredIdc = [FilteredCA1' FilteredCA3' FilteredVcx']';

cd('D:\VR_Headfix_Data_Ephys\raw\FogLapAvgFr_PCA(15%_bin3cm_fog)')

for i=1:length(filteredIdc)
    
    fileID = [cell2mat(cellID(filteredIdc(i)))];
    load([fileID '.mat'])
    In_field_RDI(i) = baselineamb0RDI;
    RDI_p(i) = baselineAmb0FRp;
    baselineamb0RDI = [];
    baselineAmb0FRp = [];
    
end

i = [];

for i = 1 : length(cellID)
    normFR(i,1:4) = normalize([RawstdAvFR((i)) Rawamb0AvFR((i)) Rawamb1AvFR((i)) Rawamb2AvFR((i))]);
end

t = [] ;

for i = 1:length(filteredIdc)
    t((i-1)*4+1 : i*4) =  (normFR(filteredIdc(i),1:4));
end

for i = 1:length(filteredIdc)
    t((i-1)*4+1 : i*4) = [RawstdAvFR(filteredIdc(i)) Rawamb0AvFR(filteredIdc(i)) Rawamb1AvFR(filteredIdc(i)) Rawamb2AvFR(filteredIdc(i))]/ max([RawstdAvFR(filteredIdc(i)) Rawamb0AvFR(filteredIdc(i)) Rawamb1AvFR(filteredIdc(i)) Rawamb2AvFR(filteredIdc(i))]);
end

c = [];
c = repmat(1:4,length(filteredIdc));
c =  c(1,:);

figure();

tAvFr = [];
tAverr = [];

x=[];
e=[];

tAvFr = ([mean(normStdFR(FilteredCA1)) mean(normAmb0FR(FilteredCA1))  mean(normAmb1FR(FilteredCA1)) mean(normAmb2FR(FilteredCA1))]);
tAverr = [nanstd(normStdFR(FilteredCA1)) /sqrt(length(FilteredCA1)) nanstd(normAmb0FR(FilteredCA1)) /sqrt(length(FilteredCA1)) nanstd(normAmb1FR(FilteredCA1)) /sqrt(length(FilteredCA1)) nanstd(normAmb2FR(FilteredCA1)) /sqrt(length(FilteredCA1))];


x = tAvFr;
e = tAverr;
plot(x,'o', 'MarkerFaceColor','b')
title('stb','FontWeight','bold','FontSize',13)
ylabel('Norm FR','FontWeight','bold','FontSize',13);
xlabel('condition','FontWeight','bold','FontSize',13);

hold on

er = errorbar(1:1:4,x,e);
er.Color = [0 0 0];
er.LineStyle = 'none';

hold on

tAvFr = [];
tAverr = [];

x=[];
e=[];

tAvFr = ([mean(normStdFR(FilteredCA3)) mean(normAmb0FR(FilteredCA3))  mean(normAmb1FR(FilteredCA3)) mean(normAmb2FR(FilteredCA3))]);
tAverr = [nanstd(normStdFR(FilteredCA3)) /sqrt(length(FilteredCA3)) nanstd(normAmb0FR(FilteredCA3)) /sqrt(length(FilteredCA3)) nanstd(normAmb1FR(FilteredCA3)) /sqrt(length(FilteredCA3)) nanstd(normAmb2FR(FilteredCA3)) /sqrt(length(FilteredCA3))];

x = tAvFr;
e = tAverr;

plot(x,'o', 'MarkerFaceColor','r')
ylabel('Norm FR','FontWeight','bold','FontSize',13);
xlabel('condition','FontWeight','bold','FontSize',13);

hold on

er = errorbar(1:1:4,x,e);
er.Color = [0 0 0];
er.LineStyle = 'none';

