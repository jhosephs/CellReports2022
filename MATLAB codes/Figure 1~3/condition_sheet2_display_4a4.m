
% 2021 May 21

close all;

% % Setting

[cue_locations, cue_locations_long] = cue_location_function_4a4(mother_root, cluster_id);

% delete void trials
corrected_cue_locations_long = cue_locations_long;
void_trials = find(parsed_trial(:, void_pt) == 1);

if ~isempty(corrected_cue_locations_long)
    for iter = 1 : length(void_trials)
        temp_index = corrected_cue_locations_long(:, 1) == void_trials(iter);
        corrected_cue_locations_long(temp_index, :) = [];
    end
end
%

% %


% % Make sheet
switch length(condition_number)
    case 2
        sheet_position = [50 50 650 900];
        
    case 3
        sheet_position = [50 50 1120 900];
        
    case 4
        sheet_position = [50 50 1120 900];
end
fh = figure('Position', sheet_position, 'color', 'white');
% %


% % Write title
font_size = 12;

temp_position = pixel_norm_4zz([0, 50, sheet_position(3), 50], sheet_position);
subplot('Position', temp_position);

% text(0.05, 0.5, ['Rat' rat_id '-S' ss_id '-TT' tt_id '-cl' cl_id], 'FontSize', font_size);
text(0.05, 0.5, cluster_id, 'FontSize', font_size);
text(0.25, 0.5, session_name, 'FontSize', font_size);
text(0.5, 0.5, ['Region: ' get_region_4zz(mother_root, cluster_id)], 'FontSize', font_size);
text(0.85, 0.5, date);
axis off;
% %


% % Draw rate map

% set position
rate_map_position = [60, 220, 230, 130];

switch length(condition_number)
    case 2
        rate_map_position(2, :) = rate_map_position(1, :) + [0, 220, 0, 0];
        
    case 3
        rate_map_position(2, :) = rate_map_position(1, :) + [0, 220, 0, 0];
        rate_map_position(3, :) = rate_map_position(1, :) + [550, 0, 0, 0];
        
    case 4
        rate_map_position(2, :) = rate_map_position(1, :) + [0, 220, 0, 0];
        rate_map_position(3, :) = rate_map_position(1, :) + [550, 0, 0, 0];
        rate_map_position(4, :) = rate_map_position(1, :) + [550, 220, 0, 0];
end
%

y_max = max(max(raw_map));

for cond_iter = 1 : length(condition_number)
    
    temp_position = pixel_norm_4zz(rate_map_position(cond_iter, :), sheet_position);
    subplot('Position', temp_position);
    hold on;
    
    % raw rate map
    plot(raw_map(:, cond_iter), 'color', 'k');
    %
    
    % smooth rate map
    plot(smooth_map(:, cond_iter), 'color', 'r');
    %
    
    ylabel('Firing rate (Hz)');
    xlabel('Position');
    title(condition_name{cond_iter});
    axis tight
    set(gca, 'YLim', [0 y_max]);
    
end

% %


% % Write map properties

txt_step = 0.155;
font_size = 12;
temp_loc = 0.65;

% set position
properties_position = [320, 220, 220, 130];

switch length(condition_number)
    case 2
        properties_position(2, :) = properties_position(1, :) + [0, 220, 0, 0];
        
    case 3
        properties_position(2, :) = properties_position(1, :) + [0, 220, 0, 0];
        properties_position(3, :) = properties_position(1, :) + [550, 0, 0, 0];
        
    case 4
        properties_position(2, :) = properties_position(1, :) + [0, 220, 0, 0];
        properties_position(3, :) = properties_position(1, :) + [550, 0, 0, 0];
        properties_position(4, :) = properties_position(1, :) + [550, 220, 0, 0];
end
%

for cond_iter = 1 : length(condition_number)
    
    temp_position = pixel_norm_4zz(properties_position(cond_iter, :), sheet_position);
    %     temp_position = pixel_norm_4zz([360, 220 + (cond_iter-1) * temp_step, 220, 130], sheet_position);
    subplot('Position', temp_position);
    hold on;
    
    % description
    text(0, 0.9, '# of trials: ', 'fontSize', font_size);
    text(0, 0.9 - txt_step, '# of spikes: ', 'fontSize', font_size);
    text(0, 0.9 - txt_step * 2, 'mean fr (raw, smth): ', 'fontSize', font_size);
    text(0, 0.9 - txt_step * 3, 'peak fr (raw, smth): ', 'fontSize', font_size);
    text(0, 0.9 - txt_step * 4, 'spatial info score: ', 'fontSize', font_size);
    text(0, 0.9 - txt_step * 5, 'p-value (spa info): ', 'fontSize', font_size);
    %
    
    % value
    text(temp_loc, 0.9, num2str(trial_number(cond_iter)), 'fontSize', font_size);
    text(temp_loc, 0.9 - txt_step, num2str(spike_number(cond_iter)), 'fontSize', font_size);
    text(temp_loc, 0.9 - txt_step * 2, [jjnum2str(raw_mean_fr(cond_iter)) ', ' jjnum2str(smooth_mean_fr(cond_iter))], 'fontSize', font_size);
    text(temp_loc, 0.9 - txt_step * 3, [jjnum2str(raw_peak_fr(cond_iter)) ', ' jjnum2str(smooth_peak_fr(cond_iter))], 'fontSize', font_size);
    text(temp_loc, 0.9 - txt_step * 4, jjnum2str(spainfo_score(cond_iter)), 'fontSize', font_size);
    text(temp_loc, 0.9 - txt_step * 5, num2str(p_spainfo(cond_iter)), 'fontSize', font_size);
    %
    
    axis off;
    
