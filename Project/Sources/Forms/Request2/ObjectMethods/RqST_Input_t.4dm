/* Object Method: Request2.RqST_Input_t
      
  Purpose: Handles user keystrokes on the "Request2" form. 
      
  Parameters: None 

  Version: 1.0 - 05/14/2021 - MWL 
      
  Property: N/A 
      
  Risk Assessment: 
     LOW - Simple code.
      
  NOTES: Pass a RegEx string to filter keystrokes.
----------------------------------------------------*/

var $Length_l; $Pos_l : Integer
var $Text_t : Text

Case of 
	: (Form event code:C388=On Load:K2:1)  // Check to see if this field is enterable or not
		OBJECT SET VALUE:C1742("RqST_Input_t"; OB Get:C1224(Form:C1466; "RqST_Default_t"; Is text:K8:3))
		
		If (OB Get:C1224(Form:C1466; "RqST_Immutable_b"; Is boolean:K8:9)=False:C215)  // Not set or False
			// Do nothing
			
		Else   // Make field non-enterable
			OBJECT SET ENTERABLE:C238(*; OBJECT Get name:C1087(Object current:K67:2); False:C215)
			OBJECT SET BORDER STYLE:C1262(*; OBJECT Get name:C1087(Object current:K67:2); 0)  // Set border line System specific/No border
			
			If (Folder separator:K24:12=":")  // If Mac OS
				OBJECT SET RGB COLORS:C628(*; OBJECT Get name:C1087(Object current:K67:2); Foreground color:K23:1; 0x00ECECEC)  // Very light Grey
				
			Else   // Win OS
				OBJECT SET RGB COLORS:C628(*; OBJECT Get name:C1087(Object current:K67:2); Foreground color:K23:1; 0x00FFFFFF)
			End if 
		End if 
		
	: (Form event code:C388=On Data Change:K2:15)
		//OB SET(Form; "RqST_Response_t"; (OBJECT Get pointer(Object current))->)
		
	: (Form event code:C388=On After Keystroke:K2:26)
		If (OB Get:C1224(Form:C1466; "RqST_TickEnd_l"; Is longint:K8:6)>0)
			Form:C1466.RqST_TickEnd_l:=Form:C1466.RqST_TickEnd_l+(60*2)  // Retard timout when user types
		End if 
		
		If (OB Get:C1224(Form:C1466; "RqST_RegExp_t"; Is text:K8:3)="")  // If no Regular Expression search pattern
			Form:C1466.RqST_Response_t:=Get edited text:C655
			
		Else   // Test keyboard entry against RegEx pattern
			$Pos_l:=0
			$Length_l:=0
			$Text_t:=Get edited text:C655
			
			If (Match regex:C1019(OB Get:C1224(Form:C1466; "RqST_RegExp_t"; Is text:K8:3); $Text_t; 1; $Pos_l; $Length_l)=True:C214)  // If valid
				Form:C1466.RqST_Response_t:=$Text_t
				
			Else   // Invalid character entered
				BEEP:C151  // Give some feedback, then truncate the character
				(OBJECT Get pointer:C1124(Object current:K67:2))->:=Substring:C12($Text_t; 1; Length:C16($Text_t)-1)
			End if 
		End if 
		
	Else   // Some other event
		// Do nothing
End case 
