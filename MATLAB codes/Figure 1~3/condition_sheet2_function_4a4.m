
% 2020 May 27

function [occ_map, spk_map, raw_map, smooth_map, raw_mean_fr, raw_peak_fr, smooth_mean_fr, smooth_peak_fr, trial_number, spike_number, spainfo_score, p_spainfo, corrected_parsed_position, corrected_parsed_spike, fh, sheet_position] = condition_sheet2_function_4a4(mother_root, cluster_id)

% % Setting
[rat_id, ss_id, tt_id, cl_id] = disassemble_id_4zz(cluster_id);
session_root = [mother_root '\6) electrophysiology data\rat' rat_id '\cheetah data calcparm\rat' rat_id '-'  ss_id];

[session_number, session_name, condition_number, condition_range, condition_name] = get_session_type_4zz(cluster_id);

% basic parameters
bin_size = 100; % 1bin = 100 UE = 3cm
sampling_rate = 30;
n_shuffle = 1000;   % number of shuffles for calculating spatial information score p-value

UE_map_length = 10000;
rate_map_length = UE_map_length / bin_size;
% n_shuffle = 1;
%

% index for parsed data
timestamp_pp = 1;
position_pp = 2;
trialn_pp = 3;
condition_pp = 4;
void_pp = 5;

condition_pt = 1;
void_pt = 2;
tstart_pt = 3;
tend_pt = 4;
treward1_pt = 5;
treward2_pt = 6;
preward1_pt = 7;
preward2_pt = 8;

timestamp_ps = 1;
position_ps = 2;
trialn_ps = 3;
condition_ps = 4;
void_ps = 5;
%

% %


% % Load parsed data
load([session_root '\parsed_position.mat'], 'parsed_position', 'parsed_trial', 'total_trial_number');
load([session_root '\TT' tt_id '\parsed_spike_' cl_id '.mat'], 'parsed_spike');

% check number of spike
if isempty(parsed_spike)
    
    occ_map = nan; spk_map = nan; raw_map = nan; smooth_map = nan;
    raw_mean_fr = nan; raw_peak_fr = nan; smooth_mean_fr = nan; smooth_peak_fr = nan;
    trial_number = nan; spike_number = nan; spainfo_score = nan; p_spainfo = nan;
    corrected_parsed_position = nan; corrected_parsed_spike = nan;
    
    sheet_position = [50 50 100 100];
    fh = figure('Position', sheet_position, 'color', 'white');
    
    return;
end
%

% %


% % Make maps

if 0
    
    occ_map2 = [];
    spk_map2 = [];
    raw_map2 = [];
    % smooth_ratemap = [];
    
    % occ map & spk map
    for cond_iter = 1 : length(condition_number)
        
        % occ map
        temp_index = parsed_position(:, void_pp) == 0 & parsed_position(:, condition_pp) == cond_iter;
        
        temp = parsed_position(temp_index, position_pp);
        temp(temp < condition_range(1, cond_iter) | temp > condition_range(2, cond_iter)) = []; % delete data outside the range
        temp = temp - condition_range(1, cond_iter);    % align start position to zero
        
        current_edge = 0 : bin_size : condition_range(2, cond_iter) - condition_range(1, cond_iter);
        [occ_map2(:, cond_iter), temp_edge] = histcounts(temp, current_edge);
        %
        
        % spk map
        temp_index = parsed_spike(:, void_ps) == 0 & parsed_spike(:, condition_ps) == cond_iter;
        
        temp = parsed_spike(temp_index, position_ps);
        temp(temp < condition_range(1, cond_iter) | temp > condition_range(2, cond_iter)) = []; % delete data outside the range
        temp = temp - condition_range(1, cond_iter);    % align start position to zero
        
        current_edge = 0 : bin_size : condition_range(2, cond_iter) - condition_range(1, cond_iter);
        [spk_map2(:, cond_iter), temp_edge] = histcounts(temp, current_edge);
        %
        
    end
    
    occ_map2(:, end+1) = sum(occ_map2(:, 1 : end), 2);
    spk_map2(:, end+1) = sum(spk_map2(:, 1 : end), 2);
    %
    
    % raw map
    for iter = 1 : size(occ_map2, 2)
        raw_map2(:, iter) = spk_map2(:, iter) ./ occ_map2(:, iter) * sampling_rate;
    end
    %
