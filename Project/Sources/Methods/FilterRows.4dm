//%attributes = {"invisible":true}
/* Method: FilterRows
      
  Purpose: xxXxx
      
  Parameters: None

  Created: 06/25/2022 - MWL
  Version: 1.0 - 06/25/2022 - MWL
      
  Property: Invisible
      
  Risk Assessment:
     LOW - Simple code.
      
  NOTES: None.
  ----------------------------------------------------*/

var $Date_d : Date
var $Column_l; $Column_Type_l; $Columns_l; $Index_l; $Indexes_l; $Row_l; $Rows_l : Integer
var $UserEntry_t : Text

$UserEntry_t:=OBJECT Get value("Filter_Value_t")
If ($UserEntry_t="")  // If filter is empty
	// Do nothing
	
Else 
	If (OBJECT Get value("SQL_Filter_cb_l")=1)  // If Filter is checked
		ProgBar_Open("Filtering data...")
		
	Else 
		ProgBar_Open("Highlighting data...")
	End if 
	
	ARRAY TEXT($Col_Name_at; 0)
	ARRAY TEXT($Hdr_Name_at; 0)
	
	ARRAY BOOLEAN($Column_Visible_ao; 0)
	
	ARRAY POINTER($Column_Var_ap; 0)
	ARRAY POINTER($Header_Var_ap; 0)
	ARRAY POINTER($Style_ap; 0)
	//LISTBOX GET ARRAYS({*;}object;arrColNames;arrHeaderNames;arrColVars;arrHeaderVars;arrColsVisible;arrStyles{;arrFooterNames;arrFooterVars})
	// Get the List information. This will require twice the memory as it makes a copy of the list data
	LISTBOX GET ARRAYS(*; "LB_QueryOutput"; $Col_Name_at; $Hdr_Name_at; $Column_Var_ap; $Header_Var_ap; $Column_Visible_ao; $Style_ap)
	ARRAY TEXT($Hdr_Name_at; 0)
	
	ARRAY BOOLEAN($Column_Visible_ao; 0)
	ARRAY POINTER($Header_Var_ap; 0)
	ARRAY POINTER($Style_ap; 0)
	
	$Columns_l:=Size of array($Column_Var_ap)
End if 

$Rows_l:=LISTBOX Get number of rows(*; "LB_QueryOutput")  //Get row count

If ($UserEntry_t="")  // If filter is empty
	ARRAY BOOLEAN(aoHiddenRow2; 0)
	ARRAY BOOLEAN(aoHiddenRow2; $Rows_l)  // Set all rows visible
	
