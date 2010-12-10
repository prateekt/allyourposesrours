function [fixedR, fixedT, varR, varT] = getRT()

%fixedR{1},fixedT{1} is forward, no rotation
%fixedR{2},fixedT{2} is sideways, no rotation
%fixedR{3},fixedT{3} is pure rotation (45 deg around each axis), no translation 

%fixed R
fixedR{1} = eye(3,3);
fixedR{2} = eye(3,3);
fixedR{3} = [1 0 0; 0 cosd(45) -1*sind(45); 0 sind(45) cosd(45)] * [cosd(45) 0 sind(45); 0 1 0; -1*sind(45) 0 cosd(45)] * [cosd(45) -1*sind(45) 0; sind(45) cosd(45) 0; 0 0 1];

%fixed T
fixedT{1} = [0,0,1];
fixedT{2} = [1,0,0];
fixedT{3} = [0,0,0];

%variety of R and 
var_i = 1;
for theta_x_ind=0:1
    for theta_y_ind=0:1
        for theta_z_ind=0:1
            for t_x=0:1
                for t_y=0:1
                    for t_z=0:1
                        if(theta_x_ind==0)
                            theta_x = 0;
                        else
                            theta_x = 45;
                        end
                        if(theta_y_ind==0)
                            theta_y = 0;
                        else
                            theta_y = 45;
                        end
                        if(theta_z_ind==0)
                            theta_z = 0;
                        else
                            theta_z = 45;
                        end
                        varR{var_i} = [1 0 0; 0 cosd(theta_x) -1*sind(theta_x); 0 sind(theta_x) cosd(theta_x)] * [cosd(theta_y) 0 sind(theta_y); 0 1 0; -1*sind(theta_y) 0 cosd(theta_y)] * [cosd(theta_z) -1*sind(theta_z) 0; sind(theta_z) cosd(theta_z) 0; 0 0 1];
                        varT{var_i} = [t_x, t_y, t_z];
                        var_i = var_i + 1;
                    end
                end
            end
        end
    end
end