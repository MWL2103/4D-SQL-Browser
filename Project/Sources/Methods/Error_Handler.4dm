//%attributes = {"invisible":true}
/* Method: Error_Handler
      
  Purpose: xxXxx
      
  Parameters: None

  Created: 06/08/2022 - MWL
  Version: 1.0 - 06/08/2022 - MWL
      
  Property: Invisible
      
  Risk Assessment:
     LOW - Simple code.
      
  NOTES: None.
----------------------------------------------------*/

var $In_Transaction_b : Boolean
var $Call_Chain_cln : Collection
var $Row_l : Integer
var $Error_ob; $Temp_ob : Object
var $Local_t; $Text_t : Text

ARRAY LONGINT($Error_Code_al; 0)
ARRAY TEXT($Error_Text_at; 0)
ARRAY TEXT($Internal_Code_at; 0)

//$Local_t:=Get_Local_Timestamp(True)

$Text_t:=""  //"Time: "+$Local_t
$Text_t:=$Text_t+"Error: "+String(error)+"\rLine "+String(error line)
$Text_t:=$Text_t+"\rMethod: "+error method
$Text_t:=$Text_t+"\rFormula: "+error formula+"\r\r"

If (True)
	$Error_ob:=New object(\
		"Timestamp_Local_t"; $Local_t; \
		"Error_t"; error; \
		"Method_t"; error method; \
		"Formula_t"; error formula; \
		"Line_l"; error line\
		)
	$Call_Chain_cln:=New collection
End if 

Error_Stack_cln.clear()

Error_Stack_cln.push(New object(\
"error"; String(error); \
"line"; String(error line); \
"method"; error method; \
"formula"; error formula\
))

GET LAST ERROR STACK($Error_Code_al; $Internal_Code_at; $Error_Text_at)
For ($Row_l; 1; Size of array($Error_Code_al))
	$Text_t:=$Text_t+String($Error_Code_al{$Row_l})+" "+$Error_Text_at{$Row_l}+"\r"
	Error_Stack_cln.push(New object("code_l"; $Error_Code_al{$Row_l}; "desc_t"; $Error_Text_at{$Row_l}))
	$Call_Chain_cln.push(New object("Code_l"; $Error_Code_al{$Row_l}; "Internal_t"; $Internal_Code_at{$Row_l}; "Desc_t"; $Error_Text_at{$Row_l}))
End for 

$Error_ob.Error_Stack_aob:=$Call_Chain_cln  // Write error stack

$Call_Chain_cln:=Get call chain

// Remove the last in the call chain since it will be this method
$Call_Chain_cln.remove(0)
$Error_ob.Call_Chain_aob:=$Call_Chain_cln  // Write call chain
//----------------------------------------------------
Error_l:=error
Error_Method_t:=$Text_t

If (Shift down=False)
	BEEP
	
Else 
	TRACE
End if 
