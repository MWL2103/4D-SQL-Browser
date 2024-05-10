//%attributes = {"invisible":true}
/* Method: RT_Clck_Delete_Column
      
  Purpose: Handles right-click requests to delete a column
      
  Parameters: 
    $1 - {text} Text of menu item
    $2 - {text} Menu reference
    $3 - {text} Sub menu reference (if any)

  Created: 07/05/2022 - MWL
  Version: 1.0 - 07/05/2022 - MWL
      
  Property: Invisible
      
  Risk Assessment:
     LOW - Simple code.
      
  NOTES: None.
  ----------------------------------------------------*/

#DECLARE($MenuText_t : Text; $Main_Menu_ID_t : Text; $Sub_Menu_ID_t : Text)

var $Column_l; $Row_l : Integer

$Row_l:=0
$Column_l:=0

If ($MenuText_t="")  // Execute menu item
	LISTBOX GET CELL POSITION(*; "LB_QueryOutput"; $Column_l; $Row_l)
	
	LISTBOX DELETE COLUMN(*; "LB_QueryOutput"; $Column_l; 1)
	
Else   // Setup menu item
	APPEND MENU ITEM($Main_Menu_ID_t; $MenuText_t)  // Set menu item text
	SET MENU ITEM PARAMETER($Main_Menu_ID_t; -1; $MenuText_t)  // Set return value if selected
End if 
