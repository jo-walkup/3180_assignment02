%runs strandbeest simulation
function strandbeest_simulation_v()
clf;

set(groot, 'defaultTextInterpreter', 'latex');
set(groot, 'defaultAxesTickLabelInterpreter', 'latex');
set(groot, 'defaultLegendInterpreter', 'latex');

    leg_params = define_leg_parameters();

    %column vector of initial guesses
    %for each vertex location.
    %in form: [x1;y1;x2;y2;...;xn;yn]
    vertex_coords_guess = [...
    [   0;   50];... %vertex 1 guess
    [ -50;    0];... %vertex 2 guess
    [ -50;   50];... %vertex 3 guess 
    [-100;    0];... %vertex 4 guess
    [-100;  -50];... %vertex 5 guess
    [ -50;  -50];... %vertex 6 guess
    [ -50; -100]...  %vertex 7 guess  
    ];   

    %your code here
    %this code will likely involve a loop, where you call
    %compute_coords at each iteration
    %you likely will also need to call update_leg_drawing each iteration


    x_LA=[];
    y_LA=[];
    x_FD=[];
    y_FD=[];
    x_list=[];
    y_list=[];
    theta_list=[];

    tip_vx_list=[];
    tip_vy_list=[];

    tip_vx_list2=[];
    tip_vy_list2=[];
  
    
    for theta=0:0.03:2*pi

        complete_vertex_coords=compute_coords(vertex_coords_guess, leg_params, theta);

        dVdtheta = compute_velocities(complete_vertex_coords, leg_params, theta);

        wrapper= @(t) compute_coords( complete_vertex_coords, leg_params, t);

        J = approximate_jacobian(wrapper, theta);


        tip_vx_list2(end+1)= J(13);
        tip_vy_list2(end+1)= dVdtheta(14);

        tip_vx_list(end+1)= dVdtheta(13);
        tip_vy_list(end+1)= dVdtheta(14);
        theta_list(end+1) = theta;

       
    end

    figure(1)
    plot(theta_list, tip_vx_list, 'r',  "linewidth", 2); hold on;
    plot(theta_list, tip_vx_list2, 'b--',  "linewidth", 2); 
    title("Velocity Graph of X Component of Strandbeest")
    xlabel("Theta (radians)")
    ylabel("Velocity (-)")
    legend("Linear Algebra Method", "Finite Difference Method")


    hold off

    figure(2)
    plot(theta_list, tip_vy_list, 'r', "linewidth", 2); hold on;
    plot(theta_list, tip_vy_list2, 'b--',  "linewidth", 2); 
    title("Velocity Graph of Y Component of Strandbeest", "linewidth", 2)
    xlabel("Theta (radians)")
    ylabel("Velocity (-)")
    legend("Linear Algebra Method", "Finite Difference Method")
end