//%attributes = {"invisible":true}
/* Method: Macro_Code_Object_Explorer
      
  Purpose: Called from a macro to launch "Code Object Explorer" in a separate thread.
           This new process prevents the current window from blocking all other windows.

  Parameters: None

  Created: 06/04/2022 - MWL
  Version: 1.0 - 06/04/2022 - MWL
      
  Property: Invisible
      
  Risk Assessment:
     LOW - Simple code.
      
  NOTES: Calls the Component "MethodExplorer_v18"
----------------------------------------------------*/

var $Temp_l : Integer

$Temp_l:=New process("_OPEN_HELP_CodeObjectExplorer"; 0; "$_OPEN_HELP_CodeObjectExplorer"; *)
If (False)
	_OPEN_HELP_CodeObjectExplorer
End if 
