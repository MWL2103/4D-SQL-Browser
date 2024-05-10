/* Object Method: SQL_Query_Login.SQL_Auto_Size_cb_l
      
  Purpose: Turns on/off the automatic column sizing
      
  Parameters: None

  Created: 06/25/2022 - MWL
  Version: 1.0 - 06/25/2022 - MWL
      
  Property: N/A
      
  Risk Assessment:
     LOW - Simple code.
      
  NOTES: None.
  ----------------------------------------------------*/

If (Form event code:C388=On Load:K2:1)
	OBJECT SET VALUE:C1742(OBJECT Get name:C1087(Object current:K67:2); 1)  // Check on by default
End if 
