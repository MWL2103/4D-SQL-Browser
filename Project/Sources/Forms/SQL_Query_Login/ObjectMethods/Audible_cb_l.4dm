/* Object Method: SQL_Query_Login.Strip_Comments_cb_l
      
  Purpose: Checkbox enables/disables stripping of comments from SQL statement
      
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
		
	Else   // Some other event
		// Do nothing
End case 