end





pos_whole_list = [];
spk_whole_list = [];

for cond_iter = 1 : length(condition_number)
    
    % pos
    temp_index = parsed_position(:, void_pp) == 0 & parsed_position(:, condition_pp) == cond_iter;
    
    temp = parsed_position(temp_index, position_pp);
    temp(temp < condition_range(1, cond_iter) | temp > condition_range(2, cond_iter)) = []; % delete data outside the range
    temp = temp - condition_range(1, cond_iter);    % align start position to zero
    
    pos_cond_list = temp;
    pos_whole_list(end+1 : end + length(temp), 1) = temp;
    %
    
    % spk
    temp_index = parsed_spike(:, void_ps) == 0 & parsed_spike(:, condition_ps) == cond_iter;
    
    temp = parsed_spike(temp_index, position_ps);
    temp(temp < condition_range(1, cond_iter) | temp > condition_range(2, cond_iter)) = []; % delete data outside the range
    temp = temp - condition_range(1, cond_iter);    % align start position to zero
    
    spk_cond_list = temp;
    spk_whole_list(end+1 : end + length(temp), 1) = temp;
    %
    
    temp_pos = [];
    temp_pos(:, 3) = [pos_cond_list; pos_cond_list + UE_map_length; pos_cond_list - UE_map_length] + UE_map_length;
    
    temp_spk = [];
    temp_spk(:, 3) = [spk_cond_list; spk_cond_list + UE_map_length; spk_cond_list - UE_map_length] + UE_map_length;
    
    [temp_occ_map, temp_spk_map, temp_raw_map, temp_smooth_map] = abmFiringRateMap(...
        temp_spk, temp_pos, rate_map_length * 3, 1, bin_size, sampling_rate);
    
    occ_map(:, cond_iter) = temp_occ_map(rate_map_length+1 : rate_map_length*2);
    spk_map(:, cond_iter) = temp_spk_map(rate_map_length+1 : rate_map_length*2);
    raw_map(:, cond_iter) = temp_raw_map(rate_map_length+1 : rate_map_length*2);
    smooth_map(:, cond_iter) = temp_smooth_map(rate_map_length+1 : rate_map_length*2);
    
end


temp_pos = [];
temp_pos(:, 3) = [pos_whole_list; pos_whole_list + UE_map_length; pos_whole_list - UE_map_length] + UE_map_length;

temp_spk = [];
temp_spk(:, 3) = [spk_whole_list; spk_whole_list + UE_map_length; spk_whole_list - UE_map_length] + UE_map_length;

[temp_occ_map, temp_spk_map, temp_raw_map, temp_smooth_map] = abmFiringRateMap(...
    temp_spk, temp_pos, rate_map_length * 3, 1, bin_size, sampling_rate);

occ_map(:, length(condition_number)+1) = temp_occ_map(rate_map_length+1 : rate_map_length*2);
spk_map(:, length(condition_number)+1) = temp_spk_map(rate_map_length+1 : rate_map_length*2);
raw_map(:, length(condition_number)+1) = temp_raw_map(rate_map_length+1 : rate_map_length*2);
smooth_map(:, length(condition_number)+1) = temp_smooth_map(rate_map_length+1 : rate_map_length*2);
%

% %


% % Mean fr, Peak fr, Spatial information score

% setting
raw_mean_fr = [];
raw_peak_fr = [];

smooth_mean_fr = [];
smooth_peak_fr = [];

trial_number = [];
spike_number = [];
spainfo_score = [];
p_spainfo = [];
%

% variables for calculating spatial information score p-value & raster plot display

