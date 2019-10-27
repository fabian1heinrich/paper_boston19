function data = read_binary (folder,filename)
% function data = read_binary (filename)
% Return data in vector called data. The file type is
% CMS binary, either real or complex.
% 
% Chad M. Spooner
% NorthWest Research Associates

% Check that file exists in current directory.

% localName = ['./' filename];
% if (exist(localName) == 0)
%    fprintf ('read_binary: file %s does not exist.\n', filename);
%    data = [];
%    return;
% end

file=fullfile(folder,filename);

% fid = fopen (filename, 'r');
fid=fopen(file,'r');
real_complex_flag = fread (fid, 1, 'int');
if (isempty(real_complex_flag) == 1)
   fprintf ('read_binary: file %s is empty.\n', filename);
   data = [];
   return;
end
N = fread (fid, 1, 'int');

if (real_complex_flag == 1)
   data = fread (fid, N, 'float');
else
   data2 = fread (fid, 2*N, 'float');
end

% If complex, demux the real and imag parts.

if (real_complex_flag == 2)
   data = data2(1:2:end) + sqrt(-1)*data2(2:2:end);
end

fclose (fid);

return;