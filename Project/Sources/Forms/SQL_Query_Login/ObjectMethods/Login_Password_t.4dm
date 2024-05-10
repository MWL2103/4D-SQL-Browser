/* Object Method: SQL_Query_Login.Login_Password_t
      
  Purpose: xxXxx
      
  Parameters: None

  Created: 06/05/2022 - MWL
  Version: 1.0 - 06/05/2022 - MWL
      
  Property: N/A
      
  Risk Assessment:
     LOW - Simple code.
      
  NOTES: None.
----------------------------------------------------*/

Case of 
	: (Form event code:C388=On Load:K2:1)
		OBJECT SET FONT:C164(*; OBJECT Get name:C1087(Object current:K67:2); "%password")
		
	: (Form event code:C388=On Data Change:K2:15)
		Form:C1466.Password_t:=OBJECT Get value:C1743(OBJECT Get name:C1087(Object current:K67:2))
		
	Else   // Some other event
		// Do nothing
End case 
