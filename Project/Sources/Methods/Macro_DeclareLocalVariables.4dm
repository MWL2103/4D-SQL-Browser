//%attributes = {"invisible":true}
/* Method: Macro_DeclareLocalVariables
      
  Purpose: Types method local variables within the selected text
      
  Parameters: None
    $0 - {boolean} 
    $1 - {object} 
    $2 - {text} 
    $3 - {longint} 
    $4 - {real} 
    $5 - {pointer} 

  Created: 06/04/2022 - MWL
  Version: 1.0 - 06/04/2022 - MWL
      
  Property: Invisible
      
  Risk Assessment:
     LOW - Simple code.
      
  NOTES: None.
----------------------------------------------------*/

ON ERR CALL("")

var $Variables_cln : Collection
var $arraySize_l; $Last_l; $Length_l; $Pos_l; $varEnd_l; $varStart_l : Integer
var $arrayDirective_t; $BLOBDirective_t; $booleanDirective_t; $clipboardText_t; $collectionDirective_t : Text
var $dateDirective_t; $longintDirective_t; $objectDirective_t; $pictureDirective_t; $pointerDirective_t : Text
var $realDirective_t; $RegEx_t; $stringVariant_t; $textDirective_t; $theText_t; $timeDirective_t : Text
var $validVariableChars_t; $variableName_t : Text

ARRAY TEXT($localVariableNames_at; 0)

GET MACRO PARAMETER(Highlighted method text; $theText_t)

