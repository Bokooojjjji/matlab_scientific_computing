function [k_el, dof] = beam_element(node1, node2, E, I, A, id1, id2)
% Euler-Bernoulli beam element (2D) with DOF per node: [axial, transverse, rotation]
x1 = node1(1); y1 = node1(2);
x2 = node2(1); y2 = node2(2);
L = sqrt((x2-x1)^2 + (y2-y1)^2);
c = (x2-x1)/L; s = (y2-y1)/L;
% local stiffness components
k_axial = E*A/L;
k_bending = E*I/L^3 * [12 6*L -12 6*L; 6*L 4*L^2 -6*L 2*L^2; -12 -6*L 12 -6*L; 6*L 2*L^2 -6*L 4*L^2];
% assemble local 6x6 (axial DOFs at positions 1 and 4)
k_local = zeros(6);
k_local([1,4],[1,4]) = [k_axial -k_axial; -k_axial k_axial];
% insert bending submatrix into transverse/rotational slots
idx = [2 3 5 6];
k_local(idx,idx) = k_bending;
% transformation matrix 6x6 (axial + rotation-preserving)
R = [ c s 0 0 0 0; -s c 0 0 0 0; 0 0 1 0 0 0; 0 0 0 c s 0; 0 0 0 -s c 0; 0 0 0 0 0 1];
k_el = R' * k_local * R;
dof = [3*id1-2, 3*id1-1, 3*id1, 3*id2-2, 3*id2-1, 3*id2];
end