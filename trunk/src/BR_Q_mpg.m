% BR_Q_mpg.m
% Bit rate and Quality trade-off in MPEG-1
%
% Capstone Multimedia Lab
% Department of Electrical and Computer Engineering
% University of Maryland, College Park
% This m file calls read_im_seq.m, write_im_seq.m, file_size and PSNR_seq.m.
% 
% Author: Guan-Ming Su

clear all;
close all;

%%%%%% parameters
frameN=10;
in_filename='..\images\foreman\fm';
out_filename='..\images\foreman\fm_mp1_';
mpg_filename='..\images\foreman.mpg';
fmt='tif';
mpg_option=[1 0 0 1 2 18 23 28];
Nframepersecond=30;
show_movie_flag=0;


% read a image sequence
M=read_im_seq(in_filename,fmt,frameN);
map=colormap;

% show the movie
if show_movie_flag==1
  figure
  movie(M)
end
% generate mpeg 
mpgwrite(M,map,mpg_filename,mpg_option);

% read the mpeg file
[nM]=mpgread(mpg_filename,1:frameN,'truecolor');
f_size=file_size(mpg_filename);
bitrate=8*f_size/(frameN/Nframepersecond);
% show the movie 
if show_movie_flag==1
  figure
  movie(nM)
end

% write out the image sequence
% Due to some bug in the movie object, the 2nd frame is the same with 1st, 
% we shift the image frame by minus 1
write_im_seq(nM,frameN,out_filename,fmt);

figure
% calculate PSNR
PSNR=PSNR_seq(in_filename,fmt,out_filename,fmt,frameN-1);
avePSNR=mean(PSNR)
bitrate
%plot(1:frameN-1,PSNR);
%title(strcat(' Bitrate:',num2str(bitrate),' average PSNR:',num2str(avePSNR)));