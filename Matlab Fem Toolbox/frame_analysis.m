function frame_analysis()
% Generic driver. Edit nodes/elements/props/loads/bc for specific model.
% Example left as simple template.
nodes = [0 0; 3 0; 6 0];
elements(1).type='truss'; elements(1).nodes=[1 2]; elements(1).prop_id=1;
elements(2).type='truss'; elements(2).nodes=[2 3]; elements(2).prop_id=1;
props(1).E = 210e9; props(1).A = 0.005; props(1).I = 1e-5;
[K,F,dofpn] = assemble_global(nodes,elements,props);
% apply a point load at node3 vertical if 2DOF/node assumed
F(end) = -1000;
fixedDofs = [1 2]; % fix node1 ux,uy
[Km,Fm,freeDof] = apply_boundary_conditions(K,F,fixedDofs);
U = Km \ Fm;
disp('Nodal displacements:'); disp(U);
plot_deformation(nodes,elements,U,1000);
end