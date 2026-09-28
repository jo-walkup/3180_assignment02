%runs strandbeest simulation
function strandbeest_simulation()
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
    fname='s_animation.avi';
    input_fname = [fname];
    %create a videowriter, which will write frames to the animation file
    writerObj = VideoWriter(input_fname);
    
    %must call open before writing any frames
    open(writerObj);
    %initialize the current figure and save as object
    fig1 = figure(1);
    title("Strandbeest Walking");
    xlabel("x position (-)")
    ylabel("y postion (-)")
     %this is the critical line that forces the video to be high quality
    %adjust the numbers to adjust the position/size of the plotting window
    set(fig1,'units','pixels','position',[0 0 1440 1080]);
    
    %set up the plotting axis
    hold on; axis equal; axis square
    axis([-120,40,-120,40])

    x_LA=[];
    y_LA=[];
    x_FD=[];
    y_FD=[];
    x_list=[];
    y_list=[];
    theta_list=[];

    tip_vx_list=[];
    tip_vy_list=[];

    hold on
    pathplot=plot(0,0,"k--");
    tan_plot=plot(0,0, "g", "Markersize", 30);
   
    leg_drawing = initialize_leg_drawing(leg_params);

    
    for theta=0:0.03:2*pi

        complete_vertex_coords=compute_coords(vertex_coords_guess, leg_params, theta);

        update_leg_drawing(complete_vertex_coords, leg_drawing, leg_params);

        dVdtheta = compute_velocities(complete_vertex_coords, leg_params, theta);


        tip_vx_list(end+1)= dVdtheta(13)
        tip_vy_list(end+1)= dVdtheta(14)

        q = 1;
        tan_plot_x = complete_vertex_coords(13)+[0,q*dVdtheta(13)];
        tan_plot_y = complete_vertex_coords(14)+[0,q*dVdtheta(14)];
        % set(tan_plot, 'xdata', tip_vx_list, 'ydata', tip_vy_list);
        set(tan_plot, 'xdata', tan_plot_x, 'ydata', tan_plot_y);
        theta_list(end+1) = theta;

        if theta<=2*pi
            x_list(end+1)= complete_vertex_coords(13);
            y_list(end+1)= complete_vertex_coords(14);

            set(pathplot, 'xdata', x_list, 'ydata', y_list);

        end
        drawnow;
        current_frame = getframe(fig1);
        writeVideo(writerObj, current_frame);
    end
    close(writerObj);

    
    plot(theta, tip_vx_list)
    plot(theta, tip_vy_list)
end