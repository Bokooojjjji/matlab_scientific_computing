function [k_global, dof] = 
truss_element(node1, node2, E, A, id1, id2)
% 2D truss element stiffness in global coordinates (4x4)
x1 = node1(1); y1 = node1(2);
x2 = node2(1); y2 = node2(2);
L = sqrt((x2-x1)^2 + (y2-y1)^2);
c = (x2 - x1)/L; s = (y2 - y1)/L;
k = E*A/L;
% axial stiffness in global coordinates
k_global = k * [ c*c  c*s -c*c -c*s;
                  c*s  s*s -c*s -s*s;
                 -c*c -c*s  c*c  c*s;
                 -c*s -s*s  c*s  s*s];
dof = [2*id1-1, 2*id1, 2*id2-1, 2*id2];
end