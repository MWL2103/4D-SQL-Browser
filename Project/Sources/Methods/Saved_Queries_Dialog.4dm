//%attributes = {"invisible":true}
/* Method: Saved_Queries_Dialog
      
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
      
  Risk Assessment:
     LOW - Simple code.
      
  NOTES: None.
  ----------------------------------------------------*/

var $WinRef_l : Integer

$WinRef_l:=Open form window("Saved_Queries"; Sheet form window)
DIALOG("Saved_Queries")
