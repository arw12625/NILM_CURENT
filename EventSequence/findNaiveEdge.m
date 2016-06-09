%find events/edges in data based on the first difference and threshold
%collect combines consecutive events into one
function [ eventTime, eventMag ] = findEvents( data, threshold, collect )

len = length(data);
diff = (data(2:len) - data(1:len-1));

eventTime = find(abs(diff) > threshold);
eventMag = diff(eventTime);

eventNum =length(eventTime);

if collect
for i = 2:eventNum
if (eventTime(i) - eventTime(i-1) == 1 && sign(eventMag(i)) == sign(eventMag(i-1)) )
    eventMag(i) = eventMag(i) + eventMag(i-1);
    eventMag(i-1) = 0;
    eventTime(i-1) = 0;
end
end
end

eventTime = eventTime(eventMag~=0);
eventMag = eventMag(eventMag~=0);


end

