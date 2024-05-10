//%attributes = {"invisible":true}
/* Method: Check_SQL_Connection
      
  Purpose: xxXxx
      
  Parameters: None

  Created: 06/25/2022 - MWL
  Version: 1.0 - 06/25/2022 - MWL
      
  Property: Invisible
      
  Risk Assessment:
     LOW - Simple code.
      
  NOTES: None.
  ----------------------------------------------------*/

var $PreviousErrorHandler_t : Text

$PreviousErrorHandler_t:=Setup_SQL_Error_Handler

If (Remote("Login")=True)
	
	
	Begin SQL
		SELECT Count(*) FROM _USER_TABLES
	End SQL
	
	Remote("Logout")
	
Else 
	
End if 

If (False)
	var $connectTo; $Entity_ob : Object
	
	var $remoteDS : cs.DataStore
	var $connectTo : Object
	$remoteDS:=ds("RemoteDB")
	If ($remoteDS=Null)
		$connectTo:=New object
		$connectTo.type:="4D Server"  // Must be "4D Server"
		$connectTo.hostname:=Form.Server_Adrs_t+":443"  //+String(Form.Port_l)
		$connectTo.user:=Form.Username_t
		$connectTo.password:=Form.Password_t
		$connectTo.idleTimeout:=70
		$connectTo.tls:=True
		//$connectTo:=New object("type"; "4D Server"; "hostname"; Form.Server_Adrs_t+":443")
		$remoteDS:=Open datastore($connectTo; "RemoteDB")
	End if 
	$Entity_ob:=$remoteDS.Error_Log.all()
	
	//return $remoteDS
	
	
	
	//var $remoteDS : cs.DataStore
	var $RemoteDS : 4D.DataStoreImplementation  // Object
	
	$connectTo:=New object
	$connectTo.type:="4D Server"  // Must be "4D Server"
	$connectTo.hostname:=Form.Server_Adrs_t+":443"  //+String(Form.Port_l)
	$connectTo.user:=Form.Username_t
	$connectTo.password:=Form.Password_t
	$connectTo.idleTimeout:=70
	$connectTo.tls:=True
	
	$RemoteDS:=Open datastore($connectTo; "RemoteA")
	$Entity_ob:=ds("RemoteA")  //.Error_Log.all()
	$Entity_ob:=$RemoteDS.Error_Log.all()
	$result_es:=ds.Remote1.all()
	
	//$remoteDS:=Open datastore($connectTo; "Error_Log")
	
End if 
