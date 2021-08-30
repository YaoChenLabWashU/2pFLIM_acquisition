function wv =  subsasgn(wv,s,val)
% SUBSREF for class wave
% This function allows you to index using structure(.), array (), or cell array {} indexing.
%
needUpdate=0;
wavename=inputname(1);
switch s(1).type
    case '.'	% Referennce fields like a structure
        switch s(1).subs
            case 'data'
                if length(s)==1 	% they are replacing the whole data field
                    s(1).type='d';
                    s(1).subs=repmat({':'},1, min(numdims(val),1));
                    [wv, needUpdate]=setWaveDataRange(wv, s(1), val);
                elseif s(2).type=='()' | s(2).type=='{}'
                    [wv, needUpdate]=setWaveDataRange(wv, s(2), val);
                else
                    error('wave/subsasgn : error indexing data field');
                end
            case 'holdUpdates'
                if val==0 | val==1
                    wv.holdUpdates=val;
                else
                    error('wave: Invalid value for holdUpdates. holdUpdates must be a 1 or 0. Skipping.');
                end 
            case 'needsReplot'
                if val==0 | val==1
                    wv.needsReplot=val;
                else
                    error('wave: Invalid value for needsReplot. needsReplot must be a 1 or 0. Skipping.');
                end 
            case 'UserData'
                name=parseUserData(s);
                a=wv.UserData;
                eval(['a' name '=val;']);
                if isstruct(a)
                    wv.UserData=a;
                else
                    error('wave: Invalid value for UserData. UserData must be structure. Skipping.');
                end
            case 'note'
                if ischar(val) 
                    wv.note=val;
                else
                    error('wave/subsasgn : note must be a char.');
                end
            case 'plot'
                if isempty(val)
                    wv.plot=[];
                else
                    wv.plot=val;
                end
            case 'xscale'
                if isnumeric(val)
                    if length(s)==1	
                        if length(val)==2
                            wv.xscale=val;
                            needUpdate=1;
                        end
                    else
                        if strcmp(s(2).type, '()')
                            if s(2).subs{1}==':'
                                if length(val)==2
                                    wv.xscale=val;
                                    needUpdate=1;
                                end
                            elseif isnumeric(s(2).subs{1})
                                pos=s(2).subs{1};
                                if length(pos)==1
                                    if pos==1 | pos==2
                                        if length(val)==1
                                            wv.xscale(pos)=val;
                                            needUpdate=1;
                                        end
                                    end
                                elseif length(pos)==2
                                    if pos==[1 2]
                                        if length(val)==2
                                            wv.xscale=val;
                                            needUpdate=1;
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                if ~needUpdate
                    error('wave/subsassgn : incorrect indexing for xscale');
                end
            case 'yscale'
                if isnumeric(val)
                    if length(s)==1	
                        if length(val)==2
                            wv.yscale=val;
                            needUpdate=1;
                        end
                    else
                        if strcmp(s(2).type, '()')
                            if s(2).subs{1}==':'
                                if length(val)==2
                                    wv.yscale=val;
                                    needUpdate=1;
                                end
                            elseif isnumeric(s(2).subs{1})
                                pos=s(2).subs{1};
                                if length(pos)==1
                                    if pos==1 | pos==2
                                        if length(val)==1
                                            wv.yscale(pos)=val;
                                            needUpdate=1;
                                        end
                                    end
                                elseif length(pos)==2
                                    if pos==[1 2]
                                        if length(val)==2
                                            wv.yscale=val;
                                            needUpdate=1;
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                if ~needUpdate
                    error('wave/subsassgn : incorrect indexing for yscale');
                end
            case 'zscale'
                if isnumeric(val)
                    if length(s)==1	
                        if length(val)==2
                            wv.zscale=val;
                            needUpdate=1;
                        end
                    else
                        if strcmp(s(2).type, '()')
                            if s(2).subs{1}==':'
                                if length(val)==2
                                    wv.zscale=val;
                                    needUpdate=1;
                                end
                            elseif isnumeric(s(2).subs{1})
                                pos=s(2).subs{1};
                                if length(pos)==1
                                    if pos==1 | pos==2
                                        if length(val)==1
                                            wv.zscale(pos)=val;
                                            needUpdate=1;
                                        end
                                    end
                                elseif length(pos)==2
                                    if pos==[1 2]
                                        if length(val)==2
                                            wv.zscale=val;
                                            needUpdate=1;
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                if ~needUpdate
                    error('wave/subsassgn : incorrect indexing for zscale');
                end
            case 'timeStamp'
                if isnumeric(val) & numdims(val)==0
                    wv.timeStamp=val;
                else
                    error('wave/subsassgn : timeStamp must be numeric scalar.');
                end
            otherwise
                disp('wave/subsassgn : field not found in wave');
        end
        
    case '()'	% Reference by points, like igor p
        wv=setWaveDataRange(wv, s(1), val);
        needUpdate=1;
        
    case '{}'	% Reference by x val, like igor x
        wv=setWaveDataRange(wv, s(1), val);
        needUpdate=1;
        
    otherwise
        error('wave/subsassign : unknown type');
end

if needUpdate & ~wv.holdUpdates
    if any(ishandle(wv.plot))
        updateWavePlots(wv);
    end
elseif needUpdate & wv.holdUpdates
    wv.needsReplot=1;
end

function name=parseUserData(s)
name=[];
for counter=2:length(s)
    if strcmp(s(counter).type,'.')
        name=[name '.' s(counter).subs ];
    end
end


function [wv, needUpdate]=setWaveDataRange(wv, s, val)
needUpdate=0;

if s.type=='d'
    needUpdate=1;
    if isempty(val)
        wv.data=[];
    else
        wv.data=val;
    end
    return
end

if s.type=='{}'
    s.type='()';	% force to next case
    for counter=1:length(s.subs)
        if isnumeric(s.subs{counter})
            switch counter
                case 1
                    s.subs{counter}=unique(x2pnt(wv, s.subs{counter}));
                case 2
                    s.subs{counter}=unique(y2pnt(wv, s.subs{counter}));
                case 3
                    s.subs{counter}=unique(z2pnt(wv, s.subs{counter}));
                otherwise
                    error('wave/subsaggn : counter is greater than 3');
            end
        end
    end
end

if s.type=='()'
    needUpdate=1;
    newpos={};
    dataSize=size(wv.data);
    if length(s.subs)==1
        wv.data(s.subs{1})=val;
    elseif length(s.subs)==2
        wv.data(s.subs{1}, s.subs{2})=val;
    end
end
