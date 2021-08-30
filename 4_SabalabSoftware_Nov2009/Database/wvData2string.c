/*
 * =============================================================
 * phonebook.c 
 * Example for illustrating how to manipulate structure and cell
 * array
 *
 * Takes a (MxN) structure matrix and returns a new structure 
 * (1x1) containing corresponding fields:for string input, it 
 * will be (MxN) cell array; and for numeric (noncomplex, scalar)
 * input, it will be (MxN) vector of numbers with the same 
 * classID as input, such as int, double etc..
 *
 * This is a MEX-file for MATLAB.
 * Copyright (c) 1984-2000 The MathWorks, Inc.
 * =============================================================
 */

/* $Revision: 1.1.4.9 $ */

#include "mex.h"
#include "string.h"
#include "stdlib.h"

#define MAXCHARS 80   /* max length of string contained in each 
                         field */

/* The gateway routine.  */
void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{
  mxArray	*dataField;
  mxArray	*xscaleField;
  double xscale;
  double offset;
  double *data;
  double *xscalePtr;
  
  char *sql, temp_str[50];
  long sql_size, curr_pos;
  int i, len;
  
  long npnts, counter;
  
 // const char **fnames;       /* pointers to field names */
  //const int  *dims;
  //mxArray    *tmp, *fout;
  //char       *pdata;
  //int        ifield, jstruct, *classIDflags;
  //int        NStructElems, nfields, ndim;
    
  /* Check proper input and output */
  if (nrhs != 1)
    mexErrMsgTxt("One input required.");
  else if (nrhs > 1)
    mexErrMsgTxt("Too many input arguments.");
  else if (!mxIsStruct(prhs[0]))
    mexErrMsgTxt("Input must be a structure.");
  
  if(nlhs != 1) mexErrMsgTxt("One output required.");
  else if (nlhs > 1)
    mexErrMsgTxt("Too many output arguments.");
	  
  
  /* get wave data*/
  
  dataField=mxGetFieldByNumber(prhs[0], 0, 0);
  xscaleField=mxGetFieldByNumber(prhs[0], 0, 1);
  
  npnts=mxGetN(dataField);
  
  data=mxGetPr(dataField);
  
  xscalePtr=mxGetPr(xscaleField);
  
  xscale=xscalePtr[1];
  offset=xscalePtr[0];

  /*create output text */
  
  sql_size=npnts*10;
  
  sql=mxCalloc(sql_size,sizeof(char));
  
  sprintf(sql, "\0");
  
  curr_pos=0;
  
  for(counter=0;counter<npnts;counter++) {
	//mexPrintf("%f\n", data[counter];
	sprintf(temp_str, "%g",data[counter]);
	//gcvt(data[counter], 15, temp_str);
	
	len=strlen(temp_str);
	for(i=0;i<len;i++) 
	    sql[curr_pos+i]=temp_str[i];
	    	
	sql[curr_pos+len]=',';
	
	curr_pos+=len+1;
	//strcat(sql, temp_str);
  }
 
  sql[curr_pos]='\0';
  
  /*mexPrintf("%d points\n", npnts);
  mexPrintf("offset=%f\n", offset);
  mexPrintf("scale=%f\n", xscale);
 
  for(counter=0;counter<npnts;counter++) {
	mexPrintf("%f\n", data[counter]);
  }*/
  
  /*send output text back to matlab */
  
  //mexPrintf("sql_statement=%s\n", sql);
  
  plhs[0] = mxCreateString(sql);
  
  mxFree(sql);
  
  return;
}
  /* Get input arguments */
  //nfields = mxGetNumberOfFields(prhs[0]);
  //NStructElems = mxGetNumberOfElements(prhs[0]);

  /* Allocate memory  for storing classIDflags */
  //classIDflags = mxCalloc(nfields, sizeof(int));

  /* Check empty field, proper data type, and data type
      consistency; get classID for each field. */
  /*for (ifield = 0; ifield < nfields; ifield++) {
    for (jstruct = 0; jstruct < NStructElems; jstruct++) {
      tmp = mxGetFieldByNumber(prhs[0], jstruct, ifield);
      if (tmp == NULL) {
        mexPrintf("%s%d\t%s%d\n",
            "FIELD:", ifield+1, "STRUCT INDEX :", jstruct+1);
        mexErrMsgTxt("Above field is empty!"); 
      } 
      if (jstruct == 0) {
        if ((!mxIsChar(tmp) && !mxIsNumeric(tmp)) || 
            mxIsSparse(tmp)) { 
          mexPrintf("%s%d\t%s%d\n", 
              "FIELD:", ifield+1, "STRUCT INDEX :", jstruct+1);
          mexErrMsgTxt("Above field must have either "
              "string or numeric non-sparse data.");
        }
        classIDflags[ifield] = mxGetClassID(tmp); 
      } else {
        if (mxGetClassID(tmp) != classIDflags[ifield]) {
          mexPrintf("%s%d\t%s%d\n", 
              "FIELD:", ifield+1, "STRUCT INDEX :", jstruct+1);
          mexErrMsgTxt("Inconsistent data type in above field!");
        } 
        else if (!mxIsChar(tmp) && ((mxIsComplex(tmp) || 
            mxGetNumberOfElements(tmp) != 1))) {
          mexPrintf("%s%d\t%s%d\n", 
              "FIELD:", ifield+1, "STRUCT INDEX :", jstruct+1);
          mexErrMsgTxt("Numeric data in above field "
              "must be scalar and noncomplex!");
        }
      }
    }
  }
*/
  /* Allocate memory  for storing pointers */
  //fnames = mxCalloc(nfields, sizeof(*fnames));

  /* Get field name pointers */
  //for (ifield = 0; ifield < nfields; ifield++) {
  //  fnames[ifield] = mxGetFieldNameByNumber(prhs[0],ifield);
  //}

  /* Create a 1x1 struct matrix for output */
 /* plhs[0] = mxCreateStructMatrix(1, 1, nfields, fnames);
  mxFree(fnames);
  ndim = mxGetNumberOfDimensions(prhs[0]);
  dims = mxGetDimensions(prhs[0]);
  for (ifield = 0; ifield < nfields; ifield++) {*/
    /* Create cell/numeric array *//*
    if (classIDflags[ifield] == mxCHAR_CLASS) {
      fout = mxCreateCellArray(ndim, dims);
    } else {
      fout = mxCreateNumericArray(ndim, dims, 
          classIDflags[ifield], mxREAL);
      pdata = mxGetData(fout);
    }
*/
    /* Copy data from input structure array */
/*    for (jstruct = 0; jstruct < NStructElems; jstruct++) {
      tmp = mxGetFieldByNumber(prhs[0],jstruct,ifield);
      if (mxIsChar(tmp)) {
        mxSetCell(fout, jstruct, mxDuplicateArray(tmp));
      } else {
        size_t     sizebuf;
        sizebuf = mxGetElementSize(tmp);
        memcpy(pdata, mxGetData(tmp), sizebuf);
        pdata += sizebuf;
      }
    }*/

    /* Set each field in output structure */
    //mxSetFieldByNumber(plhs[0], 0, ifield, fout);
  /*}
  //mxFree(classIDflags);

