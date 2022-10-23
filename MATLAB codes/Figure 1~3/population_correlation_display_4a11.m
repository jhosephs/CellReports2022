
% 2020 Oct 17

clear; clc; close all;

rng('shuffle');

% % Input
mother_root = 'H:\VR';

input_root = [mother_root '\7) ephys analysis\4\a\4\mat files2'];
% field_root = [mother_root '\7) ephys analysis\4\a\8\mat files ver2'];

% cluster_list_file = 'H:\VR\7) ephys analysis\cluster_id.csv';
% cluster_list_file = 'H:\VR\7) ephys analysis\filtering list 3\ca1_indecreasing_1cue.csv';
% cluster_list_file = 'H:\VR\7) ephys analysis\filtering list 3\ca1_indecreasing_2cue.csv';
cluster_list_file = 'H:\VR\7) ephys analysis\filtering list 3\ca1_indecreasing_3cue.csv';
% cluster_list_file = 'H:\VR\7) ephys analysis\filtering list 3\ca1_indecreasing_many cue.csv';

% cluster_list_file = 'H:\VR\7) ephys analysis\filtering list 3\ca3_indecreasing_1cue.csv';
% cluster_list_file = 'H:\VR\7) ephys analysis\filtering list 3\ca3_indecreasing_2cue.csv';
% cluster_list_file = 'H:\VR\7) ephys analysis\filtering list 3\ca3_indecreasing_3cue.csv';
% cluster_list_file = 'H:\VR\7) ephys analysis\filtering list 3\ca3_indecreasing_many cue.csv';

% input_condition = [1 1];
% input_condition = [2 2];
input_condition = [3 3];
% input_condition = [4 4];

map_drift_amount = 35;

% band width parameters

% L zone ranges
% target_range = [1 30];
% target_range = [1 45];
% target_range = [1 60];
% 

% LF zone ranges
% target_range = [31 100];
% target_range = [46 100];
target_range = [61 100];
% 

threshold_r = 0.5;
% 

% %

% % Setting
addpath(genpath([mother_root '\5) analysis programs\4\zz']));
addpath([mother_root '\5) analysis programs\4\a\11']);

cluster_fid = fopen(cluster_list_file, 'r');
cluster_list = textscan(cluster_fid, '%s');
cluster_list = cluster_list{1,1};
% %


% % Get population firing rate
pop_fr_mat = [];

