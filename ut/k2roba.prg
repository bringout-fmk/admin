#include "admin.ch"


static __only_test


// ------------------------------------------------
// konverzija jedinice mjere u robi
// ------------------------------------------------

function K2ROBA()
local aTmp := {}
local cOnlyTest := "D"
local cFmkSif := "N"
local cKalkKum := "N"
local cKalkPriv := "N"
local cFaktKum := "N"
local cFaktPriv := "N"

msg_info()

msgbeep("Prije nego zapocnete ovu operaciju DOBRO provjerite #"+;
        "da li su parovi stara - nova sifra ispravni !")

if Pitanje(,"Jeste li sigurni da zelite izvrsiti promjene ?","N") == "N"
	close all
	return
endif

if _get_vars( @cOnlyTest, @cFmkSif, @cKalkKum, @cKalkPriv, ;
		@cFaktKum, @cFaktPriv ) == 0

	close all
	return
endif

__only_test := .f.

if cOnlyTest == "D"
	__only_test := .t.
endif

// napravi arhivu....
_cre_arhive( __only_test )


if __only_test == .t.
	
	START PRINT CRET
 	? "BAZA                            POLJE        STARA VR.         NOVA VR.  "
 	? "-------------------------------------------------------------------------"
endif

O_K2ROBA

Box(,10,65)

if cFmkSif == "D"
  
  	aTmp := {}
	AADD(aTmp, { "KOLICINA", "K" })
  	PromjenaJMJ(aTmp, SIFPATH + "SAST.DBF" ,"ID2")
	
	aTmp := {}
	AADD(aTmp, { "JMJ", "J" })
	AADD(aTmp, { "NC", "C" })
	AADD(aTmp, { "VPC", "C" })
	AADD(aTmp, { "VPC2", "C" })
	AADD(aTmp, { "PLC", "C" })
	AADD(aTmp, { "MPC", "C" })
	AADD(aTmp, { "MPC2", "C" })
	AADD(aTmp, { "MPC3", "C" })
	
	PromjenaJMJ(aTmp, SIFPATH + "ROBA.DBF", "ID")
endif

if cKalkKum == "D"
  	
	aTmp := {}
	AADD(aTmp, { "KOLICINA", "K" })
	AADD(aTmp, { "GKOLICINA", "K" })
	AADD(aTmp, { "GKOLICIN2", "K" })
	AADD(aTmp, { "FCJ", "C" })
	AADD(aTmp, { "FCJ2", "C" })
	AADD(aTmp, { "FCJ3", "C" })
	AADD(aTmp, { "NC", "C" })
	AADD(aTmp, { "VPC", "C" })
	AADD(aTmp, { "VPCSAP", "C" })
	AADD(aTmp, { "MPC", "C" })
	AADD(aTmp, { "MPCSAPP", "C" })
	
	PromjenaJMJ( aTmp, gKalkKum + "KALK.DBF", "IDROBA")
	
endif

if cKalkPriv == "D"
	
	aTmp := {}
	AADD(aTmp, { "KOLICINA", "K" })
	AADD(aTmp, { "GKOLICINA", "K" })
	AADD(aTmp, { "GKOLICIN2", "K" })
	AADD(aTmp, { "FCJ", "C" })
	AADD(aTmp, { "FCJ2", "C" })
	AADD(aTmp, { "FCJ3", "C" })
	AADD(aTmp, { "NC", "C" })
	AADD(aTmp, { "VPC", "C" })
	AADD(aTmp, { "VPCSAP", "C" })
	AADD(aTmp, { "MPC", "C" })
	AADD(aTmp, { "MPCSAPP", "C" })

	
	PromjenaJMJ(aTmp, gKalkPri + "PRIPR.DBF", "IDROBA")
  	PromjenaJMJ(aTmp, gKalkPri + "PRIPR2.DBF", "IDROBA")
  	PromjenaJMJ(aTmp, gKalkPri + "PRIPR9.DBF", "IDROBA")
  	PromjenaJMJ(aTmp, gKalkPri + "_KALK.DBF", "IDROBA")
	
