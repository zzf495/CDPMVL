function [data, weights_of_img, hotY] = cutImages(img, window_size, step_size)
    if nargin < 1
        error('Input image is required.');
    end
    if nargin == 1
        window_size = 32;
        step_size = 16;
    elseif nargin == 2
        step_size = floor(window_size / 2);
    end

    % Resize image to 256x256
    img = imresize(img, [256, 256]);
    [rows, cols, ~] = size(img);
    
    % Calculate number of windows
    num_windows_row = floor((rows - window_size) / step_size) + 1;
    num_windows_col = floor((cols - window_size) / step_size) + 1;
    
    % Pre-allocate arrays
    data = zeros(window_size * window_size, num_windows_row * num_windows_col);
    weights_of_img = zeros(rows, cols, num_windows_row * num_windows_col);
    weights = zeros(rows, cols);
    hotY = zeros(num_windows_row * num_windows_col, num_windows_row * num_windows_col);
    
    % Window extraction
    count = 1;
    for i = 1:step_size:(rows - window_size + 1)
        for j = 1:step_size:(cols - window_size + 1)
            % Extract window
            window = double(img(i:i + window_size - 1, j:j + window_size - 1, :));
            data(:, count) = reshape(window, window_size * window_size, 1) / 255;

            % Normalize window
            min_value = min(window(:));
            max_value = max(window(:));
            if max_value > min_value
                normalized_fea = (window - min_value) / (max_value - min_value);
            else
                normalized_fea = window; % No normalization needed
            end

            weights_of_img(i:i + window_size - 1, j:j + window_size - 1, count) = normalized_fea;
            weights = weights + weights_of_img(:, :, count);
            hotY(count, i) = hotY(count, i) + 0.5;
            hotY(count, num_windows_row + j) = 0.5;
            count = count + 1;
        end
    end
    
    % Normalize weights_of_img
    for i = 1:num_windows_row * num_windows_col
        if any(weights(:)) % Check if weights contain non-zero values
            weights_of_img(:, :, i) = weights_of_img(:, :, i) ./ weights;
        end
    end
    hotY = hotY * hotY';
end