for cl_iter =1 : length(cluster_list)
    
    % load trial firing rate & field count
    load([input_root '\' cluster_list{cl_iter} '.mat'], 'smooth_map');
    smooth_map(:, end) = [];    % delete overall map
    
    smooth_map = [smooth_map(map_drift_amount+1 : end, :); smooth_map(1 : map_drift_amount, :)];
    %
    
    % convert condition (3 blocks -> 4 blocks)
    [session_number, ~, ~, ~, ~] = get_session_type_4zz(cluster_list{cl_iter});
    
    if session_number == 4 || session_number == 6   % if session type is '3 blocks'
        smooth_map(:, 4) = smooth_map(:, 3);
        smooth_map(:, 3) = nan;
    end
    %
    
    % add pop_fr_mat
    pop_fr_mat(cl_iter, :, 1) = smooth_map(:, input_condition(1)) / nanmax(smooth_map(:, input_condition(1)));
    pop_fr_mat(cl_iter, :, 2) = smooth_map(:, input_condition(2)) / nanmax(smooth_map(:, input_condition(2)));
    %
    
    clear smooth_map;
    
end
% %


% rnd_size = 30;
rnd_size = size(pop_fr_mat, 1);

rnd_index = randperm(size(pop_fr_mat, 1), rnd_size);

rnd_pop_fr_mat(:, :, 1) = pop_fr_mat(rnd_index, :, 1);
rnd_pop_fr_mat(:, :, 2) = pop_fr_mat(rnd_index, :, 2);

% % Population correlation matrix

pop_corr_mat = [];
pop_corp_mat = [];

for iter1 = 1 : size(rnd_pop_fr_mat, 2)    
    for iter2 = 1 : size(rnd_pop_fr_mat, 2)
        
        temp1 = rnd_pop_fr_mat(:, iter1, 1);
        temp2 = rnd_pop_fr_mat(:, iter2, 2);
        
        nan_index = isnan(temp1) | isnan(temp2);
        temp1(nan_index) = [];
        temp2(nan_index) = [];
        
        [r, p] = corrcoef(temp1, temp2);
        
        pop_corr_mat(iter1, iter2) = r(1, 2);
        pop_corp_mat(iter1, iter2) = p(1, 2);
    end
end

% % 


% % Display
figure('color', [1 1 1], 'position', [100 100 350 300]);

imagesc(pop_corr_mat);
colormap('jet');
caxis([-1 1]);
set(gca, 'Ydir', 'normal', 'tickdir', 'out', 'xtick', 0 : 10 : 100, 'ytick', 0 : 10 : 100);
% % 

cd('H:\VR\8) manuscript\3) figures3\20210928-1')


% % Get corr values in target range
corr_list_target = [];

for row_iter = target_range(1) : target_range(2)-1
    for col_iter = row_iter+1 : target_range(2)
        
        corr_list_target(end+1, 1) = pop_corr_mat(row_iter, col_iter);
        
    end
end
% % 


if 0

% % Get high correlation band area

map_length = length(pop_corr_mat);
extend_corr_mat = [pop_corr_mat, pop_corr_mat, pop_corr_mat; pop_corr_mat, pop_corr_mat, pop_corr_mat; pop_corr_mat, pop_corr_mat, pop_corr_mat];
current_target_range = target_range + map_length;

area_sum = 0;
band_width = [];
index_bw = 0;

for iter = current_target_range(1) : current_target_range(2)
    
    index_bw = index_bw + 1;
    band_width(index_bw, 1) = 0;
    
    temp_flag = true;
    current_coord = [iter, iter] + [-1, 1];
    while temp_flag
        if extend_corr_mat(current_coord(1), current_coord(2)) > threshold_r
            area_sum = area_sum + 1;
            band_width(index_bw, 1) = band_width(index_bw, 1) + 1;
            extend_corr_mat(current_coord(1), current_coord(2)) = -1;
            current_coord = current_coord + [-1, 1];
        else
            temp_flag = false;
        end
    end
    
    if iter == current_target_range(2)
        continue;
    end
    
    index_bw = index_bw + 1;
    band_width(index_bw, 1) = 0;
    
    temp_flag = true;
    current_coord = [iter, iter] + [0, 1];
    while temp_flag
        if extend_corr_mat(current_coord(1), current_coord(2)) > threshold_r
            area_sum = area_sum + 1;
            band_width(index_bw, 1) = band_width(index_bw, 1) + 1;
            extend_corr_mat(current_coord(1), current_coord(2)) = -1;
            current_coord = current_coord + [-1, 1];
        else
            temp_flag = false;
        end
    end
    
end

% % 

end

if 0

% % Get diagonal values

map_length = length(pop_corr_mat);
current_mat = pop_corr_mat(target_range(1) : target_range(2), target_range(1) : target_range(2));
diagonal_values = nan(length(current_mat));

current_mat_length = length(current_mat);

% get diagonal values
for iter = 1 : current_mat_length
    temp = [];
    
    for iter2 = 1 : current_mat_length - iter+1
        temp(iter2, 1) = current_mat(iter2, iter2 + iter-1);
    end
    
    diagonal_values(1 : length(temp), iter) = temp;    
end
% 

% get mean & sem
dv_mean = mean(diagonal_values, 1, 'omitnan');

for iter = 1 : current_mat_length
    dv_sem(iter) = sem_4zz(diagonal_values(:, iter));
end
% 

% display

% fill([1 : current_mat_length, current_mat_length : -1 : 1], [dv_mean - dv_sem, flip(dv_mean + dv_sem)], 'r');
% hold on
plot(dv_mean, 'color', 'k');

set(gca, 'Ylim', [-1 1], 'XLim', [1 70]);
% 

% % 

cd('H:\VR\8) manuscript\3) figures3\20210928-5');


temp = diagonal_values;
temp(:, 1) = [];
temp = reshape(temp, [size(temp, 1) * size(temp, 2), 1]);
temp(isnan(temp)) = [];

dv_mean = dv_mean';

end