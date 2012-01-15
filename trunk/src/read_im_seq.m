function M=read_im_seq(in_filename,fmt,frameN)

% function [M,map]=read_im_seq(in_filename,fmt,frameN)
% read a image sequences and return a movie object
%
%   in_filename : the input filename without number, 
%                 e.g.  fm0001.tif, then in_filename='fm0001'
%   fmt: input file format, e.g. fm0001.tif , fmt='tif'
%   frameN : Number of frame in the video sequence
%   M : movie object
%
%  Date : 10/27/2001
%  Author: Guan-Ming Su

M=moviein(frameN);
for i=1:1:frameN
  M(i)=im2frame(imread(strcat(in_filename,sprintf('%04d',i),'.tif')));
end  



