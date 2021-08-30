function currentPointOnAxes = recordCurrentPoint(axis)

% Thsi function returns the current Point on the axis, rounded to the nearest integer.

	currentPointOnAxes = get(axis, 'CurrentPoint');
	currentPointOnAxes = round(currentPointOnAxes(1, 1:2));


