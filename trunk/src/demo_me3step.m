function demo_me_3step
%  ref = imgread('../images/car1.bmp');
%  cur = imgread('../images/car2.bmp');
%  ofname = 'mv3stepCar.mat';
 ref = imgread('../images/carphone0195.tif');
 cur = imgread('../images/carphone0196.tif');
 ofname = 'mv3stepCarphone.mat';
 %  ref = repmat(1:64, 64, 1);
 %  cur = repmat(12+(1:64), 64, 1);
 N1 = 16; N2 = 16; R = 16;
 tic
 [mv MMAD] = me3step(double(ref), double(cur), N1, N2, R);
 toc
 [nRow nCol] = size(ref);
 nBlockRow = floor(nRow / N1);
 nBlockCol = floor(nCol / N2);
 [X Y] = meshgrid(1:nBlockCol, 0:-1:-nBlockRow+1);
 figure;quiver(X, Y, mv.x, -mv.y);
 eval(sprintf('save %s mv -mat', ofname));
end
