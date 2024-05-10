/* Object Method: SQL_Query_Login.SQL_Examples_at
      
  Purpose: Populate array with examples.
      
  Parameters: None

  Created: 07/05/2022 - MWL
  Version: 1.0 - 07/05/2022 - MWL
      
  Property: N/A
      
  Risk Assessment:
     LOW - Simple code.
      
  NOTES: None.
  ----------------------------------------------------*/

C_TEXT:C284($MenuText_t)
C_POINTER:C301($Object_p)

$Object_p:=OBJECT Get pointer:C1124(Object current:K67:2)

Case of 
	: (Form event code:C388=On Load:K2:1)
		ARRAY TEXT:C222($Object_p->; 0)
		
		APPEND TO ARRAY:C911($Object_p->; "SELECT")
		APPEND TO ARRAY:C911($Object_p->; "INSERT INTO")
		APPEND TO ARRAY:C911($Object_p->; "UPDATE")
		APPEND TO ARRAY:C911($Object_p->; "DELETE")
		
	: (Form event code:C388=On Clicked:K2:4)
		
		$MenuText_t:=$Object_p->{$Object_p->}
		$SQL_p:=OBJECT Get pointer:C1124(Object named:K67:5; "SQL_Query_t")
		Case of 
			: ($MenuText_t="SELECT")  // 
				$SQL_p->:="SELECT [ALL | DISTINCT]\r"
				$SQL_p->:=$SQL_p->+"{* | select_item, ..., select_item}\r"
				$SQL_p->:=$SQL_p->+"FROM table_reference, ..., table_reference\r"
				$SQL_p->:=$SQL_p->+"[WHERE search_condition]\r"
				$SQL_p->:=$SQL_p->+"[ORDER BY sort_list]\r"
				$SQL_p->:=$SQL_p->+"[GROUP BY sort_list]\r"
				$SQL_p->:=$SQL_p->+"[HAVING search_condition]\r"
				$SQL_p->:=$SQL_p->+"[LIMIT{4d_language_reference | int_number | ALL}]\r"
				$SQL_p->:=$SQL_p->+"[OFFSET 4d_language_reference | int_number]\r"
				$SQL_p->:=$SQL_p->+"[INTO{4d_language_reference, ..., 4d_language_reference}]\r"
				$SQL_p->:=$SQL_p->+"[FOR UPDATE]"
				
			: ($MenuText_t="INSERT INTO")  // 
				$SQL_p->:="INSERT INTO myTABLE\r"
				$SQL_p->:=$SQL_p->+"(numField1, strField, dateField, timeField)\r"
				$SQL_p->:=$SQL_p->+"VALUES (1, 'Francis','13/01/03','13:03:03');\r"
				
			: ($MenuText_t="UPDATE")  // 
				$SQL_p->:="UPDATE myTABLE\r"
				$SQL_p->:=$SQL_p->+"SET strField = 'Every dog', dateField = '2012-11-02T06:39:00', numField1 = 0\r"
				$SQL_p->:=$SQL_p->+"WHERE myKeyField = 'Something';"
				
			: ($MenuText_t="DELETE")  // 
				$SQL_p->:="DELETE FROM myTABLE\r"
				$SQL_p->:=$SQL_p->+"WHERE myNumField <= 2000;"
			Else 
				
		End case 
		
	Else   // Some other event
		// Do nothing
End case 