Case of 
	: (Length($theText_t)=0)  // nothing selected
		BEEP
		
	Else 
		
		$Variables_cln:=New collection
		$Last_l:=1
		$Pos_l:=0
		$Length_l:=0
		$RegEx_t:="(?mi-s)\\B\\$\\w+"
		
		// Parse method text and build array of variable names
		// look for local variable starting with $
		
		While (Match regex($RegEx_t; $theText_t; $Last_l; $Pos_l; $Length_l)=True)
			$Variables_cln.push(Substring($theText_t; $Pos_l; $Length_l))
			$Last_l:=$Pos_l+$Length_l
		End while 
		
		$Variables_cln:=$Variables_cln.distinct(ck diacritical)  // Remove duplicates, and sort
		
		// build compiler directive strings
		$BLOBDirective_t:=""
		$longintDirective_t:=""
		$dateDirective_t:=""
		$timeDirective_t:=""
		$realDirective_t:=""
		$pointerDirective_t:=""
		$booleanDirective_t:=""
		$textDirective_t:=""
		$stringVariant_t:=""
		$pictureDirective_t:=""
		$objectDirective_t:=""
		$collectionDirective_t:=""  // Added 06/15/2018 - MWL
		$arrayDirective_t:=""
		
		For each ($variableName_t; $Variables_cln)
			Case of 
				: ($variableName_t="@_x")
					$BLOBDirective_t:=$BLOBDirective_t+";"+$variableName_t
					
				: ($variableName_t="@_d")
					$dateDirective_t:=$dateDirective_t+";"+$variableName_t
					
				: ($variableName_t="@_h")
					$timeDirective_t:=$timeDirective_t+";"+$variableName_t
					
				: ($variableName_t="@_r")
					$realDirective_t:=$realDirective_t+";"+$variableName_t
					
				: ($variableName_t="@_l")
					$longintDirective_t:=$longintDirective_t+";"+$variableName_t
					
				: ($variableName_t="@_p")
					$pointerDirective_t:=$pointerDirective_t+";"+$variableName_t
					
				: ($variableName_t="@_b")
					$booleanDirective_t:=$booleanDirective_t+";"+$variableName_t
					
				: ($variableName_t="@_t")
					$textDirective_t:=$textDirective_t+";"+$variableName_t
					
				: ($variableName_t="@_v")  // New in 4D v18
					$stringVariant_t:=$stringVariant_t+";"+$variableName_t
					
				: ($variableName_t="@_c")
					$pictureDirective_t:=$pictureDirective_t+";"+$variableName_t
					
				: ($variableName_t="@_o")  // Deprecated
					$objectDirective_t:=$objectDirective_t+";"+$variableName_t
					
				: ($variableName_t="@_ob")  // Added 06/15/2018 - MWL
					$objectDirective_t:=$objectDirective_t+";"+$variableName_t
					
				: ($variableName_t="@_cln")
					$collectionDirective_t:=$collectionDirective_t+";"+$variableName_t  // Added 06/15/2018 - MWL
					//----------------------------------------------------
				: ($variableName_t="@_ax")
					$arrayDirective_t:=$arrayDirective_t+"ARRAY BLOB("+$variableName_t+";0)\r"  // Added 06/15/2018 - MWL
					
				: ($variableName_t="@_ab")
					$arrayDirective_t:=$arrayDirective_t+"ARRAY BOOLEAN("+$variableName_t+";0)\r"
					
				: ($variableName_t="@_ad")
					$arrayDirective_t:=$arrayDirective_t+"ARRAY DATE("+$variableName_t+";0)\r"
					
				: ($variableName_t="@_ai")
					$arrayDirective_t:=$arrayDirective_t+"ARRAY INTEGER("+$variableName_t+";0)\r"
					
				: ($variableName_t="@_al")
					$arrayDirective_t:=$arrayDirective_t+"ARRAY LONGINT("+$variableName_t+";0)\r"
					
				: ($variableName_t="@_ao")  // Deprecated
					$arrayDirective_t:=$arrayDirective_t+"ARRAY OBJECT("+$variableName_t+";0)\r"
					
				: ($variableName_t="@_aob")  // Added 06/15/2018 - MWL
					$arrayDirective_t:=$arrayDirective_t+"ARRAY OBJECT("+$variableName_t+";0)\r"
					
				: ($variableName_t="@_ac")
					$arrayDirective_t:=$arrayDirective_t+"ARRAY PICTURE("+$variableName_t+";0)\r"
					
				: ($variableName_t="@_ap")
					$arrayDirective_t:=$arrayDirective_t+"ARRAY POINTER("+$variableName_t+";0)\r"
					
				: ($variableName_t="@_ar")
					$arrayDirective_t:=$arrayDirective_t+"ARRAY REAL("+$variableName_t+";0)\r"
					
				: ($variableName_t="@_at")
					$arrayDirective_t:=$arrayDirective_t+"ARRAY TEXT("+$variableName_t+";0)\r"
					
				: ($variableName_t="@_ah")
					$arrayDirective_t:=$arrayDirective_t+"ARRAY TIME("+$variableName_t+";0)\r"  // Added 06/15/2018 - MWL
					
				Else   // default no suffix variables to Variant type
					$stringVariant_t:=$stringVariant_t+";"+$variableName_t
			End case 
		End for each 
		
		// build clipboard text
		$clipboardText_t:=""
		$clipboardText_t:=$clipboardText_t+Macro_DeclareLocalVariables2("Blob"; $BLOBDirective_t)
		$clipboardText_t:=$clipboardText_t+Macro_DeclareLocalVariables2("Boolean"; $booleanDirective_t)
		$clipboardText_t:=$clipboardText_t+Macro_DeclareLocalVariables2("Collection"; $collectionDirective_t)
		$clipboardText_t:=$clipboardText_t+Macro_DeclareLocalVariables2("date"; $dateDirective_t)
		$clipboardText_t:=$clipboardText_t+Macro_DeclareLocalVariables2("Integer"; $longintDirective_t)
		$clipboardText_t:=$clipboardText_t+Macro_DeclareLocalVariables2("Object"; $objectDirective_t)
		$clipboardText_t:=$clipboardText_t+Macro_DeclareLocalVariables2("Picture"; $pictureDirective_t)
		$clipboardText_t:=$clipboardText_t+Macro_DeclareLocalVariables2("Pointer"; $pointerDirective_t)
		$clipboardText_t:=$clipboardText_t+Macro_DeclareLocalVariables2("Real"; $realDirective_t)
		$clipboardText_t:=$clipboardText_t+Macro_DeclareLocalVariables2("Text"; $textDirective_t)
		$clipboardText_t:=$clipboardText_t+Macro_DeclareLocalVariables2("Time"; $timeDirective_t)
		$clipboardText_t:=$clipboardText_t+Macro_DeclareLocalVariables2("Variant"; $stringVariant_t)
		
		If ($arrayDirective_t#"")
			$clipboardText_t:=$clipboardText_t+$arrayDirective_t+"\r"
		End if 
		
		// put directive on clipboard
		SET TEXT TO PASTEBOARD($clipboardText_t)
		
		BEEP
End case 
