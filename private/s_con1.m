function IntValue= s_con1( IntDNAx,IntDNAy,S_con)
%Similarity�����ڶ��S_conΪ�û�ָ������;S_conΪ1..Length(DNA)
global S_CON;
if nargin==2
    S_con=S_CON;
end
IntValue=0;
l=size(IntDNAx,2);
for i=1:l
    IntValue=IntValue+T(ceq(IntDNAx,IntDNAy,i),S_con);
end
end