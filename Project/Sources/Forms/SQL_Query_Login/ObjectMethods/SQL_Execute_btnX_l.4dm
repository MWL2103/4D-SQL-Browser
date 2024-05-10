/* Object Method: SQL_Query_Login.SQL_Execute_btn_l
      
  Purpose: xxXxx
      
  Parameters: None

  Created: 06/25/2022 - MWL
  Version: 1.1 - 10/07/2022 - MWL
      
  Property: N/A
      
  Risk Assessment:
     LOW - Simple code.
      
  NOTES: None.
  ----------------------------------------------------*/

Case of 
	: (Form event code=On Clicked)
		// Reset the state of a List Box to a blank state
		//Ut_Empty_Listbox ("LB_QueryOutput")
		//LISTBOX DELETE COLUMN(LB_QueryOutput;1;LISTBOX Get number of columns(LB_QueryOutput))
		//$Limit_t:=get_SQL_limit 
		//tSQL:=Calculate_SQL_Offset ($Limit_t;$Selected_Table_t;"*")
		
		If (OBJECT Get value("SQL_Query_t")#"")
			Execute_SQL_String  //(False)
		End if 
		POST KEY(Tab key)  // Gives a visual indication that the SQL execution has finished
		// THIS SHOULD BE CONVERTED INTO A WORKER PROCESS
		POST OUTSIDE CALL(Current process)  // Call form method so row counts will get updated
		//APPEND TO ARRAY(Outside_Calls_at; "Update Query Info")
		Form.Update_Query_Info_b:=True
End case 
