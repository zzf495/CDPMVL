addpath('./utils');
window_size = 32; % the window size of image
step_size = 16; % the step size of image
alpha = 0.6; % hyperparameter for alpha combine.

% images setting: read images and resize them.
img1 = imread('figs/wolf_10009.jpg'); % giant+panda_10047.jpg
img1=rgb2gray(img1);img1 = imresize(img1, [256, 256]);
[data1,weights,hotY] = cutImages(img1,window_size,step_size);
img2 = imread('figs/wolf_10016.jpg'); % giant+panda_10048.jpg
img2=rgb2gray(img2);img2 = imresize(img2, [256, 256]);
[data2,~] = cutImages(img2,window_size,step_size);
img3 = imread('figs/wolf_10134.jpg'); % giant+panda_10049.jpg
img3=rgb2gray(img3);img3 = imresize(img3, [256, 256]);
[data3,~] = cutImages(img3,window_size,step_size);
data1 =normr(data1')';
data2 =normr(data2')';
data3 =normr(data3')';
X = {data1,data2,data3};
Y = 1:size(data3,2);
% load the learned matrices from CDPMVL.
load('result.mat');
idx = 1;
%% show the results of anchors.
orgin_img = {img1,img2,img3};
for view = 1:3
    %% orignal images
    save_figure(orgin_img{view},idx);idx = idx +1;
    %% results of anchor K
    [img] = recoverImage(K{view},weights,window_size,step_size);
    save_figure(img,idx);idx = idx +1;
    %% results of consistent similarity S
    [attentions] = getAttentionMap(S,weights); % A
    [img,~] = alphaCombine(orgin_img{view},attentions,alpha);
    save_figure(img,idx);idx = idx +1;
    %% results of partial-view-shared similarity P
    [attentions] = getAttentionMap(P{view},weights);
    [img,~] = alphaCombine(orgin_img{view},attentions,alpha);
    save_figure(img,idx);idx = idx +1;
    %% results of anchor * consistency K'S
    [img] = recoverImage(K{view}*S,weights,window_size,step_size);
    save_figure(img,idx);idx = idx +1;
    %% results of partial-view-shared knowledge K'P
    [img] = recoverImage(K{view}*P{view},weights,window_size,step_size);
    save_figure(img,idx);idx = idx +1;
    %% results of noise E
    [img] = recoverImage(E{view},weights,window_size,step_size);
    tmp=img - double(orgin_img{view})./255;
    min_value = min(tmp(:));
    max_value = max(tmp(:));
    tmp = (tmp - min_value) / (max_value - min_value);
    save_figure(tmp,idx);idx = idx +1;
    %% results of fusion knowledge K'G
    [img] = recoverImage(K{view}*G,weights,window_size,step_size);
    save_figure(img,idx);idx = idx +1;
end

function save_figure(img,idx)
    idxx =  (96 + mod(idx-1,26)+1);
    letter = char(idxx);
    pathh=['./plot/Fig. 13' letter '.png'];
    imwrite(img, pathh);
    fprintf('save [%d] to %s\n',idx,pathh);
end