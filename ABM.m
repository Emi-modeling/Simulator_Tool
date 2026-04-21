function [x,y,z] = ABM(n,md,mo,beta,gamma,lambda,alpha,epsilon,rev,x0,z,y0,mu,T)
% ABM(n,md,mo,beta,gamma,lambda,alpha,epsilon,rev,x0,z,y0,T) simulates the
% ABM. Created by Lorenzo Zino (lorenzo.zino@polito.it).
% n= number of agents (scalar)
% md= links on the conviction layer (scalar if homogeneous or vector of dimension n)
% mo= links on the behavior layer (scalar if homogeneous or vector of dimension n)
% beta= parameter beta (scalar if homogeneous or vector of dimension n)
% gamma= parameter gamma (scalar if homogeneous or vector of dimension n)
% lambda= parameter lambda (scalar if homogeneous or vector of dimension n)
% alpha= difficulty parameter alpha (scalar if homogeneous or vector of dimension n)
% epsilon= randomness parameter epsilon (scalar if homogeneous or vector of dimension n)
% x0= initial behaviors (vector of dinension n)
% z= convictions (vector of dinension n)
% y0= initial normative expectations (vector of dinension n)
% T= simulation horizon (scalar)


%%Rearranging the individuals'parameters into vectors

if length(beta)==1
    beta=beta*ones(n,1);
end

if length(gamma)==1
    gamma=gamma*ones(n,1);
end

if length(lambda)==1
    lambda=lambda*ones(n,1);
end

if length(alpha)==1
    alpha=alpha*ones(n,1);
end

if length(md)==1
    md=md*ones(n,1);
end

if length(mo)==1
    mo=mo*ones(n,1);
end

if length(epsilon)==1
    epsilon=epsilon*ones(n,1);
end

if size(beta)==1
    beta=beta';
end

if size(gamma)==1
    gamma=gamma';
end

if size(lambda)==1
    lambda=lambda';
end

if size(alpha)==1
    alpha=alpha';
end

if size(md)==1
    md=md';
end

if size(mo)==1
    mo=mo';
end

if size(epsilon)==1
    epsilon=epsilon';
end



%%Initialization
x=zeros(n,T);
y=zeros(n,T);

x(:,1)=x0;
y(:,1)=y0;

%% Loop

for t=2:T
   [W1,W2]=ADN2l(n,md,mo,1,x(:,t-1),mu);  %generate the network at time t
   y(:,t)=(1-beta).*y(:,t-1)+beta.*gamma.*(W1*z)+beta.*(1-gamma).*(W2*x(:,t-1)); %revise normative expectations
   xtemp = (1-lambda).*z+lambda.*y(:,t-1); %computes the threshold for all agents
   flag=rand(n,1)<epsilon; %generate the rational decision
   xtemp=flag.*round(rand)+(1-flag).*(xtemp >= alpha); %probabilistic mechanism to incirporate bounded rationality (randomness)
   flag=rand(n,1)<rev; %probabilistic mechanism to decide whether an individual revises
   x(:,t)=flag.*xtemp+(1-flag).*x(:,t-1); %revise behavior
end
end