temp_index = parsed_position(:, void_pp) == 0;
corrected_parsed_position = parsed_position(temp_index, :); % delete void data

temp_index = parsed_spike(:, void_ps) == 0;
corrected_parsed_spike = parsed_spike(temp_index, :); % delete void data

for cond_iter = 1 : length(condition_number)
    temp_index = corrected_parsed_position(:, condition_pp) == cond_iter;
    corrected_parsed_position(temp_index, position_pp) = corrected_parsed_position(temp_index, position_pp) - condition_range(1, cond_iter);
    
    temp_index = corrected_parsed_spike(:, condition_ps) == cond_iter;
    corrected_parsed_spike(temp_index, position_ps) = corrected_parsed_spike(temp_index, position_ps) - condition_range(1, cond_iter);
end

corrected_parsed_position(corrected_parsed_position(:, position_pp) < 0 | corrected_parsed_position(:, position_pp) > 10000, :) = [];
corrected_parsed_spike(corrected_parsed_spike(:, position_ps) < 0 | corrected_parsed_spike(:, position_ps) > 10000, :) = [];
%

% check number of spike
if isempty(corrected_parsed_spike)
    
    occ_map = nan; spk_map = nan; raw_map = nan; smooth_map = nan;
    raw_mean_fr = nan; raw_peak_fr = nan; smooth_mean_fr = nan; smooth_peak_fr = nan;
    trial_number = nan; spike_number = nan; spainfo_score = nan; p_spainfo = nan;
    corrected_parsed_position = nan; corrected_parsed_spike = nan;
    
    sheet_position = [50 50 100 100];
    fh = figure('Position', sheet_position, 'color', 'white');
    
    return;
end
% 

for cond_iter = 1 : length(condition_number)
    
    temp_index = parsed_trial(:, void_pt) == 0 & parsed_trial(:, condition_pt) == cond_iter;
    trial_number(cond_iter, 1) = sum(temp_index);
    
    spike_number(cond_iter, 1) = sum(spk_map(:, cond_iter));
    
    raw_mean_fr(cond_iter, 1) = nanmean(raw_map(:, cond_iter));
    raw_peak_fr(cond_iter, 1) = nanmax(raw_map(:, cond_iter));
    
    smooth_mean_fr(cond_iter, 1) = nanmean(smooth_map(:, cond_iter));
    smooth_peak_fr(cond_iter, 1) = nanmax(smooth_map(:, cond_iter));
    
    temp_index = corrected_parsed_position(:, condition_pp) == cond_iter;
    
    if sum(corrected_parsed_spike(:, condition_ps) == cond_iter) == 0
        spainfo_score(cond_iter, 1) = 0;
        p_spainfo(cond_iter, 1) = 1;
    else
        [spainfo_score(cond_iter, 1), p_spainfo(cond_iter, 1)] = calc_spainfo_p_function_4a4(n_shuffle, bin_size, sampling_rate, corrected_parsed_position(temp_index, timestamp_pp), corrected_parsed_position(temp_index, position_pp), parsed_spike(:, timestamp_ps));
    end
    
end

overall_index = length(condition_number)+1;

trial_number(overall_index, 1) = sum(trial_number(1 : length(condition_number), 1));
spike_number(overall_index, 1) = sum(spike_number(1 : length(condition_number), 1));

raw_mean_fr(overall_index, 1) = nanmean(raw_map(:, overall_index));
raw_peak_fr(overall_index, 1) = nanmax(raw_map(:, overall_index));

smooth_mean_fr(overall_index, 1) = nanmean(smooth_map(:, overall_index));
smooth_peak_fr(overall_index, 1) = nanmax(smooth_map(:, overall_index));

[spainfo_score(overall_index, 1), p_spainfo(overall_index, 1)] = calc_spainfo_p_function_4a4(n_shuffle, bin_size, sampling_rate, corrected_parsed_position(:, timestamp_pp), corrected_parsed_position(:, position_pp), parsed_spike(:, timestamp_ps));
% %


% % Display
condition_sheet2_display_4a4;
% %


end