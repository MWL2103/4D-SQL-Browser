/* Object Method: SQL_Query_Login.LB_Tables
      
  Purpose: xxXxx
      
  Parameters: None

  Created: 06/13/2022 - MWL
  Version: 1.1 - 08/16/2022 - MWL
      
  Property: N/A
      
  Risk Assessment:
     LOW - Simple code.
      
  NOTES: None.
----------------------------------------------------*/

LISTBOX GET CELL POSITION(*; "LB_Tables"; $Column_l; $Row_l)
$Selected_Table_t:=OBJECT Get pointer(Object named; "SQL_Tables_at")->{$Row_l}

$PreviousErrorHandler_t:=Setup_SQL_Error_Handler

Case of 
	: (Form event code=On Clicked)
		// Capture current keyboard
		$Contextual_Click_b:=Contextual click
		$Option_Down_b:=(Macintosh option down | Windows Alt down)
		$Shift_Down_b:=Shift down
		$Cntrl_Down_b:=(Macintosh control down | Windows Ctrl down)
		//----------------------------------------------------
		If (($Contextual_Click_b) & (Not($Option_Down_b)))
			$Main_Menu_ID_t:=Create menu  // Create menu in memory
			
			APPEND MENU ITEM($Main_Menu_ID_t; "Copy cell to Clipboard")  // Set menu item text (divider line)
			SET MENU ITEM PARAMETER($Main_Menu_ID_t; -1; "Copy")  // Set return value if selected
			
			//APPEND MENU ITEM($Main_Menu_ID_t; "(-")  // Set menu item text (divider line)
			//SET MENU ITEM PARAMETER($Main_Menu_ID_t; -1; "Divider1")  // Set return value if selected
			
			$Selected_Item_t:=Dynamic pop up menu($Main_Menu_ID_t)  // Display menu at current mouse coordinates
			RELEASE MENU($Main_Menu_ID_t)
			If (Caps lock down)
				//BEEP
			End if 
			
			Case of 
				: ($Selected_Item_t="Copy")  // Copy cell
					SET TEXT TO PASTEBOARD($Selected_Table_t)
					
				: ($Selected_Item_t="Hide_Table")
					
				Else   // Some other event
					// Do nothing
			End case 
			
		Else   // Single click
			Case of 
				: ($Row_l>0)
					// Reset the state of a List Box to a blank state
					LISTBOX DELETE COLUMN(*; "LB_QueryOutput"; 1; LISTBOX Get number of columns(*; "LB_QueryOutput"))
					//$Selected_Table_t:=SQL_Tables_at{$Row_l}
					
					//If (Windows Ctrl down) | (Macintosh command down)  // Users is deselecting row
					//tSQL:=""
					//OBJECT SET ENABLED(bHideTable; False)
					//Else 
					
					$Limit_t:=get_SQL_limit
					If (Remote("Login")=True)
						$Count_l:=0  // Record count varable
						$Execute_Query_b:=True  // Assume query will be ran
						
						If ((Num($Limit_t)>=1000) | (Num($Limit_t)=0))  // If the limit is GE than 1,000 or No Limit
							$myQuery_t:="SELECT count(*) FROM "+$Selected_Table_t+" INTO :$Count_l"
							Begin SQL
								EXECUTE IMMEDIATE :$myQuery_t;
							End SQL
							
							Remote("Logout")
							
							If (($Count_l>1000) & Not(($Option_Down_b)))
								If (Num($Limit_t)=0)  // Limit is set to "No Limit"
									$Dialog_ob:=New object(\
										"CoNF_Msg_t"; "This table contains "+String($Count_l; "###,###,###,##0")+" records.  Are you sure you want to load all records?"; \
										"CoNF_OK_Text_t"; "Yes"; \
										"CoNF_Cancel_Text_t"; "No"; \
										"CoNF_AutoClose_Btn_l"; 1; \
										"CoNF_Delay_l"; 60\
										)
									//CONFIRM("This table contains "+String($Count_l; "###,###,###,##0")+" records.  Do you really want to load all records?"; "No"; "Yes")
									// Are you sure you want to load
								Else   // Limit is GT 1,000
									$Dialog_ob:=New object(\
										"CoNF_Msg_t"; "This table contains "+String($Count_l; "###,###,###,##0")+" records.  Are you sure you want to load "+String(Num($Limit_t); "###,###,###,##0")+" records?"; \
										"CoNF_OK_Text_t"; "Yes"; \
										"CoNF_Cancel_Text_t"; "No"; \
										"CoNF_AutoClose_Btn_l"; 1; \
										"CoNF_Delay_l"; 60\
										)
									//CONFIRM("This table contains "+String($Count_l; "###,###,###,##0")+" records.  Do you really want to load "+String(Num($Limit_t); "###,###,###,##0")+" records?"; "No"; "Yes")
								End if 
								
								Confirm2($Dialog_ob)
								If ($Dialog_ob.FORM_Action_t=ak accept)  // User wants to load all records
									//If (OK=0)  
									$Count_l:=0  // Clear record count varable
								Else   // User does NOT want to load all records
									$Execute_Query_b:=False
								End if 
								
							Else   // The number of records is less than 1,000
								// Do nothing
								//$Count_l:=0
							End if 
						End if 
						
						If ($Execute_Query_b=True)  // ($Count_l=0)  // If zero, then query should take place
							ARRAY BOOLEAN(LB_QueryOutput; 0)
							$Hold_t:=""
							
							Case of 
								: (($Shift_Down_b) & ($Option_Down_b) & ($Cntrl_Down_b))
									$SQL_t:=Sort_Table_Columns($Limit_t; $Selected_Table_t)
									
								: (($Shift_Down_b) & ($Option_Down_b))
									$Hold_t:=OBJECT Get value("SQL_Query_t")  // Save current query string and restore
									$SQL_t:="SELECT COUNT(*) AS 'Count' FROM "+$Selected_Table_t  //+$limit_t
									
								: ($Option_Down_b)
									$Hold_t:=OBJECT Get value("SQL_Query_t")  // Save current query string
									$SQL_t:="desc "+$Selected_Table_t
									
								Else 
									//$Select_List_t:="*"  // Displays all columns in creation order, but query only shows * for select list
									$SQL_t:=Calculate_SQL_Offset($Limit_t; $Selected_Table_t; "*")
							End case 
							
							OBJECT SET VALUE("SQL_Query_t"; $SQL_t)
							
							If (OBJECT Get value("QueryOnClick_cb_l")=1)  // (QueryOnClick_b)
								Execute_SQL_String
							End if 
							
							//OBJECT SET ENABLED(bHideTable; True)
							
							If ((($Option_Down_b)) & (Length($Hold_t)>0))  // If we replaced a query string
								//tSQL:=$Hold_t  // Restore previous query string
								OBJECT SET VALUE("SQL_Query_t"; $Hold_t)
							End if 
						End if 
						
						// THIS SHOULD BE CONVERTED INTO A WORKER PROCESS
						POST OUTSIDE CALL(Current process)  // Call form method so row counts will get updated
						//APPEND TO ARRAY(Outside_Calls_at; "Update Query Info")
						Form.Update_Query_Info_b:=True
						
					Else   // Server is not available
						BEEP
						TRACE
					End if 
					
				: ($Row_l=0)
					// Reset the state of a List Box to a blank state
					LISTBOX DELETE COLUMN(LB_QueryOutput; 1; LISTBOX Get number of columns(LB_QueryOutput))
					
					//tSQL:=""
					OBJECT SET VALUE("SQL_Query_t"; "")
					
					// THIS SHOULD BE CONVERTED INTO A WORKER PROCESS
					POST OUTSIDE CALL(Current process)  // Call form method so row counts will get updated
					//APPEND TO ARRAY(Outside_Calls_at; "Update Query Info")
					Form.Update_Query_Info_b:=True
					
				Else 
					// Do nothing
			End case 
			
		End if 
		
		
	: (False)
		
	Else   // Some other event
		// Do nothing
End case 
