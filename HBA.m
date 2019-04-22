clc
clear;
tic
%% 参数初始化


%基于非支配排序的混合自适应蝙蝠算法
%PSO参数初始化
global PSO_D Pop_min Pop_max L F1
%for cf=46:47
F1 = 0.5;
L = 11;
Pop_min = 0;       %区间大小
Pop_max = 3;       %区间大小
PSO_ini = 20;      %PSO算法初始种群数量的多少
PSO_D = 20;        %PSO算法的维度
iter_max = 10;     %最大迭代次数
%c1_fin = 0.5;      %PSO算法学习因子C1最终值
%c1_ini = 2.5;      %PSO算法学习因子C1初始值
%c2_fin = 0.5;      %PSO算法学习因子C2最终值
%c2_ini = 2.5;      %PSO算法学习因子C2初始值
%W_max = 0.9;       %PSO算法权重最大值
%W_min = 0.4;       %PSO算法权重最小值
c1 = 1.5;
c2 = 1.5;
W = 0.8;
%% 初始化
%使用Tent映射进行初始化
%A = rand(PSO_ini,PSO_D);
%for i = 1:PSO_ini
%   for j = 1:PSO_D 
%      if A(i,j) > 0.5
%           A(i,j)=(1 - A(i,j))/0.5;
%       else
%          A(i,j) = A(i,j)/0.5;
%      end
%  end
%end
%PSO_pop=Pop_min+round((Pop_max-Pop_min).*A);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

PSO_pop = Pop_min+round((Pop_max-Pop_min).*rand(PSO_ini,PSO_D));   %种群的初始化
D_INI = DNAcode2(PSO_pop);
[F X r]=fastsort(PSO_pop);                                         %进行快速非支配排序
ComeReX = ComRe(X);
[F CX cr]=fastsort(ComeReX);   
Velocity = zeros(PSO_ini,PSO_D);                                   %初始化PSO速度
fitness=1./(exp((cr(:,1)-1)/max(cr(:,1)))+1);                        %计算种群适应度
N=size(X,1);                                                       %计算当前种群数量
[BestFit,bestIndex] = max(fitness);                                %最好适应度
WorstFit = min(fitness);                                           %最差适应度
avg_fit=sum(fitness)/N;                                            %平均适应度
PSO_pbest = X(bestIndex,:);                                        %PSO个体最佳值
PSO_gbest = X;                                                     %PSO全群最优值
for iter = 1:iter_max                                              
      % W = W_max-iter*(W_max-W_min)/iter_max;                      %PSO算法权重
      % c1 = c1_ini+iter*(c1_fin-c1_ini)/iter_max;                  %PSO算法学习因子C1
      % c2 = c2_ini+iter*(c2_fin-c2_ini)/iter_max;                  %PSO算法学习因子C2
       for i = 1:PSO_ini
           Velocity(i,:) = W*Velocity(i,:)+c1*rand()*(PSO_pbest-X(i,1:PSO_D))+c2*rand()*(PSO_gbest(i,:)-X(i,1:PSO_D));  %PSO速度更新
           X(i,1:PSO_D) = floor(mod((X(i,1:PSO_D)+f(Velocity (i,:))),4));                                 %PSO位置更新
       end 
       %清除不好的个体
       newPSO = ClearSwarm(ComeReX,X);
       [Fb Xb rb]=fastsort(newPSO);                                            %进行快速非支配排序
       Batfitness=1./(exp((rb(:,1)-1)/max(rb(:,1)))+1);                        %计算种群适应度
       [BestBatFit,bestBatIndex] = max(Batfitness);
       %使用蝙蝠算法进行搜索
       %%%%%%%%%%%%%%%%%%%
       %蝙蝠参数初始化
      % fmin = 0;                                        %频率最小值
       fmin = 0;
       fmax = 2;                                        %频率最大值
       r = 0.5 ;                                        %发射的频度
       %r = 0.9
      % A = 0.25;
      A = 0.5;
      %脉冲响度
       %A = 0.9
       gamma = 0.5;                                     %脉冲频度增加系数
       alpha = 0.25;                                    %脉冲响度衰减系数
       [batI,batJ] = size(newPSO);                      %获得行数，列数
       batV = zeros(batI,batJ);
       for i = 1:batI
               batf(i) = fmin+(fmin-fmax)*rand;                                                                   %蝙蝠算法的频率
               batV(i,1:PSO_D) = batV(i,1:PSO_D) + (newPSO(i,1:PSO_D)-newPSO(bestBatIndex,1:PSO_D))*batf(i);      %蝙蝠算法的速度
               batX(i,1:PSO_D) = floor(mod((f(batV(i,1:PSO_D)) + newPSO(i,1:PSO_D)),4));                          %蝙蝠算法的位置
       end
       [Fb Xb rb]=fastsort(batX);
       Batfitness=1./(exp((rb(:,1)-1)/max(rb(:,1)))+1);                                 %计算种群适应度
       [BestbatFit,bestbatIndex] = max(Batfitness);                                     %最好适应度
       % 脉冲速率
        if rand>r
            %epsilon = 2*(rand() - 0.5);
            epsilon = 0.001*randn(1,20);
            for i = 1:batI
               % batX(i,1:PSO_D) = floor(mod(  (Xb(bestbatIndex,1:PSO_D) +f( epsilon*Xb(i,1:PSO_D))),4  ));
               batX(i,1:PSO_D) = floor(mod(  (Xb(bestbatIndex,1:PSO_D) +f( epsilon)),4  ));
               
            end
       end   
     %  [Fb Xb rb]=fastsort(batX);
      % Batfitness=1./(exp((rb(:,1)-1)/max(rb(:,1)))+1);                                 %计算种群适应度
     %  [BestbatFit,bestbatIndex] = max(Batfitness);                                     %最好适应度
       
     %  for i = 1:batI
      %     if (Batfitness(i)< BestbatFit) && (rand<A) 
       %         batX(i,1:PSO_D) =  Xb(i,1:PSO_D)*(1-exp(-gamma*i));
      %          batX(i,1:PSO_D) = floor(mod((f(alpha*batX(i,1:PSO_D))),4)); 
       %     end
      % end
       
       %%%%%%%%%%%%%%%%%%%
       
       [Fb Xb rb]=fastsort(batX);
       Batfitness=1./(exp((rb(:,1)-1)/max(rb(:,1)))+1);                                 %计算种群适应度
       [BestbatFit,bestbatIndex] = max(Batfitness);                                     %最好适应度
       %清除不好的个体
       ccc=ComRe(Xb);
       newBAT = ClearSwarm(ccc,newPSO);
       
       N_Bat = size(newBAT,1);
       X2=repair(N_Bat,PSO_D,newBAT); 
       
       newX=[]; 
       if N_Bat>PSO_ini
          Value=fit(X2);
          V=sum(Value,2);
          [V, index]=sort(V);
          X2=X2(index,:);
          newX=X2(1:PSO_ini,:);     
       else
          newX=X2;
       end
       [Ffinal, Xfinal, rfinal]=fastsort(newX);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xis0 = [];
