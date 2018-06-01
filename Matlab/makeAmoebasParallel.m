close all
clear all
setenv("GNUTERM", "x11");


## global amoeba_struct

amoeba_struct                         = struct;
amoeba_struct.name                    = 'amoeba2D';
rand('twister', sum(100*clock));
amoeba_struct.rand_state              = {rand('twister')};
amoeba_struct.num_segments            = 2^3;
amoeba_struct.image_rect_size         = 256;
amoeba_struct.num_targets             = 1;
amoeba_struct.num_distractors         = 3 - amoeba_struct.num_targets;
amoeba_struct.segments_per_distractor = 2^(-1);  % 2^(-2);%as fraction of num_segments
amoeba_struct.target_outer_max        = 0.85;%1; %max/min outer radius of target annulus, units of image rect
amoeba_struct.target_outer_min        = 0.15;%0.5;%1.0;%
amoeba_struct.target_inner_max        = 0.5;%0.75;%1.0;% %max/min inner radius in units of outer radius
amoeba_struct.target_inner_min        = 0.15;%0.25;%1.0;%
amoeba_struct.num_phi                 = 1024;
amoeba_struct.num_fourier             = 4;
amoeba_struct.min_gap                 = 8; %%16;
amoeba_struct.max_gap                 = 16; %%32;
amoeba_struct.base_shape              = 0;
amoeba_struct.root_path               = '/home/xzhang/Workspaces/Amoeba/Matlab/amoeba2D';
amoeba_struct.foldername              = "target";

num_trials = 500;
plot_amoeba2D = 1;
plot_skip = 1;
fmt_trial_str = "%05i";
  
[STATUS, MSG, MSGID]                  = mkdir(amoeba_struct.root_path);
num_fourier_pow2 = 2.^[1:6];
for num_fourier = num_fourier_pow2
    
  amoeba_struct.num_fourier = num_fourier;
  amoeba2D_parent_foldername          = [num2str(num_fourier), 'FC'];
  [STATUS, MSG, MSGID]                = mkdir(amoeba_struct.root_path, amoeba2D_parent_foldername);

  for num_targets = 0 : 1
    
    amoeba2D_filename_root = ['amoeba_', num2str(num_targets), '_', num2str(num_fourier)];
  
    if num_targets > 0
      amoeba_struct.num_targets     = 1;
      amoeba2D_foldername           = 'target';
    else
      amoeba_struct.num_targets     = 0;
      amoeba2D_foldername           = 'distractor';
    endif
    amoeba_struct.num_distractors   = 5 - amoeba_struct.num_targets;
    amoeba_struct.foldername        = amoeba2D_foldername;
    amoeba2D_parent_folderpath      = [amoeba_struct.root_path, filesep, amoeba2D_parent_foldername];
    [STATUS, MSG, MSGID]            = mkdir(amoeba2D_parent_folderpath, amoeba2D_foldername);
    
    
    amoeba_struct_cell = cell(1,num_trials);
    fileName_cell = cell(1,num_trials);
    i_cell = cell(1,num_trials);
    for i = 1:num_trials
      amoeba_struct_cell{i} = amoeba_struct;
      fileName_cell{i} = [amoeba2D_parent_folderpath, filesep, amoeba2D_foldername, filesep, [amoeba2D_filename_root, '_', num2str(i, fmt_trial_str)]];     
      i_cell{i} = i;
    endfor
    parcellfun(8,"makeAmoeba2DParallel", amoeba_struct_cell,fileName_cell,i_cell);
  endfor % num_fourier_pow2
  
endfor % for num_targets

  
