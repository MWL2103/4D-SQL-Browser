/* Object Method: SQL_Query_Login.Connections_LB
      
  Purpose: Handles Connections listbox events.
      
  Parameters: None

  Created: 06/04/2022 - MWL
  Version: 1.0 - 06/04/2022 - MWL
      
  Property: N/A
      
  Risk Assessment:
     LOW - Simple code.
      
  NOTES: None.
----------------------------------------------------*/

var $Column_l; $ID_l; $Port_l; $Row_l : Integer
var $Dialog_ob : Object
var $Main_Menu_ID_t; $Name_t; $Selected_Item_t : Text

LISTBOX GET CELL POSITION:C971(*; "Connections_LB"; $Column_l; $Row_l)

Case of 
	: (Form event code:C388=On Load:K2:1)
		Load_Servers
		
	: (Form event code:C388=On Clicked:K2:4)
		If ($Row_l>0)
			If (Contextual click:C713)
				$Main_Menu_ID_t:=Create menu:C408  // Create menu in memory
				Right_Click_Copy("Copy"; $Main_Menu_ID_t; "")
				APPEND MENU ITEM:C411($Main_Menu_ID_t; "(-")  // Set menu item text (divider line)
				
				APPEND MENU ITEM:C411($Main_Menu_ID_t; "Update Name...")  // Set menu item text (divider line)
				SET MENU ITEM PARAMETER:C1004($Main_Menu_ID_t; -1; "Update_Name")  // Set return value if selected
				
				APPEND MENU ITEM:C411($Main_Menu_ID_t; "Update Port...")  // Set menu item text (divider line)
				SET MENU ITEM PARAMETER:C1004($Main_Menu_ID_t; -1; "Update_Port")  // Set return value if selected
				
				APPEND MENU ITEM:C411($Main_Menu_ID_t; "(-")  // Set menu item text (divider line)
				//------------------------------------------------------------
				APPEND MENU ITEM:C411($Main_Menu_ID_t; "Delete Address...")  // Set menu item text (divider line)
				SET MENU ITEM PARAMETER:C1004($Main_Menu_ID_t; -1; "Delete_Address")  // Set return value if selected
				//------------------------------------------------------------
				$Selected_Item_t:=Dynamic pop up menu:C1006($Main_Menu_ID_t)  // Display menu at current mouse coordinates
				RELEASE MENU:C978($Main_Menu_ID_t)
				If (Caps lock down:C547)
					//BEEP
				End if 
				
				Case of 
					: ($Selected_Item_t="Copy")  // Copy cell
						Right_Click_Copy(""; ""; "")
						
					: ($Selected_Item_t="Delete_Address")
						$ID_l:=(OBJECT Get pointer:C1124(Object named:K67:5; "LB_Primary_al"))->{$Row_l}
						$Dialog_ob:=New object:C1471("CoNF_Msg_t"; "Delete the selected address?"; "CoNF_OK_Text_t"; "Delete")
						Confirm2($Dialog_ob)
						
						If ($Dialog_ob.FORM_Action_t=ak accept:K76:37)
							Begin SQL
								DELETE FROM Servers
								WHERE ID_pk = :$ID_l
							End SQL
						End if 
						
						LISTBOX DELETE ROWS:C914(*; "Connections_LB"; $Row_l)
						
					: ($Selected_Item_t="Update_Name")
						$ID_l:=(OBJECT Get pointer:C1124(Object named:K67:5; "LB_Primary_al"))->{$Row_l}
						$Name_t:=(OBJECT Get pointer:C1124(Object named:K67:5; "LB_Name_at"))->{$Row_l}
						
						$Name_t:=Request:C163("Update server name"; $Name_t; "Update"; "Cancel")
						If (OK=1)
							(OBJECT Get pointer:C1124(Object named:K67:5; "LB_Name_at"))->{$Row_l}:=$Name_t
							
							Begin SQL
								UPDATE Servers
								SET NAME = :$Name_t
								WHERE ID_pk = :$ID_l
							End SQL
						End if 
						
					: ($Selected_Item_t="Update_Port")
						$ID_l:=(OBJECT Get pointer:C1124(Object named:K67:5; "LB_Primary_al"))->{$Row_l}
						$Port_l:=(OBJECT Get pointer:C1124(Object named:K67:5; "LB_Port_al"))->{$Row_l}
						
						$Port_l:=Num:C11(Request:C163("Update port number"; String:C10($Port_l); "Update"; "Cancel"))
						If (OK=1)
							(OBJECT Get pointer:C1124(Object named:K67:5; "LB_Port_al"))->{$Row_l}:=$Port_l
							
							Begin SQL
								UPDATE Servers
								SET Port = :$Port_l
								WHERE ID_pk = :$ID_l
							End SQL
						End if 
						
					Else   // Some other event
						// Do nothing
				End case 
				
			Else   // Normal click
				// Do nothing
			End if 
			
		Else   // No row selected
			// Do nothing
		End if 
		
	: (Form event code:C388=On Selection Change:K2:29)
		If ($Row_l>0)
			OBJECT SET VALUE:C1742("Login_Address_t"; OBJECT Get pointer:C1124(Object named:K67:5; "LB_Address_at")->{$Row_l})
			OBJECT SET VALUE:C1742("Login_Port_l"; OBJECT Get pointer:C1124(Object named:K67:5; "LB_Port_al")->{$Row_l})
			
			Form:C1466.Server_Adrs_t:=OBJECT Get value:C1743("Login_Address_t")
			Form:C1466.Port_l:=OBJECT Get value:C1743("Login_Port_l")
			
		Else 
			OBJECT SET VALUE:C1742("Login_Address_t"; "")
			OBJECT SET VALUE:C1742("Login_Port_l"; 0)
			
			Form:C1466.Server_Adrs_t:=""
			Form:C1466.Port_l:=0
		End if 
		
	: (Form event code:C388=On Double Clicked:K2:5)
		GOTO OBJECT:C206(*; "Login_User_t")
		
	Else   // Some other event
		// Do nothing
End case 
