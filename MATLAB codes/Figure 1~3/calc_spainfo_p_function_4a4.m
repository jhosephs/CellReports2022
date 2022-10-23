
% 2020 May 31

function [spainfo_score, p_value] = calc_spainfo_p_function_4a4(n_shuffle, bin_size, sampling_rate, occ_timestamp, occ_position, spk_timestamp)


% % Get spike index
spk_index = [];

for iter = 1 : size(spk_timestamp, 1)

    temp_index = find(occ_timestamp == spk_timestamp(iter));

    if isempty(temp_index)
        continue;
    end

    spk_index(end+1, 1) = temp_index;
end
% % 


% % Get shuffled spatial information scores

for shuffle_iter = 1 : n_shuffle + 1
    
    % shuffling spike timestamps
    if shuffle_iter == n_shuffle + 1
        shift_index = 0;
    else        
        shift_index = randi(length(occ_timestamp) - 2000, 1);   % sufficiantly far from original position. same with JS's code
        shift_index = shift_index + 1000;
    end
    
    spk_index_shuffle = spk_index + shift_index;
    
    temp_index = spk_index_shuffle > length(occ_timestamp);
    spk_index_shuffle(temp_index) = spk_index_shuffle(temp_index) - length(occ_timestamp);
    
    spk_position_shuffle = occ_position(spk_index_shuffle);
    %
    
    % get spatial information score    
    temp_pos = [];
    temp_pos(:, 3) = occ_position;
    
    temp_spk = [];
    temp_spk(:, 3) = spk_position_shuffle;
    
    [occ_map_shuffle, ~, ~, smooth_map_shuffle] = abmFiringRateMap(temp_spk, temp_pos, 10000/bin_size, 1, bin_size, sampling_rate);    
    spainfo_score_shuffle(shuffle_iter, 1) = GetSpaInfo(occ_map_shuffle, smooth_map_shuffle);    
    %
    
end

% % 


% % Get p-value
spainfo_score = spainfo_score_shuffle(n_shuffle+1, 1);
spainfo_score_shuffle(n_shuffle+1) = [];

p_value = sum(spainfo_score_shuffle > spainfo_score) / n_shuffle;
% % 


end