function [img] = recoverImage(feature,weights,window_size,step_size)
    img_size = 256;
    img = zeros(img_size,img_size);
    count = 1;
    for i = 1:step_size:(img_size - window_size + 1)
        for j = 1:step_size:(img_size - window_size + 1)
            idx1 = i:i + window_size - 1;
            idx2 = j:j + window_size - 1;
            tmp = zeros(img_size,img_size);
            fea = reshape(feature(:,count),window_size,window_size);
            tmp(idx1,idx2) = fea; %normalized_fea;
            tmp = tmp.*weights(:,:,count);
            img = img + tmp;
            count = count +1;
        end
    end
    img(isnan(img))=0;
    min_value = min(img(:));
    max_value = max(img(:));
    img = (img - min_value) / (max_value - min_value);
end

