//%attributes = {"invisible":true}
/* Method: Load_Servers
      
  Purpose: xxXxx
      
  Parameters: None
    $0 - {boolean} 
    $1 - {object} 
    $2 - {text} 
    $3 - {longint} 
    $4 - {real} 
    $5 - {pointer} 

  Created: 06/10/2022 - MWL
  Version: 1.0 - 06/10/2022 - MWL
      
  Property: Invisible
            None
            Execute on Server
            Available through SQL
            N/A
      
  Risk Assessment:
     LOW - Simple code.
      
  NOTES: None.
----------------------------------------------------*/

ARRAY LONGINT($ID_al; 0)  // Primary_al; 0)
ARRAY TEXT($Address_at; 0)
ARRAY LONGINT($Port_al; 0)
ARRAY TEXT($Name_at; 0)

Begin SQL
	SELECT ID_pk, IP_Address, Port, Name
	FROM Servers
	INTO :$ID_al, :$Address_at, :$Port_al, :$Name_at
End SQL

COPY ARRAY($ID_al; (OBJECT Get pointer(Object named; "LB_Primary_al"))->)
COPY ARRAY($Address_at; OBJECT Get pointer(Object named; "LB_Address_at")->)
COPY ARRAY($Port_al; (OBJECT Get pointer(Object named; "LB_Port_al"))->)
COPY ARRAY($Name_at; (OBJECT Get pointer(Object named; "LB_Name_at"))->)
