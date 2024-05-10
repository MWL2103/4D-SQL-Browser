/* Object Method: SQL_Query_Login.Logout_btn_l
      
  Purpose: xxXxx
      
  Parameters: None

  Created: 06/05/2022 - MWL
  Version: 1.1 - 08/18/2023 - MWL
      
  Property: N/A
      
  Risk Assessment:
     LOW - Simple code.
      
  NOTES: None.
----------------------------------------------------*/

Case of 
	: (Form event code=On Clicked)
		// Clear "Execute" timer if set
		SET TIMER(60*Form.Timer_Seconds_l)
		OBJECT SET VALUE("Spinner_l"; 0)
		OBJECT SET VISIBLE(*; "Spinner_l"; False)
		OBJECT SET TITLE(*; "SQL_Execute_btn_l"; "Execute")
		Form.Executing_b:=False
		
		DisconnectFromServer
		
		$Data_Source_t:="IP:"+Form.Server_Adrs_t+":"+String(Form.Port_l)
		$Msg_t:="Logged out of "+$Data_Source_t+"\n\n"+String(Current date; Internal date short)+" "+String(Current time; System time long)
		OBJECT SET VALUE("Login__Message_t"; $Msg_t)
		
	Else 
		// Do nothing
End case 
