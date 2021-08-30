function map = makeColorMap(color, bits)
	
	a = zeros(2^bits,1);
	b = (0:1/(2^bits -1):1)';
	
	switch color 
	case 'red'
		map = squeeze(cat(3, b, a, a));
	case 'green'
		map = squeeze(cat(3, a, b, a));
	case 'blue'
		map = squeeze(cat(3, a, a, b));
	case 'graySat'
		map = squeeze(cat(3, b, b, b));
		map(1,:)=[0 0 0.5];
		map(end,:)=[0.5 0 0];
	case 'gray'
		map = squeeze(cat(3, b, b, b));
	end
	
		