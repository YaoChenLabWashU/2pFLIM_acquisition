function splayAxisTile(f,varargin)
% Display a bunch of axes as a tile
% Can input heightH,heightV,startH,startV,gapH,gapV

if nargin == 0
    f=gcf;  
else
    if mod(length(varargin),2)==1   % passed a f...
        varargin=[{f} varargin];
        f=gcf;   
   end    
end

allAx=findobj(f, 'Type', 'axes', 'Box', 'off');
nAx=length(allAx);
if nAx==0
	return
end

nSq=ceil(sqrt(nAx));
nV=ceil(nAx/nSq);

gapH=.05;
startH=.07;
heightH=0.9;
gapV=.07;
startV=.07;
heightV=0.9;

% Parse input parameter pairs and rewrite values.
counter=1;
while counter+1 <= length(varargin)
    eval([varargin{counter} '=' num2str(varargin{counter+1}) ';']);
    counter=counter+2;
end

deltaV=(heightV-gapV*(nV-1))/nV;
deltaH=(heightH-gapH*(nSq-1))/nSq;

for lineCounter=1:nV
	for rowCounter=1:nSq
		place=(lineCounter-1)*nSq+rowCounter;
		if place<=nAx
			set(allAx(nAx-place+1), 'Position', [startH+(rowCounter-1)*(deltaH+gapH) startV+(lineCounter-1)*(deltaV+gapV)  deltaH deltaV ]);
		end
	end
end