end

% %


% % Draw raster plot (sorted)
temp_position = pixel_norm_4zz([70, 830, 230, 300], sheet_position);
subplot('Position', temp_position);
hold on;

sorted_index_pos = [];
sorted_index_spk = [];
sorted_index_cue = [];

current_trial = 1;

for cond_iter = 1 : length(condition_number)
    
    temp_list = find(parsed_trial(:, condition_pt) == cond_iter & parsed_trial(:, void_pt) == 0);
    
    for trial_iter = 1 : length(temp_list)
        
        temp_index = corrected_parsed_position(:, trialn_pp) == temp_list(trial_iter);
        sorted_index_pos(temp_index, 1) = current_trial;
        
        temp_index = corrected_parsed_spike(:, trialn_ps) == temp_list(trial_iter);
        sorted_index_spk(temp_index, 1) = current_trial;
        
        if ~isempty(corrected_cue_locations_long)            
            temp_index = corrected_cue_locations_long(:, 1) == temp_list(trial_iter);
            sorted_index_cue(temp_index, 1) = current_trial;
        end
        
        current_trial = current_trial + 1;
    end
    
    current_trial = current_trial + 5;
end

plot(corrected_parsed_position(:, position_pp), sorted_index_pos, '.', 'color', [.7 .7 .7], 'markerSize', 3);
plot(corrected_parsed_spike(:, position_ps), sorted_index_spk, '.', 'color', 'r', 'markerSize', 5);

% mark cue locations

% sorted_index_cue = sorted_index_cue(randperm(length(sorted_index_cue)));

if ~isempty(sorted_index_cue)
    for iter = 1 : size(corrected_cue_locations_long, 1)
        
        plot([corrected_cue_locations_long(iter, 2), corrected_cue_locations_long(iter, 2)], [sorted_index_cue(iter)-0.5, sorted_index_cue(iter)+0.5], 'color', 'b');
        
    end
end
% plot(cue_locations_long(:, 2), sorted_index_cue, '.', 'color', 'b', 'markerSize', 3);
% 

title('Raster plot (sorting)');
ylabel('Trial number');
xlabel('Position (UE)');
set(gca, 'YDir', 'rev');
axis tight
% %


% % Draw raster plot (raw)

temp_position = pixel_norm_4zz([390, 830, 230, 300], sheet_position);
subplot('Position', temp_position);
hold on;

% block lines
block_lines = [];

switch session_number
    case 1  % no_many_no
        block_lines = [find(parsed_trial(:, condition_pt) == 2, 1, 'first'), find(parsed_trial(:, condition_pt) == 2, 1, 'last')+1];
        
    case 2  % individual_combine_individual
        block_lines = [find(parsed_trial(:, condition_pt) == 4, 1, 'first'), find(parsed_trial(:, condition_pt) == 4, 1, 'last')+1];
        
    case 3  % combine_individual_combine
        temp_index = parsed_trial(:, condition_pt);
        temp_index(temp_index == 1 | temp_index == 2 | temp_index == 3) = 5;
        block_lines = [find(temp_index == 5, 1, 'first'), find(temp_index == 5, 1, 'last')+1];
        
    case 4  % increasing_3blocks
        block_lines = [find(parsed_trial(:, condition_pt) == 2, 1, 'first'), find(parsed_trial(:, condition_pt) == 3, 1, 'first')];
        
    case 5  % increasing_4blocks
        block_lines = [find(parsed_trial(:, condition_pt) == 2, 1, 'first'), find(parsed_trial(:, condition_pt) == 3, 1, 'first'), find(parsed_trial(:, condition_pt) == 4, 1, 'first')];
        
    case 6  % decreasing_3blocks
        block_lines = [find(parsed_trial(:, condition_pt) == 2, 1, 'first'), find(parsed_trial(:, condition_pt) == 1, 1, 'first')];
        
    case 7  % decreasing_4blocks
        block_lines = [find(parsed_trial(:, condition_pt) == 3, 1, 'first'), find(parsed_trial(:, condition_pt) == 2, 1, 'first'), find(parsed_trial(:, condition_pt) == 1, 1, 'first')];
        
    case 8  % three_many
end

block_lines = (parsed_trial(block_lines, tstart_pt) - corrected_parsed_position(1, timestamp_pp)) / 10^6;
%


plot(corrected_parsed_position(:, position_pp), (corrected_parsed_position(:, timestamp_pp) - corrected_parsed_position(1, timestamp_pp)) / 10^6, '.', 'color', [.7 .7 .7], 'markerSize', 3)
plot(corrected_parsed_spike(:, position_ps), (corrected_parsed_spike(:, timestamp_ps) - corrected_parsed_position(1, timestamp_pp)) / 10^6, '.', 'color', 'r', 'markerSize', 5)

for iter = 1 : length(block_lines)
    plot([0 10000], [block_lines(iter), block_lines(iter)], 'color', 'k');
end


% mark cue locations
for iter = 1 : size(corrected_cue_locations_long, 1)
    
    current_trial = corrected_cue_locations_long(iter, 1);
    
    temp_y = [parsed_trial(current_trial, tstart_pt), parsed_trial(current_trial, tend_pt)];
    temp_y = temp_y - corrected_parsed_position(1, timestamp_pp);
    temp_y = temp_y / 10^6;
    
    plot([corrected_cue_locations_long(iter, 2), corrected_cue_locations_long(iter, 2)], temp_y, 'color', 'b');
    
end
%

title('Raster plot (raw)');
ylabel('Time (s)');
xlabel('Position (UE)');
set(gca, 'YDir', 'rev');
axis tight

% %



