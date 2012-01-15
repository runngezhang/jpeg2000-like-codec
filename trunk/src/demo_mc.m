function demo_mc
% Full
load mvFullCar.mat -mat; % mv
% 3-step
%load mv3stepCar.mat -mat;
% Motion Compensation (Estimate current frame)
ref = imgread('../images/car1.bmp');
est = uint8(mc(double(ref), mv));
figure;imshow(est);title('Estimated Car2.bmp');
imwrite(est, '../images/estCar2.bmp');
% Motion Compensation Residual (diff)
cur = imgread('../images/car2.bmp');
est = imgread('../images/estCar2.bmp');
residual = double(cur) - double(est);
figure;imshow(residual, [min(min(residual)) max(max(residual))]);
title('Motion Compensation Residual');
% mean absolute difference
[M N] = size(residual);
MAD = sum(sum(abs(residual))) / (M*N);
fprintf('The mean absolute difference is %f\n', MAD);
end