/* 
 * This file is part of the bring.out FMK, a free and open source 
 * accounting software suite,
 * Copyright (c) 1996-2011 by bring.out doo Sarajevo.
 * It is licensed to you under the Common Public Attribution License
 * version 1.0, the full text of which (including FMK specific Exhibits)
 * is available in the file LICENSE_CPAL_bring.out_FMK.md located at the 
 * root directory of this source code archive.
 * By using this software, you agree to be bound by its terms.
 */


#include "admin.ch"


static __only_test

// ------------------------------------------------
// zamjena sifrarnika partnera
// ------------------------------------------------
function kpartn()
local cOnlyTest := "D"
local cFmkSif := "N"
local cKalkKum := "N"
local cFinKum := "N"
local cFaktKum := "N"
local cEPDVKum := "N"
local aTmp := {}
local cLabel := "R"

msg_info()

msgbeep("Prije nego zapocnete ovu operaciju DOBRO provjerite #"+;
        "da li su parovi stara - nova sifra ispravni !")

if Pitanje(, "Jeste li sigurni da zelite izvrsiti promjene ?", "N" ) == "N"
	
	close all
	return
	
endif

// uzmi podesenja....
if _get_vars( @cOnlyTest, @cFmkSif, @cFinKum, @cKalkKum, @cFaktKum, ;
		@cEPDVKum ) == 0

	close all
	return
	
endif

__only_test := .f.

if cOnlyTest == "D"
	__only_test := .t.
endif


// kreiraj arhivu
_cre_arhive( __only_test )

O_KPARTN

if __only_test == .t.
	START PRINT CRET
endif

if cFmkSif == "D"
	
	aTmp := {}
	AADD(aTmp, { "ID", "C", 6, 0 })
	cIdField := "ID"
	cNazField := "NAZ"
	cTblName := "PARTN.DBF"
	cTbl2 := "KPARTN"
	
	_kv_in_sif( __only_test, cLabel, aTmp, SIFPATH, cTblName, cTbl2, ;
		nil, cNazField, cIdField )
  
endif

if cKalkKum == "D"

	aTmp := {}
	AADD(aTmp, { "IDPARTNER", "C", 6, 0 })
	AADD(aTmp, { "IDZADUZ", "C", 6, 0 })
	AADD(aTmp, { "IDZADUZ2", "C", 6, 0 })
	
	cTbl2 := "KPARTN"
	cTblName := "KALK.DBF"

	_kv_in_kum( __only_test, cLabel, aTmp, gKalkKum, ;
		cTblName, cTbl2 )
		
  	cTblName := "DOKS.DBF"
	
	_kv_in_kum( __only_test, cLabel, aTmp, gKalkKum, ;
		cTblName, cTbl2 )

	cTblName := "PRIPR.DBF"
	
	_kv_in_kum( __only_test, cLabel, aTmp, gKalkPri, ;
		cTblName, cTbl2 )

endif

if cFinKum == "D"

	aTmp := {}
	AADD(aTmp, { "IDPARTNER", "C", 6, 0 })
	
	cTblName := "SUBAN.DBF"
	cTbl2 := "KPARTN"

	_kv_in_kum( __only_test, cLabel, aTmp, gFinKum, ;
		cTblName, cTbl2 )

	cTblName := "PRIPR.DBF"
	
	_kv_in_kum( __only_test, cLabel, aTmp, gFinPriv, ;
		cTblName, cTbl2 )

	cTblName := "IOS.DBF"
	
	_kv_in_kum( __only_test, cLabel, aTmp, gFinPriv, ;
		cTblName, cTbl2 )

	cTblName := "PSUBAN.DBF"
	
	_kv_in_kum( __only_test, cLabel, aTmp, gFinPriv, ;
		cTblName, cTbl2 )

endif

if cKalkKum == "D"

	aTmp := {}
	AADD(aTmp, { "IDPARTNER", "C", 6, 0 })
	
	cTbl2 := "KPARTN"
	cTblName := "FAKT.DBF"

	_kv_in_kum( __only_test, cLabel, aTmp, gFaktKum, ;
		cTblName, cTbl2 )
		
  	cTblName := "UGOV.DBF"
	
	_kv_in_kum( __only_test, cLabel, aTmp, gFaktKum, ;
		cTblName, cTbl2 )

	cTblName := "DOKS.DBF"
	
	_kv_in_kum( __only_test, cLabel, aTmp, gFaktKum, ;
		cTblName, cTbl2 )

	cTblName := "PRIPR.DBF"
	
	_kv_in_kum( __only_test, cLabel, aTmp, gFaktPri, ;
		cTblName, cTbl2 )

	cTblName := "_FAKT.DBF"
	
	_kv_in_kum( __only_test, cLabel, aTmp, gFaktPri, ;
		cTblName, cTbl2 )

endif

if __only_test == .t.
	END PRINT
endif

if __only_test == .f.

	msgbeep("Sada provjerite da li su konverzije uspjele.#"+;
        "Ako nisu NEMOJTE PONOVO POKRETATI KONVERZIJE##"+;
        "U tom slucaju Zovite SIGMA-COM SERVIS!!!")
	
endif

close all
return



// ---------------------------------------------------
// vrati setovane uslove za konverziju...
// ---------------------------------------------------
static function _get_vars( cOnlyTest, cFmkSif, cFinKum, cKalkKum, ;
			cFaktKum, cEPDVKum )
local nX := 1			
local nBoxX := 20
local nBoxY := 65
local nOpcLeft := 35
private GetList:={}

Box(, nBoxX, nBoxY)

	@ m_x + nX, m_y + 2 SAY "*** Uslovi za konverziju polja konto:"

	nX += 2

	@ m_x + nX, m_y + 2 SAY PADL("Konvertovati sifrarnik (FMK):", nOpcLeft) GET cFmkSif PICT "@!" VALID cFmkSif  $ "DN"
	
	nX += 1
	
	@ m_x + nX, m_y + 2 SAY PADL("Konvertovati kumulativ (FIN):", nOpcLeft) GET cFinKum PICT "@!" VALID cFinKum  $ "DN"
  
  	nX += 1
	
	@ m_x + nX, m_y + 2 SAY PADL("Konvertovati kumulativ (KALK):", nOpcLeft) GET cKalkKum PICT "@!" VALID cKalkKum  $ "DN"
  
  	nX += 1
	
	@ m_x + nX, m_y + 2 SAY PADL("Konvertovati kumulativ (FAKT):", nOpcLeft) GET cFaktKum PICT "@!" VALID cFaktKum  $ "DN"
  
  	nX += 1
	
	@ m_x + nX, m_y + 2 SAY PADL("Konvertovati kumulativ (ePDV):", nOpcLeft) GET cEPDVKum PICT "@!" VALID cEPDVKum  $ "DN"
  
  	nX += 3
 
	@ m_x + nX, m_y + 2 SAY "Izvrsiti samo provjere ?" GET cOnlyTest PICT "@!" VALID cOnlyTest $ "DN"
  
  	read

BoxC()

if LastKey() == K_ESC
	return 0
endif

return 1




