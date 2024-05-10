//%attributes = {"invisible":true}
/* Method: Load_Tables
      
  Purpose: xxXxx
      
  Parameters: None

  Created: 06/05/2022 - MWL
  Version: 1.0 - 06/05/2022 - MWL
      
  Property: Invisible
      
  Risk Assessment:
     LOW - Simple code.
      
  NOTES: None.
----------------------------------------------------*/

var $Columns_l; $Count_l : Integer
var $Tab_Cntrl_p : Pointer
var $PreviousErrorHandler_t : Text

$Tab_Cntrl_p:=OBJECT Get pointer(Object named; "Tables_Tab_at")

Case of 
	: ($Tab_Cntrl_p->=1)  // SQL System Tables
		// fill an array for the list box of system tables
		ARRAY TEXT($SQL_Tables_at; 7)
		$SQL_Tables_at{1}:="_USER_TABLES"  // Describes the user tables of the database
		$SQL_Tables_at{2}:="_USER_COLUMNS"  // Describes the columns of the user tables of the database
		$SQL_Tables_at{3}:="_USER_INDEXES"  // Describes the user indexes of the database
		$SQL_Tables_at{4}:="_USER_CONSTRAINTS"  // Describes the integrity constraints of the database
		$SQL_Tables_at{5}:="_USER_IND_COLUMNS"  // Describes the columns of user indexes of the database
		$SQL_Tables_at{6}:="_USER_SCHEMAS"  // Describes the schemas of the database
		$SQL_Tables_at{7}:="_USER_CONS_COLUMNS"  // Describes the columns of user constraints of the database
		
		//----------------------------------------------------
		// See if we are connected to a 4D v14+ system.
		//$PreviousErrorHandler_t:=Setup_SQL_Error_Handler  // Save current error handler 
		
		$Count_l:=No current record
		Begin SQL
			SELECT Count(*) FROM _USER_VIEWS INTO :$Count_l;
		End SQL
		
		//ON ERR CALL($PreviousErrorHandler_t)  // Restore previous error handler 
		
		If (Error_l=0)  // If no SQL exception, these tables exist (v14+ only)
			APPEND TO ARRAY($SQL_Tables_at; "_USER_VIEWS")  // Describes the views of database users 
			APPEND TO ARRAY($SQL_Tables_at; "_USER_VIEW_COLUMNS")  // Describes the columns of the views of the database users
			
		Else   // Must be 4D v11, v12, or v13
			// Do nothing
		End if 
		
		COPY ARRAY($SQL_Tables_at; (OBJECT Get pointer(Object named; "SQL_Tables_at"))->)
		//----------------------------------------------------
	: ($Tab_Cntrl_p->=2)  // Remote User Tables
		// SQL_Tables_at
		ARRAY TEXT($SQL_Tables_at; 0)
		If (OBJECT Get value("Login_btn_l")=1)  // Initial login
			//If (OBJECT Get value("Audible_cb_l")=1)  // If audible events on
			//BEEP
			//End if 
			
			Begin SQL
				--SELECT TABLE_NAME, TEMPORARY, TABLE_ID, SCHEMA_ID, REPLICATION, REST_AVAILABLE, LOGGED
				SELECT TABLE_NAME 
				FROM _USER_TABLES 
				ORDER BY 1
				INTO :$SQL_Tables_at;
			End SQL
			
		Else   // Don't sort after initial login
			Begin SQL
				SELECT TABLE_NAME 
				FROM _USER_TABLES 
				ORDER BY 1
				INTO :$SQL_Tables_at;
			End SQL
		End if 
		
		//: ($Tab_Cntrl_p->=3)  // Remote User Tables
		//COPY ARRAY(Selected_Tables_at; SQL_Tables_at)
		
		COPY ARRAY($SQL_Tables_at; (OBJECT Get pointer(Object named; "SQL_Tables_at"))->)
		
	Else   // Some other tab
		// Do nothing
End case 

$Columns_l:=Size of array($SQL_Tables_at)
OBJECT SET TITLE(*; "LB_Tables_Title"; $Tab_Cntrl_p->{$Tab_Cntrl_p->}+" ("+String($Columns_l)+")")
