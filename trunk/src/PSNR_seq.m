function PSNR=PSNR_seq(seq1_filename,seq1_fmt,seq2_filename,seq2_fmt,frameN)

% function PSNR=PSNR_seq(seq1_filename,seq1_fmt,seq2_filename,seq2_fmt,frameN)
% Calculate the PSNR between pairs of two image sequences.
%
%    seq1_filename : the 1st sequence filename without number, 
%                    e.g.  fm0001.tif, then in_filename='fm0001'
%    seq1_fmt: 1st sequence file format, e.g. fm0001.tif , fmt='tif'
%    seq2_filename : the 2nd filename without number, 
%    seq2_fmt: 2nd sequence file format,
%    frameN :  Number of frame in the video sequence
%    PSNR : a vector contains PSNR between pairs of two image sequences.
% Date : 10/27/2001
% Author : Guan-Ming Su


PSNR=zeros(1,frameN);
for i=1:1:frameN
  Im1=double(rgb2gray( imread( strcat(seq1_filename,sprintf('%04d',i),'.',seq1_fmt) ) ));
  Im2=double(rgb2gray( imread( strcat(seq2_filename,sprintf('%04d',i),'.',seq2_fmt) ) ));
  [image_rows image_cols]=size(Im1);
  PSNR(i)=10*log10(power(255,2)*image_cols*image_rows/sum(sum((Im1-Im2).^2)));
end  



