function range=spc_WriteToExcelCOM(writeParams, increment, data, startCol)
% if (writeParams) -- do the ddepoke from spc.analysis.fieldsForExcel
% if (increment) -- at end, go to next row, first column
% if startCol is specified, starts in that column
	global spc
	
	if isempty(spc.analysis.excelChannel)
		beep;
		disp('*** Excel Link not open ***');
		return
	end

	if ~isnumeric(spc.analysis.excelNextCol)
		spc.analysis.excelNextCol=1;
	end
	if nargin==4
		spc.analysis.excelNextCol=startCol;
	end
	if nargin<3
		data=[];
	end
	if nargin<2
		increment=1;
	end
	if nargin<1
		writeParams=1;
    end
	
    
    
    
    range=get(spc.analysis.sheet,'Range',cellspec(spc.analysis.excelRow,spc.analysis.excelNextCol));
    range.Value=data;
    spc.analysis.excelNextCol=spc.analysis.excelNextCol+1;
    
    if increment
			spc.analysis.excelRow = spc.analysis.excelRow + 1;
			spc.analysis.excelNextCol=1;		
	end
    
    
% 	try
% 		if writeParams
% 			for col=1:size(spc.analysis.fieldsForExcel, 2)
% 				ddepoke(spc.analysis.excelChannel, ...
% 					['r' num2str(spc.analysis.excelRow) ...
% 						'c' num2str(col+spc.analysis.excelNextCol-1)], ...
% 					getfield(spc.analysis, spc.analysis.fieldsForExcel{col}));
% 			end
% 			spc.analysis.excelNextCol=spc.analysis.excelNextCol+size(spc.analysis.fieldsForExcel, 2);
% 		end
% 		
% 		if ~isempty(data)
% 			ddepoke(spc.analysis.excelChannel, ['r' num2str(spc.analysis.excelRow) 'c' num2str(spc.analysis.excelNextCol) ...
% 					':r' num2str(spc.analysis.excelRow) 'c' num2str(spc.analysis.excelNextCol-1+size(data, 2))], data);
% 			if isnumeric(data)
% 				spc.analysis.excelNextCol=spc.analysis.excelNextCol + size(data, 2);
% 			else
% 				spc.analysis.excelNextCol=spc.analysis.excelNextCol + 1;
% 			end
% 		end
% 		
% 		if increment
% 			spc.analysis.excelRow = spc.analysis.excelRow + 1;
% 			spc.analysis.excelNextCol=1;		
% 		end
% 		% updateGuiByGlobal('spc.analysis.excelRow');
% 	catch
% 		beep
% 		disp(['spc_WriteDataToExcel : Caught error ' lasterr ])	
% 	end
	
    function str = cellspec(row,col)
    % specify an Excel cell
    str = [excelColNameFromNumber(col) num2str(row)];