function [mv MMAD] = mefull(ref, cur, N1, N2, R)
% Motion Estimation using Exhaustive (Full) Block Matching algorithm
%
%  mv = mefull(ref, cur, N1, N2, R)
%
% Input arguments ([]s are optional):
%  ref (matrix) of size NRxNC: reference frame image
%  cur (matrix) of size NRxNC: current freme image
%  N1 (scalar): row block size. Default is 16.
%  N2 (scalar): column block size. Default is 16.
%  R (scalar): search range block size (2R >= N1 or N2). Default is 16
%
% Output arguments ([]s are optional):
%  mv: motion vectors for each block
%   mv.x (matrix) of size NR/N1xNC/N2: for x (col) direction
%   mv.y (matrix) of size NR/N1xNC/N2: for y (row) direction
%  [MMAD] (matrix) of size NR/N1xNC/N2: Minimum Mean Absolute Difference
%   value for each block
%
% Author: Naotoshi Seo <sonots(at)umd.edu>
% Date  : April 2007

% Input Argument Check
[nRow, nCol, nColor] = size(ref);
if nColor > 1,
    error('Only grayscale images are accepted.');
end
if nargin < 3,
    N1 = 16;
end
if nargin < 4,
    N2 = 16;
end
if nargin < 5,
    R = 16;
end

nBlockCol = floor(nCol/N2);
nBlockRow = floor(nRow/N1);
for n2=0:(nBlockCol-1)
    sCol = n2*N2+1; eCol = sCol+N2-1; indsCol = sCol:eCol;
    for n1=0:(nBlockRow-1)
        sRow = n1*N1+1; eRow = sRow+N1-1; indsRow = sRow:eRow;
        cur_block = cur(indsRow, indsCol);
        MSAD(n1+1, n2+1) = Inf;
        for d2=-R:R-1
            if d2 + sCol < 1 || d2 + eCol > nCol, continue;, end;
            for d1=-R:R-1
                if d1 + sRow < 1 || d1 + eRow > nRow, continue;, end;
                ref_block = ref(indsRow+d1, indsCol+d2);
                % Sum Abosolute Difference
                SAD = sum(sum(abs(ref_block - cur_block)));
                % Minimum Index
                if SAD < MSAD(n1+1, n2+1)
                    MSAD(n1+1, n2+1) = SAD;
                    mv.y(n1+1, n2+1) = d1;
                    mv.x(n1+1, n2+1) = d2;
                end
            end
        end
        %pause
        %fprintf('Block (%d, %d) is done (%d, %d).\n',...
        %    n1+1, n2+1, mv.x(n1+1, n2+1), mv.y(n1+1, n2+1));
    end
end
if nargout > 1,
    % Mean Absolute Difference
    MMAD = MSAD ./ (nBlockRow * nBlockCol);
end