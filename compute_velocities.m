%Computes the theta derivatives of each vertex coordinate for the Jansen linkage
%INPUTS:
%vertex_coords: a column vector containing the (x,y) coordinates of every vertex
%               these are assumed to be legal values that are roots of the error funcs!
%leg_params: a struct containing the parameters that describe the linkage
%theta: the current angle of the crank
%OUTPUTS:
%dVdtheta: a column vector containing the theta derivates of each vertex coord
function dVdtheta = compute_velocities(vertex_coords, leg_params, theta)
   
    link_wrapper = @(vertex_coords) link_length_error_func(vertex_coords, leg_params);

    J = approximate_jacobian(link_wrapper,vertex_coords);

    l=leg_params.crank_length;

    dx1=-l*sin(theta);
    dy1=l*cos(theta);
    dx2=0;
    dy2=0;

    B=[dx1;dy1;dx2;dy2;0;0;0;0;0;0;0;0;0;0];

    I=eye(4);
    o=zeros(4,10);

    M=[I, o;J];

    dVdtheta=M\B;

end