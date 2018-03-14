function [id] = generate_id(n)
chars = ['0':'9' 'a':'z' 'A':'Z'];
id = randsample(chars, n);
end
