Reset;
% First get the units correct
%% Atomic unit conversions
Wcm_2=1/3.50944e16;
eV=1/27.2113962;
fs=1/2.41888e-2;
%% Sim Params
Ip=13.6*eV;
I0=1e14*Wcm_2;
lambda=800; %nm
Z=1;
m=0;

% Derived Params
E0=sqrt(I0);
w=45.5633526/lambda;

% Define the time
t0=0;
tend=100*fs;
N=2^11;
t=linspace(0,tend,N)';

% Define the Field
tau=10*fs;
t0=50*fs;
E=E0*exp(-(t-t0).^2/tau^2) .* cos(w*t);
A=zeros(size(t));
for i=2:length(E)
    A(i)=-trapz(E(1:i),t(1:i));
end

% Plot Field
figure();
plot(t/fs,E)
ylabel('E')
yyaxis right
plot(t/fs,A)
ylabel('A')
set(gcf, 'Position',  [402 235 425 210])
title('Field')

%% Ionization
% nstar=Z/(2*Ip);
% w=(2*(2*Ip)^(3/2)./E).^(2*nstar-abs(m)-1) .* exp(-2*(2*Ip)^(3/2)./(3*E));
% w=abs(w);
% 
% w(isnan(w)) = 0;
% w(isnan(w)) = 0;
% for i=1:length(w)
%     if isnan(w(i))
%         w(i)=0;
%     end
%     if isinf(w(i))
%         w(i)=0;
%     end
% end
% % w(w==1)=max(w);
% w=w/sum(w);
% figure();
% semilogy(t/fs,w)
n=3;
w=abs(E.^n);
w=w/sum(w);
figure();
semilogy(t/fs,w)
%% Propagation
S=zeros(size(t));
psi_t=zeros(size(t));
tic;
for i=1:length(t)-1
    k=-A(i);
    Aprime=A(i:N);
    tprime=t(i:N);
    S(i)=-trapz((k+Aprime).^2/2+Ip);
    psi_t(i)=w(i)*exp(1i*S(i));
end
plot(t/fs,abs(psi_t))
xlabel('t (fs)')
ylabel('abs(\psi)')
toc