xis1 = [];
xfit = [Xfinal;newX];
Nxfit = size(xfit,1);
xRepair = repair(Nxfit,PSO_D,xfit);
fopt = fit(xRepair);
X_fit = [xfit fopt];
[row, col] = size(X_fit);
for i = 1:row
    if fopt(i,3) < 300
        if fopt(i,1)==0 && fopt(i,2)==0
            xis0 = [xis0;X_fit(i,1:col)];
        else
            xis1 = [xis1;X_fit(i,1:col)];
        end
    end
end

xis0NDA = [];
xis1NDA = [];
[row0,col0] = size(xis0);
[row1,col1] = size(xis1);
for i = 1:row0
    xis0NDA = [xis0NDA ;xis0(i,1:PSO_D)];
end
for i = 1:row1
    xis1NDA = [xis1NDA ;xis1(i,1:PSO_D)];
end

f0 = fit(xis0NDA);
N0 = size(xis0NDA,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%选取10条
%if N0>=10
%     xis0com = ComRe10(xis0NDA);
%     f5 = fit(xis0com);
%     D=DNAcode2(xis0com);
%     [f5(:,5),f5(:,6)] = GCTmBioBox(D);
%      xis0com=[xis0com,f5];
%      X8 = zeros(1,26);
%      X9 = [xis0com;X8];
%      for j = 21:26
%         for i = 1:10
%            X9(11,j)=X9(11,j)+X9(i,j);
%         end
%      end
%else
%    N1 = 11-N0;
%    XIS1 = [];
%    for i = 1:N1
%       XIS1=[XIS1;xis1NDA(i,1:PSO_D)];
%    end
%    xis0NDA = [xis0NDA;XIS1];
%    Feslse = fit(xis0NDA);
%    xis0com = ComRe10(xis0NDA);
%    f5 = fit(xis0com);
%    D=DNAcode2(xis0com);
%    [f5(:,5),f5(:,6)] = GCTmBioBox(D);
%    xis0com=[xis0com,f5];
%    X8 = zeros(1,26);
%    X9 = [xis0com;X8];
%      for j = 21:26
%         for i = 1:10
%            X9(11,j)=X9(11,j)+X9(i,j);
%         end
%      end  
%end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%选取7条
if N0>=7
     xis0com = ComRe(xis0NDA);
     f5 = fit(xis0com);
     D=DNAcode2(xis0com);
     [f5(:,5),f5(:,6)] = GCTmBioBox(D);
      xis0com=[xis0com,f5];
      X8 = zeros(1,26);
      X9 = [xis0com;X8];
      for j = 21:26
         for i = 1:7
            X9(8,j)=X9(8,j)+X9(i,j);
         end
      end
else
    N1 = 8-N0;
    XIS1 = [];
    for i = 1:N1
       XIS1=[XIS1;xis1NDA(i,1:PSO_D)];
    end
    xis0NDA = [xis0NDA;XIS1];
    Feslse = fit(xis0NDA);
    xis0com = ComRe(xis0NDA);
    f5 = fit(xis0com);
    D=DNAcode2(xis0com);
    [f5(:,5),f5(:,6)] = GCTmBioBox(D);
    xis0com=[xis0com,f5];
    X8 = zeros(1,26);
    X9 = [xis0com;X8];
      for j = 21:26
         for i = 1:7
            X9(8,j)=X9(8,j)+X9(i,j);
         end
      end  
end
save result711

       
toc
     
%%%%%%%%%%%%%%%%%%%
       
       
       
       
      





