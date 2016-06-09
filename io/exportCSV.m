function [ success ] = exportCSV( file, headers, data )

fid = fopen(file, 'wt');
fprintf(fid, strjoin(headers, ', '));
fprintf(fid, '\n');
for i=1:size(data,1)
   fprintf(fid, '%d, ', data(i,1:end - 1));
   fprintf(fid, '%d \n', data(i,end));
end
fclose(fid);
success = 1;
end

