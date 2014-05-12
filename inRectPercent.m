function isInRect = inRectPercent(rect1, rect2, percent)
% ������� ������� ��������� ������ �������������� � ������.

dS = rectint(rect1, rect2);
avgS = (rect1(3)*rect1(4)+rect2(3)*rect2(4))/2;
isInRect =  (100/avgS)*dS >= percent;

end

