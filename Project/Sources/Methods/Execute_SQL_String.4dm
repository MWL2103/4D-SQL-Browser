//%attributes = {"invisible":true}
/* Method: Execute_SQL_String
      
  Purpose: xxXxx
      
  Parameters: None

  Created: 06/25/2022 - MWL
  Version: 1.1 - 09/28/2022 - MWL
      
  Property: Invisible
      
  Risk Assessment:
     LOW - Simple code.
      
  NOTES: None.
  ----------------------------------------------------*/

// Execute_SQL_String

// Description: This method does the actual execution of the query.

// Version: 1.7 - 12/22/2020 - MWL

// Risk assessment: 
//      LOW - No known bugs.

// Notes: Could add a IF statement for simultaneously matching leading and
//        trailing whitespace . Grep:^[ << t]+ | [ << t]+$
//-------------------------------------------------

var $Found_b; $Match_b : Boolean
var $Count_l; $First_l; $Is_Alive_l; $Last_l; $Length_l; $Offset_l; $Pos_l : Integer
var $Start_l : Integer
var $Strip_Comments_p : Pointer
var $PreviousErrorHandler_t; $RegEx_t; $SQL_t : Text

ARRAY BOOLEAN(LB_QueryOutput; 0)

$PreviousErrorHandler_t:=Setup_SQL_Error_Handler  // Reset error variables

$SQL_t:=OBJECT Get value("SQL_Query_t")
$Length_l:=Length($SQL_t)

