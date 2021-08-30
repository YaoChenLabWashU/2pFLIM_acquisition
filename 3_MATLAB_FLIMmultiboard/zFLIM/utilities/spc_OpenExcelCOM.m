function spc_OpenExcelCOM
	global spc
    ExcelExportConfig; % open the modal dialog to select options
    
	[fname, pname] = uigetfile('*.xls*', 'Choose Excel File to Open...');
	if pname == 0
		return
	else
		spc.analysis.excelFileName = [pname fname];
    end
    try
        spc.analysis.excelChannel=actxserver('Excel.Application');
        spc.analysis.excelFile=spc.analysis.excelChannel.Workbooks.Open(spc.analysis.excelFileName);
    catch
		disp('Not a valid File name');
		spc.analysis.excelChannel=[];
        return
    end
	
    % specify the starting row in the Excel file
    headerRow=25;
    
    params=[spc.analysis.fieldsForExcelLabels ];
    spc.analysis.sheet=spc.analysis.excelChannel.Worksheets.get('Item','Sheet1');
	for col=1:size(params, 2)
        range1=get(spc.analysis.sheet,'Range',[excelColNameFromNumber(col) num2str(headerRow)]);
		range1.Value=params(col);
	end
	spc.analysis.excelRow=headerRow+1;
    spc.analysis.excelNextCol=1;
    spc.analysis.excelChannel.Visible=1;

