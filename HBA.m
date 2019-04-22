clc
clear;
tic
%% ������ʼ��


%���ڷ�֧������Ļ������Ӧ�����㷨
%PSO������ʼ��
global PSO_D Pop_min Pop_max L F1
%for cf=46:47
F1 = 0.5;
L = 11;
Pop_min = 0;       %�����С
Pop_max = 3;       %�����С
PSO_ini = 20;      %PSO�㷨��ʼ��Ⱥ�����Ķ���
PSO_D = 20;        %PSO�㷨��ά��
iter_max = 10;     %����������
%c1_fin = 0.5;      %PSO�㷨ѧϰ����C1����ֵ
%c1_ini = 2.5;      %PSO�㷨ѧϰ����C1��ʼֵ
%c2_fin = 0.5;      %PSO�㷨ѧϰ����C2����ֵ
%c2_ini = 2.5;      %PSO�㷨ѧϰ����C2��ʼֵ
%W_max = 0.9;       %PSO�㷨Ȩ�����ֵ
%W_min = 0.4;       %PSO�㷨Ȩ����Сֵ
c1 = 1.5;
c2 = 1.5;
W = 0.8;
%% ��ʼ��
%ʹ��Tentӳ����г�ʼ��
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

PSO_pop = Pop_min+round((Pop_max-Pop_min).*rand(PSO_ini,PSO_D));   %��Ⱥ�ĳ�ʼ��
D_INI = DNAcode2(PSO_pop);
[F X r]=fastsort(PSO_pop);                                         %���п��ٷ�֧������
ComeReX = ComRe(X);
[F CX cr]=fastsort(ComeReX);   
Velocity = zeros(PSO_ini,PSO_D);                                   %��ʼ��PSO�ٶ�
fitness=1./(exp((cr(:,1)-1)/max(cr(:,1)))+1);                        %������Ⱥ��Ӧ��
N=size(X,1);                                                       %���㵱ǰ��Ⱥ����
[BestFit,bestIndex] = max(fitness);                                %�����Ӧ��
WorstFit = min(fitness);                                           %�����Ӧ��
avg_fit=sum(fitness)/N;                                            %ƽ����Ӧ��
PSO_pbest = X(bestIndex,:);                                        %PSO�������ֵ
PSO_gbest = X;                                                     %PSOȫȺ����ֵ
for iter = 1:iter_max                                              
      % W = W_max-iter*(W_max-W_min)/iter_max;                      %PSO�㷨Ȩ��
      % c1 = c1_ini+iter*(c1_fin-c1_ini)/iter_max;                  %PSO�㷨ѧϰ����C1
      % c2 = c2_ini+iter*(c2_fin-c2_ini)/iter_max;                  %PSO�㷨ѧϰ����C2
       for i = 1:PSO_ini
           Velocity(i,:) = W*Velocity(i,:)+c1*rand()*(PSO_pbest-X(i,1:PSO_D))+c2*rand()*(PSO_gbest(i,:)-X(i,1:PSO_D));  %PSO�ٶȸ���
           X(i,1:PSO_D) = floor(mod((X(i,1:PSO_D)+f(Velocity (i,:))),4));                                 %PSOλ�ø���
       end 
       %������õĸ���
       newPSO = ClearSwarm(ComeReX,X);
       [Fb Xb rb]=fastsort(newPSO);                                            %���п��ٷ�֧������
       Batfitness=1./(exp((rb(:,1)-1)/max(rb(:,1)))+1);                        %������Ⱥ��Ӧ��
       [BestBatFit,bestBatIndex] = max(Batfitness);
       %ʹ�������㷨��������
       %%%%%%%%%%%%%%%%%%%
       %���������ʼ��
      % fmin = 0;                                        %Ƶ����Сֵ
       fmin = 0;
       fmax = 2;                                        %Ƶ�����ֵ
       r = 0.5 ;                                        %�����Ƶ��
       %r = 0.9
      % A = 0.25;
      A = 0.5;
      %�������
       %A = 0.9
       gamma = 0.5;                                     %����Ƶ������ϵ��
       alpha = 0.25;                                    %�������˥��ϵ��
       [batI,batJ] = size(newPSO);                      %�������������
       batV = zeros(batI,batJ);
       for i = 1:batI
               batf(i) = fmin+(fmin-fmax)*rand;                                                                   %�����㷨��Ƶ��
               batV(i,1:PSO_D) = batV(i,1:PSO_D) + (newPSO(i,1:PSO_D)-newPSO(bestBatIndex,1:PSO_D))*batf(i);      %�����㷨���ٶ�
               batX(i,1:PSO_D) = floor(mod((f(batV(i,1:PSO_D)) + newPSO(i,1:PSO_D)),4));                          %�����㷨��λ��
       end
       [Fb Xb rb]=fastsort(batX);
       Batfitness=1./(exp((rb(:,1)-1)/max(rb(:,1)))+1);                                 %������Ⱥ��Ӧ��
       [BestbatFit,bestbatIndex] = max(Batfitness);                                     %�����Ӧ��
       % ��������
        if rand>r
            %epsilon = 2*(rand() - 0.5);
            epsilon = 0.001*randn(1,20);
            for i = 1:batI
               % batX(i,1:PSO_D) = floor(mod(  (Xb(bestbatIndex,1:PSO_D) +f( epsilon*Xb(i,1:PSO_D))),4  ));
               batX(i,1:PSO_D) = floor(mod(  (Xb(bestbatIndex,1:PSO_D) +f( epsilon)),4  ));
               
            end
       end   
     %  [Fb Xb rb]=fastsort(batX);
      % Batfitness=1./(exp((rb(:,1)-1)/max(rb(:,1)))+1);                                 %������Ⱥ��Ӧ��
     %  [BestbatFit,bestbatIndex] = max(Batfitness);                                     %�����Ӧ��
       
     %  for i = 1:batI
      %     if (Batfitness(i)< BestbatFit) && (rand<A) 
       %         batX(i,1:PSO_D) =  Xb(i,1:PSO_D)*(1-exp(-gamma*i));
      %          batX(i,1:PSO_D) = floor(mod((f(alpha*batX(i,1:PSO_D))),4)); 
       %     end
      % end
       
       %%%%%%%%%%%%%%%%%%%
       
       [Fb Xb rb]=fastsort(batX);
       Batfitness=1./(exp((rb(:,1)-1)/max(rb(:,1)))+1);                                 %������Ⱥ��Ӧ��
       [BestbatFit,bestbatIndex] = max(Batfitness);                                     %�����Ӧ��
       %������õĸ���
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
%ѡȡ10��
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

%ѡȡ7��
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
       
       
       
       
      





