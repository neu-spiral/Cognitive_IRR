function GLRT_evaluation_module(config, LOS_vector, Y, X, A_nonopt, T_rangecell)

close all,
values_vector = 9.5:0.01:10.5;
n_values = size(values_vector,2);
GLRT = ones(n_values, n_values);
GLRT_index = zeros(n_values, n_values, 2);
GLRT_plot = zeros(1, n_values*n_values);
x_axis = zeros(1, n_values*n_values);
y_axis = zeros(1, n_values*n_values);
n=1;
for i = 1:n_values
    v_x = values_vector(i);
    for j = 1:n_values
        v_y = values_vector(j);
        GLRT(i, j) = get_OFDM_GLRT([v_x; v_y], config, LOS_vector, Y, X, A_nonopt, T_rangecell);
        GLRT_index(i, j, :) = [v_x; v_y];
        GLRT_plot(n) = GLRT(i, j);
        x_axis(n) = v_x;
        y_axis(n) = v_y;
        n = n+1;
%         if GLRT(i, j) == 0
%             disp([v_x; v_y])
%             GLRT(i, j) = get_OFDM_GLRT([v_x; v_y], config, LOS_vector, Y, X, A_nonopt, T_rangecell);
%         end
    end
end
scatter3(x_axis, y_axis, GLRT_plot)
xlabel('v_x', 'fontsize', 20)
ylabel('v_y', 'fontsize', 20)
title('GLRT(v) CLAIRVOYANT (known X coefficients)', 'fontsize', 20)
disp('debug GLRT')

close all
figure()
mesh(GLRT)
colorbar

plot(values_vector, GLRT(:, 50))
plot(values_vector, GLRT(50, :))

[min_GLRT, index_min_GLRT] = min(GLRT, [], 'all')
[row,col] = ind2sub(size(GLRT), index_min_GLRT)