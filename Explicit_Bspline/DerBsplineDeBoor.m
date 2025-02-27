%l-ed fok� Bsplinok alappont szerinti els� parci�lis 
%deriv�ltjainak el��ll�t�sa osztott differenci�k seg�ts�g�vel.%

%{
Param�terek:
 - l  : foksz�m
 - k  : megadja, hogy melyik alappontra illesz�k a splinet
 - j  : xk(j) alappont szerinti parci�lis deriv�ltat sz�moljuk
 - xk : alappontok x koordin�t�ja
 - x  : ezeken a helyeken sz�moljuk ki a Bspline parci�lis deriv�ltj�nak �rt�k�t
Visszat�r�si �rt�kek:
 - y : a Bspline parci�lis deriv�ltj�nak �rt�ke az x helyeken
%}

function y=DerBsplineDeBoor(l,k,j,xk,x)
    if k<=j && j<=k+l+1
        xkj=[xk(k:j-1); xk(j); xk(j); xk(j+1:k+l+1)]; %duplicate the point xk(j)
        tpvals=trunpow(l,xkj,x);    
        y=(-1)^(l+1)*tpvals;
        for i=1:1:l+2
            y=divdiff(l,i,y,x,xkj);
        end
    else
        y=zeros(size(x));
    end
    %y=(xk(k+l+1)-xk(k))*y; %scaling
end

%Trucated power functions.
function val=trunpow(l,xj,x)
    val=zeros(length(xj),length(x));
    for j=1:1:length(xj)
        y=(x-xj(j));
        val(j,y>0)=y(y>0).^l;
    end
end

%Kth derivative of the trucated power functions.
function val=dertrunpow(l,k,xj,x)
    val=zeros(length(xj),length(x));
    for j=1:1:length(xj)
        y=(x-xj(j));
        val(j,y>0)=prod((l-k+1):l)*y(y>0).^(l-k);
    end
end

%Kth order divided differences between rows.
function d=divdiff(l,k,y,x,xj)
    d=diff(y,1,1);
    for i=1:1:size(d,1)
        if xj(i+k)==xj(i)
            d(i,:)=dertrunpow(l,k,xj(i),x)./factorial(k);
        else
            h=xj(i+k)-xj(i);
            d(i,:)=d(i,:)/h;
        end
    end
end