//%attributes = {"invisible":true}
/* Method: Remote
      
  Purpose: xxXxx
      
  Parameters: None

  Created: 06/12/2022 - MWL
  Version: 1.1 - 06/25/2022 - MWL
      
  Property: Invisible
      
  Risk Assessment:
     LOW - Simple code.
      
  NOTES: https://blog.4d.com/system-worker-vs-launch-external-process/
----------------------------------------------------*/

#DECLARE($Action_t : Text)->$Connected_b : Boolean

var $Data_Source_t : Text

Case of 
	: ($Action_t="Login")
		$Data_Source_t:="IP:"+Form.Server_Adrs_t+":"+String(Form.Port_l)
		
		If (SQL Get current data source=$Data_Source_t)  // If we are already connected
			$Connected_b:=True
			
		Else 
			SQL SET OPTION(SQL connection timeout; 3)
			// attempt to connect
			SQL LOGIN($Data_Source_t; Form.Username_t; Form.Password_t; *)
			
			If ((SQL Get current data source=$Data_Source_t) & (Error_l=0))
				$Connected_b:=True
				
			Else 
				$Connected_b:=False
			End if 
		End if 
		
	Else   // Logout
		SQL LOGOUT
		
		If (Error_l=0)
			$Connected_b:=False
			
		Else 
			
		End if 
End case 
