function turnOffAllChildren(h)
	c=get(h, 'Children');
	
	set(c, 'enable', 'off');
