function out = redim(wv, pts, front)
% This fucntion takes in a wave and outputs a vector containg only the points
% given in pts.
% It adds and subtracts points from the back of the wave.
% if you set the flag to 'front', it will cut from the fron and appen to the front.

if nargin < 2 | nargin > 3
	error('redim: need to enter a wave and the pts');
end

if isnumeric(pts)
	if pts < 0
		error('redim: pts needs to be an integer greater than 0');
	elseif mod(pts,1) == 0	% not an integer
		pts=round(pts);
	else
		error('redim: pts needs to be an integer greater than 0');
	end
end

data = wv.data;
le = length(data);
if nargin == 2 	% normal padd and cut from back
	if pts > le 	% padding to zero
		pad = zeros(1,(pts-le));
		out = [data pad];
	elseif pts == le	% in and out the same
		out = data;
	elseif	pts < le
		out = data(1:pts);
	end
elseif nargin == 3
	if strcmp(front, 'f')	% append from front
		if pts > le 	% padding to zero
			pad = zeros(1,(pts-le));
			out = [pad data];
		elseif pts == le	% in and out the same
			out = data;
		elseif	pts < le
			out = data((le-pts+1):end);
		end
	else
		error('redim: only parameter to enter is ''f'' .');
	end
end






