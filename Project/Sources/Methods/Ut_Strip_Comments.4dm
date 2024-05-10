//%attributes = {"invisible":true}
/* Method: Ut_Strip_Comments
      
  Purpose: This method attemps to strip all SQL comments from the query.
      
  Parameters: 
    $0 - {text} Output SQL string
    $1 - {text} Input SQL string

  Created: 06/25/2022 - MWL
  Version: 1.0 - 06/25/2022 - MWL
      
  Property: Invisible
      
  Risk Assessment:
     LOW - Simple code.
      
  NOTES: None.
  ----------------------------------------------------*/

#DECLARE($SQL_t : Text)->$SQL_Out_t : Text

var $Length_l; $Pos_l; $Start_l : Integer
var $RegEx_t; $Slice_t : Text

$RegEx_t:="(?mi-s)--.*\\r"  // Selects start of -- to EOL, which is bad if line contains -- somewhere
$RegEx_t:="(?mi-s)-{2}(?!.*-{2}).*$"  // Works if line contains -- as long as line ends with -- comment
$RegEx_t:="(?mi-s)--.*$"
$Start_l:=1


While (Match regex($RegEx_t; $SQL_t; $Start_l; $Pos_l; $Length_l)=True)
	
	$Slice_t:=Substring($SQL_t; $Pos_l; $Length_l)  // Trim from 1 to $Length_l
	$SQL_t:=Replace string($SQL_t; $Slice_t; ""; 1)
	
	If ($Pos_l>Length($SQL_t))  // If we are past the new length of the source
		$Start_l:=Length($SQL_t)  // Drop out of loop
		
	Else   // Still more text to process
		$Start_l:=$Pos_l+1  // Move search forward so we don't make a false match after comment is removed
	End if 
End while 

$SQL_Out_t:=$SQL_t
