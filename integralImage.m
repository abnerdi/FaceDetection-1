function integral = integralImage(I, rect)
% Интегральное представление изображения.
% Выполняет две функции:
%   1. Вычисляет интегральное изображение,
%   2. Вычисляет значение в заданной области rect.


if nargin < 2

    integral = zeros(size(I));

    integral(1, 1) = I(1, 1);

    for i=2:size(I,1)
       integral(i, 1) =  I(i, 1) + integral(i - 1, 1);
    end

    for j=2:size(I,2)
       integral(1, j) =  I(1, j) + integral(1, j-1);
    end

    for i=2:size(I,1)
        for j=2:size(I,2)
            integral(i, j) = I(i, j) - integral(i-1, j-1) + ...
                integral(i, j-1) + integral(i-1, j);
        end
    end

else
    rect(3) = rect(1) + rect(3) - 1;
    rect(4) = rect(2) + rect(4) - 1;
    if rect(1) == 1 && rect(2) == 1
        integral = I(rect(4), rect(3));
    elseif rect(2) == 1
        integral = I(rect(4), rect(3)) - I(rect(4), rect(1) - 1);
    elseif rect(1) == 1
        integral = I(rect(4), rect(3)) - I(rect(2) - 1, rect(3));
    else
        integral = I(rect(4), rect(3)) - I(rect(4), rect(1) - 1) - ...
            I(rect(2) - 1, rect(3)) + I(rect(2) - 1, rect(1) - 1);
    end
end

end