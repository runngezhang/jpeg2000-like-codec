function [y, codewords, pad] = huffman(x, symbols)
% Huffman Encoding
%
%  [y, codewords, pad] = huffman(x)
%
% Input arguments ([]s are optional):
%  x (vector) of size 1xN: Input Symbol row vector (uint8)
%  [symbols] (vecotr) of size 1xP: Sets of possible symbols (uint8)
%
% Output arguments ([]s are optional):
%  y (vector) of size 1xP: Compressed Output vector (uint8)
%  [codewords] (vector): Huffman codewords;
%      Codewords are stored in the 52 available bits of a double. 
%      To avoid ambiguities, after the last codeword bit, 
%      a "1" bit is added to terminate the codeword.
%      The max codeword length can be 51 bits.
%    For example)
%      (3,1)      122
%      (6,1)      116
%      (8,1)      110
%     (12,1)      112
%    means 122 => 1 (3 = 11 -> 1), 116 => 01 (6 = 110 -> 10 -> 01), 
%    110 => 000 (8 = 1000 -> 000), 112 => 001 (12 = 1100 -> 100 -> 001)
%  [pad] (scalar): # of zero padded bits to make uint8 output
%
% See also: ihuffman.m

% ensure to handle uint8 input vector
if isempty(x)
    y = [];
    codewords = [];
    pad = [];
    return;
end
if ~isa(x,'uint8'),
	error('input argument must be a uint8 vector')
end

% x as a row
x = x(:)';

% frequency (at below)
f = frequency(x);

% symbols presents in the vector are
if nargin < 2,
    symbols = find(f~=0); % first value is 1 not 0!!!
else
    symbols = symbols + 1; % first value is 1 not 0!!!
end
f = f(symbols);

% sort using the frequency
[f,sortindex] = sort(f);
symbols = symbols(sortindex);

% generate the codewords as the 52 bits of a double
len = length(symbols);
symbols_index = num2cell(1:len);
codeword_tmp = cell(len,1);
while length(f)>1,
	index1 = symbols_index{1};
	index2 = symbols_index{2};
	codeword_tmp(index1) = addnode(codeword_tmp(index1),uint8(0));
	codeword_tmp(index2) = addnode(codeword_tmp(index2),uint8(1));
	f = [sum(f(1:2)) f(3:end)];
	symbols_index = [{[index1 index2]} symbols_index(3:end)];
	% resort data in order to have the two nodes with lower frequency as first two
	[f,sortindex] = sort(f);
	symbols_index = symbols_index(sortindex);
end

% arrange cell array to have correspondance simbol <-> codeword
codeword = cell(256,1);
codeword(symbols) = codeword_tmp;

% calculate full string length
len = 0;
for index=1:length(x),
	len = len+length(codeword{double(x(index))+1});
end
	
% create the full 01 sequence
string = repmat(uint8(0),1,len);
pointer = 1;
for index=1:length(x),
	code = codeword{double(x(index))+1};
	len = length(code);
	string(pointer+(0:len-1)) = code;
	pointer = pointer+len;
end

% calculate if it is necessary to add padding zeros
len = length(string);
pad = 8-mod(len,8);
if pad>0,
	string = [string uint8(zeros(1,pad))];
end

% now save only usefull codewords
codeword = codeword(symbols);
codelen = zeros(size(codeword));
weights = 2.^(0:51);
maxcodelen = 0;
for index = 1:length(codeword),
	len = length(codeword{index});
	if len>maxcodelen,
		maxcodelen = len;
	end
	if len>0,
		code = sum(weights(codeword{index}==1));
		code = bitset(code,len+1);
		codeword{index} = code;
		codelen(index) = len;
	end
end
codeword = [codeword{:}];

% calculate zipped vector
cols = length(string)/8;
string = reshape(string,8,cols);
weights = 2.^(0:7);
y = uint8(weights*double(string));

% store data into a sparse matrix
codewords = sparse(1,1); % init sparse matrix
for index = 1:numel(codeword),
	codewords(codeword(index),1) = symbols(index);
end

% create info structure
% info.pad = pad;
% info.codewords = codewords;
% info.length = length(x);
% info.ratio = cols./length(x);
% info.maxcodelen = maxcodelen;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function codeword_new = addnode(codeword_old,item)
codeword_new = cell(size(codeword_old));
for index = 1:length(codeword_old),
	codeword_new{index} = [item codeword_old{index}];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function f = frequency(x)
%FREQUENCY   Simbols frequencies
%   For vectors, FREQUENCY(X) returns a [1x256] sized double array with frequencies
%   of symbols 0-255.
%
%   For matrices, X(:) is used as input.
%
%   Input must be of uint8 type, while the output is a double array.
% ensure to handle uint8 input vector
if ~isa(x,'uint8'),
	error('input argument must be a uint8 vector')
end
% create f
f = histc(x(:), 0:255); f = f(:)'/sum(f); % always make a row of it
