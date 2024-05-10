//%attributes = {"invisible":true}
/* Method: Open_4D_SQL_Query_Browser
      
  Purpose: This method is used to create a new process, then open the 
           4D SQL Query Browser window.  This allows for multiple browsers
           to be open while simultaneously connected to different servers
      
  Parameters: None

  Created: 06/04/2022 - MWL
  Version: 1.0 - 06/04/2022 - MWL
      
  Property: Invisible
      
  Risk Assessment:
     LOW - Simple code.
      
  NOTES: None.
----------------------------------------------------*/

var $Process_l : Integer

$Process_l:=New process("New_Query_Browser"; 0; "SQL_Query_Window")
If (False)
	New_Query_Browser  // For reference only
End if 

BRING TO FRONT($Process_l)
