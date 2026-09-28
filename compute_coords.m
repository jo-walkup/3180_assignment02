%Computes the vertex coordinates that describe a legal linkage configuration
%INPUTS:
%vertex_coords_guess: a column vector containing the (x,y) coordinates of every vertex
%                      these coords are just a GUESS! It's used to seed Newton's method
%leg_params: a struct containing the parameters that describe the linkage
%theta: the desired angle of the crank
%OUTPUTS:
%vertex_coords_root: a column vector containing the (x,y) coordinates of every vertex
%                    these coords satisfy all the kinematic constraints!
function vertex_coords_root = compute_coords(vertex_coords_guess, leg_params, theta)
    %your code here
    link_wrapper = @(vertex_coords) linkage_error_func(vertex_coords, leg_params, theta);
    %you will likely need to make a wrapper function of linkage_error_func
    %so that it is only a function of vertex_coords 
    %(and not leg_params or theta, which should be set beforehand)
    %you can then pass this wrapper function to your multidimensional Newton
    %solver, along with vertex_coords_guess to find the vertex coordinates
    %corresponding to the legal configuration of the linkage, 
    %given the values set for leg_params and theta
    solver_params = struct();
    solver_params.dxmin = 1e-14;
    solver_params.ftol = 1e-14;
    solver_params.max_iter = 200;
    solver_params.dmax = 1e8;
    solver_params.numerical_diff = 1;
    xn = multi_newton_solver(link_wrapper,vertex_coords_guess, solver_params);

    vertex_coords_root=xn;
end

%Error function that encodes all necessary linkage constraints
%INPUTS:
%vertex_coords: a column vector containing the (x,y) coordinates of every vertex
%leg_params: a struct containing the parameters that describe the linkage
%theta: the current angle of the crank
%OUTPUTS:
%error_vec: a vector describing each constraint on the linkage
%           when error_vec is all zeros, the constraints are satisfied
function error_vec = linkage_error_func(vertex_coords, leg_params, theta)
    distance_errors = link_length_error_func(vertex_coords, leg_params);
    coord_errors = fixed_coord_error_func(vertex_coords, leg_params, theta);
    error_vec = [distance_errors;coord_errors];
end

%Error function that encodes the link length constraints
%INPUTS:
%vertex_coords: a column vector containing the (x,y) coordinates of every vertex
%             in the linkage. There are two ways that I would recommend stacking
%             the coordinates. You could alternate between x and y coordinates:
%             i.e. vertex_coords = [x1;y1;x2;y2;...;xn;y_n], or alternatively
%             you could do all the x's first followed by all of the y's
%             i.e. vertex_coords = [x1;x2;...xn;y1;y2;...;yn]. You could also do
%             something else entirely, the choice is up to you.
%leg_params: a struct containing the parameters that describe the linkage
%          importantly, leg_params.link_lengths is a list of linakge lengths
%          and leg_params.link_to_vertex_list is a two column matrix where
%          leg_params.link_to_vertex_list(i,1) and
%          leg_params.link_to_vertex_list(i,2) are the pair of vertices connected 
%          by the ith link in the mechanism
%OUTPUTS:
%length_errors: a column vector describing the current distance error of the ith 
%               link specifically, length_errors(i) = (xb-xa)^2 + (yb-ya)^2 - d_i^2
%               where (xa,ya) and (xb,yb) are the coordinates of the vertices that
%               are connected by the ith link, and d_i is the length of the ith link
function length_errors = link_length_error_func(vertex_coords, leg_params)
    length_errors=[];
    i=1;
    coords_out = column_to_matrix(vertex_coords);
    for i = 1:10 %change this??
        vertex1 = leg_params.link_to_vertex_list(i, 1);
        vertex2 = leg_params.link_to_vertex_list(i, 2);
        length = leg_params.link_lengths(i);
        vertex1x = coords_out(vertex1, 1);
        vertex1y = coords_out(vertex1, 2);
        vertex2x = coords_out(vertex2, 1);
        vertex2y = coords_out(vertex2, 2);

        error = (vertex2x-vertex1x)^2 + (vertex2y-vertex1y)^2 - length^2;
        length_errors = [length_errors; error];
    end
    % while i<length(coords_out)
    % 
    %     xb=coords_out(i, 1);
    %     yb=coords_out(i, 2);
    % 
    %     xa=coords_out(i+1, 1);
    %     ya=coords_out(i+2, 2);
    % 
    %     d_i=leg_params.link_lengths(i);
    %     error = (xb-xa)^2 + (yb-ya)^2 - d_i^2;
    %     length_errors = [length_errors; error];
    % 
    %     i=i+1;
    % end
end

%Error function that encodes the fixed vertex constraints
%INPUTS:
%vertex_coords: a column vector containing the (x,y) coordinates of every vertex
%               same input as link_length_error_func
%leg_params: a struct containing the parameters that describe the linkage
%            importantly, leg_params.crank_length is the length of the crank
%            and leg_params.vertex_pos0 and leg_params.vertex_pos2 are the
%            fixed positions of the crank rotation center and vertex 2.
%theta: the current angle of the crank
%OUTPUTS:
%coord_errors:  a column vector of height four corresponding to the differences
%               between the current values of (x1,y1),(x2,y2) and 
%               the fixed values that they should be
function coord_errors = fixed_coord_error_func(vertex_coords, leg_params, theta)
    %your code here
    x1 = vertex_coords(1);
    y1 = vertex_coords(2);
    x2 = vertex_coords(3);
    y2 = vertex_coords(4);
    x1fix = leg_params.crank_length*sin(theta);
    y1fix = leg_params.crank_length*cos(theta);
    x2fix = leg_params.vertex_pos2(1);
    y2fix = leg_params.vertex_pos2(2);
    current = [x1; y1; x2; y2];
    fixed = [x1fix; y1fix; x2fix; y2fix];
    coord_errors = current - fixed;
end


%Converts from the matrix form of the coordinates back to the
%original column vector form
%INPUTS:
%coords_in = [x1,y1;x2,y2;...;xn,yn] (n x 2 matrix)
%OUTPUTS:
%coords_out = [x1;y1;x2;y2;...;xn;yn] (2n x 1 column vector)
function coords_out = matrix_to_column(coords_in)
    num_coords = 2*size(coords_in,1);
    coords_out = zeros(num_coords,1);
    coords_out(1:2:(num_coords-1)) = coords_in(:,1);
    coords_out(2:2:num_coords) = coords_in(:,2);
end

%Converts from the column vector form of the coordinates to a
%friendlier matrix form
%INPUTS:
%coords_in = [x1;y1;x2;y2;...;xn;yn] (2n x 1 column vector)
%OUTPUTS:
%coords_out = [x1,y1;x2,y2;...;xn,yn] (n x 2 matrix)
function coords_out = column_to_matrix(coords_in)
    num_coords = length(coords_in);
    coords_out = [coords_in(1:2:(num_coords-1)),coords_in(2:2:num_coords)];
end