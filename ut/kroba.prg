#include "admin.ch"


static __only_test

// -----------------------------------------------
// konverzija polja u tabeli robe
// -----------------------------------------------
function kroba()
local cOnlyTest := "D"
local cFmkSif := "N"
local cKalkKum := "N"
local cKalkPriv := "N"
local cFaktKum := "N"
local cFaktPriv := "N"
local cLabel := "R"
// label R - roba
local cTblName := ""
local cTbl2 := ""
local cType := ""
local cNazField := ""
local cIdField := ""

msg_info()

msgbeep("Prije nego zapocnete ovu operaciju DOBRO provjerite #"+;
        "da li su parovi stara - nova sifra ispravni !")

if Pitanje(,"Jeste li sigurni da zelite izvrsiti promjene ?","N")=="N"
	close all
	return
endif

// uzmi varijable
if _get_vars( @cOnlyTest, @cFmkSif, @cKalkKum, @cKalkPriv, ;
		@cFaktKum, @cFaktPriv ) == 0
	
	close all
	return
endif

__only_test := .f.

if cOnlyTest == "D"
	__only_test := .t.
endif

// arhiva za svaki slucaj....
_cre_arhive( __only_test )

O_KROBA

if cFmkSif == "D"

	aTmp := {}
	AADD(aTmp, { "ID", "C", 10, 0 })
	cTblName := "ROBA.DBF"
	cTbl2 := "KROBA"
	cIdField := "ID"
	cNazField := "NAZ"
	
	_kv_in_sif( __only_test, cLabel, aTmp, SIFPATH, ;
			cTblName, cTbl2, nil, cNazField, cIdField )

endif


if cKalkKum == "D"
	
	aTmp := {}
	AADD(aTmp, { "IDROBA", "C", 10, 0 })
	cTblName := "KALK.DBF"
	cTbl2 := "KROBA"
	
	_kv_in_kum( __only_test, cLabel, aTmp, gKalkKum, cTblName, cTbl2 )

endif

if cKalkPriv == "D"
	
	aTmp := {}
	AADD(aTmp, { "IDROBA", "C", 10, 0 })
	cTblName := "PRIPR.DBF"
	cTbl2 := "KROBA"
	
	_kv_in_kum( __only_test, cLabel, aTmp, gKalkPriv, cTblName, cTbl2 )

endif

if cFaktKum == "D"
	
	aTmp := {}
	AADD(aTmp, { "IDROBA", "C", 10, 0 })
	cTblName := "FAKT.DBF"
	cTbl2 := "KROBA"
	
	_kv_in_kum( __only_test, cLabel, aTmp, gFaktKum, cTblName, cTbl2 )

	cTblName := "RUGOV.DBF"
	
	_kv_in_kum( __only_test, cLabel, aTmp, gFaktKum, cTblName, cTbl2 )

endif

if cFaktPriv == "D"
	
	aTmp := {}
	AADD(aTmp, { "IDROBA", "C", 10, 0 })
	cTblName := "PRIPR.DBF"
	cTbl2 := "KROBA"
	
	_kv_in_kum( __only_test, cLabel, aTmp, gFaktPriv, cTblName, cTbl2 )

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
static function _get_vars( cOnlyTest, cFmkSif, cKalkKum, cKalkPriv, ;
			cFaktKum, cFaktPriv )
local nX := 1			
local nBoxX := 20
local nBoxY := 65
local nOpcLeft := 35
private GetList:={}

Box(, nBoxX, nBoxY)

	@ m_x + nX, m_y + 2 SAY "*** Uslovi za konverziju polja idroba:"

	nX += 2

	@ m_x + nX, m_y + 2 SAY PADL("Konvertovati sifrarnik (FMK):", nOpcLeft) GET cFmkSif PICT "@!" VALID cFmkSif  $ "DN"
	
	nX += 1
	
	@ m_x + nX, m_y + 2 SAY PADL("Konvertovati kumulativ (KALK):", nOpcLeft) GET cKalkKum PICT "@!" VALID cKalkKum  $ "DN"
  
  	nX += 1
	
	@ m_x + nX, m_y + 2 SAY PADL("Konvertovati privatne dir. (KALK):", nOpcLeft) GET cKalkPriv PICT "@!" VALID cKalkPriv  $ "DN"
  
  	nX += 1
	
	@ m_x + nX, m_y + 2 SAY PADL("Konvertovati kumulativ (FAKT):", nOpcLeft) GET cFaktKum PICT "@!" VALID cFaktKum  $ "DN"
  
  	nX += 1
	
	@ m_x + nX, m_y + 2 SAY PADL("Konvertovati privatne dir. (FAKT):", nOpcLeft) GET cFaktPriv PICT "@!" VALID cFaktPriv  $ "DN"
  
  	nX += 3
 
	@ m_x + nX, m_y + 2 SAY "Izvrsiti samo provjere ?" GET cOnlyTest PICT "@!" VALID cOnlyTest $ "DN"
  
  	read

BoxC()

if LastKey() == K_ESC
	return 0
endif

return 1


