function spc_fixLifetimeAxes
% needed if there are any zeros in lifetime data, to prevent incorrect
% autoscaling of top axis
global gui
axTop=axis(gui.spc.figure.lifetimeAxes);
axBottom=axis(gui.spc.figure.residual);
axTop(1:2)=axBottom(1:2);  %make sure that the x-ranges match
axis(gui.spc.figure.lifetimeAxes,axTop);
axis(gui.spc.figure.lifetimeAxes,'auto y');
