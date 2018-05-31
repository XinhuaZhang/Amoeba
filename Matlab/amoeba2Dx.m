
function [amoeba_image] = amoeba2Dx(amoeba_struct)

% the following parameters should be packaged into an amoeba
if nargin == 0
    amoeba_struct = struct;
    rand('twister', sum(100*clock));
    amoeba_struct.rand_state = {rand('twister')};
    amoeba_struct.num_segments = 25;
    amoeba_struct.image_rect_size = 512;
    amoeba_struct.num_targets = 1;
    amoeba_struct.num_distractors = 1;
    amoeba_struct.segments_per_distractor = 2^(-2);  %as fraction of num_segments
    amoeba_struct.target_outer_max = 0.75;%1; %max/min outer radius of target annulus, units of image rect
    amoeba_struct.target_outer_min = 0.25;%0.5;
    amoeba_struct.target_inner_max = 0.75;%0.75; %max/min inner radius of target annulus, units of target outer radius
    amoeba_struct.target_inner_min = 0.25;%0.25;
    amoeba_struct.num_phi = 1024;
    amoeba_struct.num_fourier = min(10,amoeba_struct.num_phi);
    amoeba_struct.min_gap = 8;
    amoeba_struct.max_gap = 16;
elseif isempty( amoeba_struct.rand_state )
    rand('twister', sum(100*clock));
    amoeba_struct.rand_state = {rand('twister')};
%     last_trial = 0;
%     for i_trial = 1 : length(amoeba_struct.rand_state)
%         if isempty( amoeba_struct.rand_state )
%             last_trial = i_trial - 1;
%             break;
%         end
%     end
%     if last_trial == 0
%         last_trial = 1;
%         rand('twister', sum(100*clock));
%     end
%     rand('twister', amoeba_struct.rand_state{last_trial});
end

amoeba_image = cell( amoeba_struct.num_targets + amoeba_struct.num_distractors, 2 );

amoeba_struct.delta_phi = (2*pi)/amoeba_struct.num_phi;
amoeba_struct.fourier_arg = (0:(amoeba_struct.num_phi-1)) * amoeba_struct.delta_phi;
amoeba_struct.fourier_arg2 = ...
    repmat((0:(amoeba_struct.num_fourier-1))',[1, amoeba_struct.num_phi]) .* ...
    repmat( amoeba_struct.fourier_arg, [amoeba_struct.num_fourier, 1] );
% exponential is too regular...
% amoeba_struct.fourier_ratio = exp(-(0:(amoeba_struct.num_fourier-1))/amoeba_struct.num_fourier)';
amoeba_struct.fourier_ratio = ones(amoeba_struct.num_fourier, 1);
amoeba_struct.fourier_ratio(:) = 1.0 ./ [1:amoeba_struct.num_fourier]; 
amoeba_struct.delta_segment = amoeba_struct.num_phi / amoeba_struct.num_segments;

%make targets & distractors
for i_amoeba = 1 : amoeba_struct.num_targets
    [amoeba_image_x, amoeba_image_y] = amoebaSegments2x(amoeba_struct, 0);
    amoeba_image{i_amoeba, 1} = amoeba_image_x;
    amoeba_image{i_amoeba, 2} = amoeba_image_y;
end

%make distractors
for i_amoeba = amoeba_struct.num_targets + 1 : amoeba_struct.num_targets + amoeba_struct.num_distractors
    [amoeba_image_x, amoeba_image_y] = amoebaSegments2x(amoeba_struct, 1);
    amoeba_image{i_amoeba, 1} = amoeba_image_x;
    amoeba_image{i_amoeba, 2} = amoeba_image_y;
end
