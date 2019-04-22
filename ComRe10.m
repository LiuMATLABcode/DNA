function [ SubPop ] = ComRe10( Pop )
%   选取最后的结果函数
%   在种群Pop中选取10条，优先选取连续性和发卡结构为0的个体
[SwarmSize,~] = size(Pop);
fitness = fit(Pop);
SubPop_1 = [];
SubPop_2 = [];
for i=1:SwarmSize
    if fitness(i,1)==0 && fitness(i,2)==0
        SubPop_1 = [SubPop_1;Pop(i,:)];
    else
        SubPop_2 = [SubPop_2;Pop(i,:)];
    end
end
row_1 = size(SubPop_1,1);
row_2 = size(SubPop_2,1);
if row_1 >= 10
    SubPop = SubPop_1(1:10,:);
else
    SubPop = SubPop_1(:,:);
    for i = 1:(10-row_1)
        SubPop = [SubPop;SubPop_2(i,:)];
    end
end
end

