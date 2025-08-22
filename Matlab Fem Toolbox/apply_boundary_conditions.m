function [K_mod, F_mod, freeDof] = apply_boundary_conditions(K, F, fixedDofs, prescribedValues)
% fixedDofs: vector of DOF indices to fix; prescribedValues optional same size vec
if nargin<4, prescribedValues = zeros(size(fixedDofs)); end
K_mod = K; F_mod = F;
for i=1:length(fixedDofs)
    d = fixedDofs(i);
    K_mod(d,:) = 0; K_mod(:,d) = 0; K_mod(d,d) = 1;
    F_mod(d) = prescribedValues(i);
end
allDof = 1:size(K,1);
freeDof = setdiff(allDof, fixedDofs);
end