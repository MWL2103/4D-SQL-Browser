//%attributes = {"invisible":true}
/* Method: Size_Columns
      
  Purpose: Sizes all result columns to best fit the column header or data.
      
  Parameters: None

  Created: 06/25/2022 - MWL
  Version: 1.0 - 06/25/2022 - MWL
      
  Property: Invisible
      
  Risk Assessment:
     LOW - Simple code.
      
  NOTES: None.
  ----------------------------------------------------*/

var $bestHeight_l; $bestWidth_l; $Column_l; $Column_Type_l; $Columns_l : Integer
var $Max_Width_l; $Row_l; $Rows_l; $Type_l : Integer
var $Header_Name_t; $Row_Text_t : Text

ARRAY TEXT($Col_Name_at; 0)  // Column object names
ARRAY TEXT($Head_Name_at; 0)
ARRAY POINTER($Column_Var_ap; 0)
ARRAY POINTER($Head_Ptr_ap; 0)
ARRAY BOOLEAN($Col_Visible_ao; 0)
ARRAY POINTER($Style_Ptr_ap; 0)

LISTBOX GET ARRAYS(*; "LB_QueryOutput"; $Col_Name_at; $Head_Name_at; $Column_Var_ap; $Head_Ptr_ap; $Col_Visible_ao; $Style_Ptr_ap)

//$Row_l:=Find in array(LB_QueryOutput;True)
$Row_Text_t:=""
$bestWidth_l:=0
$bestHeight_l:=0
//$Rows_l:=Size of array(OBJECT Get pointer(Object named;$Col_Name_at{1})->)  // How many rows of data
$Rows_l:=Size of array(LB_QueryOutput)
If ($Rows_l>20)
	$Rows_l:=10  // Limit the number of rows we check
End if 
$Columns_l:=Size of array($Head_Name_at)
//progBar_Open ("Sizing columns...")

For ($Column_l; 1; $Columns_l)
	$Header_Name_t:=OBJECT Get title(*; $Head_Name_at{$Column_l})
	//progBar_Update ($Header_Name_t;$Column_l;$Columns_l)
	
	OBJECT GET BEST SIZE(*; $Head_Name_at{$Column_l}; $bestWidth_l; $bestHeight_l)
	
	$Max_Width_l:=$bestWidth_l+3  // Add a 4 to the width
	//$Type_l:=Type($Column_Var_ap{$Column_l}->)  // Get the column data type
	$Column_Type_l:=Type($Column_Var_ap{$Column_l}->{1})  // Get the type of the first element in the column
	
	Case of 
		: ($Column_Type_l=Is boolean)  // For Boolean, only use column width
			// Do nothing
			
		: ($Column_Type_l=Is picture)  // For Picture, only use column width
			// Do nothing
			
			//: ($Column_Type_l=Is integer 64 bits)  // Special case for INT64
			//OBJECT GET BEST SIZE($Column_Var_ap{$Column_l}->;$bestWidth_l;$bestHeight_l)
			
			//: ($Column_Type_l=Is longint)
			//OBJECT GET BEST SIZE($Column_Var_ap{$Column_l}->;$bestWidth_l;$bestHeight_l)
			//If ($bestWidth_l>$Max_Width_l)
			//$Max_Width_l:=$bestWidth_l
			
			//Else   // Max width has already been reached
			//  // Do nothing
			//End if 
			
			//: ($Column_Type_l=Is text)
			//OBJECT GET BEST SIZE($Column_Var_ap{$Column_l}->;$bestWidth_l;$bestHeight_l)
			//If ($bestWidth_l>$Max_Width_l)
			//$Max_Width_l:=$bestWidth_l
			
			//Else   // Max width has already been reached
			//  // Do nothing
			//End if 
			
			//: ($Type_l=Time array)
			//$Row_Text_t:=$Row_Text_t+String($Col_Ptr_ap{$Column_l}->{$Row_l})
			
			//: ($Type_l=Date array)
			//If (60>$Max_Width_l)  // If header width is less than 60
			//$Max_Width_l:=60
			
			//Else   // Use header width
			//  // Do nothing
			//End if 
			
			//: ($Type_l=Boolean array)
			//$Row_Text_t:=$Row_Text_t+String($Col_Ptr_ap{$Column_l}->{$Row_l})
			
			//: ($Type_l=String array) | ($Type_l=Text array)
			//  // Eliminate style information (if any)
			//$Row_Text_t:=$Row_Text_t+$Col_Ptr_ap{$Column_l}->{$Row_l}
		Else   // Data type not handled
			OBJECT GET BEST SIZE($Column_Var_ap{$Column_l}->; $bestWidth_l; $bestHeight_l)
			If ($bestWidth_l>$Max_Width_l)
				$Max_Width_l:=$bestWidth_l
				
			Else   // Max width has already been reached
				// Do nothing
			End if 
			//For ($Row_l;1;$Rows_l)
			//OBJECT GET BEST SIZE($Column_Var_ap{$Column_l}->{$Row_l};$bestWidth_l;$bestHeight_l)
			//If ($bestWidth_l>$Max_Width_l)
			//$Max_Width_l:=$bestWidth_l
			
			//Else   // Max width has already been reached
			//  // Do nothing
			//End if 
			
			//End for 
	End case 
	
	
	If ($Max_Width_l>200)
		LISTBOX SET COLUMN WIDTH($Column_Var_ap{$Column_l}->; 200)
		
	Else 
		LISTBOX SET COLUMN WIDTH($Column_Var_ap{$Column_l}->; $Max_Width_l+4)
	End if 
	//BEEP
	//$Type_l:=Type($Col_Ptr_ap{$Column_l}->)  // Get the column data type
	
End for 
//progBar_Close 
//  // Must be running 4D v14 for this to work
//ARRAY TEXT($FormObjects_at;0)
//FORM GET OBJECTS($FormObjects_at)
//ARRAY LONGINT($Object_Type_al;Size of array($FormObjects_at))
//For ($Column_l;1;Size of array($FormObjects_at))
//$Object_Type_al{$Column_l}:=OBJECT Get type(*;$FormObjects_at{$Column_l})
//If ($Object_Type_al{$Column_l}=Object type listbox)
//ARRAY TEXT($LB_Objects_at;0)
//LISTBOX GET OBJECTS(*;$FormObjects_at{$Column_l};$LB_Objects_at)
//End if 
//End for 
