function checkForOldPlots(wvname)
% This function will prompt the user if they want to remove calls to a wvae that is about
% to be created.
% This occurs of the wave was not killed properly.
% wvname is a string

if ~ischar(wvname)
    error('checkForOldPlots: wvname must be a char.');
end

a = [findobj('Type', 'line') findobj('type', 'image')];  % Get images that are open...
userdata = get(a, 'UserData');	    % Look in UserData.

if iscell(userdata)
    query=0;
    for i = 1:length(a)	
        if isfield(userdata{i}, 'name') 
            if strcmp(userdata{i}.name,wvname)
                if ~query
                    button = questdlg(['Do you want to Remove Old Plots with Name ' wvname],...
                        'Action to Take:','Delete All','Delete Current','Cancel Clear','Delete All');
                    if strcmp(button,'Delete All')
                        delete(a(i));
                        query=1;    % Dont ask again, just kill them
                    elseif strcmp(button,'Delete Current')
                        delete(a(i));   % Ask before killing each wave
                    elseif strcmp(button,'Cancel Clear')
                        return  % Stop Killing
                    end
                else
                    delete(a(i));
                end
            end
        end
    end
elseif isfield(userdata, 'name') % Only one plot on graph
    if strcmp(userdata.name,wvname)
        button = questdlg(['Do you want to Remove Old Plots with Name ' wvname],...
            'Action to Take:','Delete','Cancel Clear','Delete');
        if strcmp(button,'Delete')
            delete(a);
        elseif strcmp(button,'Cancel Clear')
            return  % Stop Killing
        end
    end
end