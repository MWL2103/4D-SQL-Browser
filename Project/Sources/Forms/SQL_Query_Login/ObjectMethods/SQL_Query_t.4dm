/* Object Method: SQL_Query_Login.SQL_Query_t
      
  Purpose: xxXxx
      
  Parameters: None

  Created: 06/25/2022 - MWL
  Version: 1.1 - 08/18/2022 - MWL
      
  Property: N/A
      
  Risk Assessment:
     LOW - Simple code.
      
  NOTES: None.
  ----------------------------------------------------*/

Case of 
	: (Form event code=On Clicked)
		If (Contextual click)  // If Right-Click
			Ut_Object_Value_To_Clipboard(OBJECT Get pointer(Object current))
			
		Else   // Single click
			// Do nothing
		End if 
		
	: (Form event code=On After Keystroke)
		//Match_Query_Commands 
		
		// THIS SHOULD BE CONVERTED INTO A WORKER PROCESS
		Case of 
			: (Keystroke=" ")
				POST OUTSIDE CALL(Current process)  // Call form method so row counts will get updated
				
			: (Character code(Keystroke)=Backspace key)
				POST OUTSIDE CALL(Current process)  // Call form method so row counts will get updated
				
			: (Character code(Keystroke)=ReturnKey)
				POST OUTSIDE CALL(Current process)  // Call form method so row counts will get updated
				
			Else 
				
		End case 
		
		//APPEND TO ARRAY(Outside_Calls_at; "Format_Query")
		Form.Format_Query_b:=True
		
	: (Form event code=On Selection Change)
		If (Caps lock down)
			//TRACE
		End if 
		GET HIGHLIGHT(*; "SQL_Query_t"; $Cursor_Start_l; $Cursor_End_l)  // Get the cursor position
		
		If ($Cursor_Start_l=$Cursor_End_l)
			// Do nothing
		Else 
			//BEEP
		End if 
		
	: (Form event code=On After Edit)
		Query_Left_at{Query_Tab_at}:=Replace string(Get edited text; Char(Tab); "")  // Remove any tab characters
		OBJECT SET VALUE("SQL_Query_t"; Query_Left_at{Query_Tab_at})
		//Match_Query_Commands 
		//BEEP
		
	Else   // Some other event
		// Do nothing
End case 
