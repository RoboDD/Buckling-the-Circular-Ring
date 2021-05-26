clc;
clear;
%% Q4
global c p;
c = 0.01;
p = 3.5; % Change the value of p here

%% Init
s=[0 0 0 0 0 0 0]; 
s0 = [-0.9712;-2.9135;-0.0288];
sspan = [0 pi/2];
y0 = [pi/2 s(2) 0 0 s(5) 0 s(7)];
yb = [0 0 0 0 0 0 0]; %Value to be Shot
k=100;
h=0.001;

%% Solver
% z=F(s0, c, p);
for p = 3: +h:3.5
   sstar = broyden2(@(s)F(s, c, p), s0, k); 
   y0 = [pi/2 sstar(1) 0 0 sstar(2) 0 sstar(3)];
   [~,w_sol]=ode45(@(s,y) odefcn(y,c,p),sspan,y0);
   w_radius = 1 - sqrt(w_sol(end,2)^2 + w_sol(end,3)^2);
    
   sstar2 = broyden2(@(s)F(s, c, p), sstar, k); 
   y0 = [pi/2 sstar2(1) 0 0 sstar2(2) 0 sstar2(3)];
   [~,w_sol2]=ode45(@(s,y) odefcn(y,c,p),sspan,y0);
   w_radius2 = 1 - sqrt(w_sol2(end,2)^2 + w_sol2(end,3)^2);
   
   disp(w_radius);
   disp(w_radius2);
   
   if (abs(w_radius - w_radius2) > 1e-1)
       disp(sstar);
       break;
   end
   disp(p); 
end

% if (norm(F(sstar, c, p)) < 1e-3)
%     disp("sstar found")
%     % Plot the Result
%     y0 = [pi/2 sstar(1) 0 0 sstar(2) 0 sstar(3)]; %Initial State
%     [~,w_sol]=ode45(@(s,y) odefcn(y,c,p),sspan,y0);
% 
%     axis equal 
%     hold on
%     plot(w_sol(:,2),w_sol(:,3),'r-o'); %LU (You may change color here)
%     plot(-w_sol(:,2),w_sol(:,3),'r-o');%RU
%     plot(-w_sol(:,2),-w_sol(:,3),'r-o');%RD
%     plot(w_sol(:,2),-w_sol(:,3),'r-o');%LD
% else
%     disp("Failed")
% end

%% ODEs
% This is a system of ODE (7.10)
function dyds = odefcn(y,c,p)
dyds = zeros(7,1);
dyds(1) = -1-c*y(5)+(c+1)*y(7);
dyds(2) = (1+c*(y(5)-y(7)))*cos(y(1));
dyds(3) = (1+c*(y(5)-y(7)))*sin(y(1));
dyds(4) = 1+c*(y(5)-y(7));
dyds(5) = -y(6)*(-1-c*y(5)+(c+1)*y(7));
dyds(6) = y(7)*y(5)-(1+c*(y(5)-y(7)))*(y(5)+p);
dyds(7) = (1+c*(y(5)-y(7)))*y(6);
end

%% Shooting Method
% Input: Initial state, s 3x1 vector
% Output: shot solution of z
% Example usage: z=F(s, c, p)
function z = F(s, c, p)
sspan = [0 pi/2];
y0 = [pi/2 s(1) 0 0 s(2) 0 s(3)]; %Initial State
yb = [0 0 0 0 0 0 0]; %Value to be Shot

[~,w]=ode45(@(s,y) odefcn(y,c,p),sspan,y0);

y1bs = w(end,1)-yb(end,1);
y2bs = w(end,2)-yb(end,2);
y6bs = w(end,6)-yb(end,6);

z = [y1bs; y2bs; y6bs];
end

%% Broyden's Method II
% Input: x0 initial vector, k = max steps
% Output: solution x
% Example usage: broyden2(f,[1;2],10)
function x=broyden2(f,x0,k)
[n,m]=size(x0);
b=eye(n,n);           % initial b
for i=1:k
  x=x0-b*f(x0);
  del=x-x0;delta=f(x)-f(x0);
  b=b+(del-b*delta)*del'*b/(del'*b*delta);
  x0=x;
end
end