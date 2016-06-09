%remove empty columns from file
function names = getnonnull(path)
fid = fopen(path);
len = length(strsplit(fgets(fid), ','));
fclose(fid);
fid = fopen(path);
C = textscan(fid, repmat('%s',1,len), 'delimiter',',', 'CollectOutput',true);
C = C{1};
fclose(fid);

names = strjoin(cellfun(@(X) strrep(X, '"', ''), C(1,(find(~cellfun(@isempty, C(2,:))))), 'UniformOutput', false), ', ');