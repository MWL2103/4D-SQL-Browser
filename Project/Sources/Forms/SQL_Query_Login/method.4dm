/* Form Method: SQL_Query_Login
      
  Purpose: xxXxx
      
  Parameters: None

  Created: 06/05/2022 - MWL
  Version: 1.0 - 06/05/2022 - MWL
      
  Property: N/A
      
  Risk Assessment:
     LOW - Simple code.
      
  NOTES: None.
----------------------------------------------------*/

var $Column_l; $Row_l : Integer
var $Dialog_ob : Object
var $SQL_t; $Temp_t : Text

Case of 
	: (Form event code=On Load)
		Form.Username_t:=""
		Form.Password_t:=""
		Form.Server_Adrs_t:=""
		Form.Port_l:=0
		
		// Initialize here
		Form.Update_Query_Info_b:=False
		Form.Format_Query_b:=False
		//: (Form event code=On Selection Change)
		//LISTBOX GET CELL POSITION(*; "Connections_LB"; $Column_l; $Row_l)
		
		//If ($Row_l>0)
		//Form.Username_t:=OBJECT Get value("Login_User_t")
		//Form.Password_t:=OBJECT Get value("Login_Password_t")
		//Form.Server_Adrs_t:=OBJECT Get value("Login_Address_t")
		//Form.Port_l:=OBJECT Get value("Login_Port_l")
		
		//Else 
		//Form.Username_t:=""
		//Form.Password_t:=""
		//Form.Server_Adrs_t:=""
		//Form.Port_l:=0
		//End if 
		
	: (Form event code=On Close Box)
		//Confirm2("Quit the SQL Query Browser?"; "Yes"; "No")
		$Dialog_ob:=New object(\
			"CoNF_Msg_t"; "Quit the SQL Query Browser?"; \
			"CoNF_OK_Text_t"; "No"; \
			"CoNF_Cancel_Text_t"; "Yes"; \
			"CoNF_AutoClose_Btn_l"; 1; \
			"CoNF_Delay_l"; 60\
			)
		Confirm2($Dialog_ob)
		
		If ($Dialog_ob.FORM_Action_t=ak cancel)  // Yes
			If (Is compiled mode)
				QUIT 4D
				
			Else 
				CANCEL  // Closes this window
			End if 
			
		Else   // No
			// Do nothing
		End if 
		
	: (Form event code=On Timer)  // Check remote SQL connection
		Check_SQL_Connection
		
		If (OB Get(Form; "Executing_b"; Is boolean)=True)
			If (OBJECT Get value("SQL_Query_t")#"")
				Execute_SQL_String  //(False)
			End if 
			//POST KEY(Tab key)  // Gives a visual indication that the SQL execution has finished
			// THIS SHOULD BE CONVERTED INTO A WORKER PROCESS
			POST OUTSIDE CALL(Current process)  // Call form method so row counts will get updated
			//APPEND TO ARRAY(Outside_Calls_at; "Update Query Info")
			Form.Update_Query_Info_b:=True
		End if 
		
	: (Form event code=On Outside Call)
		If (Caps lock down)
			TRACE
		End if 
		Case of 
			: (Form.Update_Query_Info_b=True)  // (Find in array(Outside_Calls_at; "Update Query Info")>0)
				
				If (OBJECT Get value("Audible_cb_l")=1)  // If audible events on
					BEEP
				End if 
				
				//queryExtraInfo_t:=set_queryExtraInfo("LB_QueryOutput"; Form.End_Time_ms_l-Form.Start_Time_ms_l)
				OBJECT SET VALUE("QueryExtraInfo_t"; set_queryExtraInfo)
				Form.Update_Query_Info_b:=False
				
				//Repeat 
				//DELETE FROM ARRAY(Outside_Calls_at; Find in array(Outside_Calls_at; "Update Query Info"))
				//Until (Find in array(Outside_Calls_at; "Update Query Info")=No current record)
				
			: (Form.Format_Query_b=True)  // (Find in array(Outside_Calls_at; "Format_Query")>0)
				Form.Format_Query_b:=False
				//Repeat 
				//DELETE FROM ARRAY(Outside_Calls_at; Find in array(Outside_Calls_at; "Format_Query"))
				//Until (Find in array(Outside_Calls_at; "Format_Query")=No current record)
				
				SQL_Pretty_Print
				
			: (Find in array(Outside_Calls_at; "Filter_Paste")>0)
				Repeat 
					DELETE FROM ARRAY(Outside_Calls_at; Find in array(Outside_Calls_at; "Filter_Paste"))
				Until (Find in array(Outside_Calls_at; "Filter_Paste")=No current record)
				
				$SQL_t:=ST Get plain text(*; "SQL_Query_t")
				$Temp_t:=$SQL_t
				//Query_Left_at{Query_Tab_at}:=ST Get plain text(Query_Left_at{Query_Tab_at};ST Tags as plain text)
				$SQL_t:=Replace string($SQL_t; "\t"; "")  // Remove ALL tabs
				Ut_Trim_White_Space(->$SQL_t; True; True; False)  // Trim any space from beginning of SQL statement
				
				If ($Temp_t=$SQL_t)  // If no difference
					// Do nothing
					
				Else 
					ST SET TEXT(*; "SQL_Query_t"; $SQL_t)
					
					If ((OBJECT Get pointer(Object named; "Style_SQL_cb"))->=1)  // If Style SQL checkbox is checked
						POST OUTSIDE CALL(Current process)  // Call form method so row counts will get updated
						APPEND TO ARRAY(Outside_Calls_at; "Format_Query")
					End if 
				End if 
				
			: (Find in array(Outside_Calls_at; "Tab_Selected")>0)
				Repeat 
					DELETE FROM ARRAY(Outside_Calls_at; Find in array(Outside_Calls_at; "Tab_Selected"))
				Until (Find in array(Outside_Calls_at; "Tab_Selected")=No current record)
				
				// INSTEAD OF CLEARING THE SELECTION, IT WOULD BE MUCH BETTER TO RESTORE THE LAST SELECTED TEXT FOR THE TAB
				HIGHLIGHT TEXT(*; "SQL_Query_t"; 0; 1)  // Restore cursor position
				
			Else   // No match
				// Do nothing
		End case 
		
	: (Form event code=On After Edit) | (Form event code=On Data Change)
		If (OBJECT Get pointer(Object with focus)=(->Filter_Value_t))
			FilterRows
		End if 
		
	: (Form event code=On Menu Selected)
		// Do nothingQuery_Left_at{Query_Tab_at}:=
		
	: (FORM Event.objectName="SQL_Filter_cb_l")
		FilterRows
		
	Else   // Some other event
		// Do nothing
End case 
