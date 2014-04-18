function D = rerange(D, new_min, new_max)

old_min = min(D);
old_max = max(D);

f = @(x)((x - old_min)*(new_max-new_min)/(old_max-old_min)-new_min);

for i=1:length(D)
    D(i) = f(D(i));
end

end

