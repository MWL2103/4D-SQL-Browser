/* Method: SQL_Query_Login.SQL_Table_Sets_at
      
  Purpose: xxXxx
      
  Parameters: None

  Created: 07/07/2022 - MWL
  Version: 1.0 - 07/07/2022 - MWL
      
  Property: N/A
      
  Risk Assessment:
     LOW - Simple code.
      
  NOTES: None.
  ----------------------------------------------------*/

var $Object_p : Pointer

$Object_p:=OBJECT Get pointer:C1124(Object named:K67:5; "SQL_Table_Sets_at")

Case of 
	: (Form event code:C388=On Load:K2:1)
		ARRAY TEXT:C222($Set_at; 0)
		
		APPEND TO ARRAY:C911($Set_at; "No Sets")
		
		COPY ARRAY:C226($Set_at; $Object_p->)
		$Object_p->:=1
		
	: (False:C215)
		
	Else   // Some other event
		// Do nothing
End case 
