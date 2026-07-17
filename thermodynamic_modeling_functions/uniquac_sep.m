function gamma = uniquac_sep(T, x, param, varargin)
% UNIQUAC model using energy parameters a_ij
%
% Input:
% T - temperature [K]
% x - mole fraction vector (n x 1 or 1 x n)
% param - energy parameter matrix delta u_ij (n x n) [K]
% varargin:
% r - volume parameters (n x 1)
% q - surface parameters (n x 1)
%
% Output:
% gamma - activity coefficients (n x 1)

x = x(:);
n = length(x);

a = param;

% Read varargin
if length(varargin) < 2
    error('Please provide r and q as additional inputs');
end

r = varargin{1}(:);
q = varargin{2}(:);

% UNIQUAC coordination number
z = 10;


% Interaction parameters
tau = exp(-a./ T);

% Volume and surface fractions
psi = (r .* x) / sum(r .* x);
theta = (q .* x) / sum(q .* x);

% l parameter
l = (z/2) .* (r - q) - (r - 1);

% Combinatorial contribution
ln_gamma_C = log(psi ./ x) ...
+ (z/2) .* q .* log(theta ./ psi) ...
+ l - (psi ./ x) * sum(x .* l);

% Residual contribution
ln_gamma_R = zeros(n,1);

for i = 1:length(x)
sum_i = sum(theta .* tau(:,i));

term1 = log(sum_i);

term2 = 0;
for j = 1:n
    denom = sum(theta .* tau(:,j));
    term2 = term2 + theta(j) * tau(i,j) / denom;
end

ln_gamma_R(i) = q(i) * (1 - term1 - term2);

end

% Total
ln_gamma = ln_gamma_C + ln_gamma_R;
gamma = exp(ln_gamma);
gamma = gamma(:).'; 
end