//%attributes = {"invisible":true}
/* Method: Ut_Remove_Last_Semicolon
      
  Purpose: Simply removes the last semicolon from the query string.
      
  Parameters: 
    $0 - {text} 
    $1 - {text} 

  Created: 06/25/2022 - MWL
  Version: 1.0 - 06/25/2022 - MWL
      
  Property: Invisible
      
  Risk Assessment:
     LOW - Simple code.
      
  NOTES: None.
  ----------------------------------------------------*/

#DECLARE($Source_t : Text)->$Result_t : Text

var $Length_l; $Pos_l; $Start_l : Integer
var $Pattern_t : Text

$Start_l:=1
$Pattern_t:="(?mi-s);+$"
If (Match regex($Pattern_t; $Source_t; $Start_l; $Pos_l; $Length_l)=True)
	$Source_t:=Substring($Source_t; 1; $Pos_l-1)
End if 

$Result_t:=$Source_t
