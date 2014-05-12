function res = skinDetectionTest(I, rect)

IS = skinDetection(I);
II = integralImage(IS);

res = [];

for i=1:size(rect, 1)
    res(end+1) = (integralImage(II, rect(i,:))/(rect(3)*rect(4)))*100;
end

end

