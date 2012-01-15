function demo_mc2
% Full
%load mvFullCarphone.mat -mat;
% 3-step
load mv3stepCarphone.mat -mat;
% Motion Compensation (Estimate current frame)
ref = imgread('../images/carphone0195.tif');
est = uint8(mc(double(ref), mv));
figure;imshow(est);title('Estimated carphone0916.tif');
imwrite(est, '../images/estCarphone0916.tif');
% Motion Compensation Residual (diff)
cur = imgread('../images/carphone0196.tif');
est = imgread('../images/estCarphone0916.tif');
residual = double(cur) - double(est);
figure;imshow(residual, [min(min(residual)) max(max(residual))]);
title('Motion Compensation Residual');
% mean absolute difference
[M N] = size(residual);
MAD = sum(sum(abs(residual))) / (M*N);
fprintf('The mean absolute difference is %f\n', MAD);
end