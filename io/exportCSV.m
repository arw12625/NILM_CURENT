function [ success ] = exportCSV( file, headers, data )

fid = fopen(file, 'wt');
fprintf(fid, strjoin(headers, ', '));
fprintf(fid, '\n');
for i=1:size(data,1)-1
   fprintf(fid, '%.3f, ', data(i,1:end - 1));
   fprintf(fid, '%.3f \n', data(i,end));
end
fprintf(fid, '%.3f, ', data(size(data,1),1:end - 1));
fprintf(fid, '%.3f', data(size(data,1),end));
fclose(fid);
success = 1;
end

