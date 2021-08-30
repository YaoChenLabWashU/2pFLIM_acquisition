function Aout = add2d(A, Bx)

% add2d.m*****
% Function that adds over Bx columns in an image array. 
%
% Function that bins by averaging over Bx (columns) elements along the x-axis.  A is a 2D intensity matrix.
% Bx must be divisible into the array dimensions.
% 
% By is the Binning factor for rows (lines)
% Function Form: add2d(A,Bx)
%
% Written By: Thomas Pologruto
% Cold Spring Harbor Labs
% January 26, 2001.
%
% Edited By: Bernardo Sabatini
% January 26, 2001
% Cold Spring Harbor Labs

	Ny = size(A,1);	
	Nx = size(A,2);			% Tells function the number of columns of A
	
	if Bx == 1
		Aout = A;
	else
		Aout = sum(reshape(A', Bx, Ny*(Nx/Bx)));
		Aout = reshape(Aout, (Nx/Bx), Ny)';
	end
	
	
	
	

	