
% 2021 May 21

clc;
clear all;
close all;

rng('shuffle');

% % Input
mother_root = 'H:\VR';
cluster_list_file = [mother_root '\7) ephys analysis\cluster_id_pilot1.csv'];
% %

% % Output
save_root = [mother_root '\7) ephys analysis\4\a\4'];

if ~exist([save_root '\figures2'], 'dir')
    mkdir([save_root '\figures2']);
end

if ~exist([save_root '\mat files2'], 'dir')
    mkdir([save_root '\mat files2']);
end
% %


% % Setting
addpath(genpath([mother_root '\5) analysis programs\4\zz']));
addpath([mother_root '\5) analysis programs\4\a\4']);

cluster_fid = fopen(cluster_list_file, 'r');
cluster_list = textscan(cluster_fid, '%s');
cluster_list = cluster_list{1,1};
% %


% % Batch
for cl_iter = 1 : length(cluster_list)
    
    [occ_map, spk_map, raw_map, smooth_map, raw_mean_fr, raw_peak_fr, smooth_mean_fr, smooth_peak_fr, trial_number, spike_number, ...
        spainfo_score, p_spainfo, corrected_parsed_position, corrected_parsed_spike, fh, sheet_position] = condition_sheet2_function_4a4(mother_root, cluster_list{cl_iter});
    
    % save
    save([save_root '\mat files2\' cluster_list{cl_iter} '.mat'], 'occ_map', 'spk_map', 'raw_map', 'smooth_map', 'raw_mean_fr', 'raw_peak_fr', 'smooth_mean_fr', ...
        'smooth_peak_fr', 'trial_number', 'spike_number', 'spainfo_score', 'p_spainfo', 'corrected_parsed_position', 'corrected_parsed_spike');
    
    cd([save_root '\figures2']);
    saveImage(fh, [cluster_list{cl_iter} '.png'], 'pixel', sheet_position);
    %
    
    disp([num2str(cl_iter) ' / ' num2str(length(cluster_list)) ', cluster ' cluster_list{cl_iter} ' is done']);
    
end
% %

