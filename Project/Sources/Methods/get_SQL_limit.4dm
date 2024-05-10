//%attributes = {"invisible":true}
/* Method: get_SQL_limit
      
  Purpose: Used from the 4D SQL Query Browser window to 
           find and return the limit for query results
      
  Parameters: 
    $0 - {text} SQL limit last chosen from popup menu

  Created: 06/13/2022 - MWL
  Version: 1.0 - 06/13/2022 - MWL
      
  Property: Invisible
      
  Risk Assessment:
     LOW - Simple code.
      
  NOTES: None.
----------------------------------------------------*/

#DECLARE->$Return_t

var $Object_p : Pointer

$Object_p:=OBJECT Get pointer(Object named; "SQL_Limit_at")

Case of 
		//: ($Object_p->{$Object_p->}="No Limit")  // no limit
		//$Return_t:=""
		
	: ($Object_p->{$Object_p->}="100")  // limit to 100
		$Return_t:=" LIMIT 100"
		
	: ($Object_p->{$Object_p->}="500")  // limit to 500
		$Return_t:=" LIMIT 500"
		
	: ($Object_p->{$Object_p->}="1,000")  // limit to 1,000
		$Return_t:=" LIMIT 1000"
		
	: ($Object_p->{$Object_p->}="10,000")  // limit to 10,000
		$Return_t:=" LIMIT 10000"
		
	: ($Object_p->{$Object_p->}="Last 20")  // limit to last 20 in table
		$Return_t:=" LIMIT 20 OFFSET "
		
	: ($Object_p->{$Object_p->}="Last 100")  // limit to last 100 in table
		$Return_t:=" LIMIT 100 OFFSET "
		
	: ($Object_p->{$Object_p->}="Last 1,000")  // limit to last 1000 in table
		$Return_t:=" LIMIT 1000 OFFSET "
		
	Else   // No limit
		$Return_t:=""
End case 
