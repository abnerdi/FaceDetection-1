function I = vec2img(vec, height, width)

k = 1;
I = zeros(width, height, 'uint8');
for i=1:width
    for j=1:height
        I(i, j) = vec(k);
        k = k + 1;
    end
end

end