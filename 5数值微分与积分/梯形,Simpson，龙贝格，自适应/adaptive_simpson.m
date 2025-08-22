function I = adaptive_simpson(f, a, b, tol, maxRec)
% 自适应Simpson
if nargin<4, tol = 1e-8; end
if nargin<5, maxRec = 20; end
fa = f(a); fm = f((a+b)/2); fb = f(b);
I = recurse(f,a,b,fa,fm,fb,simpson_est(fa,fm,fb,a,b),tol,maxRec);
end

function S = simpson_est(fa,fm,fb,a,b)
S = (b-a)/6*(fa + 4*fm + fb);
end

function I = recurse(f,a,b,fa,fm,fb,S,tol,depth)
m  = (a+b)/2;
fl = f((a+m)/2); fr = f((m+b)/2);
Sl = simpson_est(fa,fl,fm,a,m);
Sr = simpson_est(fm,fr,fb,m,b);
if depth<=0 || abs(Sl+Sr - S) < 15*tol
    I = Sl + Sr + (Sl+Sr - S)/15;
else
    I = recurse(f,a,m,fa,fl,fm,Sl,tol/2,depth-1) + ...
        recurse(f,m,b,fm,fr,fb,Sr,tol/2,depth-1);
end
end