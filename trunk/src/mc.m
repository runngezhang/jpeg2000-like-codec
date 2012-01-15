function est = mc(ref, mv)
% Motion Compensation
%
%  est = mc(ref, mv)
%
% Input arguments ([]s are optional):
%  ref (matrix) of size nRow x nCol: reference frame image
%  mv: motion vectors for each block
%   mv.x (matrix) of size nBlockRow x nBlockCol: for x direction
%   mv.y (matrix) of size nBlockRow x nBlockCol: for y direction
%
% Output arguments ([]s are optional):
%  est (matrix) of size nRow x nCol: estimated current frame image
%
% Author: Naotoshi Seo <sonots(at)umd.edu>
% Date  : April 2007

[nRow, nCol] = size(ref);
[nBlockRow, nBlockCol] = size(mv.x);
N2 = floor(nCol / nBlockCol);
N1 = floor(nRow / nBlockRow);
est = zeros(nRow, nCol);
for n2=0:(nBlockCol-1)
    sCol = n2*N2+1; eCol = sCol+N2-1; indsCol = sCol:eCol;
    for n1=0:(nBlockRow-1)
        sRow = n1*N1+1; eRow = sRow+N1-1; indsRow = sRow:eRow;
        d1 = mv.y(n1+1, n2+1);
        d2 = mv.x(n1+1, n2+1);
        est(indsRow, indsCol) = ref(indsRow+d1, indsCol+d2);
    end
end
end
