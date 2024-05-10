//%attributes = {"invisible":true}
/* Method: Right_Click_Copy
      
  Purpose: Handles right-click requests to copy selected value to clipboard
      
  Parameters: 
    $1 - {text} Text of menu item
    $2 - {text} Menu reference
    $3 - {text} Sub menu reference (if any)

  Created: 06/04/2022 - MWL
  Version: 1.0 - 06/04/2022 - MWL
      
  Property: Invisible
      
  Risk Assessment:
     LOW - Simple code.
      
  NOTES: None.
----------------------------------------------------*/

#DECLARE($MenuText_t : Text; $Main_Menu_ID_t : Text; $Sub_Menu_ID_t : Text)

var $Column_l; $Content_Type_l; $First_l; $Last_l; $Row_l; $Type_l : Integer
var $ListBox_p : Pointer
var $Temp_t : Text

If ($MenuText_t="")  // If menu item is blank, process selection
	//$ListBox_p:=OBJECT Get pointer(Object with focus)  // Get pointer to listbox caller
	
	$ListBox_p:=OBJECT Get pointer(Object current)  // Get pointer to listbox caller
	
	$Temp_t:=OBJECT Get name(Object current)
	$Type_l:=OBJECT Get type(*; $Temp_t)  // Get the Type of the object
	//$Type_l:=OBJECT Get type($ListBox_p->)  // Get the Type of the object
	
	Case of 
		: ($Type_l=Object type listbox)  //& (Type($ListBox_p->)=Boolean array))  // If the object is a listbox
			$ListBox_p:=OBJECT Get pointer(Object with focus)  // Get pointer to listbox caller
			LISTBOX GET CELL POSITION($ListBox_p->; $Column_l; $Row_l)
			
			ARRAY TEXT($ColNames_at; 0)
			ARRAY TEXT($HeaderNames_at; 0)
			
			ARRAY BOOLEAN($ColsVisible_ao; 0)
			
			ARRAY POINTER($ColVars_ap; 0)
			ARRAY POINTER($HeaderVars_ap; 0)
			ARRAY POINTER($Styles_ap; 0)
			
			// Get the List information. This will require twice the memory as it makes a copy of the list data
			LISTBOX GET ARRAYS($ListBox_p->; $ColNames_at; $HeaderNames_at; $ColVars_ap; $HeaderVars_ap; $ColsVisible_ao; $Styles_ap)
			
			Case of 
				: (Type($ColVars_ap{$Column_l}->{$Row_l})=Text array)  // Listbox cell is Text
					SET TEXT TO PASTEBOARD($ColVars_ap{$Column_l}->{$Row_l})
					
				: (Type($ColVars_ap{$Column_l}->{$Row_l})=String array)  // Listbox cell is Alpha Field
					SET TEXT TO PASTEBOARD($ColVars_ap{$Column_l}->{$Row_l})
					
				: (Type($ColVars_ap{$Column_l}->{$Row_l})=Is longint)
					SET TEXT TO PASTEBOARD(String($ColVars_ap{$Column_l}->{$Row_l}))
					
				Else   // Listbox cell is some other type
					If (Macintosh option down | Windows Alt down)  // Include any style information
						SET TEXT TO PASTEBOARD(String($ColVars_ap{$Column_l}->{$Row_l}))
						
					Else   // Eliminate style information 
						$Temp_t:=ST Get plain text($ColVars_ap{$Column_l}->{$Row_l}; ST Tags as plain text)
						SET TEXT TO PASTEBOARD($Temp_t)
					End if 
					
			End case 
			
		Else   // The object is a field or variable
			$Type_l:=Type($ListBox_p->)
			Case of 
				: (($Type_l=Is real) | ($Type_l=Is date))
					SET TEXT TO PASTEBOARD(String($ListBox_p->))
					
				: ($Type_l=Is text)  // Text field
					
					$Content_Type_l:=ST Get content type($ListBox_p->)
					Case of   // processing of different types
						: ($Content_Type_l=ST Url type)
							
							
						: ($Content_Type_l=ST Expression type)
							
							
						Else 
							GET HIGHLIGHT($ListBox_p->; $First_l; $Last_l)
							
							If ($First_l=$Last_l)  // If right-click with no text selected, copy everything
								If (Macintosh option down | Windows Alt down)  // Include any style information
									SET TEXT TO PASTEBOARD($ListBox_p->)
									
								Else   // Eliminate style information 
									$Temp_t:=ST Get plain text($ListBox_p->; ST Tags as plain text)
									SET TEXT TO PASTEBOARD($Temp_t)
								End if 
								
							Else   // Copy only selected text
								If (Macintosh option down | Windows Alt down)  // Include any style information
									SET TEXT TO PASTEBOARD(Substring($ListBox_p->; $First_l; $Last_l-$First_l))
									
								Else   // Eliminate style information 
									$Temp_t:=ST Get plain text($ListBox_p->; ST Tags as plain text)
									SET TEXT TO PASTEBOARD(Substring($Temp_t; $First_l; $Last_l-$First_l))
								End if 
							End if 
							
					End case 
					
					
					If (False)
						If ($First_l=$Last_l)  // If right-click with no text selected, copy everything
							SET TEXT TO PASTEBOARD($ListBox_p->)
							
						Else   // Copy only selected text
							SET TEXT TO PASTEBOARD(Substring($ListBox_p->; $First_l; $Last_l-$First_l))
						End if 
					End if 
					
					
				Else   // Could be an array in a List Box
					$ListBox_p:=OBJECT Get pointer(Object with focus)  // Get pointer to listbox caller
					
					LISTBOX GET CELL POSITION($ListBox_p->; $Column_l; $Row_l)
					Case of 
						: (Type($ListBox_p->{$Row_l})=Text array)  // Listbox cell is Text
							SET TEXT TO PASTEBOARD($ColVars_ap{$Column_l}->{$Row_l})
							
						: (Type($ListBox_p->{$Row_l})=String array)  // Listbox cell is Alpha Field
							SET TEXT TO PASTEBOARD($ColVars_ap{$Column_l}->{$Row_l})
							
						Else   // Listbox cell is some other type
							SET TEXT TO PASTEBOARD(String($ListBox_p->{$Row_l}))
					End case 
					
			End case 
	End case 
	
	
Else   // Add menu item to dropdown
	APPEND MENU ITEM($Main_Menu_ID_t; $MenuText_t)  // Set menu item text
	SET MENU ITEM PARAMETER($Main_Menu_ID_t; -1; $MenuText_t)  // Set return value if selected
End if 
