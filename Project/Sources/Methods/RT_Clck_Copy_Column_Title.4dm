//%attributes = {"invisible":true}
/* Method: RT_Clck_Copy_Column_Title
      
  Purpose: Handles right-click requests to copy column title to clipboard
      
  Parameters: 
    $1 - {text} Text of menu item
    $2 - {text} Menu reference
    $3 - {text} Sub menu reference

  Created: 07/05/2022 - MWL
  Version: 1.0 - 07/05/2022 - MWL
      
  Property: Invisible
      
  Risk Assessment:
     LOW - Simple code.
      
  NOTES: None.
  ----------------------------------------------------*/

#DECLARE($MenuText_t : Text; $Main_Menu_ID_t : Text; $Sub_Menu_ID_t : Text)

var $Object_p : Pointer
var $Temp_t : Text

If ($MenuText_t="")  // Execute menu item
	$Object_p:=OBJECT Get pointer(Object current)
	$Temp_t:=OBJECT Get title($Object_p->)
	SET TEXT TO PASTEBOARD($Temp_t)
	
	
Else   // Setup menu item
	APPEND MENU ITEM($Main_Menu_ID_t; $MenuText_t)  // Set menu item text
	SET MENU ITEM PARAMETER($Main_Menu_ID_t; -1; $MenuText_t)  // Set return value if selected
End if 
