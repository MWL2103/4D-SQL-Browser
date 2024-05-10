// Object Method: [Form]Form1.LB_QueryOutput

// Description: Handles mouse clicks and right-clicks in ListBox area.

// Version: 1.2 - 09/01/2016

// Risk assessment: 
//      LOW - Simple code.

// NOTES: None.
//-------------------------------------------------

C_TEXT($Selected_Item_t)
C_TEXT($Main_Menu_ID_t)

Case of 
	: (Form event code=On Header Click)
		
		If (Contextual click)
			
			$Main_Menu_ID_t:=Create menu  // Create menu in memory
			
			RT_Clck_Copy_Column_Title("Copy column title"; $Main_Menu_ID_t; "")
			
			RT_Clck_Append_Column_Title("Append column title"; $Main_Menu_ID_t; "")
			//------------------------------------------------------------
			APPEND MENU ITEM($Main_Menu_ID_t; "(-")  // Set menu item text (divider line)
			SET MENU ITEM PARAMETER($Main_Menu_ID_t; -1; "Divider1")  // Set return value if selected
			//------------------------------------------------------------
			RT_Clck_Clear_Clipboard("Clear Clipboard"; $Main_Menu_ID_t; "")
			//------------------------------------------------------------
			$Selected_Item_t:=Dynamic pop up menu($Main_Menu_ID_t)  // Display menu at current mouse coordinates
			
			Case of 
				: ($Selected_Item_t="Copy column title")  // Copy column title
					RT_Clck_Copy_Column_Title(""; ""; "")
					
				: ($Selected_Item_t="Append column title")  // Copy cell
					RT_Clck_Append_Column_Title(""; ""; "")
					
				: ($Selected_Item_t="Clear Clipboard")  // Copy cell
					RT_Clck_Clear_Clipboard(""; ""; "")
					
				Else 
					
			End case 
			
			
		Else   // Non right-click
			
		End if 
		
	: (Form event code=On Double Clicked)
		
	: (Form event code=On Column Resize)
		
	: (Form event code=On Mouse Move)
		//BEEP
		//$lValue:=Selected list items(LB_QueryOutput)
		//GET LIST ITEM(LB_QueryOutput;$lValue;$vlItemRef;$vsItemText)
		
	: (Form event code=On Clicked)  // (Form event=On Header Click) | 
		
		If (Contextual click)
			$Main_Menu_ID_t:=Create menu  // Create menu in memory
			
			RT_Clck_Copy_Cell("Copy Cell to Clipboard"; $Main_Menu_ID_t; "")
			//------------------------------------------------------------
			APPEND MENU ITEM($Main_Menu_ID_t; "(-")  // Set menu item text (divider line)
			SET MENU ITEM PARAMETER($Main_Menu_ID_t; -1; "Divider1")  // Set return value if selected
			//------------------------------------------------------------
			RT_Clck_Delete_Column("Delete Column"; $Main_Menu_ID_t; "")
			//------------------------------------------------------------
			APPEND MENU ITEM($Main_Menu_ID_t; "(-")  // Set menu item text (divider line)
			//------------------------------------------------------------
			APPEND MENU ITEM($Main_Menu_ID_t; "Size Columns")  // Set menu item text (divider line)
			SET MENU ITEM PARAMETER($Main_Menu_ID_t; -1; "Size")  // Set return value if selected
			//------------------------------------------------------------
			$Selected_Item_t:=Dynamic pop up menu($Main_Menu_ID_t)  // Display menu at current mouse coordinates
			
			Case of 
				: ($Selected_Item_t="Delete Column")  // Delete Column
					RT_Clck_Delete_Column(""; ""; "")
					
				: ($Selected_Item_t="Copy Cell to Clipboard")  // Copy cell
					RT_Clck_Copy_Cell(""; ""; "")
					
				: ($Selected_Item_t="Sort")
					ARRAY TEXT($Col_Name_at; 0)  // Column object names
					ARRAY TEXT($Head_Name_at; 0)
					ARRAY POINTER($Col_Ptr_ap; 0)
					ARRAY POINTER($Head_Ptr_ap; 0)
					ARRAY BOOLEAN($Col_Visible_ao; 0)
					ARRAY POINTER($Style_Ptr_ap; 0)
					
					LISTBOX GET ARRAYS(LB_QueryOutput; $Col_Name_at; $Head_Name_at; $Col_Ptr_ap; $Head_Ptr_ap; $Col_Visible_ao; $Style_Ptr_ap)
					
					ARRAY TEXT($Column_Names_at; 0)
					For ($Column_l; 1; Size of array($Head_Name_at))
						$Header_Name_t:=OBJECT Get title(*; $Head_Name_at{$Column_l})
						APPEND TO ARRAY($Column_Names_at; $Header_Name_t)
					End for 
					SORT ARRAY($Column_Names_at; <)
					
					For ($Column_l; 1; Size of array($Head_Name_at))
						LISTBOX MOVE COLUMN(*; $Head_Name_at{$Column_l}; $Column_l)
					End for 
					
				: ($Selected_Item_t="Size")
					Size_Columns
					
				Else 
					
			End case 
			
		Else   // Regular click
			// Do nothing
		End if 
		
	Else   // Some other form event
		// Do nothing
End case 
