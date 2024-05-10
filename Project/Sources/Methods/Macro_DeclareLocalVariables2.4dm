//%attributes = {"invisible":true}
/* Method: Macro_DeclareLocalVariables2
      
  Purpose: Used to break long declaration lines into alphabetically sorted short lines.
      
  Parameters: 
    $0 - {text} Wrapped declaration
    $1 - {text} Compiler directive
    $2 - {text} Declaration line

  Created: 06/04/2022 - MWL
  Version: 1.0 - 06/04/2022 - MWL
      
  Property: Invisible
      
  Risk Assessment:
     LOW - Simple code.
      
  NOTES: None.
----------------------------------------------------*/

var $0; $1; $2 : Text

var $Temp_cln : Collection
var $maxLength_l; $Pos_l; $Row_l; $Rows_l : Integer
var $compilerDirective_t; $theData_t; $wrappedText_t : Text

ARRAY TEXT($Variables_at; 0)

// Declaring variables using the var keyword is recommended since
// this syntax allows you to bind object variables with classes

$compilerDirective_t:=$1
$theData_t:=Substring($2; 2)  // strip off leading semicolon

$Temp_cln:=Split string($theData_t; ";"; sk ignore empty strings+sk trim spaces)  // Split string into a collection

$maxLength_l:=70

$theData_t:=""
$wrappedText_t:=""
$Rows_l:=$Temp_cln.length

If ($Rows_l>0)
	For each ($wrappedText_t; $Temp_cln)
		$theData_t:=$theData_t+";"+$wrappedText_t
	End for each 
	
	$theData_t:=Substring($theData_t; 2)  // strip off leading semicolon
	
	Case of   // Could probably improve on this CASE block, but didn't see the need - MWL
		: ($theData_t="")
			$wrappedText_t:=""
			
		: (Length($theData_t)<=$maxLength_l)
			$wrappedText_t:="var "+$theData_t+" : "+$compilerDirective_t+"\r"
			
		Else   // need to wrap lines
			$wrappedText_t:="var "
			
			While (Length($theData_t)>=$maxLength_l)
				// start at max length and look backwards to find a semicolon
				For ($Pos_l; $maxLength_l; $maxLength_l-50; -1)
					If ($theData_t[[$Pos_l]]=";")
						$wrappedText_t:=$wrappedText_t+Substring($theData_t; 1; $Pos_l-1)+" : "+$compilerDirective_t+"\r"
						$wrappedText_t:=$wrappedText_t+"var "
						$theData_t:=Substring($theData_t; $Pos_l+1)
						$Pos_l:=0
					End if 
				End for 
			End while 
			
			$wrappedText_t:=$wrappedText_t+$theData_t+" : "+$compilerDirective_t+"\r"
	End case 
	
Else 
	$wrappedText_t:=""
End if 

$0:=$wrappedText_t
