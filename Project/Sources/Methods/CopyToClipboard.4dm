//%attributes = {"invisible":true}
/* Method: CopyToClipboard
      
  Purpose: xxXxx
      
  Parameters: None

  Created: 06/25/2022 - MWL
  Version: 1.0 - 06/25/2022 - MWL
      
  Property: Invisible
      
  Risk Assessment:
     LOW - Simple code.
      
  NOTES: None.
  ----------------------------------------------------*/

var $Column_l; $Columns_l; $Comma_Pos_l; $CR_Pos_l; $DblQt_Pos_l; $Row_l : Integer
var $Rows_l; $Type_l : Integer
var $Column_Name_t; $CR_t; $DblQ_t; $Delim_t; $File_Name_t; $File_Path_t : Text
var $Header_Name_t; $LineEndings_t; $Temp_t; $Text_t : Text
var $File_Ref_h : Time

If (Is macOS)  // If Mac OS X
	$LineEndings_t:="\n"
	
Else   // Windows OS
	$LineEndings_t:="\r\n"
End if 

$Delim_t:=Char(Tab)
$DblQ_t:=Char(Double quote)
$CR_t:=Char(Carriage return)

ARRAY TEXT($ColName_at; 0)
ARRAY TEXT($HeaderName_at; 0)

ARRAY BOOLEAN($ColsVisible_ab; 0)

ARRAY POINTER($ColVars_ap; 0)
ARRAY POINTER($HeaderVars_ap; 0)
ARRAY POINTER($Styles_ap; 0)

// Get the List information. This will require twice the memory as it makes a copy of the list data
LISTBOX GET ARRAYS(*; "LB_QueryOutput"; $ColName_at; $HeaderName_at; $ColVars_ap; $HeaderVars_ap; $ColsVisible_ab; $Styles_ap)

$File_Path_t:=Temporary folder+"4D_Temp_"+String(Tickcount)+".txt"
$File_Path_t:=Get 4D folder(Current resources folder)
$File_Name_t:="4D_Temp_"+String(Tickcount)+".txt"
//If (OK=1)
$Text_t:=""

// Build the header row
$Columns_l:=Count in array($ColsVisible_ab; True)
For ($Column_l; 1; $Columns_l)
	$Header_Name_t:=$HeaderName_at{$Column_l}
	$Column_Name_t:=OBJECT Get title(*; $HeaderName_at{$Column_l})
	$Text_t:=$Text_t+$Column_Name_t+$Delim_t
End for 

If (Substring($Text_t; 1; 2)="ID")
	// A SYLK file is a text file that begins with "ID" or "ID_xxxx", where xxxx
	// is a text string. The first record of a SYLK file is the ID_Number
	// record. When Excel identifies this text at the beginning of a text file,
	// it interprets the file as a SYLK file. Excel tries to convert the file
	// from the SYLK format, but cannot do so because there are no valid SYLK
	// codes after the "ID" characters. Because Excel cannot convert the file,
	// you receive the error message.
	$Text_t:="'"+$Text_t
End if 

$Text_t:=Substring($Text_t; 1; Length($Text_t)-1)
$Text_t:=$Text_t+$LineEndings_t
$File_Ref_h:=Create document($File_Path_t+$File_Name_t; "*")

If (OK=1)  // Document created
	SEND PACKET($File_Ref_h; $Text_t)
	$Text_t:=""
	
	$Rows_l:=LISTBOX Get number of rows(*; "LB_QueryOutput")  //Get row count
	
	If ($Rows_l>1000)
		ProgBar_Open("Exporting data to Clipboard...")
	End if 
	
	// Build the detail row(s)
	For ($Row_l; 1; $Rows_l)
		For ($Column_l; 1; $Columns_l)
			$Type_l:=Type($ColVars_ap{$Column_l}->{$Row_l})
			
			Case of 
				: (aoHiddenRow2{$Row_l})  // If true, this row is hidden
					// Do nothing
					
				: (($Type_l=Is alpha field) | ($Type_l=Is text))
					$DblQt_Pos_l:=Position($DblQ_t; $ColVars_ap{$Column_l}->{$Row_l})
					$Comma_Pos_l:=Position(Char(44); $ColVars_ap{$Column_l}->{$Row_l})
					$CR_Pos_l:=Position($CR_t; $ColVars_ap{$Column_l}->{$Row_l})
					Case of 
						: ($DblQt_Pos_l>0)
							$Temp_t:=Replace string($ColVars_ap{$Column_l}->{$Row_l}; $DblQ_t; $DblQ_t+$DblQ_t)
							$Text_t:=$Text_t+$DblQ_t+$Temp_t+$DblQ_t+$Delim_t
							
						: ($Comma_Pos_l>0) | ($CR_Pos_l>0)
							$Text_t:=$Text_t+$DblQ_t+$ColVars_ap{$Column_l}->{$Row_l}+$DblQ_t+$Delim_t
							
						Else 
							$Text_t:=$Text_t+$ColVars_ap{$Column_l}->{$Row_l}+$Delim_t
							
					End case 
					
				: (($Type_l=Is real) | ($Type_l=Is integer) | ($Type_l=Is longint))
					$Text_t:=$Text_t+String($ColVars_ap{$Column_l}->{$Row_l})+$Delim_t
					
				: ($Type_l=Is integer 64 bits)
					$Text_t:=$Text_t+String($ColVars_ap{$Column_l}->{$Row_l}+0)+$Delim_t  // Force int64 to int32
					
				: ($Type_l=Is date)
					$Text_t:=$Text_t+String($ColVars_ap{$Column_l}->{$Row_l}; Internal date short)+$Delim_t
					
				: ($Type_l=Is time)
					$Text_t:=$Text_t+String($ColVars_ap{$Column_l}->{$Row_l}; HH MM SS)+$Delim_t
					
				: ($Type_l=Is boolean)
					$Text_t:=$Text_t+Choose($ColVars_ap{$Column_l}->{$Row_l}; "True"; "False")+$Delim_t
					
				: ($Type_l=Is picture)
					$Text_t:=$Text_t+"PICT: "+String(Picture size($ColVars_ap{$Column_l}->{$Row_l}); "###,###,###,###,##0")+" bytes"+$Delim_t
					
				: ($Type_l=Is subtable)
					$Text_t:=$Text_t+$Delim_t
					
				: ($Type_l=Is BLOB)
					$Text_t:=$Text_t+"BLOB: "+String(BLOB size($ColVars_ap{$Column_l}->{$Row_l}); "###,###,###,###,##0")+" bytes"+$Delim_t
					
				Else 
					TRACE
			End case 
			
		End for 
		
		If ($Text_t#"")  // Row was NOT hidden
			$Text_t:=Substring($Text_t; 1; Length($Text_t)-1)
			$Text_t:=$Text_t+$LineEndings_t
			SEND PACKET($File_Ref_h; $Text_t)
			
			$Text_t:=""  // Clear last row data
		End if 
		
	End for 
	
	CLOSE DOCUMENT($File_Ref_h)
	
	SET TEXT TO PASTEBOARD(Document to text($File_Path_t+$File_Name_t))
	DELETE DOCUMENT($File_Path_t+$File_Name_t)
	
	If ($Rows_l>1000)
		progBar_Close
	End if 
	
Else 
	ALERT("File I/O error prevented 'Copy to Clipboard' from working."; "Okay")
End if 
