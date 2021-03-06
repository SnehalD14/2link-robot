clear
close all
clc

figure

quivers = quiver3([0.0; 0.0], [0.0; 0.0], [0.0; 0.0], [0.0; 0.0], [0.0; 0.0], [1.0; 1.0], 1.00, 'Color','b', 'LineWidth', 2.0);

% set z offset for arm if needed
[link1, verts1] = linkGeneration();
[link2, verts2] = linkGeneration();

%provide an offset for verts 2
z_offset = -0.1;
verts2 = bsxfun(@plus, verts2, [0.0, 0.0, z_offset]);

xlim([-2.25 2.25])
ylim([-2.25 2.25])
zlim([-2 2])

%set(gca,'xtick',[])
set(gca,'xticklabel',[])
%set(gca,'ytick',[])
set(gca,'yticklabel',[])
%set(gca,'ztick',[])
set(gca,'zticklabel',[])

camlight
campos([0.0 0.0 2]);
camorbit(25,50,'camera')

axis equal

traj1 = animatedline('Marker','none', 'Color', [0.4, 0.4, 0.4], 'LineWidth', 1.0);
traj2 = animatedline('Marker','none', 'Color', [0.4, 0.4, 0.4], 'LineWidth', 1.0);

load joint_data.mat;
% Data loaded are:
% W: PD controller with gravity
% P: Iterative learning controller
% X: Inverse dynamics controller
% Y: Lapunov-based controller
% Z: Passiviy-based controller

% X: Inverse-Dynamics controller
th1 = X(:,1)';
th2 = X(:,2)';
th1_dot = X(:,3)';
th2_dot = X(:,4)';

% Y: Lapunov-based controller
%th1 = Y(:,1)';
%th2 = Y(:,2)';
%th1_dot = Y(:,3)';
%th2_dot = Y(:,4)';

% Z: Passiviy-based controller
%th1 = Z(:,1)';
%th2 = Z(:,2)';
%th1_dot = Z(:,3)';
%th2_dot = Z(:,4)';


for i=1:size(th1,2)
    [fr1, pos1, fr2, pos2] = planar_fk2(th1(i), th2(i));

    linkTransform(link1, verts1, fr1)
    linkTransform(link2, verts2, fr2)

    addpoints(traj1, pos1(1), pos1(2), pos1(3));
    addpoints(traj2, pos2(1), pos2(2), pos2(3)+z_offset);

    % TODO: test different scaling factors
    %vec_w1 = sign(th1_dot(i))*0.1 + th1_dot(i)*0.010;
    %vec_w2 = sign(th2_dot(i))*0.1 + th2_dot(i)*0.010;
    
    vec_w1 = sign(th1_dot(i))*0.1 + th1_dot(i);
    vec_w2 = sign(th2_dot(i))*0.1 + th2_dot(i);
    
    set(quivers, 'xdata', [0; pos1(1)],'ydata', [0; pos1(2)], 'wdata', [vec_w1; vec_w2]);

    axis equal
    xlim([-2.25 2.25])
    ylim([-2.25 2.25])
    zlim([-1 1])

    drawnow;
 %   if i==1
 %      pause(10)
 %   end
end
