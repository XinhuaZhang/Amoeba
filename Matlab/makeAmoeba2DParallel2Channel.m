function data = makeAmoeba2DParallel2Channel(amoeba_struct,  i)
  data = cell(1);
  [amoeba_image] = amoeba2Dx(amoeba_struct, i);
  amoeba = zeros(amoeba_struct.image_rect_size,amoeba_struct.image_rect_size, 2);
  if amoeba_struct.num_targets == 1
    for i_amoeba = 1 : amoeba_struct.num_targets
      amoeba_image_x = amoeba_image{i_amoeba, 1};
      amoeba_image_y = amoeba_image{i_amoeba, 2};
      for i_seg = 1 : size(amoeba_image_x,1)
	for j = 1: size(amoeba_image_x{i_seg}(:))
	  idx_x = round(amoeba_image_x{i_seg}(j));
	  idx_y = round(amoeba_image_y{i_seg}(j));
	  if idx_x <= 0
	    idx_x = 1;
	  elseif idx_x > amoeba_struct.image_rect_size
	    idx_x = amoeba_struct.image_rect_size;
	  endif
	  if idx_y <= 0
	    idx_y = 1;
	  elseif idx_y > amoeba_struct.image_rect_size
	    idx_y = amoeba_struct.image_rect_size;
	  endif
	  amoeba(idx_x,idx_y,1) = 255;
	endfor      
      endfor 
    endfor
    xs = 2 : (1 + amoeba_struct.num_distractors);    
  else
    xs = 1 : amoeba_struct.num_distractors;
  endif

  for i_amoeba = xs
    amoeba_image_x = amoeba_image{i_amoeba, 1};
    amoeba_image_y = amoeba_image{i_amoeba, 2};
    for i_seg = 1 : size(amoeba_image_x,1)
      for j = 1: size(amoeba_image_x{i_seg}(:))
	idx_x = round(amoeba_image_x{i_seg}(j));
	idx_y = round(amoeba_image_y{i_seg}(j));
	if idx_x <= 0
	  idx_x = 1;
	elseif idx_x > amoeba_struct.image_rect_size
	  idx_x = amoeba_struct.image_rect_size;
	endif
	if idx_y <= 0
	  idx_y = 1;
	elseif idx_y > amoeba_struct.image_rect_size
	  idx_y = amoeba_struct.image_rect_size;
	endif
	amoeba(idx_x,idx_y,2) = 255;
      endfor
    endfor
  endfor
  data{1}.time = i;
  data{1}.values = amoeba;
endfunction