endif

if cFaktKum == "D"
  	
	aTmp := {}
	AADD(aTmp, { "KOLICINA", "K" })
	AADD(aTmp, { "CIJENA", "C" })
	
  	PromjenaJMJ(aTmp, gFaktKum + "FAKT.DBF", "IDROBA")
  
  	aTmp := {}
	AADD(aTmp, { "KOLICINA", "K" })
  	
	PromjenaJMJ(aTmp, gFaktKum + "RUGOV.DBF", "IDROBA")
	
endif

if cFaktPriv == "D"
 	
	aTmp := {}
	AADD(aTmp, { "KOLICINA", "K" })
	AADD(aTmp, { "CIJENA", "C" })
  
	PromjenaJMJ(aTmp, gFaktPri + "PRIPR.DBF", "IDROBA")
  	PromjenaJMJ(aTmp, gFaktPri + "_FAKT.DBF", "IDROBA")
	
endif

BoxC()

if __only_test == .f.
	msgbeep("Sada provjerite da li su konverzije uspjele.#"+;
        "Ako nisu NEMOJTE PONOVO POKRETATI KONVERZIJE##"+;
        "U tom slucaju Zovite S-COM SERVIS!!!")
else
	END PRINT
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




// -----------------------------------------
// promjena jedinice mjere
// -----------------------------------------
function PromjenaJMJ( aPolja, cBaza, cITrazi )
local i

private cNPolja := ""
private xPolja := 0
private cTrazi


USEX (cBaza) NEW ALIAS PRBAZA
set order to
go top

do while !EOF()

	select K2ROBA
	go top
	// baza definicija promjena
    
    	cTrazi := cITrazi

    	seek PRBAZA->(&(cTrazi))   
	// ima li u definicijama promjena vrijednost
        // izraza cTrazi (obicno je to polje ID ili
        // IDROBA)

    	if FOUND()
		// ako postoji definicija promjene

      		select PRBAZA 
		// baza za promjene
      		
		for i:=1 TO LEN(aPolja)
        		cNPolja:=aPolja[i,1]
        		if FIELDPOS(cNPolja) > 0     
				// ako polje postoji u bazi
          			xPolja:=&(cNPolja)
          			if aPolja[i,2] == "K"
					
					// kolicina
            				
					if __only_test == .t.
					
              					@ prow()+1,1 SAY PADR(cBaza,30)
             					@ prow(),33 SAY cNPolja
              					@ prow(),46 SAY xPolja
              					
						if K2ROBA->nstare <> 0
						
							@ prow(), 64 SAY xPolja*K2ROBA->nnove/K2ROBA->nstare
						endif
						
            				else
              					FIELDPUT ( FIELDPOS(cNPolja) , xPolja*K2ROBA->nnove/K2ROBA->nstare )
            				endif
					
          			elseif aPolja[i, 2] == "C"   
					
					// cijena
            				
					if __only_test == .t.
					
              					@ prow()+1,1 SAY PADR(cBaza,30)
              					@ prow(),33 SAY cNPolja
              					@ prow(),46 SAY xPolja
						
						if K2ROBA->nnove <> 0
              						@ prow(),64 SAY xPolja*K2ROBA->nstare/K2ROBA->nnove
						endif
						
            				else
              					FIELDPUT ( FIELDPOS(cNPolja) , xPolja*K2ROBA->nstare/K2ROBA->nnove )
            				endif
					
          			elseif aPolja[i, 2] == "J"   
					
					// jedinica mjere
            				
					if __only_test == .t.
					
              					@ prow()+1,1 SAY PADR(cBaza,30)
              					@ prow(),33 SAY cNPolja
              					@ prow(),46 SAY xPolja
              					@ prow(),64 SAY K2ROBA->naz
            				else
              					FIELDPUT ( FIELDPOS(cNPolja) , K2ROBA->naz )
            				endif
          			endif
        		endif
      		next
	else
		select PRBAZA
    	endif

    	skip 1
enddo

use
return (nil)


