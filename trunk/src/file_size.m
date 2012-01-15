function f_size=file_size(filename)

% function f_size=file_size(filename)
% return the file size f
%  
%   filename : name of file 
% Date : 10/27/2001
% Author : Guan-Ming Su


[fid,message]=fopen(filename,'r');
status = fseek(fid,0,'eof');
f_size = ftell(fid);
status=fclose(fid);

