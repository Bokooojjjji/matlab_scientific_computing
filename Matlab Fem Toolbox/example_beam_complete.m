function example_beam_complete()
% Complete single-span simply supported beam under uniform load q (N/m)
% Length L, E, I, A
L = 6; nodes = [0 0; L 0];
% single beam element between node1 and node2
elements(1).type = 'beam'; elements(1).nodes = [1 2]; elements(1).prop_id = 1; elements(1).udl = -5000; % q = -5000 N/m (down)
props(1).E = 210e9; props(1).I = 8.333e-6; props(1).A = 0.01;
[K,F,dpn] = assemble_global(nodes,elements,props);
% No point loads in this example; UDL already added in assemble_global via consistent loads
% Boundary conditions: simply supported -> node1 v=0 (dof 2), node2 v=0 (dof 5) and allow rotations
% For 3DOF/node indexing: node1 dofs [1 2 3], node2 [4 5 6]
fixedDofs = [2,5]; % transverse DOFs fixed
[Km,Fm,freeDof] = apply_boundary_conditions(K,F,fixedDofs);
U = Km \ Fm;
fprintf('Nodal displacement vector (global DOFs):\n'); disp(U);
% Postprocess: element internal forces
elemForces = postprocess_beam_forces(nodes,elements,props,U);
disp('Element end forces (local coords):'); disp(elemForces);
% plot deformation (scale to visualize)
plot_deformation(nodes,elements,U,1000);
% Compare with hand solution for simply supported beam wL^4/(384EI) max def at midspan
w = abs(elements(1).udl); % magnitude
Umax_theory = w*L^4/(384*props(1).E*props(1).I);
fprintf('Theoretical max deflection at midspan = %.6e m\n', Umax_theory);
end