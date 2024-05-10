//%attributes = {"invisible":true}
/* Method: RT_Clck_Clear_Clipboard
      
  Purpose: xxXxx
      
  Parameters: None
    $0 - {boolean} 
    $1 - {object} 
    $2 - {text} 
    $3 - {longint} 
    $4 - {real} 
    $5 - {pointer} 

  Created: 07/05/2022 - MWL
  Version: 1.0 - 07/05/2022 - MWL
      
  Property: Invisible
            None
            Execute on Server
            Available through SQL
            N/A
      
  Risk Assessment:
     LOW - Simple code.
      
  NOTES: None.
  ----------------------------------------------------*/

// RT_Clck_Copy_Column_Title

// Description: Handles right-click requests to clear the clipboard

// Version: 1.0 - 02/27/2015 - MWL

// Method Property: Invisible

// Risk assessment: 
//     LOW - Simple code.

// NOTES: None.
//        
//---------------------------------------------------- 

C_TEXT($1; $MenuText_t)  // Text of menu item
C_TEXT($2; $Main_Menu_ID_t)  // Menu reference
C_TEXT($3; $Sub_Menu_ID_t)  // Sub menu reference

$MenuText_t:=$1
$Main_Menu_ID_t:=$2
$Sub_Menu_ID_t:=$3  // Not used

If ($MenuText_t="")  // Execute menu item
	CLEAR PASTEBOARD
	
Else   // Setup menu item
	APPEND MENU ITEM($Main_Menu_ID_t; $MenuText_t)  // Set menu item text
	SET MENU ITEM PARAMETER($Main_Menu_ID_t; -1; $MenuText_t)  // Set return value if selected
	
End if 
