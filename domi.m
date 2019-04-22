function k = domi(a,b)
less=0;
more=0;
% val_a=objective(a);
% val_b=objective(b);
for i=1:length(a)
    if a(i)<b(i)
        less=less+1;
    elseif a(i)>b(i)
        more=more+1;
    end
end
if less>0 && more==0
    k=1;
elseif more>0 && less==0
    k=2;
else k=0;
end
