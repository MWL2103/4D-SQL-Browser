//%attributes = {"invisible":true}
/* Method: Update_Connections
      
  Purpose: xxXxx
      
  Parameters: None

  Created: 06/05/2022 - MWL
  Version: 1.0 - 06/05/2022 - MWL
      
  Property: Invisible
      
  Risk Assessment:
     LOW - Simple code.
      
  NOTES: None.
----------------------------------------------------*/

var $Count_l; $Pos_l; $Row_l; $Servers_ID_l; $Users_ID_l : Integer
var $Name_t; $Temp_t : Text

$Servers_ID_l:=0
$Temp_t:=Form.Server_Adrs_t
$Name_t:=""

Begin SQL
	SELECT ID_pk, Name
	FROM Servers
	WHERE IP_Address = :$Temp_t
	LIMIT 1 INTO :$Servers_ID_l, :$Name_t
End SQL

OBJECT SET VALUE("Window_ID_t"; $Name_t)  // Set window ID

//$Pos_l:=Find in field([Connection]IP_Address; serveraddress_t)
If ($Servers_ID_l=0)  // (Find in field([Servers]IP_Address; Form.Server_Adrs_t)=No current record)
	CREATE RECORD([Servers])
	[Servers]IP_Address:=Form.Server_Adrs_t
	[Servers]Port:=Form.Port_l
	$Servers_ID_l:=[Servers]ID_pk
	SAVE RECORD([Servers])
	//CREATE RECORD([Connection])
	//[Connection]IP_Address:=serveraddress_t
	//[Connection]Port:=Num(serversqlport_t)
	//SAVE RECORD([Connection])
	Load_Servers
	
	$Row_l:=Find in array(OBJECT Get pointer(Object named; "LB_Address_at")->; Form.Server_Adrs_t)
	If ($Row_l>0)
		LISTBOX SELECT ROW(*; "Connections_LB"; $Row_l; lk replace selection)
	End if 
	
Else 
	
End if 

Form.Server_ID_pk_l:=$Servers_ID_l  // NOT SURE I NEED THIS, BUT SAVE FOR NOW

$Users_ID_l:=0
$Temp_t:=Form.Username_t
//$Count_l:=0
Begin SQL
	SELECT ID_pk
	FROM Users
	WHERE Name = :$Temp_t
	LIMIT 1 INTO :$Users_ID_l
End SQL

//$Pos_l:=Find in field([User]Name; username_t)
If ($Users_ID_l=0)  // (Find in field([Users]Name; Form.Username_t)=No current record)
	CREATE RECORD([Users])
	[Users]Servers_ID_fk:=$Servers_ID_l
	[Users]Name:=Form.Username_t
	$Users_ID_l:=[Users]ID_pk
	SAVE RECORD([Users])
	//CREATE RECORD([User])
	//[User]Name:=username_t
	//SAVE RECORD([User])
	
Else 
	
End if 

Form.Users_ID_pk_l:=$Users_ID_l  // NOT SURE I NEED THIS, BUT SAVE FOR NOW
