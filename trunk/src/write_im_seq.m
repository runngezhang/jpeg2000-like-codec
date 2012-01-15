function write_im_seq(M,frameN,out_filename,fmt)


% function write_im_seq(M,frameN,out_filename,fmt)
% read a movie object and write out a image sequences 
%
%   M : movie object
%   frameN : Number of frame in the video sequence
%   out_filename : the output filename without number, 
%                 e.g.  fm0001.tif, then in_filename='fm0001'
%   fmt: input file format, e.g. fm0001.tif , fmt='tif'
%
%  Date : 10/27/2001
%  Author: Guan-Ming Su

for i=2:1:frameN
  [Im map]=frame2im(M(i));
  imwrite(Im,strcat(out_filename,sprintf('%04d',i-1),'.',fmt),fmt);
end  
