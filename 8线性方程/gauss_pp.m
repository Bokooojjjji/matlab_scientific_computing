function x = gauss_pp(A,b)
% 高斯消元（列主元）
A = A; b = b(:);
n = size(A,1);
for k = 1:n-1
    [~,idx] = max(abs(A(k:n,k))); p = idx + k - 1;
    if p~=k
        A([k p],:) = A([p k],:);
        b([k p])   = b([p k]);
    end
    if abs(A[k,k])<eps, error('奇异或接近奇异'); end %#ok<NBRAK>
    for i = k+1:n
        m = A(i,k)/A(k,k);
        A(i,k:n) = A(i,k:n) - m*A(k,k:n);
        b(i) = b(i) - m*b(k);
    end
end
% 回代
x = zeros(n,1);
for i=n:-1:1
    x(i) = ( b(i) - A(i,i+1:end)*x(i+1:end) ) / A(i,i);
end
end