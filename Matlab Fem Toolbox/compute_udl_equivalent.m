function f_el = compute_udl_equivalent(q, L)
% Consistent nodal load vector for a uniformly distributed transverse load q (N/m)
% for a beam element of length L. Positive q is downward in local transverse dir.
% Returns 6x1 vector ordered as [axial1; v1; th1; axial2; v2; th2]
% axial components are zero for transverse UDL.
Fv = q * L / 2; % shear nodal equivalent
M = q * L^2 / 12; % nodal moment equivalent (sign convention: M2 negative)
f_el = [0; Fv; M; 0; Fv; -M];
end