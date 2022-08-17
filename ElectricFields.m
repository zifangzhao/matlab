%-------------------------------------------------------------------------%
%       This simple program computes the Electric Fields due to dipole  
%           in a 2-D plane using the Coulomb's Law
%-------------------------------------------------------------------------%

clc
close all; clear all;

%-------------------------------------------------------------------------%
%                   SYMBOLS USED IN THIS CODE                             
%-------------------------------------------------------------------------%

% E = Total electric field
% Ex = X-Component of Electric-Field
% Ey = Y-Component of Electric-Field
% n = Number of charges
% Q = All the 'n' charges are stored here
% Nx = Number of grid points in X- direction
% Ny = Number of grid points in Y-Direction
% eps_r = Relative permittivity
% r = distance between a selected point and the location of charge
% ex = unit vector for x-component electric field
% ey = unit vector for y-component electric field
%-------------------------------------------------------------------------%


%-------------------------------------------------------------------------%
%                         INITIALIZATION                                  
%          Here, all the grid, size, charges, etc. are defined
%-------------------------------------------------------------------------%

% Constant 1/(4*pi*epsilon_0) = 9*10^9
k = 9*10^9;

% Enter the Relative permittivity
eps_r = 1;
charge_order = 10^-9; % milli, micro, nano etc..
const = k*charge_order/eps_r;

% Enter the dimensions
Nx = 101; % For 1 meter
Ny = 101; % For 1 meter

% Enter the number of charges.
n = 2;

% Electric fields Initialization
E_f = zeros(Nx,Ny);
Ex = E_f;
Ey = E_f;

% Vectors initialization
ex = E_f;
ey = E_f;
r = E_f;
r_square = E_f;

% Array of charges
Q = [1,-1];

% Array of locations
X = [5,-5];
Y = [0,0];

%-------------------------------------------------------------------------%
%                   COMPUTATION OF ELECTRIC FIELDS
%-------------------------------------------------------------------------%

%  Repeat for all the 'n' charges
for k = 1:n
    q = Q(k);
    
    % Compute the unit vectors
    for i=1:Nx
        for j=1:Ny

            r_square(i,j) = (i-51-X(k))^2+(j-51-Y(k))^2;
            r(i,j) = sqrt(r_square(i,j));
            ex(i,j) = ex(i,j)+(i-51-X(k))./r(i,j);
            ey(i,j) = ey(i,j)+(j-51-Y(k))./r(i,j);
        end
    end
    
    

    E_f = E_f + q.*const./r_square;

    Ex = Ex + E_f.*ex.*const;
    Ey = Ex + E_f.*ey.*const;

end

%-------------------------------------------------------------------------%
%                   PLOT THE RESULTS
%-------------------------------------------------------------------------%

x_range = (1:Nx)-51;
y_range = (1:Ny)-51;
contour_range = -8:0.02:8;
contour(x_range,y_range,E_f',contour_range,'linewidth',0.7);
axis([-15 15 -15 15]);
colorbar('location','eastoutside','fontsize',12);
xlabel('x ','fontsize',14);
ylabel('y ','fontsize',14);
title('Electric field distribution, E (x,y) in V/m','fontsize',14);

%-------------------------------------------------------------------------%
%                  REFERENCE
% SADIKU, ELEMENTS OF ELECTROMAGNETICS, 4TH EDITION, OXFORD
%-------------------------------------------------------------------------%


