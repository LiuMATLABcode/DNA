function [ n ] = f( v )
%UNTITLED6 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
S = 1./(1+exp(-v));
for i = 1:length(v)
    r = rand();
    if r>1/2 && r< S(i)
        n(i) = 0;
    elseif r<1/2 && r< S(i)
        n(i) = 1;
    elseif r<= 1/2 && r>= S(i)
        n(i) = 2;
    elseif r>=1/2 && r>= S(i)
        n(i) = 3;
    end
end
end

