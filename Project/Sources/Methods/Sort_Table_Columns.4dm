//%attributes = {"invisible":true}
/* Method: Sort_Table_Columns
      
  Purpose: xxXxx
      
  Parameters: 
    $0 - {boolean} 
    $1 - {text} SQL limit chosen last from popup menu
    $2 - {text} Currently selected table name

  Created: 06/13/2022 - MWL
  Version: 1.0 - 06/13/2022 - MWL
      
  Property: Invisible
      
  Risk Assessment:
     LOW - Simple code.
      
  NOTES: None.
  ----------------------------------------------------*/

#DECLARE($Limit_t : Text; $Selected_Table_t : Text)->$Return_t : Text

var $Row_l; $Rows_l : Integer
var $Select_List_t : Text


ARRAY TEXT($Columns_at; 0)
// Query will wrap columns with spaces in name with brackets [Column_Name]
$Select_List_t:="SELECT CASE WHEN POSITION(' ' IN COLUMN_NAME) >0 THEN CONCAT('[',CONCAT(COLUMN_NAME,']')) ELSE COLUMN_NAME END FROM _USER_COLUMNS WHERE Table_Name = '"+\
$Selected_Table_t+"' ORDER BY 1 INTO :$Columns_at"
Begin SQL  // Execute the query
	EXECUTE IMMEDIATE :$Select_List_t;
End SQL

$Rows_l:=Size of array($Columns_at)
Case of 
	: ($Rows_l=0)
		$Select_List_t:="*"  // Displays all columns in creation order, but query only shows * for select list
		
	: ($Rows_l=1)
		$Select_List_t:=$Columns_at{1}
		
	Else 
		$Select_List_t:=$Columns_at{1}+", "
		For ($Row_l; 2; $Rows_l)
			
			If ($Row_l<$Rows_l)
				$Select_List_t:=$Select_List_t+$Columns_at{$Row_l}+", "
				
			Else 
				$Select_List_t:=$Select_List_t+$Columns_at{$Row_l}
			End if 
			
		End for 
End case 

$Return_t:=Calculate_SQL_Offset($Limit_t; $Selected_Table_t; $Select_List_t)
