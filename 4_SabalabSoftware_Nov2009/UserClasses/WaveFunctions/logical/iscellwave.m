function out=iscellwave(input)
% tells if the structure is a cell array of wave names
% outputs an array of the sam elength as the input, with 0 and ones
% in it.  Use all or any for logical IDS.
%
% Use waveCell=waveCell(iscellwave(waveCell)) to remove the non wave names from the waveCell.
%
% generalize the iswave call to include cell arrays of  wave names.

out=[];
if iscellstr(input)
    for i=1:length(input)
        if iswave(input{i})
            out=[out 1];
        else
            out=[out 0];
        end
    end
    out=logical(out);
elseif ischar(input)
    out=logical(iswave(input));
else
    error('iscellwave: input must be a cell array of strings');
end


