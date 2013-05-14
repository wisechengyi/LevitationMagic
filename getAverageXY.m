function [ meanX, meanY] = getAverageXY( contour)
count =0;
sumX =0;
sumY =0;
[height, width] = size(contour);

for i=1:height
    for j=1:width
        if contour(i,j)~=0
            count=count+1;
            sumX = sumX + j;
            sumY = sumY + i;
        end
    end
end


if count~=0
    meanX = sumX / count;
    meanY = sumY / count;
else
    meanX = -1;
    meanY = -1;
end

end