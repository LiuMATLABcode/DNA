function [ SubPop ] = ComRe( Pop )
%   ѡȡ���Ľ������
%   ����ȺPop��ѡȡ7��������ѡȡ�����Ժͷ����ṹΪ0�ĸ���
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
if row_1 >= 7
    SubPop = SubPop_1(1:7,:);
else
    SubPop = SubPop_1(:,:);
    for i = 1:(7-row_1)
        SubPop = [SubPop;SubPop_2(i,:)];
    end
end
end

