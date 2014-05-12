function outRect = reductionRect(inRect, percent)
% ������� ��� �������� ���������� ���������� ���.
% inRect.rect - ���������� ��������������� ���.
% inRect.dist - ���������.

a = struct('dist', num2cell(inRect.dist), 'rect', num2cell(inRect.rect, 2)');
a = nestedSortStruct(a, 'dist');

for i=1:length(a)
    
    if i >= length(a)
        break;
    end
   
    delInd = [];
    for k=i+1:length(a)
        if inRectPercent(a(i).rect, a(k).rect, percent)
            delInd(end+1) = k;
        end
    end
    
    a(delInd) = [];
    
end

outRect = a;

end

