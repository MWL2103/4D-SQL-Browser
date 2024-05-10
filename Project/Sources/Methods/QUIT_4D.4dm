//%attributes = {}
/* Method: QUIT_4D
      
  Purpose: xxXxx
      
  Parameters: None
    $0 - {boolean} 
    $1 - {object} 
    $2 - {text} 
    $3 - {longint} 
    $4 - {real} 
    $5 - {pointer} 

  Created: 07/13/2022 - MWL
  Version: 1.0 - 07/13/2022 - MWL
      
  Property: Invisible
            None
            Execute on Server
            Available through SQL
            N/A
      
  Risk Assessment:
     LOW - Simple code.
      
  NOTES: None.
  ----------------------------------------------------*/

var $Row_l : Integer
var $Dialog_ob : Object

$Dialog_ob:=New object(\
"CoNF_Msg_t"; "Are you sure you want to quit?"; \
"CoNF_OK_Text_t"; "OK"; \
"CoNF_IconName_t"; "Warn_Red"\
)
If (Application type=4D Server) | (Count parameters=1)  // If 4D Server or skipping the quit dialog
	OB SET($Dialog_ob; "FORM_Action_t"; ak accept)
	
Else   // 4D Client or 4D Stand Alone
	Confirm2($Dialog_ob)
End if 

If (OB Get($Dialog_ob; "FORM_Action_t"; Is text)=ak accept)
	
	If (Application type=4D Remote mode)  // If 4D Client
		// Do nothing
		
	Else   // 4D Server or 4D Stand Alone
		//SP_Kill_Stored_Procedure("All")
	End if 
	
	If (Application type=4D Server)
		// Let 4D Server shutdown on it's own
		
	Else   // 4D Stand alone
		QUIT 4D
	End if 
	
Else   // User canceled
	// Do nothing
End if 
