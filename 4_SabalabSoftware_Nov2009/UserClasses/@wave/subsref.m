function b=subsref(wv,s)

userdataflag=0;
for counter=1:length(s)
    switch s(counter).type
        case '.'	% Referennce fields like a structure
            if ~userdataflag
                switch s(counter).subs
                    case 'data'
                        b=wv.data;
                    case 'UserData'
                        b=wv.UserData;
                        userdataflag=1;
                    case 'note'
                        b=wv.note;
                    case 'plot'
                        b= wv.plot;
                    case 'xscale'
                        b=wv.xscale;
                    case 'yscale'
                        b=wv.yscale;
                    case 'zscale'
                        b=wv.zscale;
                    case 'timeStamp'
                        b=wv.timeStamp;
                    case 'holdUpdates'
                        b=wv.holdUpdates;
                    case 'needsReplot'
                        b=wv.needsReplot;
                    otherwise
                        b=[];
                        error('wave/subsref : unknown wave field');
                end
            else
                b=getfield(b,s(counter).subs);
            end
            
        case '()'	% Reference by points, like igor p
            % Standard matlab indexing.
            if counter==1
                b=wv.data;
            end
            len=length(s(counter).subs); % What index was sent in??
            if len == 1
                b=b(s(counter).subs{1});
            elseif len== 2  % indexing a 2dwave...
                b = b(s(counter).subs{1},s(counter).subs{2});
            else
                error('wave/subsref: reference is only allowed in 1D or 2D');
            end
            
        case '{}'	% Reference by points, like igor p
            % Standard matlab indexing.
            if counter==1
                b=wv.data;
            end
            len=length(s(counter).subs); % What index was sent in??
            for subsCounter=1:len
                if isnumeric(s(counter).subs{subsCounter})
                    switch subsCounter
                        case 1
                            s(counter).subs{1}=unique(x2pnt(wv, s(counter).subs{1}));
                        case 2
                            s(counter).subs{2}=unique(y2pnt(wv, s(counter).subs{2}));
                        case 3
                            s(counter).subs{3}=unique(z2pnt(wv, s(counter).subs{3}));
                        otherwise
                            error('wave/subsref : counter is greater than 3');
                    end
                end
            end	
            if len == 1
                b=b(s(counter).subs{1});
            elseif len== 2  % indexing a 2dwave...
                b = b(s(counter).subs{1},s(counter).subs{2});
            else
                error('wave/subsref: reference is only allowed in 1D or 2D');
            end
        otherwise
            error('wave/subsref : unknown index for wave');
            b=[];
    end
end
