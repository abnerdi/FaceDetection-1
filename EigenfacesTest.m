function res = EigenfacesTest(I, rect)

IG = rgb2gray(I);

res = [];

for i=1:size(rect, 1)
    res(end+1) = (integralImage(II, rect(i,:))/(rect(i,3)*rect(i,4)))*100;
    if res(end)<4
       figure;
       imshow(IS);
       rH = rectangle('Position',rect(i,:));
       set(rH,'edgecolor','b');
    end
end

end

