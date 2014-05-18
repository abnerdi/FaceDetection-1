function IL = LBP(image)

global I;

if ndims(image) == 3
    I = rgb2gray(image);
else
    I = image;
end

IL = zeros(size(I), 'uint8');

N = size(I,1);
M = size(I,2);

I = [I(:,1) I I(:,end)];
I = [I(1,:); I; I(end,:)];

for i=2:N+1
    for j=2:M+1
        
        bin = [I(i-1,j-1) > I(i,j),...
               I(i-1,j)   > I(i,j),...
               I(i-1,j+1) > I(i,j),...
               I(i,  j+1) > I(i,j),...
               I(i+1,j+1) > I(i,j),...
               I(i+1,j)   > I(i,j),...
               I(i+1,j-1) > I(i,j),...
               I(i,  j-1) > I(i,j)];
           
        last = bin(1);
        k = 0;
        for q=2:8
            if bin(q) ~= last
                k = k + 1;
            end
            last = bin(q);
        end
        
        if k < 3
            IL(i-1,j-1) = b2d(bin);
        else
            IL(i-1,j-1) = 0;
        end
        
        %IL(i,j) = pattern(i,j);
    end
end
end

function dec = pattern(i, j)

global I;
P = zeros(3,3);

for q=i-1:i+1
    for w=j-1:j+1
        if I(q,w) > I(i,j)
            P(q-i+2, w-j+2) = 1;
        end
    end
end

% нужно его сделать РЛБШ

P = P';
bin = [P(1:3), P(6), P(9), P(8), P(7), P(4)];

last = bin(1);
k = 0;
for i=2:8
    if bin(i) ~= last
        k = k + 1;
    end
    last = bin(i);
end

if k < 3
    dec = bi2de(bin, 'left-msb');
else
    dec = 0;
end

end
