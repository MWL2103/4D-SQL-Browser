/* Object Method: SQL_Query_Login.Input
      
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
		OBJECT SET VALUE:C1742(OBJECT Get name:C1087(Object current:K67:2); Storage:C1525.DB_ob.Version_t)
		
	Else   // Some other event
		// Do nothing
End case 
