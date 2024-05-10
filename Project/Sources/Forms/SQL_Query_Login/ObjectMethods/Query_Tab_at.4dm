/* Object Method: SQL_Query_Login.Query_Tab_at
      
  Purpose: xxXxx
      
  Parameters: None

  Created: 06/25/2022 - MWL
  Version: 1.0 - 06/25/2022 - MWL
      
  Property: N/A
      
  Risk Assessment:
     LOW - Simple code.
      
  NOTES: None.
  ----------------------------------------------------*/

C_TEXT:C284($Selected_Item_t)

Case of 
	: (Form event code:C388=On Load:K2:1)
		ARRAY TEXT:C222(Query_Tab_at; 0)
		APPEND TO ARRAY:C911(Query_Tab_at; "View ")
		APPEND TO ARRAY:C911(Query_Tab_at; "+")
		Query_Tab_at:=1
		Query_Tab_at{0}:=String:C10(Query_Tab_at)
		
		ARRAY TEXT:C222(Query_Left_at; 0)
		ARRAY TEXT:C222(Query_Right_at; 0)
		APPEND TO ARRAY:C911(Query_Left_at; "")
		APPEND TO ARRAY:C911(Query_Right_at; "")
		
	: (Form event code:C388=On Clicked:K2:4)
		
		If (Contextual click:C713) & (Size of array:C274(Query_Tab_at)>2)
			
			If (Query_Tab_at{Query_Tab_at}="+")  // If Plus is right-clicked on
				Query_Tab_at:=Query_Tab_at-1  // Select tab just before Plus tab item
				
			Else 
				$Main_Menu_ID_t:=Create menu:C408  // Create menu in memory
				//APPEND MENU ITEM($Main_Menu_ID_t;"Delete "+Query_Tab_at{Query_Tab_at})  // Set menu item text
				//SET MENU ITEM PARAMETER($Main_Menu_ID_t;-1;"Delete "+Query_Tab_at{Query_Tab_at})  // Set return value if selected
				RT_Clck_Delete_Tab("Delete "+Query_Tab_at{Query_Tab_at}; $Main_Menu_ID_t; "")
				
				$Selected_Item_t:=Dynamic pop up menu:C1006($Main_Menu_ID_t)  // Display menu at current mouse coordinates
				
				$Tab_Text_t:=Query_Tab_at{Query_Tab_at}
				Case of 
					: ($Selected_Item_t=("Delete "+$Tab_Text_t))  // User wants to delete selected tab
						RT_Clck_Delete_Tab(""; ""; "")
						//DELETE FROM ARRAY(Query_Tab_at;Query_Tab_at)
						//DELETE FROM ARRAY(Query_Left_at;Query_Tab_at)
						//DELETE FROM ARRAY(Query_Right_at;Query_Tab_at)
						//
						//If (Size of array(Query_Tab_at)=Query_Tab_at)
						//Query_Tab_at:=Query_Tab_at-1
						//Else 
						//
						//End if 
						
					Else   // Nothing selected
						// Do nothing
				End case 
				
			End if 
			
		Else 
			$Tabs_l:=Size of array:C274(Query_Tab_at)
			If ($Tabs_l=Query_Tab_at)  // If the last tab ( + ) is currently active
				
				For ($Tab_l; 1; $Tabs_l)
					$Pos_l:=Find in array:C230(Query_Tab_at; "View "+String:C10($Tab_l))
					Case of 
						: ($Pos_l>0)
							// Do nothing
							
						: ($Tab_l=1)  // If this is the first tab
							// Do nothing
							
						Else   // Some other event
							//Query_Tab_at:=Query_Tab_at-1  // Select tab just before Plus tab item
							Query_Tab_at{$Tabs_l}:="View "+String:C10($Tab_l)  // Rename the last tab ( + )
							APPEND TO ARRAY:C911(Query_Tab_at; "+")
							APPEND TO ARRAY:C911(Query_Left_at; "")
							APPEND TO ARRAY:C911(Query_Right_at; "")
					End case 
				End for 
				
			Else   // Some other tab
				// Do nothing
			End if 
			
			HIGHLIGHT TEXT:C210(*; "SQL_Query_t"; 1; 1)  // Clear any query text that may be selected
		End if 
		
		$Note_Object_p:=OBJECT Get pointer:C1124(Object named:K67:5; "Right_Text_t")
		$SQL_Object_p:=OBJECT Get pointer:C1124(Object named:K67:5; "SQL_Query_t")
		
		// Save text before changing tab
		Query_Left_at{Num:C11(Query_Tab_at{0})}:=$SQL_Object_p->  //tSQL
		Query_Right_at{Num:C11(Query_Tab_at{0})}:=$Note_Object_p->
		
		Query_Tab_at{0}:=String:C10(Query_Tab_at)  // Save new selected tab
		
		// Update right side text before changing tab
		//tSQL:=Query_Left_at{Query_Tab_at}
		$SQL_Object_p->:=Query_Left_at{Query_Tab_at}
		$Note_Object_p->:=Query_Right_at{Query_Tab_at}
		
		APPEND TO ARRAY:C911(Outside_Calls_at; "Tab_Selected")
		POST OUTSIDE CALL:C329(Current process:C322)  // THIS SHOULD BE CONVERTED INTO A WORKER PROCESS
		
	Else   // Some other event
		//FORM GOTO PAGE(2)
		// Do nothing
End case 
