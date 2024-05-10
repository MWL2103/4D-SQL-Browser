//%attributes = {"invisible":true}
/* Method: Ut_Encode_HTML_Entities
      
  Purpose: Encodes specific characters so multi-style text areas do not fail.
      
  Parameters: 
    $0 - {text} Resulting text string
    $1 - {text} Input text string

  Created: 06/04/2022 - MWL
  Version: 1.0 - 06/04/2022 - MWL
      
  Property: Invisible
      
  Risk Assessment:
     LOW - Simple code.
      
  NOTES: None.
----------------------------------------------------*/

#DECLARE($Input_t : Text)->$Output_t : Text

$Output_t:=Replace string($Input_t; "&"; "&amp;")
$Output_t:=Replace string($Output_t; "<"; "&lt;")
$Output_t:=Replace string($Output_t; ">"; "&gt;")
