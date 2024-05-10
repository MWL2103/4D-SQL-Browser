//%attributes = {"invisible":true}
/* Method: List_Export
      
  Purpose: Exports listbox data to comma or tab delimited file.
      
  Parameters: 
    $1 - {text} File delimiter (comma or tab)

  Created: 06/25/2022 - MWL
  Version: 1.0 - 06/25/2022 - MWL
      
  Property: Invisible
      
  Risk Assessment:
     LOW - Simple code.
      
  NOTES: None.
  ----------------------------------------------------*/

#DECLARE($Delim_t : Text)

var $Column_l; $Columns_l; $Comma_Pos_l; $CR_Pos_l; $DblQt_Pos_l; $Row_l : Integer
var $Rows_l; $Value_Type_l : Integer
var $Column_Name_t; $CR_t; $DblQ_t; $Delim_t; $Doc_Path_t; $File_Name_t : Text
var $File_Path_t; $Header_Name_t; $Line_Endings_t; $Temp_t; $Text_To_File_t : Text
var $Ref_h : Time

If (Is macOS)
	$Line_Endings_t:="\n"
	
Else 
	$Line_Endings_t:="\r\n"
End if 

$DblQ_t:=Char(Double quote)
$CR_t:=Char(Carriage return)

ARRAY TEXT($Column_Name_at; 0)
ARRAY TEXT($Header_Name_at; 0)

ARRAY BOOLEAN($Column_Visible_ab; 0)

ARRAY POINTER($Column_Var_ap; 0)
ARRAY POINTER($Header_Var_ap; 0)
ARRAY POINTER($Column_Style_ap; 0)

// Get the List information. This will require twice the memory as it makes a copy of the list data
LISTBOX GET ARRAYS(*; "LB_QueryOutput"; $Column_Name_at; $Header_Name_at; $Column_Var_ap; $Header_Var_ap; $Column_Visible_ab; $Column_Style_ap)

//$File_Path_t:=Get 4D folder(Current resources folder)
//$File_Name_t:="4D_Temp_"+String(Tickcount)+".txt"

If ($Delim_t=",")
	//$Ref_h:=Create document($Doc_Path_t; "csv")
	$Ref_h:=Create document(""; "csv")
	
Else 
	$Ref_h:=Create document(""; "txt")
End if 

If (OK=1)
	$Text_To_File_t:=""
	
	// Build the header row
	$Columns_l:=Count in array($Column_Visible_ab; True)
	For ($Column_l; 1; $Columns_l)
		$Header_Name_t:=$Header_Name_at{$Column_l}
		$Column_Name_t:=OBJECT Get title(*; $Header_Name_t)
		$Text_To_File_t:=$Text_To_File_t+$Column_Name_t+$Delim_t
	End for 
	
	If (Substring($Text_To_File_t; 1; 2)="ID")
		// A SYLK file is a text file that begins with "ID" or "ID_xxxx", where xxxx
		// is a text string. The first record of a SYLK file is the ID_Number
		// record. When Excel identifies this text at the beginning of a text file,
		// it interprets the file as a SYLK file. Excel tries to convert the file
		// from the SYLK format, but cannot do so because there are no valid SYLK
		// codes after the "ID" characters. Because Excel cannot convert the file,
		// you receive the error message.
		$Text_To_File_t:="'"+$Text_To_File_t
	End if 
	
	$Text_To_File_t:=Substring($Text_To_File_t; 1; Length($Text_To_File_t)-1)
	$Text_To_File_t:=$Text_To_File_t+$Line_Endings_t
	SEND PACKET($Ref_h; $Text_To_File_t)
	$Text_To_File_t:=""
	
	$Rows_l:=LISTBOX Get number of rows(*; "LB_QueryOutput")  //Get row count
	If ($Rows_l>1000)
		ProgBar_Open("Exporting data...")
	Else 
		
	End if 
	
	// Build the detail row(s)
	For ($Row_l; 1; $Rows_l)
		For ($Column_l; 1; $Columns_l)
			$Value_Type_l:=Type($Column_Var_ap{$Column_l}->{$Row_l})
			
			Case of 
				: (($Value_Type_l=Is alpha field) | ($Value_Type_l=Is text))
					$DblQt_Pos_l:=Position($DblQ_t; $Column_Var_ap{$Column_l}->{$Row_l})
					$Comma_Pos_l:=Position(Char(44); $Column_Var_ap{$Column_l}->{$Row_l})
					$CR_Pos_l:=Position($CR_t; $Column_Var_ap{$Column_l}->{$Row_l})
					Case of 
						: ($DblQt_Pos_l>0)
							$Temp_t:=Replace string($Column_Var_ap{$Column_l}->{$Row_l}; $DblQ_t; $DblQ_t+$DblQ_t)
							$Text_To_File_t:=$Text_To_File_t+$DblQ_t+$Temp_t+$DblQ_t+$Delim_t
							
						: ($Comma_Pos_l>0) | ($CR_Pos_l>0)
							$Text_To_File_t:=$Text_To_File_t+$DblQ_t+$Column_Var_ap{$Column_l}->{$Row_l}+$DblQ_t+$Delim_t
							
						Else 
							$Text_To_File_t:=$Text_To_File_t+$Column_Var_ap{$Column_l}->{$Row_l}+$Delim_t
							
					End case 
					
				: (($Value_Type_l=Is real) | ($Value_Type_l=Is integer) | ($Value_Type_l=Is longint) | ($Value_Type_l=Is integer 64 bits))
					$Text_To_File_t:=$Text_To_File_t+String($Column_Var_ap{$Column_l}->{$Row_l})+$Delim_t
					
				: ($Value_Type_l=Is date)
					$Text_To_File_t:=$Text_To_File_t+String($Column_Var_ap{$Column_l}->{$Row_l}; System date short)+$Delim_t
					
				: ($Value_Type_l=Is time)
					$Text_To_File_t:=$Text_To_File_t+String($Column_Var_ap{$Column_l}->{$Row_l}; HH MM SS)+$Delim_t
					
				: ($Value_Type_l=Is boolean)
					$Text_To_File_t:=$Text_To_File_t+String(Num($Column_Var_ap{$Column_l}->{$Row_l}); "True;ERROR;False")+$Delim_t
					
				: ($Value_Type_l=Is picture)
					$Text_To_File_t:=$Text_To_File_t+$Delim_t
					
				: ($Value_Type_l=Is subtable)
					$Text_To_File_t:=$Text_To_File_t+$Delim_t
					
				: ($Value_Type_l=Is BLOB)
					$Text_To_File_t:=$Text_To_File_t+$Delim_t
					
				Else 
					TRACE
			End case 
			
		End for 
		$Text_To_File_t:=Substring($Text_To_File_t; 1; Length($Text_To_File_t)-1)
		$Text_To_File_t:=$Text_To_File_t+$Line_Endings_t
		SEND PACKET($Ref_h; $Text_To_File_t)
		$Text_To_File_t:=""
	End for 
	
	CLOSE DOCUMENT($Ref_h)
	// Document
	If ($Rows_l>1000)
		ProgBar2_Close
		
	Else 
		
	End if 
	
Else   // User cancelled
	// Do nothing
End if 