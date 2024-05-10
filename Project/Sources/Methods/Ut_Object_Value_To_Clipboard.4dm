//%attributes = {"invisible":true}
/* Method: Ut_Object_Value_To_Clipboard
      
  Purpose: Method is a wrapper to add a contextual click "Copy"
           popup menu to fields and variables.

  Parameters: None

  Created: 06/25/2022 - MWL
  Version: 1.0 - 06/25/2022 - MWL
      
  Property: Invisible

  Risk Assessment:
     LOW - Simple code.
      
  NOTES: None.
  ----------------------------------------------------*/

var $Main_Menu_ID_t; $Selected_Item_t : Text

$Main_Menu_ID_t:=Create menu  // Create menu in memory

Right_Click_Copy("Copy"; $Main_Menu_ID_t; "")

// Display menu at current mouse coordinates
$Selected_Item_t:=Dynamic pop up menu($Main_Menu_ID_t)
RELEASE MENU($Main_Menu_ID_t)

If (Caps lock down)
	//BEEP
End if 

Case of 
	: ($Selected_Item_t="Copy")  // Copy cell
		Right_Click_Copy(""; ""; "")
		
	Else   // Nothing chosen
		// Do nothing
End case 

