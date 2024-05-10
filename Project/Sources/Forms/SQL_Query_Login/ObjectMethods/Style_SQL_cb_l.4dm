/* Object Method: SQL_Query_Login.Style_SQL_cb_l
      
  Purpose: xxXxx
      
  Parameters: None

  Created: 06/25/2022 - MWL
  Version: 1.0 - 06/25/2022 - MWL
      
  Property: N/A
      
  Risk Assessment:
     LOW - Simple code.
      
  NOTES: None.
  ----------------------------------------------------*/

If (Form event code:C388=On Load:K2:1)
	(OBJECT Get pointer:C1124(Object current:K67:2))->:=1
End if 
