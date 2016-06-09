%find the indices of a list of names (exc) from another list (names)
function retindex = findIndices(exc, names)
retindex = [];
for i = 1:length(exc)
    retindex =  [retindex , find(strcmp(names, exc(i)))];
end
end