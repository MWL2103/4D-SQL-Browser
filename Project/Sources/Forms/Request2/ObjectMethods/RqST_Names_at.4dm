/* Object Method: Request2.RqST_Names_at
      
  Purpose: Handles the display and selection of optional choices 
           for the request response.

  Parameters: None 

  Version: 1.0 - 05/14/2021 - MWL 
      
  Property: N/A 
      
  Risk Assessment: 
     LOW - Simple code.
      
  NOTES: None.
----------------------------------------------------*/

var $Selected_l : Integer
var $Value_t : Text

ARRAY TEXT:C222($Names_at; 0)
ARRAY TEXT:C222($Values_at; 0)

Case of 
	: (Form event code:C388=On Load:K2:1)
		
		If (OB Is defined:C1231(Form:C1466; "RqST_Names_at")=False:C215)
			OBJECT SET VISIBLE:C603(*; OBJECT Get name:C1087(Object current:K67:2); False:C215)
			OB SET NULL:C1233(Form:C1466; "RqST_Item_Selected_l")  // No item has been selected
			
		Else   // An array was passed, so don't hide it
			OB GET ARRAY:C1229(Form:C1466; "RqST_Names_at"; $Names_at)
			
			//%W-518.1 to disable compiler warning (Pointer in COPY ARRAY)
			COPY ARRAY:C226($Names_at; (OBJECT Get pointer:C1124(Object current:K67:2))->)
			//%W+518.1 to enable compiler warning
			
			OB SET:C1220(Form:C1466; "RqST_Item_Selected_l"; 0)  // No item has been selected
		End if 
		
	: (Form event code:C388=On Data Change:K2:15)
		$Selected_l:=(OBJECT Get pointer:C1124(Object current:K67:2))->
		OB SET:C1220(Form:C1466; "RqST_Item_Selected_l"; $Selected_l)  // Incase programmer needs to know which item was selected
		
		If (OB Is defined:C1231(Form:C1466; "RqST_Values_at")=False:C215)
			$Value_t:=(OBJECT Get pointer:C1124(Object current:K67:2))->{$Selected_l}
			
		Else 
			OB GET ARRAY:C1229(Form:C1466; "RqST_Values_at"; $Values_at)
			$Value_t:=$Values_at{$Selected_l}
		End if 
		
		OBJECT SET VALUE:C1742("RqST_Input_t"; $Value_t)
		
	Else   // Some other event
		// Do nothing
End case 
