//%attributes = {"invisible":true}
/* Method: New_Query_Browser
      
  Purpose: xxXxx
      
  Parameters: None

  Created: 06/05/2022 - MWL
  Version: 1.0 - 06/05/2022 - MWL
      
  Property: Invisible
      
  Risk Assessment:
     LOW - Simple code.
      
  NOTES: None.
----------------------------------------------------*/

var $Ref_l : Integer

$Ref_l:=Open form window("SQL_Query_Login"; Plain form window; Horizontally centered; Vertically centered)

SET WINDOW TITLE("New Connection")

DIALOG("SQL_Query_Login")
CLOSE WINDOW($Ref_l)
