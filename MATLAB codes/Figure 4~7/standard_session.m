clc
clear all
close all

opts = delimitedTextImportOptions("NumVariables", 242);

opts.DataLines = [1, Inf];
opts.Delimiter = ",";

opts.VariableNames = ["VarName1", "VarName2", "VarName3", "VarName4", "VarName5", "VarName6", "VarName7", "VarName8", "VarName9", "VarName10", "VarName11", "VarName12", "VarName13", "VarName14", "VarName15", "VarName16", "VarName17", "VarName18", "VarName19", "VarName20", "VarName21", "VarName22", "VarName23", "VarName24", "VarName25", "VarName26", "VarName27", "VarName28", "VarName29", "VarName30", "VarName31", "VarName32", "VarName33", "VarName34", "VarName35", "VarName36", "VarName37", "VarName38", "VarName39", "VarName40", "VarName41", "VarName42", "VarName43", "VarName44", "VarName45", "VarName46", "VarName47", "VarName48", "VarName49", "VarName50", "VarName51", "VarName52", "VarName53", "VarName54", "VarName55", "VarName56", "VarName57", "VarName58", "VarName59", "VarName60", "VarName61", "VarName62", "VarName63", "VarName64", "VarName65", "VarName66", "VarName67", "VarName68", "VarName69", "VarName70", "VarName71", "VarName72", "VarName73", "VarName74", "VarName75", "VarName76", "VarName77", "VarName78", "VarName79", "VarName80", "VarName81", "VarName82", "VarName83", "VarName84", "VarName85", "VarName86", "VarName87", "VarName88", "VarName89", "VarName90", "VarName91", "VarName92", "VarName93", "VarName94", "VarName95", "VarName96", "VarName97", "VarName98", "VarName99", "VarName100", "VarName101", "VarName102", "VarName103", "VarName104", "VarName105", "VarName106", "VarName107", "VarName108", "VarName109", "VarName110", "VarName111", "VarName112", "VarName113", "VarName114", "VarName115", "NaN", "NaN_1", "NaN_2", "NaN_3", "NaN_4", "NaN_5", "NaN_6", "NaN_7", "NaN_8", "NaN_9", "NaN_10", "NaN_11", "VarName128", "VarName129", "VarName130", "VarName131", "VarName132", "VarName133", "VarName134", "VarName135", "VarName136", "VarName137", "VarName138", "VarName139", "VarName140", "VarName141", "VarName142", "VarName143", "VarName144", "VarName145", "VarName146", "VarName147", "VarName148", "VarName149", "VarName150", "VarName151", "VarName152", "VarName153", "VarName154", "VarName155", "VarName156", "VarName157", "VarName158", "VarName159", "VarName160", "VarName161", "VarName162", "VarName163", "VarName164", "VarName165", "VarName166", "VarName167", "VarName168", "VarName169", "VarName170", "VarName171", "VarName172", "VarName173", "VarName174", "VarName175", "VarName176", "VarName177", "VarName178", "VarName179", "VarName180", "VarName181", "VarName182", "VarName183", "VarName184", "VarName185", "VarName186", "VarName187", "VarName188", "VarName189", "VarName190", "VarName191", "VarName192", "VarName193", "VarName194", "VarName195", "VarName196", "VarName197", "VarName198", "VarName199", "VarName200", "VarName201", "VarName202", "VarName203", "VarName204", "VarName205", "VarName206", "VarName207", "VarName208", "VarName209", "VarName210", "VarName211", "VarName212", "VarName213", "VarName214", "VarName215", "VarName216", "VarName217", "VarName218", "VarName219", "VarName220", "VarName221", "VarName222", "VarName223", "VarName224", "VarName225", "VarName226", "VarName227", "VarName228", "VarName229", "VarName230", "VarName231", "VarName232", "VarName233", "VarName234", "VarName235", "VarName236", "VarName237", "VarName238", "VarName239", "VarName240", "VarName241", "VarName242"];
opts.SelectedVariableNames = ["VarName1", "VarName2", "VarName3", "VarName4", "VarName5", "VarName6", "VarName7", "VarName8", "VarName9", "VarName10", "VarName11", "VarName12", "VarName13", "VarName14", "VarName15", "VarName16", "VarName17", "VarName18", "VarName19", "VarName20", "VarName21", "VarName22", "VarName23", "VarName24", "VarName25", "VarName26", "VarName27", "VarName28", "VarName29", "VarName30", "VarName31", "VarName32", "VarName33", "VarName34", "VarName35", "VarName36", "VarName37", "VarName38", "VarName39", "VarName40", "VarName41", "VarName42", "VarName43", "VarName44", "VarName45", "VarName46", "VarName47", "VarName48", "VarName49", "VarName50", "VarName51", "VarName52", "VarName53", "VarName54", "VarName55", "VarName56", "VarName57", "VarName58", "VarName59", "VarName60", "VarName61", "VarName62", "VarName63", "VarName64", "VarName65", "VarName66", "VarName67", "VarName68", "VarName69", "VarName70", "VarName71", "VarName72", "VarName73", "VarName74", "VarName75", "VarName76", "VarName77", "VarName78", "VarName79", "VarName80", "VarName81", "VarName82", "VarName83", "VarName84", "VarName85", "VarName86", "VarName87", "VarName88", "VarName89", "VarName90", "VarName91", "VarName92", "VarName93", "VarName94", "VarName95", "VarName96", "VarName97", "VarName98", "VarName99", "VarName100", "VarName101", "VarName102", "VarName103", "VarName104", "VarName105", "VarName106", "VarName107", "VarName108", "VarName109", "VarName110", "VarName111", "VarName112", "VarName113", "VarName114", "VarName115", "NaN", "VarName128", "VarName129", "VarName130", "VarName131", "VarName132", "VarName133", "VarName134", "VarName135", "VarName136", "VarName137", "VarName138", "VarName139", "VarName140", "VarName141", "VarName142", "VarName143", "VarName144", "VarName145", "VarName146", "VarName147", "VarName148", "VarName149", "VarName150", "VarName151", "VarName152", "VarName153", "VarName154", "VarName155", "VarName156", "VarName157", "VarName158", "VarName159", "VarName160", "VarName161", "VarName162", "VarName163", "VarName164", "VarName165", "VarName166", "VarName167", "VarName168", "VarName169", "VarName170", "VarName171", "VarName172", "VarName173", "VarName174", "VarName175", "VarName176", "VarName177", "VarName178", "VarName179", "VarName180", "VarName181", "VarName182", "VarName183", "VarName184", "VarName185", "VarName186", "VarName187", "VarName188", "VarName189", "VarName190", "VarName191", "VarName192", "VarName193", "VarName194", "VarName195", "VarName196", "VarName197", "VarName198", "VarName199", "VarName200", "VarName201", "VarName202", "VarName203", "VarName204", "VarName205", "VarName206", "VarName207", "VarName208", "VarName209", "VarName210", "VarName211", "VarName212", "VarName213", "VarName214", "VarName215", "VarName216", "VarName217", "VarName218", "VarName219", "VarName220", "VarName221", "VarName222", "VarName223", "VarName224", "VarName225", "VarName226", "VarName227", "VarName228", "VarName229", "VarName230", "VarName231", "VarName232", "VarName233", "VarName234", "VarName235", "VarName236", "VarName237", "VarName238", "VarName239", "VarName240", "VarName241", "VarName242"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
opts = setvaropts(opts, [117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127], "WhitespaceRule", "preserve");
opts = setvaropts(opts, [117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127], "EmptyFieldRule", "auto");
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

FieldMatrixv = readtable("D:\VR_Headfix_Data_Ephys\raw\FieldMatrix\FieldMatrixv9(0525).csv", opts);

FieldMatrixv = table2array(FieldMatrixv);

clear opts

load ('FieldIdx.mat');

CA1Index = [1:length(CA1FieldIdx)];
CA3Index = [ 1+length(CA1Index) : 1+length(CA1Index)+length(CA3FieldIdx)-1];
VcxIndex = [ 1+length(CA1Index)+length(CA3Index) : size(FieldMatrixv,1) ];

idx= [1:231];

for i=1:length(CA1Index)
    CA1CellTable(i, :) = FieldMatrixv(CA1Index(i), idx);
end

for i=1:length(CA3Index)
    CA3CellTable(i, :) = FieldMatrixv(CA3Index(i), idx);
end

for i=1:length(VcxIndex)
    VxCellTable(i, :) = FieldMatrixv(VcxIndex(i), idx);
end


for i=1:length(CA1Index);
    [CA1MaxPeakPosition(i) CA1MaxPeakIndex(i)] = max(CA1CellTable(i,:));
end

for i=1:length(CA3Index);
    [CA3MaxPeakPosition(i) CA3MaxPeakIndex(i)] = max(CA3CellTable(i,:));
end

for i=1:length(VcxIndex);
    [VxMaxPeakPosition(i) VxMaxPeakIndex(i)] = max(VxCellTable(i,:));
end

uniform_dist = makedist('uniform');


subplot(1,3,1)

[f,x] = ecdf(CA1MaxPeakIndex(CA1MaxPeakIndex<=100));
plot(x,f,'LineWidth',2)

hold on
[f,x] = ecdf(CA1MaxPeakIndex(CA1MaxPeakIndex>115 & CA1MaxPeakIndex<=216)-116);
plot(x,f,'LineWidth',2)

set(gca,'linewidth',1.5)

xlabel('peak position (1bin = 3cm)','FontWeight','bold','FontSize',13);
ylabel('Proportion','FontWeight','bold','FontSize',13);
axis([0 100 0 1]);
grid on

[h,p] = kstest2(CA1MaxPeakIndex(CA1MaxPeakIndex<=100),CA1MaxPeakIndex(CA1MaxPeakIndex>115 & CA1MaxPeakIndex<=216)-116)

CA1Field_rescale = CA1MaxPeakIndex(CA1MaxPeakIndex<=115) ./ 100;
CA3Field_rescale = (CA1MaxPeakIndex(CA1MaxPeakIndex>115 & CA1MaxPeakIndex<=230)-116) ./ 100;

[h,p] = kstest(CA1Field_rescale,'cdf',uniform_dist)
[h,p] = kstest(CA3Field_rescale,'cdf',uniform_dist)


subplot(1,3,2)

[f,x] = ecdf(CA3MaxPeakIndex(CA3MaxPeakIndex<=100));
plot(x,f,'LineWidth',2)

hold on
[f,x] = ecdf(CA3MaxPeakIndex(CA3MaxPeakIndex>115 & CA3MaxPeakIndex<=216)-116);
plot(x,f,'LineWidth',2)

set(gca,'linewidth',1.5)

xlabel('peak position (1bin = 3cm)','FontWeight','bold','FontSize',13);
ylabel('Proportion','FontWeight','bold','FontSize',13);
axis([0 100 0 1]);
grid on

[h,p] = kstest2(CA3MaxPeakIndex(CA3MaxPeakIndex<=100),CA3MaxPeakIndex(CA3MaxPeakIndex>115 & CA3MaxPeakIndex<=216)-116)

subplot(1,3,3)

[f,x] = ecdf(VxMaxPeakIndex(VxMaxPeakIndex<=100));
plot(x,f,'LineWidth',2)

hold on
[f,x] = ecdf(VxMaxPeakIndex(VxMaxPeakIndex>115 & VxMaxPeakIndex<=216)-116);
plot(x,f,'LineWidth',2)

set(gca,'linewidth',1.5)

xlabel('peak position (1bin = 3cm)','FontWeight','bold','FontSize',13);
ylabel('Proportion','FontWeight','bold','FontSize',13);
axis([0 100 0 1]);

[h,p] = kstest2(VxMaxPeakIndex(VxMaxPeakIndex<=100),VxMaxPeakIndex(VxMaxPeakIndex>115 & VxMaxPeakIndex<=216)-116)

[CA1SortedIndex CA1index] = sort(CA1MaxPeakIndex , 'descend');
[CA3SortedIndex CA3index] = sort(CA3MaxPeakIndex , 'descend');
[VxSortedIndex Vxindex] = sort(VxMaxPeakIndex , 'descend');

CA1_Sorted = CA1CellTable(CA1index,:) ;
CA3_Sorted = CA3CellTable(CA3index,:) ;
Vx_Sorted = VxCellTable(Vxindex,:) ;

subplot(1,3,1)
imagesc(CA1_Sorted)
colormap(jet);
title('CA1');
xline(94,'--w', 'LineWidth', 2);
xline(210,'--w', 'LineWidth', 2);

subplot(1,3,2)
imagesc(CA3_Sorted)
colormap(jet);
title('CA3');
xline(94,'--w', 'LineWidth', 2);
xline(210,'--w', 'LineWidth', 2);


subplot(1,3,3)
imagesc(Vx_Sorted)
colormap(jet);
title('VcX');
xline(94,'--w', 'LineWidth', 2);
xline(210,'--w', 'LineWidth', 2);

    