Case of 
	: ($Length_l=0)
		// Do nothing
		
	Else 
		//$Strip_Comments_p:=OBJECT Get pointer(Object named; "Strip_Comments_cb")
		
		GET HIGHLIGHT(*; "SQL_Query_t"; $First_l; $Last_l)
		
		If ($First_l=$Last_l) | (Macintosh option down | Windows Alt down)  // No selection OR Alt key down
			$SQL_t:=ST Get plain text(*; "SQL_Query_t"; ST Text displayed with 4D Expression values)
			
			If (True)
				$Found_b:=False
				$Start_l:=1
				$Pos_l:=0
				$Length_l:=0
				$RegEx_t:="(?mi-s)[^\\r\\n]+((\\r|\\n|\\r\\n)[^\\r\\n]+)*"  // Match Paragraphs
				Repeat 
					$Match_b:=Match regex($RegEx_t; $SQL_t; $Start_l; $Pos_l; $Length_l)
					
					$Offset_l:=Length(Substring($SQL_t; $Pos_l; $Length_l))
					
					Case of 
						: ($Pos_l<=$First_l) & (($Pos_l+$Offset_l)>=$First_l)  // If cursor is between First and Last
							$SQL_t:=Substring($SQL_t; $Pos_l; $Length_l)
							HIGHLIGHT TEXT(*; "SQL_Query_t"; $Pos_l; $Pos_l+$Length_l)
							$Found_b:=True
							
						: ($Pos_l>$Last_l)  // Were past the end of the selection
							$SQL_t:=""
							$Found_b:=True
							
						: ($Offset_l=0)  // End of text
							$Found_b:=True
							
						Else 
							
					End case 
					
					$Start_l:=$Pos_l+$Length_l
				Until ($Found_b=True)  // (($Pos_l>=$First_l) & ($Pos_l<=$Last_l))
			End if 
			
		Else   // Get the selection
			$SQL_t:=ST Get text(*; "SQL_Query_t"; ST Start highlight; ST End highlight)
			$SQL_t:=ST Get plain text($SQL_t; ST Text displayed with 4D Expression values)
		End if 
		
		If (OBJECT Get value("Strip_Comments_cb_l")=1) & ($SQL_t#"")  // If checked
			$SQL_t:=Ut_Strip_Comments($SQL_t)
			
		Else   // Were not stripping comments out
			$SQL_t:=$SQL_t
		End if 
		
		If ($SQL_t#"")
			//$SQL_t:=Replace string($SQL_t;"\r";" ";1)  // Replace all CR's with a space (FAILS WITH -- COMMENTS)
			Ut_Trim_White_Space(->$SQL_t; False; True; False)  // Trim any space from beginning of SQL statement
			
			While ($SQL_t[[1]]="\r")  // Trim any CR's from the beginning of the string (if any)
				$SQL_t:=Substring($SQL_t; 2)
			End while 
			
			Ut_Trim_White_Space(->$SQL_t; False; True; False)  // Trim any space from beginning of SQL statement
		End if 
		
		
		Case of 
			: (($SQL_t="desc @") | ($SQL_t="describe @"))
				LISTBOX DELETE COLUMN(*; "LB_QueryOutput"; 1; LISTBOX Get number of columns(*; "LB_QueryOutput"))
				
				$Pos_l:=Position("desc "; $SQL_t)+5
				If ($Pos_l<6)  // User typed desc
					$Pos_l:=Position("describe "; $SQL_t)+9
				End if 
				$SQL_t:=Substring($SQL_t; $Pos_l)
				//$SQL_t:="SELECT * FROM _USER_COLUMNS WHERE Table_Name = '"+$SQL_t+"' into :LB_QueryOutput"
				$SQL_t:="SELECT TABLE_NAME, COLUMN_NAME, "+"CASE DATA_TYPE "+"WHEN 1 THEN 'Boolean' "+"WHEN 3 THEN 'Integer' "+"WHEN 4 THEN 'LongInt' "+"WHEN 5 THEN 'Integer 64 bits' "+"WHEN 6 THEN 'Real' "+"WHEN 7 THEN 'Float' "+"WHEN 8 THEN 'Date' "+"WHEN 9 THEN 'Time' "+"WHEN 10 THEN CASE DATA_LENGTH WHEN 0 THEN 'Text' ELSE CONCAT('Alpha ', DATA_LENGTH/2) END "+"WHEN 12 THEN 'Picture' "+"WHEN 13 THEN 'UUID' "+"WHEN 18 THEN 'BLOB' "+"ELSE CONCAT('Unknown Type ', DATA_TYPE) END AS Type, "+"CASE NULLABLE WHEN True THEN 'YES' ELSE 'Reject NULL' END AS 'Null OK', "+"TABLE_ID, COLUMN_ID "+"FROM _USER_COLUMNS WHERE Table_Name = '"+$SQL_t+"' into :LB_QueryOutput"
				
			: ((Position("SELECT "; $SQL_t)=1) | (Position("SELECT\r"; $SQL_t)=1))  // ($SQL_t="SELECT@")
				LISTBOX DELETE COLUMN(*; "LB_QueryOutput"; 1; LISTBOX Get number of columns(*; "LB_QueryOutput"))
				
				$SQL_t:=Ut_Remove_Last_Semicolon($SQL_t)
				//$Pos_l:=Position(";";$SQL_t)  // Does the query string have a semicolon?
				//If ($Pos_l>0)
				//$SQL_t:=Substring($SQL_t;1;$Pos_l-1)  // Remove semicolon from query string
				//End if 
				
				// append the 'into :ListBox' notation to the query for display purposes
				$SQL_t:=$SQL_t+" INTO :LB_QueryOutput"
				
			Else   // This is NOT a SELECT call, so don't update the result set
				$Pos_l:=Position(";"; $SQL_t)  // Does the query string have a semicolon?
				If ($Pos_l>0)
					$SQL_t:=Substring($SQL_t; 1; $Pos_l-1)  // Remove semicolon from query string
				End if 
				// append the 'into :ListBox' notation to the query for display purposes
				//$SQL_t:=$SQL_t+" INTO :LB_QueryOutput"
				
		End case 
		
		// Setup SQL error handler
		//ON ERR CALL("Err_SQL_Handler")
		//If (False)
		//Err_SQL_Handler 
		//End if 
		
		//$Is_Alive_l:=-1
		//NET_Ping ( Get current data source ; "." ; $Is_Alive_l ; 2 )
		
		// check the time before execution
		SQL SET OPTION(SQL query timeout; 1)  // Set maximum timeout awaiting response
		
		//$Count_l:=-1
		//Begin SQL
		//SELECT count(*) FROM _USER_TABLES INTO :$Count_l;
		//End SQL
		
		// Clearing this array fixes redraw problem left over from last filter text
		ARRAY BOOLEAN(aoHiddenRow2; 0)
		
		// Clear filter and past filter
		Filter_Value_t:=""  //tFilterRows:=""
		Form.Old_Filter_Value_t:=""  // tOldFilterRows:=""
		
		If (Remote("Login")=True)
			Form.Start_Time_ms_l:=Milliseconds
			Begin SQL  // Execute the query
				EXECUTE IMMEDIATE :$SQL_t;
			End SQL
			Form.End_Time_ms_l:=Milliseconds
			
			Remote("Logout")
			
			//If (Error_l=0)
			
			//Else 
			//Alert2(Error_Method_t)
			//End if 
			
		Else 
			BEEP
		End if 
		
		// check time after the execution of the query
		
		// Tear down the error handler
		//ON ERR CALL("")
		
		// set the list box display to enterable
		OBJECT SET ENTERABLE(*; "LB_QueryOutput"; True)
		
		If (OBJECT Get pointer(Object named; "SQL_Auto_Size_cb_l")->=1)
			Size_Columns
		End if 
End case 
