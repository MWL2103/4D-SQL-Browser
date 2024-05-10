//%attributes = {"invisible":true}
/* Method: Copy_As_JSON_2_Clipboard
      
  Purpose: xxXxx
      
  Parameters: None

  Created: 06/25/2022 - MWL
  Version: 1.0 - 06/25/2022 - MWL
      
  Property: Invisible
      
  Risk Assessment:
     LOW - Simple code.
      
  NOTES: None.
  ----------------------------------------------------*/

var $Column_cln : Collection
var $Column_l; $Columns_l; $Row_l; $Rows_l : Integer
var $Column_Name_t : Text

ARRAY TEXT($ColName_at; 0)
ARRAY BOOLEAN($ColsVisible_ab; 0)
ARRAY POINTER($ColVars_ap; 0)
ARRAY OBJECT($Export_aob; 0)
ARRAY TEXT($HeaderName_at; 0)
ARRAY POINTER($HeaderVars_ap; 0)
ARRAY POINTER($Styles_ap; 0)


// Get the List information. This will require twice the memory as it makes a copy of the list data
LISTBOX GET ARRAYS(*; "LB_QueryOutput"; $ColName_at; $HeaderName_at; $ColVars_ap; $HeaderVars_ap; $ColsVisible_ab; $Styles_ap)

//$ File_Path_t:=Temporary folder+"4D_Temp_"+String(Tickcount)+".txt"
//$ File_Path_t:=Get 4D folder(Current resources folder)
//$ File_Name_t:="4D_Temp_"+String(Tickcount)+".txt"

// Get column count
$Columns_l:=Count in array($ColsVisible_ab; True)

ARRAY OBJECT($Export_aob; 0)
$Column_cln:=New collection

For ($Column_l; 1; $Columns_l)  // Loop through each column
	$Column_Name_t:=OBJECT Get title(*; $HeaderName_at{$Column_l})  // Get the column header name
	
	ARRAY TO COLLECTION($Column_cln; $ColVars_ap{$Column_l}->; $Column_Name_t)  // Append header and data
End for 

If (Count in array(aoHiddenRow2; True)>0)  // If there are hidden rows
	
	$Rows_l:=Size of array(aoHiddenRow2)
	For ($Row_l; $Rows_l; 1; -1)
		If (aoHiddenRow2{$Row_l}=True)
			$Column_cln.remove($Row_l-1)  // Remove the hidden rows from the collection
		End if 
	End for 
	
End if 

If (Macintosh option down | Windows Alt down)
	SET TEXT TO PASTEBOARD(JSON Stringify($Column_cln))  // Compact printing
	
Else 
	SET TEXT TO PASTEBOARD(JSON Stringify($Column_cln; *))  // Pretty printing
End if 
