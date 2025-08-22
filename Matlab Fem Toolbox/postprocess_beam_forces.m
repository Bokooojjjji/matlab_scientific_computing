function elemForces = postprocess_beam_forces(nodes, elements, props, U)
% Compute element end forces (axial, shear, moment) in local coords for beam elements
% Returns struct array with fields: element_id, node_ids, N1,V1,M1,N2,V2,M2
for e=1:length(elements)
    if strcmp(elements(e).type,'beam')
        nid = elements(e).nodes; p = props(elements(e).prop_id);
        L = sqrt(sum((nodes(nid(2),:)-nodes(nid(1),:)).^2));
        % get element DOF
        dof = [3*nid(1)-2,3*nid(1)-1,3*nid(1),3*nid(2)-2,3*nid(2)-1,3*nid(2)];
        u_e = U(dof);
        % compute local transformation
        x1 = nodes(nid(1),1); y1 = nodes(nid(1),2); x2 = nodes(nid(2),1); y2 = nodes(nid(2),2);
        c = (x2-x1)/L; s = (y2-y1)/L;
        R = [ c s 0 0 0 0; -s c 0 0 0 0; 0 0 1 0 0 0; 0 0 0 c s 0; 0 0 0 -s c 0; 0 0 0 0 0 1];
        u_local = R * u_e; % local element DOFs
        % local stiffness (same as in beam_element)
        k_axial = p.E*p.A/L;
        k_bending = p.E*p.I/L^3 * [12 6*L -12 6*L; 6*L 4*L^2 -6*L 2*L^2; -12 -6*L 12 -6*L; 6*L 2*L^2 -6*L 4*L^2];
        k_local = zeros(6);
        k_local([1,4],[1,4]) = [k_axial -k_axial; -k_axial k_axial];
        idx = [2 3 5 6]; k_local(idx,idx) = k_bending;
        % element end forces in local coords: f = k_local * u_local - f_consistent (if any)
        f_el = k_local * u_local;
        % subtract consistent udl if present
        if isfield(elements(e),'udl') && elements(e).udl~=0
            q = elements(e).udl; f_cons = compute_udl_equivalent(q, L); f_el = f_el - f_cons;
        end
        % assign outputs
        elemForces(e).element_id = e;
        elemForces(e).nodes = nid;
        elemForces(e).N1 = f_el(1); elemForces(e).V1 = f_el(2); elemForces(e).M1 = f_el(3);
        elemForces(e).N2 = f_el(4); elemForces(e).V2 = f_el(5); elemForces(e).M2 = f_el(6);
    else
        elemForces(e).element_id = e; elemForces(e).nodes = elements(e).nodes; % empty for truss
    end
end
end