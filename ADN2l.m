function [W1,W2] =ADN2l(n,m1,m2,a,x,mu)
% ADN2l(n,m1,m2) generates a 2-layer activity-driven network, where each
% node i establishes m1(i) links on the first layer and m2(i) links on the
% second layer. Links are established uniformly at random.
% 
% ADN2l(n,m1,m2,a) generates a 2-layer activity-driven network, where each
% node i establishes m1(i) links on the first layer and m2(i) links on the
% second layer, with probability a. Links are established uniformly at random..
%
% ADN2l(n,m1,m2,a,x.mu) generates a 2-layer activity-driven network, where each
% node i establishes m1(i) links on the first layer and m2(i) links on the
% second layer, with probability a. Links are established randomly, with
% probability increased by mu to connect with an individual with x(i)=1.
%
% Created by Lorenzo Zino (lorenzo.zino@polito.it).

%Re-arrange the paramters as vectors

if length(m1)==1
    m1=m1*ones(n,1);
end
if length(m2)==1
    m2=m2*ones(n,1);
end

%$ Empty network
W1=zeros(n);
W2=zeros(n);


%%Generates network
if nargin==4 %%With activation probability
flag=rand(n,1)<a;
for i=1:n
    if flag(i)==1
        W1(i,randperm(n,m1(i)))=1/m1(i);        
        W2(i,randperm(n,m2(i)))=1/m2(i);        
    end
end
elseif nargin==3 %%Without activation probability (set to 1)
    for i=1:n
        W1(i,randperm(n,m1(i)))=1/m1(i);        
        W2(i,randperm(n,m2(i)))=1/m2(i);        
    end
else %%With attractiveness
p_r=1/(1+mu);
    for i=1:n
        temp=randperm(n,m1(i));
        W1(i,temp)=1/m1(i);  
        flag =0;
        while flag==0
            temp=randperm(n,m2(i));
            if rand<p_r^(m2(i)-sum(x(temp)))
                flag=1;
                W2(i,temp)=1/m2(i);  
            end
        end    
    end
end
end