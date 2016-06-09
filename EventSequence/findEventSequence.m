%events are defined as a transition between steady states above threshold.
%event sequences are defined as a list of consecutive events such that the
%power never drops below the original and the power ends at the original
%level. this represents a possible combination of devices cycling

function [sequences] = findEventSequence(powerData, initThreshold, thresholdWeight)

sequences = {};
i = 1;
sequenceIndex = 1;
%iterate sequences
while(i <= length(powerData))
    threshold = initThreshold;
    sequence = [;];
    invalid = false;
    finished = false;
    initValue = powerData(i);
    currentValue = initValue;
    eventIndex = 1;
    %iterate events
    while(i <= length(powerData) && ~invalid && ~finished)
        %iterate values
        while(i <= length(powerData) &&  abs(currentValue - powerData(i)) < threshold)
            i = i + 1;
        end
        if i <= length(powerData)
            eventSign = sign(powerData(i) - currentValue);
            previousValue = currentValue;
            while(i <= length(powerData) && sign(powerData(i) - previousValue) == eventSign)
                previousValue = powerData(i);
                i = i + 1;
            end
            i = i-1;
        end
        
        invalid = (i > length(powerData)) || (powerData(i) <= initValue - threshold);
        
        if(~invalid)
            sequence(1, eventIndex) = i;
            sequence(2, eventIndex) = powerData(i) - currentValue;
            eventIndex = eventIndex + 1;
            finished = (abs(powerData(i) - initValue) < threshold);
            %threshold = (thresholdWeight*threshold + abs(powerData(i) - currentValue))/(thresholdWeight + 1);
            currentValue = powerData(i);
                
        end
        i = i + 1;
    
    end
    if(finished)
        sequences{sequenceIndex} = sequence;
        sequenceIndex = sequenceIndex + 1;
    end
end
