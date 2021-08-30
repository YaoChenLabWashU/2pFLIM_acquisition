function closeMotorGUI
global gh

% closeMotorGUI.m****
% Function that executes if the X is hit on the MotorGUI window.
% Also updates the globals to save the current positions and z-steps.
%
% Written By: Thomas Pologruto
% Cold Spring Harbor Labs
% January 4, 2001

try
	set(gh.motorGUI.figure1, 'Visible', 'Off');
end

	