//%attributes = {"invisible":true}
/* Method: DisconnectFromServer
      
  Purpose: xxXxx
      
  Parameters: None

  Created: 06/05/2022 - MWL
  Version: 1.0 - 06/05/2022 - MWL
      
  Property: Invisible
      
  Risk Assessment:
     LOW - Simple code.
      
  NOTES: None.
----------------------------------------------------*/

var $Variable_x : Blob
var $Column_l; $Columns_l; $Row_l : Integer
var $LB_p : Pointer
var $Error_t; $Path_t : Text
var $vhDocRef : Variant

SET TIMER(0)  // Turn off the repeating connection tests

OBJECT SET VALUE("QueryExtraInfo_t"; "")  // Clear the query information at the bottom of the screen

LISTBOX SELECT ROW(*; "LB_SystemTables"; 0; lk remove from selection)
LISTBOX SELECT ROW(*; "LB_Tables"; 0; lk remove from selection)
SELECT LIST ITEMS BY POSITION(*; "SqlLimit_at"; 1)

If (Position("_LOCAL"; SQL Get current data source)=0)  // See if we are connected
	//SQL LOGOUT
	Remote("Logout")
End if 

For ($Row_l; 1; LISTBOX Get number of rows(*; "LB_Tables"))
	LISTBOX DELETE ROWS(*; "LB_Tables"; $Row_l; 1)
End for 

If (True)  // Clear SQL query results listbox
	$Columns_l:=LISTBOX Get number of columns(*; "LB_QueryOutput")
	For ($Column_l; $Columns_l; 1; -1)
		LISTBOX DELETE COLUMN(*; "LB_QueryOutput"; $Column_l)
	End for 
	
	$LB_p:=OBJECT Get pointer(Object named; "LB_QueryOutput")
	CLEAR VARIABLE($LB_p->)
End if 

SET WINDOW TITLE("New Connection")  // Reset the window title
FORM GOTO PAGE(1)
//-------------------------------------------------  
// Save current tabs
$Path_t:=Get 4D folder(Current resources folder)+"Tabs"+Folder separator+Form.Server_Adrs_t+Folder separator

If (Test path name($Path_t+"Query_Left.blob")#Is a document)
	CREATE FOLDER($Path_t; *)
	$vhDocRef:=Create document($Path_t+"Query_Left.blob")  // Save the document of your choice
	CLOSE DOCUMENT($vhDocRef)  // We don't need to keep it open
End if 

VARIABLE TO BLOB(Query_Left_at; $Variable_x)  // Store the array into the BLOB
BLOB TO DOCUMENT($Path_t+"Query_Left.blob"; $Variable_x)  // Save the BLOB on disk
//-------------------------------------------------
If (Test path name($Path_t+"Query_Right.blob")#Is a document)
	CREATE FOLDER($Path_t; *)
	$vhDocRef:=Create document($Path_t+"Query_Right.blob")  // Save the document of your choice
	CLOSE DOCUMENT($vhDocRef)  // We don't need to keep it open
End if 

VARIABLE TO BLOB(Query_Right_at; $Variable_x)  // Store the array into the BLOB
BLOB TO DOCUMENT($Path_t+"Query_Right.blob"; $Variable_x)  // Save the BLOB on disk
//-------------------------------------------------
If (Test path name($Path_t+"Query_Tab.blob")#Is a document)
	CREATE FOLDER($Path_t; *)
	$vhDocRef:=Create document($Path_t+"Query_Tab.blob")  // Save the document of your choice
	CLOSE DOCUMENT($vhDocRef)  // We don't need to keep it open
End if 

VARIABLE TO BLOB(Query_Tab_at; $Variable_x)  // Store the array into the BLOB
BLOB TO DOCUMENT($Path_t+"Query_Tab.blob"; $Variable_x)  // Save the BLOB on disk