Else   // Filter rows
	If (OBJECT Get value("SQL_Filter_cb_l")=1)  // If Filter is checked
		For ($Row_l; 1; $Rows_l)
			aoHiddenRow2{$Row_l}:=True  // First hide all rows
		End for 
		
	Else   // Unchecked, so we are not filtering, just highlighting
		For ($Row_l; 1; $Rows_l)
			aoHiddenRow2{$Row_l}:=False  // First hide all rows
		End for 
	End if 
	
	For ($Column_l; 1; $Columns_l)
		$Column_Type_l:=Type($Column_Var_ap{$Column_l}->{1})  // Get the type of the first element in the column
		$Row_l:=0
		
		Case of 
			: (($Column_Type_l=Is alpha field) | ($Column_Type_l=Is text))
				
				While ($Row_l>-1)
					$Row_l:=Find in array($Column_Var_ap{$Column_l}->; "@"+$UserEntry_t+"@"; $Row_l+1)
					
					If ($Row_l>-1)
						aoHiddenRow2{$Row_l}:=False
						LISTBOX SET ROW COLOR(*; $Col_Name_at{$Column_l}; $Row_l; 0x00FACFD0; lk background color)
					End if 
					
				End while 
				
			: (($Column_Type_l=Is real) | ($Column_Type_l=Is integer) | ($Column_Type_l=Is longint))
				If (Match regex("(?mi-s)[0-9]+"; $UserEntry_t; 1))
					While ($Row_l>-1)
						$Row_l:=Find in array($Column_Var_ap{$Column_l}->; Num($UserEntry_t); $Row_l+1)
						
						If ($Row_l>-1)
							aoHiddenRow2{$Row_l}:=False
							LISTBOX SET ROW COLOR(*; $Col_Name_at{$Column_l}; $Row_l; 0x00FACFD0; lk background color)
						End if 
						
					End while 
				End if 
				
			: ($Column_Type_l=Is date)
				$Date_d:=Date($UserEntry_t)
				If ($Date_d#!00-00-00!)
					While ($Row_l>-1)
						$Row_l:=Find in array($Column_Var_ap{$Column_l}->; $Date_d; $Row_l+1)
						
						If ($Row_l>-1)
							aoHiddenRow2{$Row_l}:=False
							LISTBOX SET ROW COLOR(*; $Col_Name_at{$Column_l}; $Row_l; 0x00FACFD0; lk background color)
						End if 
						
					End while 
					
				End if 
				
			: ($Column_Type_l=Is time)
				
			: ($Column_Type_l=Is integer 64 bits)  // Special case for INT64
				ARRAY LONGINT($Temp_al; 0)
				$Indexes_l:=Size of array($Column_Var_ap{$Column_l}->)
				For ($Index_l; 1; $Indexes_l)
					APPEND TO ARRAY($Temp_al; $Column_Var_ap{$Column_l}->{$Index_l}+0)  // Force int64 to int32
				End for 
				
				If (Match regex("(?mi-s)[0-9]+"; $UserEntry_t; 1))
					While ($Row_l>-1)
						$Row_l:=Find in array($Temp_al; Num($UserEntry_t); $Row_l+1)
						
						If ($Row_l>-1)
							aoHiddenRow2{$Row_l}:=False
							LISTBOX SET ROW COLOR(*; $Col_Name_at{$Column_l}; $Row_l; 0x00FACFD0; lk background color)
						End if 
						
					End while 
				End if 
				
				ARRAY LONGINT($Temp_al; 0)
				
			: ($Column_Type_l=Is boolean)
				//If (Match regex("(?mi-s)\\btrue\\b|\\bfalse\\b";$UserEntry_t;1))
				Case of 
					: ($UserEntry_t="True")
						While ($Row_l>-1)
							$Row_l:=Find in array($Column_Var_ap{$Column_l}->; True; $Row_l+1)
							
							If ($Row_l>-1)
								aoHiddenRow2{$Row_l}:=False
								LISTBOX SET ROW COLOR(*; $Col_Name_at{$Column_l}; $Row_l; 0x00FACFD0; lk background color)
							End if 
							
						End while 
					: ($UserEntry_t="False")
						While ($Row_l>-1)
							$Row_l:=Find in array($Column_Var_ap{$Column_l}->; False; $Row_l+1)
							
							If ($Row_l>-1)
								aoHiddenRow2{$Row_l}:=False
								LISTBOX SET ROW COLOR(*; $Col_Name_at{$Column_l}; $Row_l; 0x00FACFD0; lk background color)
							End if 
							
						End while 
						
					Else 
						// Do nothing
				End case 
				
				
			: ($Column_Type_l=Is picture)
				// Skip this column
				
			: ($Column_Type_l=Is subtable)
				// Skip this column
				
			: ($Column_Type_l=Is BLOB)
				// Skip this column
				
			Else 
				TRACE
		End case 
		
	End for 
	
End if 

If ($UserEntry_t="")  // If filter is empty
	// Do nothing
	
Else 
	//queryExtraInfo_t:=set_queryExtraInfo("LB_QueryOutput"; form.End_Time_ms_l-form.Start_Time_ms_l)
	OBJECT SET VALUE("QueryExtraInfo_t"; set_queryExtraInfo)
	progBar_Close
End if 
