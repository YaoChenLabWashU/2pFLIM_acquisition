function loadWaveFromStructure(a,name)
% Overload for load of classs wave.
% a is what is saved, a structure array
% This is converted to a wave by the loadobj function
nameOfFile = fieldnames(a);		% a is a struct. First field is the name of the wave
if iscell(nameOfFile)			
	nameOfFile = nameOfFile{1};
end
nameOfWave=nameOfFile;
if nargin == 2
	if ischar(name)
		nameOfWave=name;
	else
		nameOfWave=nameOfFile;
	end
end
if iswave(nameOfWave)
	error('loadWaveFromStructure: Wave already exists; USe loadWaveo');
end
loadWaveFromStructureo(a,nameOfWave)
