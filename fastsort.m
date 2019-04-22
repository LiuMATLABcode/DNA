function [f y fitness]=fastsort(P)
N=size(P,1);%个体数
value=fit(P); 
rank=zeros(N,1);
f{1}=[];
M=0;
for i=1:N
    s{i}=[];  % s{i}为个体i支配的解序号集合
    num(i)=0; % num(i)为支配个体i的解个数
    for j=1:N
        M=domi(value(i,:),value(j,:))
        if M==1
% if domi(P(i,:),P(j,:))==1
            s{i}=[s{i} j];
        elseif M==2
% elseif domi(P(i,:),P(j,:))==2
            num(i)=num(i)+1;
        end
    end
    if num(i)==0
        rank(i)=1;
        f{1}=[f{1} i];
    end
end
front=1;
while ~isempty(f{front})
    Q=[];
    for i=1:length(f{front})
        p=f{front}(i);
        if ~isempty(s{p})
            for j=1:length(s{p})
                q=s{p}(j);
                num(q)=num(q)-1;
                if num(q)==0
                    rank(q)=front+1;
                    Q=[Q q];
                end
            end
        end
    end
    front=front+1;
    f{front}=Q;
end

%% 对P按非支配等级rank从小到大排序，返回排序后的种群y
[rank,index]=sort(rank);
fitness=rank;
for i=1:N
    y(i,:)=P(index(i),:);
end

