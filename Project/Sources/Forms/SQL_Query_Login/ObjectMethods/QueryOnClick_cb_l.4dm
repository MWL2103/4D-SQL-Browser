/* Object Method: SQL_Query_Login.QueryOnClick_cb_l
      
  Purpose: xxXxx
      
  Parameters: None

  Created: 06/25/2022 - MWL
  Version: 1.0 - 06/25/2022 - MWL
      
  Property: N/A
      
  Risk Assessment:
     LOW - Simple code.
      
  NOTES: None.
  ----------------------------------------------------*/

Case of 
	: (Form event code:C388=On Load:K2:1)
		OBJECT SET VALUE:C1742(OBJECT Get name:C1087(Object current:K67:2); 1)  // Default to checked
		
	: (False:C215)
		
	Else   // Some other event
		// Do nothing
End case 
