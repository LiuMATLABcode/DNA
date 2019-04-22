function [ NewSwarm ] = ClearSwarm(Pop,OptSwarm )
% ��������϶����ṹ�ĺ���
%   ��������϶����ṹҪ��ĺ����������Ժͷ����ṹ��ֵ����10�����������ֵ����10�����壬ͬʱ�޶�GC
%   ������ʹ���и����GC����������50%
global L
[SwarmSize,ParticleSize] = size(Pop);
Pop(:,1:ParticleSize)=repair(SwarmSize,ParticleSize,Pop(:,1:ParticleSize));
       NewSwarm = [Pop(:,1:ParticleSize);OptSwarm];       
           for i = 1:size(NewSwarm,1)-1
               for j = i+1:size(NewSwarm,1)
                   H = hamming(ParticleSize,NewSwarm(i,:),NewSwarm(j,:));
                   if H <= L
                      NewSwarm(j,:) =[];
                      break
                   end
               end
           end
 
      M = size(NewSwarm,1);
      a = 1;
        while a <= M
            H2 = Hairpin(NewSwarm(a,:));
            Values= Continuity(NewSwarm(a,:));
           if Values >= 10 || H2 >= 10
               NewSwarm(a,:)=[];
               a = a-1;
           end
           M = size(NewSwarm,1);
           a = a+1;
        end
end

