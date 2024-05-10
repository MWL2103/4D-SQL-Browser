

Case of 
	: (Form event code=On Alternative Click) | (Form event code=On Long Click)
		$Main_Menu_ID_t:=Create menu  // Create menu in memory
		
		If (OB Get(Form; "Executing_b"; Is boolean)=False)
			APPEND MENU ITEM($Main_Menu_ID_t; "Execute selected code every...")  // Set menu item text
			
		Else 
			APPEND MENU ITEM($Main_Menu_ID_t; "(Execute selected code every...")  // Set menu item text
		End if 
		
		SET MENU ITEM PARAMETER($Main_Menu_ID_t; -1; "Execute")  // Set return value if selected
		
		If (OB Get(Form; "Executing_b"; Is boolean)=False)
			APPEND MENU ITEM($Main_Menu_ID_t; "(Stop execution")  // Set menu item text
			
		Else 
			APPEND MENU ITEM($Main_Menu_ID_t; "Stop execution")  // Set menu item text
		End if 
		
		SET MENU ITEM PARAMETER($Main_Menu_ID_t; -1; "Stop")  // Set return value if selected
		
		$Selected_Item_t:=Dynamic pop up menu($Main_Menu_ID_t)  // Display menu at current mouse coordinates
		RELEASE MENU($Main_Menu_ID_t)
		
		Case of 
			: ($Selected_Item_t="Execute")
				$Dialog_ob:=New object("CoNF_Msg_t"; "Enter the execution frequency in seconds")
				$Dialog_ob:=New object
				$Dialog_ob.RqST_Msg_t:="Enter the execution frequency in seconds"
				$Dialog_ob.RqST_Default_t:="3"
				$Dialog_ob.RqST_Delay_l:=60
				Request2($Dialog_ob)
				
				If ($Dialog_ob.FORM_Action_t=ak accept)
					Form.Timer_Seconds_l:=Abs(Num($Dialog_ob.RqST_Response_t))
					SET TIMER(60*Form.Timer_Seconds_l)
					OBJECT SET VALUE("Spinner_l"; 1)
					OBJECT SET VISIBLE(*; "Spinner_l"; True)
					OBJECT SET TITLE(*; "SQL_Execute_btn_l"; "Execute     .")
					Form.Executing_b:=True
					
				Else   // User cancelled
					// Do nothing
				End if 
				
			: ($Selected_Item_t="Stop")
				SET TIMER(60*Form.Timer_Seconds_l)
				OBJECT SET VALUE("Spinner_l"; 0)
				OBJECT SET VISIBLE(*; "Spinner_l"; False)
				OBJECT SET TITLE(*; "SQL_Execute_btn_l"; "Execute")
				Form.Executing_b:=False
				
			Else   // Some other event
				// Do nothing
		End case 
		
	: (Form event code=On Load)
		OBJECT SET VISIBLE(*; "Spinner_l"; False)
		
	: (Form event code=On Clicked)
		
		If (OBJECT Get value("SQL_Query_t")#"")
			Execute_SQL_String  //(False)
		End if 
		
		POST KEY(Tab key)  // Gives a visual indication that the SQL execution has finished
		// THIS SHOULD BE CONVERTED INTO A WORKER PROCESS
		POST OUTSIDE CALL(Current process)  // Call form method so row counts will get updated
		//APPEND TO ARRAY(Outside_Calls_at; "Update Query Info")
		Form.Update_Query_Info_b:=True
		
	Else   // Some other event
		BEEP
End case 
