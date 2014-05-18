function ISkin = skinDetection(I)
% �������� �� ������� ����������� �����, ������� �� ���� ����.
% I - ������� �����������.
% ISkin - �����-����� ����������� � ���������� ����� ����.

sig1 = 10.3;
sig2 = 8.4;
m1 = 42.91;
m2 = 32.28;

r = (double(I(:,:,1))./sum(I,3))*100;
g = (double(I(:,:,2))./sum(I,3))*100;

ISkin = false(size(r));

ISkin = abs(r-m1)<sig1 & abs(g-m2)<sig2;

end

