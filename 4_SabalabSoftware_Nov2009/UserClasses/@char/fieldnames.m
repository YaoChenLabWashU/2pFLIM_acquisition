function out=fieldnames(wv)
% returns fieldnames in UserData for a cell array of wave names

if nargin ~= 1
    error('fieldnames: A wave must be specified');
end

if ~iswave(wv)
    error('fieldnames: input must be a wave, wavename, or cell array of names');
end

out=evalin('base', ['fieldnames(' wv ')']);
