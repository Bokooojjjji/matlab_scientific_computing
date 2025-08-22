function plot_deformation(nodes, elements, U, scale)
if nargin<4, scale = 1; end
figure; hold on; axis equal; grid on;
% choose plotting for 2DOF/node or 3DOF/node (plot XY)
dof_per_node = size(U,1)/size(nodes,1);
% plot undeformed
for e=1:length(elements)
    nid = elements(e).nodes; x = nodes(nid,1); y = nodes(nid,2); plot(x,y,'-k');
end
% build deformed nodes
nnode = size(nodes,1);
deformed = nodes;
if dof_per_node==2
    for i=1:nnode
        deformed(i,1) = nodes(i,1) + scale*U(2*i-1);
        deformed(i,2) = nodes(i,2) + scale*U(2*i);
    end
else
    for i=1:nnode
        deformed(i,1) = nodes(i,1) + scale*U(3*i-2);
        deformed(i,2) = nodes(i,2) + scale*U(3*i-1);
    end
end
for e=1:length(elements)
    nid = elements(e).nodes; x = deformed(nid,1); y = deformed(nid,2); plot(x,y,'-r','LineWidth',1.5);
end
legend('undeformed','deformed'); title('Deformation (scaled)');
end