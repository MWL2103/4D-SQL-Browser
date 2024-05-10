/* Object Method: Alert2.ALrT_Msg_t
      
  Purpose: Used to copy dialog text to clipboard on the "Alert2" form. 
      
  Parameters: None 

  Version: 1.1 - 05/13/2021 - MWL 
      
  Property: N/A 
      
  Risk Assessment: 
     LOW - Simple code.
      
  NOTES: Can't get a pointer to this variable when the variable
         expression is set to: Form.ALrT_Msg_t
----------------------------------------------------*/

var $Main_Menu_ID_t; $Selected_Item_t : Text

Case of 
	: (Form event code:C388=On Load:K2:1)
		OBJECT SET VALUE:C1742(OBJECT Get name:C1087(Object current:K67:2); Form:C1466.ALrT_Msg_t)
		
	: (Form event code:C388=On Clicked:K2:4)
		
		If (Contextual click:C713)
			$Main_Menu_ID_t:=Create menu:C408  // Create menu in memory
			APPEND MENU ITEM:C411($Main_Menu_ID_t; "Copy")  // Set menu item text
			SET MENU ITEM PARAMETER:C1004($Main_Menu_ID_t; -1; "Copy")  // Set return value if selected
			$Selected_Item_t:=Dynamic pop up menu:C1006($Main_Menu_ID_t)  // Display menu at current mouse coordinates
			
			Case of 
				: ($Selected_Item_t="Copy")  // Copy cell
					Right_Click_Copy(""; ""; "")  // Added to remove style tags from copied text - 07/26/2016 - MWL
					
				Else   // Nothing chosen
					// Do nothing
			End case 
			RELEASE MENU:C978($Main_Menu_ID_t)
			
		End if 
		
	Else   // Some other event
		// Do nothing
End case 
