% validate_results.m
% 验证FEM结果与理论解的对比函数

function [errors, theory_values] = validate_results(problem_type, nodes, elements, props, U, elemForces, loads)
% 验证FEM结果与理论解的对比
% 输入参数：
%   problem_type - 问题类型 ('simply_supported', 'cantilever', 'fixed_ends', 'truss')
%   nodes, elements, props - FEM模型数据
%   U - 位移向量
%   elemForces - 单元内力
%   loads - 荷载信息

errors = struct();
theory_values = struct();

switch lower(problem_type)
    case 'simply_supported'
        % 简支梁均布荷载验证
        q = abs(loads.udl);
        L = loads.length;
        E = props(1).E;
        I = props(1).I;
        
        % 理论值
        theory_values.max_deflection = 5*q*L^4/(384*E*I);
        theory_values.max_moment = q*L^2/8;
        theory_values.max_shear = q*L/2;
        
        % FEM结果 - 安全获取最大挠度
        try
            n_nodes = size(nodes, 1);
            if n_nodes >= 2
                % 简支梁情况：获取中点竖向位移
                mid_idx = ceil(n_nodes/2);
                fem_max_deflection = abs(U(3*mid_idx-1));
            else
                fem_max_deflection = max(abs(U(2:3:size(U,1))));
            end
        catch
            fem_max_deflection = max(abs(U));
        end
        
        % 安全地提取单元内力
        if isstruct(elemForces)
            moments = [elemForces.M1, elemForces.M2];
            shears = [elemForces.V1, elemForces.V2];
        else
            % 如果是数组格式
            moments = [elemForces.M1, elemForces.M2];
            shears = [elemForces.V1, elemForces.V2];
        end
        
        fem_max_moment = max(abs(moments(:)));
        fem_max_shear = max(abs(shears(:)));
        
        % 计算误差
        errors.deflection = abs((fem_max_deflection - theory_values.max_deflection) / theory_values.max_deflection) * 100;
        errors.moment = abs((fem_max_moment - theory_values.max_moment) / theory_values.max_moment) * 100;
        errors.shear = abs((fem_max_shear - theory_values.max_shear) / theory_values.max_shear) * 100;
        
    case 'cantilever'
        % 悬臂梁均布荷载验证
        q = abs(loads.udl);
        L = loads.length;
        E = props(1).E;
        I = props(1).I;
        
        % 理论值
        theory_values.max_deflection = q*L^4/(8*E*I);
        theory_values.max_moment = q*L^2/2;
        theory_values.max_shear = q*L;
        
        % FEM结果（悬臂梁自由端）
        n_nodes = size(nodes, 1);
        free_end_dof = 3*n_nodes - 1; % 最后一个节点的竖向位移
        fem_max_deflection = abs(U(free_end_dof));
        fem_max_moment = abs(elemForces(1).M1); % 固定端弯矩
        fem_max_shear = abs(elemForces(1).V1);  % 固定端剪力
        
        % 计算误差
        errors.deflection = abs((fem_max_deflection - theory_values.max_deflection) / theory_values.max_deflection) * 100;
        errors.moment = abs((fem_max_moment - theory_values.max_moment) / theory_values.max_moment) * 100;
        errors.shear = abs((fem_max_shear - theory_values.max_shear) / theory_values.max_shear) * 100;
        
    case 'fixed_ends'
        % 固端梁均布荷载验证
        q = abs(loads.udl);
        L = loads.length;
        E = props(1).E;
        I = props(1).I;
        
        % 理论值
        theory_values.max_deflection = q*L^4/(384*E*I); % 中点挠度为0
        theory_values.support_moment = q*L^2/12;
        theory_values.midspan_moment = q*L^2/24;
        
        % FEM结果
        fem_support_moment = abs(elemForces(1).M1);
        fem_midspan_moment = abs(elemForces(1).M2);
        
        % 计算误差
        errors.support_moment = abs((fem_support_moment - theory_values.support_moment) / theory_values.support_moment) * 100;
        errors.midspan_moment = abs((fem_midspan_moment - theory_values.midspan_moment) / theory_values.midspan_moment) * 100;
        
    case 'truss'
        % 桁架验证（简单桁架）
        P = loads.point_load;
        
        % 理论值（基于静力分析）
        if size(nodes, 1) == 3 % 简单三角形桁架
            L1 = norm(nodes(3,:) - nodes(1,:));
            L2 = norm(nodes(3,:) - nodes(2,:));
            h = nodes(3,2);
            
            theory_values.N1 = -P * L1 / (2 * h); % 杆1轴力
            theory_values.N2 = -P * L2 / (2 * h); % 杆2轴力
            theory_values.N3 = 0; % 底部杆件
            
            % FEM结果
            fem_forces = [elemForces.N1, elemForces.N2, elemForces.N3];
            theory_forces = [theory_values.N1, theory_values.N2, theory_values.N3];
            
            % 计算误差
            errors.N1 = abs((fem_forces(1) - theory_forces(1)) / theory_forces(1)) * 100;
            errors.N2 = abs((fem_forces(2) - theory_forces(2)) / theory_forces(2)) * 100;
            errors.N3 = abs((fem_forces(3) - theory_forces(3))) * 100; % 绝对误差
        end
        
    case 'point_load_beam'
        % 集中荷载简支梁
        P = loads.point_load;
        a = loads.position;
        L = loads.length;
        E = props(1).E;
        I = props(1).I;
        
        % 理论值
        if a == L/2 % 中点荷载
            theory_values.max_deflection = P*L^3/(48*E*I);
            theory_values.max_moment = P*L/4;
        else
            b = L - a;
            theory_values.max_deflection = P*a^2*b^2/(3*E*I*L);
            theory_values.max_moment = P*a*b/L;
        end
        
        % FEM结果
        fem_max_deflection = max(abs(U([2,5,8])));
        fem_max_moment = max(abs([elemForces.M1, elemForces.M2]));
        
        % 计算误差
        errors.deflection = abs((fem_max_deflection - theory_values.max_deflection) / theory_values.max_deflection) * 100;
        errors.moment = abs((fem_max_moment - theory_values.max_moment) / theory_values.max_moment) * 100;
        
end

% 显示验证结果
fprintf('\n=== 验证结果 ===\n');
fields = fieldnames(errors);
for i = 1:length(fields)
    if isfield(errors, fields{i})
        fprintf('%s 误差: %.2f%%\n', fields{i}, errors.(fields{i}));
    end
end

end