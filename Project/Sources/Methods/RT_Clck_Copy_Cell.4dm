//%attributes = {"invisible":true}
/* Method: RT_Clck_Copy_Cell
      
  Purpose: Handles right-click requests to copy cell value to clipboard
      
  Parameters: 
    $1 - {text} Text of menu item
    $2 - {text} Menu reference
    $3 - {text} Sub menu reference (if any)

  Created: 07/05/2022 - MWL
  Version: 1.0 - 07/05/2022 - MWL
      
  Property: Invisible
      
  Risk Assessment:
     LOW - Simple code.
      
  NOTES: None.
  ----------------------------------------------------*/


#DECLARE($MenuText_t : Text; $Main_Menu_ID_t : Text; $Sub_Menu_ID_t : Text)

var $Column_l; $Row_l; $Size_l; $Type_l : Integer
var $ListBox_p : Pointer
var $DocRef_h : Time

If ($MenuText_t="")  // Execute menu item
	//$ListBox_p:=OBJECT Get pointer(Object named;"LB_QueryOutput")
	LISTBOX GET CELL POSITION(*; "LB_QueryOutput"; $Column_l; $Row_l)
	
	ARRAY TEXT($Column_Name_at; 0)
	ARRAY TEXT($Header_Name_at; 0)
	
	ARRAY BOOLEAN($Column_Visible_ab; 0)
	
	ARRAY POINTER($Column_Var_ap; 0)
	ARRAY POINTER($Header_Var_ap; 0)
	ARRAY POINTER($Column_Style_ap; 0)
	
	// Get the List information. This will require twice the memory as it makes a copy of the list data
	LISTBOX GET ARRAYS(*; "LB_QueryOutput"; $Column_Name_at; $Header_Name_at; $Column_Var_ap; $Header_Var_ap; $Column_Visible_ab; $Column_Style_ap)
	
	$Type_l:=Type($Column_Var_ap{$Column_l}->{$Row_l})
	Case of 
		: (($Type_l=Is text) | ($Type_l=Is alpha field))  // Is Text or Alpha)
			SET TEXT TO PASTEBOARD($Column_Var_ap{$Column_l}->{$Row_l})
			
		: ($Type_l=Is time)  // Is Time)
			SET TEXT TO PASTEBOARD(String($Column_Var_ap{$Column_l}->{$Row_l}; HH MM SS))
			
		: (($Type_l=Is real) | ($Type_l=_o_Is float) | ($Type_l=Is longint) | ($Type_l=Is integer))  //
			SET TEXT TO PASTEBOARD(String($Column_Var_ap{$Column_l}->{$Row_l}))
			
		: ($Type_l=Is integer 64 bits)
			SET TEXT TO PASTEBOARD(String($Column_Var_ap{$Column_l}->{$Row_l}+0))  // Force int64 to int32
			
		: ($Type_l=Is date)  //
			SET TEXT TO PASTEBOARD(String($Column_Var_ap{$Column_l}->{$Row_l}; Internal date short))
			
		: ($Type_l=Is boolean)
			SET TEXT TO PASTEBOARD(String(Num($Column_Var_ap{$Column_l}->{$Row_l})=1; "True;;False"))
			
		: ($Type_l=Is picture)
			SET PICTURE TO PASTEBOARD($Column_Var_ap{$Column_l}->{$Row_l})
			
		: ($Type_l=Is BLOB)
			$Size_l:=BLOB size($Column_Var_ap{$Column_l}->{$Row_l})
			If ($Size_l>0)
				$DocRef_h:=Create document("")  // Save the document of your choice
				If (OK=1)  // If a document has been created
					CLOSE DOCUMENT($DocRef_h)  // We don't need to keep it open
					BLOB TO DOCUMENT(Document; $Column_Var_ap{$Column_l}->{$Row_l})  // Write the document contents
					
					If (OK=0)
						// Handle error
					End if 
				End if 
				
			Else 
				If (OBJECT Get value("Audible_cb_l")=1)  // If audible events on
					BEEP
				End if 
			End if 
			
		Else 
			
	End case 
	
Else   // Setup menu item
	APPEND MENU ITEM($Main_Menu_ID_t; $MenuText_t)  // Set menu item text
	SET MENU ITEM PARAMETER($Main_Menu_ID_t; -1; $MenuText_t)  // Set return value if selected
End if 
