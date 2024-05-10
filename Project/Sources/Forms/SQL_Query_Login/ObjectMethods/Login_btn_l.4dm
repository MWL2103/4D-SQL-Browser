/* Object Method: SQL_Query_Login.Login_btn_l
      
  Purpose: Connects to specified address, and loads schema table names
      
  Parameters: None

  Created: 06/04/2022 - MWL
  Version: 1.1 - 01/03/2023 - MWL
      
  Property: N/A
      
  Risk Assessment:
     LOW - Simple code.
      
  NOTES: Does not distinguish between databases < 4D v14 which can
         have _USER_VIEWS and _USER_VIEW_COLUMNS.  When one of those
         system tables is selected, a runtime error will result.
----------------------------------------------------*/


Case of 
	: (Form event code=On Clicked)
		
		ARRAY TEXT($Missing_Items_at; 0)
		// Check for missing items needed for logging in
		If (Form.Username_t="")  // If username is blank
			APPEND TO ARRAY($Missing_Items_at; "Username")
		End if 
		
		//If (serveraddress_t="")  
		If (Form.Server_Adrs_t="")  // If 4D Server address is blank
			APPEND TO ARRAY($Missing_Items_at; "4D Server Address")
		End if 
		
		//If (serversqlport_t="")  
		If (Form.Port_l=0)  // If sql server port is blank
			APPEND TO ARRAY($Missing_Items_at; "4D Servers SQL Port")
		End if 
		
		If (Size of array($Missing_Items_at)=0)
			Update_Connections  // Stores unique combinations of user logins
			// No missing items
			//C_TEXT(connectto_t)
			
			// Prepare the connection string using the server address and port
			//$Object_p:=OBJECT Get pointer(Object named;"Address_at")
			//serveraddress_t:=$Object_p->{$Object_p->}
			//serversqlport_t:=(OBJECT Get pointer(Object named; "Server_SQL_Port_t"))->
			
			//connectto_t:="IP:"+serveraddress_t+":"+serversqlport_t
			//tTempText:=""  // Temporary storage of text
			$PreviousErrorHandler_t:=Setup_SQL_Error_Handler
			
			//$Error_t:=Ut_Verify_Host(serveraddress_t; Replace string(serversqlport_t; ":ssl"; ""))
			
			// If Ut_Verify_Host did not return an error OR Windows OS OR Mac Option key down
			$Window_ID_t:=""  //[Connection]Name
			$Server_Adrs_t:=Form.Server_Adrs_t
			$Servers_ID_l:=0
			
			//Begin SQL
			//SELECT ID_pk, Name
			//FROM Servers
			//WHERE IP_Address = :$Server_Adrs_t
			//LIMIT 1 INTO :$Servers_ID_l, :$Window_ID_t
			//End SQL
			
			If (True)  // (Position("Error:"; $Error_t)=0) | (Folder separator#":") | (Macintosh option down)
				// Setup login error handler
				//ON ERR CALL("err_handler")
				//If (False)
				//err_handler
				//End if 
				
				// Set connetion timout to 10 seconds
				//SQL SET OPTION(SQL connection timeout; 3)
				$Data_Source_t:="IP:"+Form.Server_Adrs_t+":"+String(Form.Port_l)
				//// attempt to connect
				//SQL LOGIN($Data_Source_t; Form.Username_t; Form.Password_t; *)
				
				// clear the login err handler
				//ON ERR CALL("")
				
				// Check current data source with requested data source
				If (Remote("Login")=True)  // ((Get current data source=$Data_Source_t) & (Error_l=0))  // ((OK=1) & (Error=0))
					$Window_ID_t:=OBJECT Get value("Window_ID_t")  // Set window ID
					// connection successful
					SET WINDOW TITLE("Connected"+Choose($Window_ID_t=""; ""; " to "+$Window_ID_t)+" as "+Form.Username_t+" - "+$Data_Source_t)
					
					// Get the list of tables form the connected database
					$Tab_Cntrl_p:=OBJECT Get pointer(Object named; "Tables_Tab_at")
					//$Tab_Cntrl_p->:=1  // Load remote system table
					//Load_Tables
					
					$Tab_Cntrl_p->:=2  // Load remote tables
					Load_Tables
					
					ARRAY TEXT(Outside_Calls_at; 0)  // Outside call information
					Form.Timer_Seconds_l:=3
					SET TIMER(60*Form.Timer_Seconds_l)  // Start timer to check SQL connection every 3 seconds
					
					//Get_Excluded_Tables  // Get any excluded tables for this connection
					
					Remote("Logout")
					//-------------------------------------------------
					// Load previous tabs
					$Path_t:=Get 4D folder(Current resources folder)+"Tabs"+Folder separator+Form.Server_Adrs_t+Folder separator
					
					If (Test path name($Path_t+"Query_Left.blob")=Is a document)
						C_BLOB($Variable_x)
						DOCUMENT TO BLOB($Path_t+"Query_Left.blob"; $Variable_x)  // Load the BLOB from the disk
						BLOB TO VARIABLE($Variable_x; Query_Left_at)  // Retrieve the array from the BLOB
						
						DOCUMENT TO BLOB($Path_t+"Query_Right.blob"; $Variable_x)  // Load the BLOB from the disk
						BLOB TO VARIABLE($Variable_x; Query_Right_at)  // Retrieve the array from the BLOB
						
						DOCUMENT TO BLOB($Path_t+"Query_Tab.blob"; $Variable_x)  // Load the BLOB from the disk
						BLOB TO VARIABLE($Variable_x; Query_Tab_at)  // Retrieve the array from the BLOB
						
						// Restore text to current tab
						OBJECT SET VALUE("SQL_Query_t"; Query_Left_at{Query_Tab_at})
						OBJECT SET VALUE("Right_Text_t"; Query_Right_at{Query_Tab_at})
						
					Else   // New login
						ARRAY TEXT(Query_Tab_at; 0)
						APPEND TO ARRAY(Query_Tab_at; "View ")
						APPEND TO ARRAY(Query_Tab_at; "+")
						Query_Tab_at:=1
						Query_Tab_at{0}:=String(Query_Tab_at)
						
						ARRAY TEXT(Query_Left_at; 0)
						ARRAY TEXT(Query_Right_at; 0)
						APPEND TO ARRAY(Query_Left_at; "")
						APPEND TO ARRAY(Query_Right_at; "")
					End if 
					
					If (False)
						ARRAY TEXT(Outside_Calls_at; 0)  // Outside call information
						Get_Excluded_Tables  // Get any excluded tables for this connection
						
						READ ONLY([Queries])
						READ ONLY([Users])
						QUERY([Users]; [Users]Servers_ID_fk=Connection_ID_l)
						
						// Load saved queries
						ARRAY TEXT(Saved_Queries_Menu_at; 0)
						ARRAY LONGINT(Saved_Queries_ID_al; 0)
						//QUERY([Queries];[Queries]UserID_fk=[User]ID_pk)
						ALL RECORDS([Queries])
						SELECTION TO ARRAY([Queries]Name; Saved_Queries_Menu_at; [Queries]ID_pk; Saved_Queries_ID_al)
						//Begin SQL
						//SELECT Name, ID_pk 
						//FROM User_Queries
						//ORDER BY 1
						//INTO :atQueryNames, :atQueryIDs;
						//End SQL
						
						// Load excluded tables
						//QUERY([Tables];[Tables]UserID_fk=[User]ID_pk)
						//SELECTION TO ARRAY([Tables]Excluded;$atExcluded)
					End if 
					
					ARRAY TEXT($QueryNames_at; 0)
					ARRAY LONGINT($Query_IDs_al; 0)
					
					Begin SQL
						SELECT Name, ID_pk 
						FROM Queries
						ORDER BY 1
						INTO :$QueryNames_at, :$Query_IDs_al;
					End SQL
					
					
					If (False)
						//$K:=Size of array(atExcludedTables)
						//For ($J; 1; $K)
						//$L:=Find in array(SQL_Tables_at; atExcludedTables{$J})
						
						//If ($L>0)
						//LISTBOX DELETE ROWS(*; "LB_Tables"; $L; 1)
						//End if 
						//End for 
						
					End if 
					
					// goto the next page
					FORM GOTO PAGE(2)
				Else 
					// connection failed
					// alerted from error handler
					BEEP
					OBJECT SET VALUE("Login__Message_t"; Error_Method_t+"\r\r"+String(Current date; Internal date short)+" "+String(Current time; System time long))
				End if 
			Else   // Host returned an error
				//ALERT($Error_t;"OK")
				BEEP
				OBJECT SET VALUE("Login__Message_t"; Error_Method_t+"\r\r"+String(Current date; Internal date short)+" "+String(Current time; System time long))
			End if 
			
		Else   // missing items
			// Prep a message for the user
			$Msg_t:="The following fields are blank:\r\n"
			For ($Row_l; 1; Size of array($Missing_Items_at))
				// append the missing item to the message
				$Msg_t:=$Msg_t+"\n* "+$Missing_Items_at{$Row_l}
			End for 
			
			// Alert the user of the missing items
			$Msg_t:=$Msg_t+"\n\nPlease fill in all fields before attempting to login. "
			$Msg_t:=$Msg_t+"\n\n"+String(Current date; Internal date short)+" "+String(Current time; System time long)
			BEEP
			OBJECT SET VALUE("Login__Message_t"; $Msg_t)
		End if 
		
	Else 
		// Do nothing
End case 