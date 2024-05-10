//%attributes = {"invisible":true}
/* Method: Calculate_SQL_Offset
      
  Purpose: xxXxx
      
  Parameters: 
    $0 - {text} 
    $1 - {text} 
    $2 - {text} 
    $3 - {text} 

  Created: 06/25/2022 - MWL
  Version: 1.0 - 06/25/2022 - MWL
      
  Property: Invisible
      
  Risk Assessment:
     LOW - Simple code.
      
  NOTES: None.
  ----------------------------------------------------*/

#DECLARE($Limit_t : Text; $Selected_Table_t : Text; $Select_List_t : Text)->$SQL_t : Text

var $Count_l : Integer
var $Text_t : Text

If (Position("OFFSET "; $Limit_t)>0)
	$Count_l:=0  // Record count varable
	$SQL_t:="SELECT count(*) from "+$Selected_Table_t+" INTO :$Count_l"
	Begin SQL
		EXECUTE IMMEDIATE :$SQL_t;
	End SQL
	
	$Text_t:=String($Count_l-Num($Limit_t))
	
	If (Num($Text_t)<=Num($Limit_t))  // If there are fewer records in the table then there is a limit on
		$Limit_t:=Replace string($Limit_t; "OFFSET"; "")
		$SQL_t:="SELECT "+$Select_List_t+" FROM "+$Selected_Table_t+$Limit_t  // Just set a limit
		
	Else   // More records in table than the limit is set to
		$SQL_t:="SELECT "+$Select_List_t+" FROM "+$Selected_Table_t+$Limit_t+$Text_t  // Set a limit and offset
	End if 
	
Else 
	$SQL_t:="SELECT "+$Select_List_t+" FROM "+$Selected_Table_t+$Limit_t
End if 
