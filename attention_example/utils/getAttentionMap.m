function [attentions] = getAttentionMap(similarity,weights)
    img_size = 256;
    attentions = zeros(img_size,img_size);
    n = size(similarity,2);
    for i = 1:n
       for j = i:n
           w1 = weights(:,:,i);
           w2 = weights(:,:,j);
           attentions = attentions + (w1 + w2) * similarity(i,j)./2;
       end
    end
    [val,idx] = sort(attentions(:));
    maxVal = val(floor(0.8*length(idx)));
    attentions(attentions<maxVal)=0;
end

