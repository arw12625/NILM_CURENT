%reconstruct signal from events eg integrate first difference
function  data= integrateEvent(eventTime, eventMag, totalTime)

    eventIntegral = eventMag;
    diffTime = eventTime;
    for i = 2: length(eventIntegral)
    eventIntegral(i) = (eventIntegral(i-1) + eventIntegral(i));
    diffTime(i) = eventTime(i) - eventTime(i-1);
    end
    data =  generateData([eventTime(1)-1,diffTime], [0,eventIntegral]);
    plot(data);
end

