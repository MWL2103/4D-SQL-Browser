/* Object Method: SQL_Query_Login.SQL_Limit_at
      
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
		ARRAY TEXT:C222($Limit_at; 0)
		
		APPEND TO ARRAY:C911($Limit_at; "100")
		APPEND TO ARRAY:C911($Limit_at; "500")
		APPEND TO ARRAY:C911($Limit_at; "1,000")
		APPEND TO ARRAY:C911($Limit_at; "10,000")
		APPEND TO ARRAY:C911($Limit_at; "Last 20")
		APPEND TO ARRAY:C911($Limit_at; "Last 100")
		APPEND TO ARRAY:C911($Limit_at; "Last 1,000")
		APPEND TO ARRAY:C911($Limit_at; "No Limit")
		
		// Select the second (500) item in the drop down list
		$Limit_at:=2
		
		COPY ARRAY:C226($Limit_at; OBJECT Get pointer:C1124(Object current:K67:2)->)
		
	Else   // Some other event
		// Do nothing
End case 
