/* Object Method: SQL_Query_Login.Saved_Queries_Menu_at
      
  Purpose: xxXxx
      
  Parameters: None

  Created: 07/05/2022 - MWL
  Version: 1.0 - 07/05/2022 - MWL
      
  Property: N/A
      
  Risk Assessment:
     LOW - Simple code.
      
  NOTES: None.
  ----------------------------------------------------*/

$Object_p:=OBJECT Get pointer:C1124(Object current:K67:2)

Case of 
	: (Form event code:C388=On Load:K2:1)
		ARRAY TEXT:C222($Query_at; 0)
		
		APPEND TO ARRAY:C911($Query_at; "Empty")
		
		COPY ARRAY:C226($Query_at; $Object_p->)
		$Object_p->:=1
		
	: (Form event code:C388=On Clicked:K2:4)
		TRACE:C157
		$tTheID:=$Object_p->{$Object_p->}
		ST SET TEXT:C1115(*; "SQL_Query_t"; "<span></span>")  // Must clear variable before reassigning the text
		
		READ ONLY:C145([Queries:3])
		QUERY:C277([Queries:3]; [Queries:3]ID_pk:1=$tTheID)
		//tSQL:=[Queries]SQL_Query
		ST SET TEXT:C1115(*; "SQL_Query_t"; [Queries:3]SQL_Query:4)
		
		//$SQL_t:=ST Get plain text(*;"SQL_Query_t")
		
		// THIS SHOULD BE CONVERTED INTO A WORKER PROCESS
		POST OUTSIDE CALL:C329(Current process:C322)  // Call form method so row counts will get updated
		//APPEND TO ARRAY(Outside_Calls_at; "Format_Query")
		Form:C1466.Format_Query_b:=True:C214
		
	Else 
		//$lEvent:=Form event
End case 
