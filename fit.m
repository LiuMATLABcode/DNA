function f=fit(DNAs)
f(:,1)=Continuity(DNAs); %Continuity
f(:,2)=Hairpin(DNAs);    %Hairpin
[f(:,3),f(:,4)]=HmSm(DNAs);%h-measure,similarity  
% D=DNAcode2(DNAs);
% [f(:,5),f(:,6)] = GCTmBioBox(D);
% [f(:,2),f(:,1)]=HmSm(DNAs);%h-measure,similarity  
% f(:,3)=Continuity(DNAs); %Continuity
% f(:,4)=Hairpin(DNAs);    %Hairpin
% f(:,5)=f(:,1)+f(:,2)+f(:,3)+f(:,4);
% f(:,7)=f(:,1)+f(:,2)+f(:,3)+f(:,4)+abs(f(:,5)-55*ones(size(f(:,5))))+abs(f(:,6)-50*ones(size(f(:,6))));
end

