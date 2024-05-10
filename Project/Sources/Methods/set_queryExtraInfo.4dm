//%attributes = {"invisible":true}
/* Method: set_queryExtraInfo
      
  Purpose: Used to populate the 'queryExtraInfo_t' variable on the 4D SQL Query
           Browser window with additional information about the query

  Parameters: None

  Created: 06/05/2022 - MWL
  Version: 1.1 - 09/28/2022 - MWL
      
  Property: Invisible
      
  Risk Assessment:
     LOW - Simple code.
      
  NOTES: None.
  ----------------------------------------------------*/

#DECLARE->$Message_t : Text

If (Error_l=0)
	// append the number of rows displayed
	$Message_t:=String(LISTBOX Get number of rows(*; "LB_QueryOutput"); "###,###,###,##0")+" Rows returned with "
	//$tMessage:=String(lRowsInList;"###,###,###,##0")+" Rows returned with "
	
	// append the number of columns displayed
	$Message_t:=$Message_t+String(LISTBOX Get number of columns(*; "LB_QueryOutput"); "###,###,###,##0")+" Columns in "
	
	// append the execution time
	$Message_t:=$Message_t+String(Form.End_Time_ms_l-Form.Start_Time_ms_l; "###,###,###,##0")+" ms"
	
	//tFilterRows:=""  // Clear filter variable
Else 
	BEEP  //Alert2("Error:\n"+JSON Stringify(Error_Stack_cln; *))
	Alert2("Error: "+Error_Method_t)
	$Message_t:=Setup_SQL_Error_Handler  // Reset the error handler
End if 
