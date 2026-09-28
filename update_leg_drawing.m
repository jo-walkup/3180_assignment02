%Updates the plot objects that visualize the leg linkage
%for the current leg configuration
%INPUTS:
%complete_vertex_coords: a column vector containing the (x,y) coordinates of every vertex
%leg_drawing: a struct containing all the plotting objects for the linkage
%       leg_drawing.linkages is a cell array, where each element corresponds
%       to a plot of a single link (excluding the crank)
%       leg_drawing.crank is a plot of the crank link
%       leg_drawing.vertices is a cell array, where each element corresponds
%       to a plot of one of the vertices in the linkage
function update_leg_drawing(complete_vertex_coords, leg_drawing, leg_params)
    %iterate through each link, and update corresponding link plot
    num_vertices= leg_params.num_vertices;
    crank_length= leg_params.crank_length;
    num_linkages= leg_params.num_linkages;
    link_to_vertex_list=leg_params.link_to_vertex_list;
    link_length=leg_params.link_lengths;
    pos0=leg_params.vertex_pos0;
    pos2=leg_params.vertex_pos2;


    coords_out=column_to_matrix(complete_vertex_coords);

    for linkage_index = 1:leg_params.num_linkages
        
        %linkage_index is the label of the current link
        v1_index=link_to_vertex_list(linkage_index,1);
        v2_index=link_to_vertex_list(linkage_index,2);

        x1=coords_out(v1_index,1);
        y1=coords_out(v1_index,2);
        x2=coords_out(v2_index,1);
        y2=coords_out(v2_index,2);
        
        %line_x and line_y should both be two element arrays containing
        %the x and y coordinates of the line segment describing the current link
        line_x = [x1, x2];
        line_y = [y1, y2];
        set(leg_drawing.linkages{linkage_index},'xdata',line_x,'ydata',line_y); 
    end

    %iterate through each vertex, and update corresponding vertex plot
    for vertex_index = 1:leg_params.num_vertices

        %vertex_index is the label of the current vertex
        x_i = coords_out(vertex_index, 1);
        y_i = coords_out(vertex_index, 2);

        %dot_x and dot_y should both be scalars
        %specifically the x and y coordinates of the corresponding vertex
        dot_x = x_i;%your code here;
        dot_y = y_i;%;your code here;
        
        set(leg_drawing.vertices{vertex_index},'xdata',dot_x,'ydata',dot_y); 
    end

    %your code here
    x0 = pos0(1);
    y0 = pos0(2);
    x1 = coords_out(1, 1);
    y1 = coords_out(1, 2);

    %crank_x and crank_y should both be two element arrays
    %containing the x and y coordinates of the line segment describing the crank
    crank_x = [x0, x1];
    crank_y = [y0, y1];
    
    set(leg_drawing.crank,'xdata',crank_x,'ydata',crank_y);
end