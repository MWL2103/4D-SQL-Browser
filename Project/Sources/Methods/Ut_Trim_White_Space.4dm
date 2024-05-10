//%attributes = {"invisible":true}
/* Method: Ut_Trim_White_Space
      
  Purpose: Trims unnecessary white space (spaces, tabs and line breaks)
           from the start and/or end of a pointer to text using regular
           expressions and 4D substring.  Also, there is an option to
           capitalize the first character of each word boundary.
      
  Parameters: 
    $1 - {pointer} Text to process
    $2 - {boolean} If True, trim leading whitespace  - Left trim
    $3 - {boolean} If True, trim trailing whitespace (spaces and/or tabs) - Right trim
    $4 - {boolean} If True, capitalize the first character of each word boundary

  Created: 06/25/2022 - MWL
  Version: 1.0 - 06/25/2022 - MWL
      
  Property: Invisible
      
  Risk Assessment:
     LOW - Simple code.
      
  NOTES: Works on original text via pointer to handle large blocks of text.
  ----------------------------------------------------*/

#DECLARE($Text_p : Pointer; $Trim_Leading_b : Boolean; $Trim_Trailing_b : Boolean; $Capitalize_b : Boolean)

var $Length_l; $Pos_l; $Start_l : Integer

If (Asserted(Count parameters=4; "Illegal parameter count."))  // Requires 4 parameters
	
	If ($Trim_Leading_b=True)  // Trim leading white space
		If (Match regex("^\\s+"; $Text_p->; 1; $Start_l; $Length_l))  // If pattern found
			$Text_p->:=Substring($Text_p->; $Start_l+$Length_l)  // Trim from 1 to Length
		End if 
	End if 
	//----------------------------------------------------
	If ($Trim_Trailing_b=True)  // Trim trailing white space
		If (Match regex("\\s+$"; $Text_p->; 1; $Start_l; $Length_l))  // If pattern found
			$Text_p->:=Substring($Text_p->; 1; $Start_l-1)  // Trim from Start to end of string
		End if 
	End if 
	//----------------------------------------------------
	If ($Capitalize_b=True)  // Match any lowercase letter starting a word boundry
		$Pos_l:=1
		
		While (Match regex("(\\b[a-z](?![\\s.]))"; $Text_p->; $Pos_l; $Start_l; $Length_l))
			$Text_p->[[$Start_l]]:=Uppercase($Text_p->[[$Start_l]])  // Uppercase matched character
			$Pos_l:=$Start_l+1  // Increment position
		End while 
	End if 
	//----------------------------------------------------
End if   // End parameter count
