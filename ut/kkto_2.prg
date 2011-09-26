#include "admin.ch"


// da li je pokrenut samo test...
static __only_test


// ----------------------------------------------------
// zamjena podataka kontnog plana
// ----------------------------------------------------
function KKonto2()
local cFmkSif := "N"
local cFinKum := "N"
local cFinPriv := "N"
local cKalkKum := "N"
local cFaktKum := "N"
local cOsKum := "N"
local cEPDVKum := "N"
local cOnlyTest := "D"
local aTmp := {}
local cTblName := ""
local cLabel := "K"
// label = K - konto

// prijavi poruku, info, arhiva
msg_info()

MsgBeep("Prije nego zapocnete ovu operaciju DOBRO provjerite #"+;
        "da li su parovi stari - novi konto ispravni !")

if Pitanje(,"Jeste li sigurni da zelite izvrsiti promjene ?","N")=="N"
	closeret
endif

// setuj sta trebas konvertovati
if _get_vars( @cOnlyTest, @cFmkSif, @cFinKum, @cFinPriv, @cKalkKum, ;
	@cOsKum, @cEPDVKum ) == 0
	
	// prekinuta opcija... izadji
	return
endif

__only_test := .f.

if cOnlyTest == "D"
	__only_test := .t.
endif

// kreiraj arhivu za svaki slucaj....
// ako nije test
_cre_arhive( __only_test )

// izvrsi konverzije
O_KKONTO

if __only_test == .t.
	START PRINT CRET
endif


// SIFRARNICI
if cFmkSif == "D"
	
	aTmp := {}
	AADD( aTmp, { "ID", "C", 7, 0 })
	cTblName := "KONTO.DBF"
	cType := "D"
	cIdField := "ID"
	cNazField := "NAZ"
	cTbl2 := "KKONTO"
	
	_kv_in_sif( __only_test, cLabel, aTmp, SIFPATH, ;
			cTblName, cTbl2, cType, cNazField, , cIdField )
	
	
endif

// modul FIN
if cFinKum == "D"
	
	aTmp := {}
	AADD( aTmp, { "IDKONTO", "C", 7, 0 })
	
	cTblName := "SUBAN.DBF"
	_kv_in_kum( __only_test, cLabel, aTmp, gFinKum, cTblName )

	cTblName := "ANAL.DBF"
	_kv_in_kum( __only_test, cLabel, aTmp, gFinKum, cTblName )

	cTblName := "SINT.DBF"
	_kv_in_kum( __only_test, cLabel, aTmp, gFinKum, cTblName )

endif

// FIN PRIV.PATH
if cFinPriv == "D"
	
	aTmp := {}
	AADD( aTmp, { "IDKONTO", "C", 7, 0 })
	
	cTblName := "PRIPR.DBF"
	_kv_in_kum( __only_test, cLabel, aTmp, gFinPri, cTblName )

endif

// modul KALK
if cKalkKum == "D"
	
	aTmp := {}
	AADD( aTmp, { "IDKONTO", "C", 7, 0 })
	AADD( aTmp, { "IDKONTO2", "C", 7, 0 })
	AADD( aTmp, { "MKONTO", "C", 7, 0 })
	AADD( aTmp, { "PKONTO", "C", 7, 0 })
	
	cTblName := "KALK.DBF"
	_kv_in_kum( __only_test, cLabel, aTmp, gKalkKum, cTblName )

	aTmp := {}
	AADD( aTmp, { "MKONTO", "C", 7, 0 })
	AADD( aTmp, { "PKONTO", "C", 7, 0 })
	
	cTblName := "DOKS.DBF"
	_kv_in_kum( __only_test, cLabel, aTmp, gKalkKum, cTblName )
	
	aTmp := {}
	AADD( aTmp, { "IDKONTO", "C", 7, 0 })
	
	cTblName := "TRFP.DBF"
	_kv_in_kum( __only_test, cLabel, aTmp, SIFPATH, cTblName )

	cTblName := "TRFP2.DBF"
	_kv_in_kum( __only_test, cLabel, aTmp, SIFPATH, cTblName )

	cTblName := "TRFP3.DBF"
	_kv_in_kum( __only_test, cLabel, aTmp, SIFPATH, cTblName )

endif

// modul OS
if cOSKum == "D"
	
	aTmp := {}
	AADD( aTmp, { "IDKONTO", "C", 7, 0 })
	
	cTblName := "OS.DBF"
	_kv_in_kum( __only_test, cLabel, aTmp, gOSKum, cTblName )

endif


// modul ePDV
if cEPDVKum == "D"
	
	aTmp := {}
	AADD( aTmp, { "ID_KTO", "C", 10, 0 })
	
	cTblName := "SG_KIF.DBF"
	_kv_in_kum( __only_test, cLabel, aTmp, gEPDVKum, cTblName )

	cTblName := "SG_KUF.DBF"
	_kv_in_kum( __only_test, cLabel, aTmp, gEPDVKum, cTblName )

endif

if __only_test == .t.

	END PRINT
	
endif


if __only_test == .f.
	
	msgbeep("Sada provjerite da li su konverzije uspjele.#"+;
        	"Ako nisu NEMOJTE PONOVO POKRETATI KONVERZIJE##"+;
        	"U tom slucaju zovite bring.out servis !!!")
	
endif

close all
return


// ---------------------------------------------------
// vrati setovane uslove za konverziju...
// ---------------------------------------------------
static function _get_vars( cOnlyTest, cFmkSif, cFinKum, cFinPriv, cKalkKum, ;
			cOsKum, cEPDVKum )
local nX := 1			
local nBoxX := 20
local nBoxY := 65
local nOpcLeft := 35
private GetList:={}

Box(, nBoxX, nBoxY)

	@ m_x + nX, m_y + 2 SAY "*** Uslovi za konverziju polja konto:"

	nX += 2

	@ m_x + nX, m_y + 2 SAY PADL("Konvertovati sifrarnik (FMK):", nOpcLeft) GET cFmkSif PICT "@!" VALID cFmkSif  $ "DN"
	
	nX += 2
	
	@ m_x + nX, m_y + 2 SAY PADL("Konvertovati kumulativ (FIN):", nOpcLeft) GET cFinKum PICT "@!" VALID cFinKum  $ "DN"
  
  	nX += 1
	
	@ m_x + nX, m_y + 2 SAY PADL("Konvertovati pripremu (FIN):", nOpcLeft) GET cFinPriv PICT "@!" VALID cFinPriv  $ "DN"
  
	nX += 2
	
	@ m_x + nX, m_y + 2 SAY PADL("Konvertovati kumulativ (KALK):", nOpcLeft) GET cKalkKum PICT "@!" VALID cKalkKum  $ "DN"
  
  	nX += 1
	
	@ m_x + nX, m_y + 2 SAY PADL("Konvertovati kumulativ (OS):", nOpcLeft) GET cOsKum PICT "@!" VALID cOsKum  $ "DN"
  
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


