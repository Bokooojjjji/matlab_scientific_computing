function [K, F, dof_per_node] = assemble_global(nodes, elements, props)
% Assemble global stiffness matrix and force vector. Supports 'truss' and 'beam'.
n_nodes = size(nodes,1);
hasBeam = any(strcmp({elements.type}, 'beam'));
if hasBeam
    dof_per_node = 3;
else
    dof_per_node = 2;
end
GDof = n_nodes * dof_per_node;
K = zeros(GDof, GDof);
F = zeros(GDof,1);
for e=1:length(elements)
    eType = elements(e).type; nid = elements(e).nodes; p = props(elements(e).prop_id);
    if strcmp(eType,'truss')
        [k_e, dof] = truss_element(nodes(nid(1),:), nodes(nid(2),:), p.E, p.A, nid(1), nid(2));
        K(dof,dof) = K(dof,dof) + k_e;
        % no consistent loads implemented for truss
    elseif strcmp(eType,'beam')
        [k_e, dof] = beam_element(nodes(nid(1),:), nodes(nid(2),:), p.E, p.I, p.A, nid(1), nid(2));
        K(dof,dof) = K(dof,dof) + k_e;
        % if element has udl (local w in props), compute equivalent and add
        if isfield(elements(e),'udl') && any(elements(e).udl~=0)
            L = sqrt(sum((nodes(nid(2),:)-nodes(nid(1),:)).^2));
            q = elements(e).udl; % local magnitude (positive down)
            f_el_local = compute_udl_equivalent(q, L);
            % transform local load to global coordinates
            x1 = nodes(nid(1),1); y1 = nodes(nid(1),2); x2 = nodes(nid(2),1); y2 = nodes(nid(2),2);
            c = (x2-x1)/L; s = (y2-y1)/L;
            R = [ c s 0 0 0 0; -s c 0 0 0 0; 0 0 1 0 0 0; 0 0 0 c s 0; 0 0 0 -s c 0; 0 0 0 0 0 1];
            f_el_global = R' * f_el_local; % consistent with k_el = R' k_local R
            F(dof) = F(dof) + f_el_global;
        end
    else
        error('Unknown element type');
    end
end
end