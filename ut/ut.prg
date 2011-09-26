#include "admin.ch"



// ------------------------------------------
// konverzija kumulativa....
// aFields - struktura polja
// cPath - putanja do tabele
// cTblName - ime tabele
// ------------------------------------------
function _kv_in_kum( lTest, cLabel, aFields, cPath, cTblName, cTbl2 )

if lTest == .t.
	fld_replace( lTest, cLabel, cPath, cTblName, aFields, cTbl2 )
else
    	fld_replace( lTest, cLabel, cPath, cTblName, aFields, cTbl2 )
endif

return


// ------------------------------------------
// konverzija sifrarnika
// aFields - struktura polja
// cPath - putanja do tabele
// cTblName - ime tabele
// ------------------------------------------
function _kv_in_sif( lTest, cLabel, aFields, cPath, cTblName, ;
			cTbl2,  cType, cNazField, cNaz2, cIdField)

if lTest == .t.
	fld_replace( lTest, cLabel, cPath, cTblName, aFields, cTbl2, cNazField, cType, cNaz2, cIdField)
else
    	fld_replace( lTest, cLabel, cPath, cTblName, aFields, cTbl2, cNazField, cType, cNaz2, cIdField)
endif

return


// --------------------------------------------------
// kreiranje arhive ... za svaki slucaj
// --------------------------------------------------
function _cre_arhive( lTest )
local aDirs

// ako je test onda ne treba
if lTest == .t.
	return
endif

aDirs:={}

if PostDir(SIFPATH)
	AADD(aDirs, SIFPATH)
endif

if PostDir(gFinKum)
	AADD(aDirs, gFinKum)
endif

if PostDir(gFinPri)
	AADD(aDirs, gFinPri)
endif
	
if PostDir(gKalkKum)
	AADD(aDirs, gKalkKum)
endif

if PostDir(gKalkPri)
	AADD(aDirs, gKalkPri)
endif

if PostDir(gFaktKum)
	AADD(aDirs, gFaktKum)
endif

if PostDir(gVirmKum)
	AADD(aDirs, gVirmKum)
endif
	
if PostDir(gEPDVKum)
	AADD(aDirs, gEPDVKum)
endif

if PostDir(gOsKum)
 	AADD(aDirs, gOsKum)
endif
	
ZaSvakiSlucaj( , .t., aDirs, .f.)

return



// -------------------------------------------------------------
// coznaka = "K"
// lCheck := .t. - provjeri samo jeli sve u redu
// cPoljeNaz - polje naziva u bazi sa kojim se mjenja naziv
// cKKDBF - npr kkonto!
// -------------------------------------------------------------
function fld_replace( lCheck, ;
			cOznaka, ;
			cDir, ;
			cDBF, ;
			aPolja, ;
			cKKdbf, ;
			cPoljeNaz, ;
			cDodaji, ;
			cPoljenaz2, ;
			cTag)
			
local cStart
local lExit
local nLen
local lRet
local lOst2 := .f.
local cOst2 := ""
local i
local nSifri
local nCount := 0
local nTotCount := 0
local nTPom
local cTPom
private GetList:={}

cArea := STRTRAN(cDbf, ".DBF", "")

lExit:=.t.
lRet:=.t.

altd()

if cKKdbf == nil
	cKKdbf := "KKONTO"
endif

select (cKKdbf)
set order to tag "ID"

if !FILE( cDir + cDbf )  
	// nema dbf-a
	return .f.
endif

select 20
use

select 20
use (cDir + cDbf)
go top

nTotCount := RECCOUNT2()

if lCheck == .t.

	?   "******* " + cDir + cDBF + " *********"
	?
	
endif

set device to screen

Box(, 6, 70)
@ m_x + 1, m_y + 2 SAY "Proces konverzije u toku.... tabela: " + cDbf

set device to printer

set order to 0 
go top 

do while !EOF()

	++ nCount

	for nSifri := 1 to LEN( aPolja )  
		
		lOst2 := .f.		

		// prolaz kroz sve sifre
		cPolje := aPolja[ nSifri, 1]    
		// "idkonto"
    		cNPolje := "N" + cPolje         
		// "nidkonto"
    		cVrijednost := &cPolje        
		// "5600   "
		nLen := LEN( cVrijednost )      
		// 7
    		cVrTrim := TRIM( cVrijednost )  
		// "5600"

		// ispisi info...
		set device to screen
		
		@ m_x + 3, m_y + 2 SAY PADR("odradjujem: " + ALLTRIM(STR(nCount)) + "/" + ALLTRIM(STR(nTotCount)), 65)
		
		@ m_x + 4, m_y + 2 SAY PADR("** polje: " + cPolje, 65)
		@ m_x + 5, m_y + 2 SAY PADR("** vrijednost: " + cVrijednost, 65)
		
		set device to printer
		select (cKKDbf)
	
		for i := LEN( cVrTrim ) to 0 STEP -1
       			
			seek PADR(LEFT(cVrTrim, i), nLen)     
			// 1) trazi identicnu sifru
       			
			if FOUND()
				// 2), 3)... trazi sintetiku
         			lRet := .t.
         			exit
       			else
         			lRet := .f.
       			endif
    		next
		
		cTPRNaz := ""
    		
		if lRet == .t.
      			
			cGlavniDio := LEFT( cVrTrim, i)
      			cOstatak := SUBSTR( cVrTrim, i + 1)
			
			select 20
        		
			if lCheck == .f.
				replace &cPolje with TRIM((cKKdbf)->id2) + cOstatak 
        		endif
			
			if cPoljeNaz <> NIL .and. LEFT((cKKdbf)->naz,1) <> "."
          				
				// ako naz pocinje sa . ne mjenjaj ga !
          				
				private cPN := cPoljeNaz
          			
				if lCheck == .f.
            				replace &cPN with (cKKdbf)->naz
				endif
					
          			if lCheck == .f.
					cTPRNaz := &cPN
				else
					cTPRNaz := (cKKDbf)->naz
				endif
        		endif
			
    		else
      			
			cOld := cVrijednost
      			
			lExit := .f.
      			
			//exit    
			select (20)
			loop
    		
		endif 

    		cNovaVrijednost := TRIM((cKKdbf)->id2) + cOstatak
		
    		if LEN(cNovaVrijednost) > nLen
       			
			lRet := .f.
       			
			cOld := ALLTRIM(cVrijednost) + " -> " + ALLTRIM(cNovaVrijednost) + "  ! PREVELIKA SIFRA"
       			lExit := .f.
       			
			if lCheck == .t.
         			
				? cOld
				
       			endif
       			
			exit
    		else
       			
			if lCheck == .t.
        			
				? ALLTRIM(cVrijednost) + " -> "+ PADR(cNovaVrijednost, 11), ALLTRIM(cTPRNaz)
       			endif
			
    		endif

  	next
  	
	select 20
	skip 1
	
enddo  

if cDodaji <> nil

	set device to printer

	?
	? "Dodajem nove sifre u: " + cDbf
	?

	if cTag <> NIL
 		
		select 20
 		set order to tag (cTAG)
		
	endif
	
	select (cKKdbf)
	
	if cKKdbf == "KKONTO"
		set order to tag "BR"
	endif
	
	go top  
	
	do while !eof()
  		
		// samo ako je nova sifra, status "N"
		if field->status == "N"
    			
			select 20
			go top
    			
			seek (cKKdbf)->id2
    			
			if !FOUND()
      				if lCheck == .f.
					append blank
				else
					? "dodajem novu sifru..."
				endif
    			endif
    			
			private cPN := cPoljeNaz
			
			if lCheck == .f. 
    				replace id with (cKKdbf)->id2
				replace &cPN with (cKKdbf)->naz
    			else
				? "mjenjam id: " + (cKKdbf)->id2 + ;
					" naz: " + ALLTRIM( (cKKdbf)->naz )
			endif
			
			skip
			
    			do while !eof() .and. id == (cKKdbf)->id2  
				// brisi suvisne sifre
       				skip
				nTrec:=RECNO()
				skip -1
				
       				if lCheck == .f.
					delete
				else
					? "brisem sifru: " + field->id
				endif
       								
				go nTrec
    			enddo
		endif
  		
		select (cKKdbf)
  		skip
		
	enddo
	
endif 

BoxC()

select 20
use

set device to screen

return lExit




function ScData(cMod, cModul, cSta)
// cMod="S" - snimi
//      "C" - citaj
// cSta="011"
//      format P-privatni, S-Sifranici, K-Kumulativ

local fRet:=.t.
local i
local cScr
local cDir1,cDir2,cDir3
local aFiles
local cPom
local cImeZip

if left(cmodul,3)=="FIN"
   cDir1:=gFinPri
   cDir2:=cDirSif
   cDir3:=gFinKum
elseif left(cmodul,4)=="KALK"
   cDir1:=gKalkPri
   cDir2:=cDirSif
   cDir3:=gKalkKum
elseif left(cmodul,4)=="FAKT"
   cDir1:=gFaktPri
   cDir2:=cDirSif
   cDir3:=gFaktKum
elseif left(cmodul,2)=="OS"
   cDir1:=gOSPri
   cDir2:=cDirSif
   cDir3:=gOsKum
elseif left(cmodul,4)=="VIRM"
   cDir1:=gVirmPri
   cDir2:=cDirSif
   cDir3:=gVirmKum
elseif left(cmodul,4)=="TOPS"
   cDir1:=gTopsPri
   cDir2:=cDirSif
   cDir3:=gTopsKum
elseif left(cmodul,4)=="HOPS"
   cDir1:=gHopsPri
   cDir2:=cDirSif
   cDir3:=gHopsKum
elseif left(cmodul,4)=="ePDV"
   cDir1:=gEPDVPri
   cDir2:=cDirSif
   cDir3:=gEPDVKum
endif

cCDX:="D"
//gScData   korjeni direktorij podataka npr "C:\SCDATA"

if cCDX=="D"
	fCDX:=.t.
endif

fRecurse:=.f.
fret:=.t.

save screen to cScr
cls

do while .t.

cImeZip:=alltrim(gScData)+"\"+alltrim(cModul)
if cMod="S"
  // snimi podatake
  if substr(cSta,1,1)="1"
       // privatni
     cKom:="zip "+cImeZip+"P  -x*.bak -x*.cdx "+alltrim(cDir1)+"\*.*"
     // primjer: zip  c:\scsdata\fin1P c:\sigma\fin\kum1
     ferase(cImeZip+"P.zip") // izbrisi stari

     if !swpruncmd(cKom,0,"","")
       fret:=.f.
     endif
  endif
  if substr(cSta,2,1)="1"
     cKom:="zip "+cImeZip+"S -x*.bak -x*.cdx "+alltrim(cDir2)+"\*.*"
     // primjer: zip  c:\scsdata\fin1P c:\sigma\fin\kum1
     ferase(cImeZip+"S.zip") // izbrisi stari

     if !swpruncmd(cKom,0,"","")
       fret:=.f.
     endif
  endif
  if substr(cSta,3,1)="1"
     cKom:="zip "+cImeZip+"K -x*.bak -x*.cdx "+alltrim(cDir3)+"\*.*"
     // primjer: zip  c:\scsdata\fin1P c:\sigma\fin\kum1
     ferase(cImeZip+"K.zip") // izbrisi stari
     if !swpruncmd(cKom,0,"","")
       fret:=.f.
     endif
  endif

elseif cMod="C"
  // citaj podatke
  if substr(cSta,1,1)="1"
       // privatni
     cKom:="unzip -o "+cImeZip+"P "+alltrim(cDir1)+"\"
     if !swpruncmd(cKom,0,"","")
       fret:=.f.
     endif
  endif
  if substr(cSta,2,1)="1"
     cKom:="unzip -o "+cImeZip+"S "+alltrim(cDir2)+"\"
     // primjer: zip  c:\scsdata\fin1P c:\sigma\fin\kum1
     if !swpruncmd(cKom,0,"","")
       fret:=.f.
     endif
  endif
  if substr(cSta,3,1)="1"
     cKom:="unzip -o "+cImeZip+"K  "+alltrim(cDir3)+"\"
     // primjer: zip  c:\scsdata\fin1P c:\sigma\fin\kum1
     if !swpruncmd(cKom,0,"","")
       fret:=.f.
     endif
  endif
endif

if fret
   exit
else
   MsgBeep("Arhiviranje nije uspjesno izvrseno !!")
   if pitanje(,"Pokusati ponovo","D")=="N"
      exit
   endif
endif

enddo // vrti se dok nije uspjesno
restore screen from cScr


return


// -----------------------------------------
// osvjezavanje verzije
// -----------------------------------------
function OsvV()
local fRet:=.t.
local i
local cScr
local cDisk
local aFiles
local cPom

cCDX:="D"
cDisk:=padr("A:\",30)
cIme:=PADR("PORLD",6)
cDest:=PADR("C:\SIGMA",30)

Box(,5,70)
  @ m_x+1,m_y+2 SAY "Podaci se nalaze na            :" GET cDisk pict "@!"
  @ m_x+3,m_y+2 SAY "Osvjeziti (FIN/KALK/LD/OS/VIRM/PORLD):" GET cIme pict "@!"
  @ m_x+5,m_y+2 SAY "Prenos izvrsiti na             :" GET cDest pict "@!"
  read; ESC_BCR
BoxC()

if cCDX=="D"
 fCDX:=.t.
endif

fRecurse:=.f.

cKom:="unzip -t "+alltrim(cDisk)+alltrim(cIme)+" "+alltrim(cDest)



save screen to cScr

cls
?
? "Vrsim testiranja arhive :"
? cKom
?


? "Pritisni <ENTER> za nastavak ...."
inkey(5)
?
if !swpruncmd(cKom,0,"","")
  fret:=.f.
endif
if swperrlev()<>0
 fRet:=.f.
endif
inkey(10)
if !fret
  msgbeep("Arhiva nije ispravna !!")


  restore screen from cScr
  closeret

else
  // sasda ide pravo arhiviranje
  cKom:="unzip -o "+alltrim(cDisk)+alltrim(cIme)+" "+alltrim(cDest)
  cls
  ? cKom
  ?

  ?
  if !swpruncmd(cKom,0,"","")
    fret:=.f.
  endif
  if swperrlev()<>0
    fRet:=.f.
  endif

  if !fret
    MsgBeep("Osvjezavanje nije uspjelo !?")
  endif

  restore screen from cScr

  if fret
    msgbeep("Osvjezavanje je zavrseno ")
  endif
endif


return



// --------------------------------------------
// osvjezavanje verzije
// --------------------------------------------
function OsvjeziV()
local fRet:=.t.
local i
local cScr
local cDisk
local aFiles
local cPom

cCDX:="D"
cDisk:=padr("A:\",30)
cIme:=PADR("PORLD",6)
cDest:=PADR("C:\SIGMA",30)
Box(,5,70)
  @ m_x+1,m_y+2 SAY "Podaci se nalaze na            :" GET cDisk pict "@!"
  @ m_x+3,m_y+2 SAY "Osvjeziti (FIN/KALK/LD/OS/VIRM/PORLD):" GET cIme pict "@!"
  @ m_x+5,m_y+2 SAY "Prenos izvrsiti na             :" GET cDest pict "@!"
  read; ESC_BCR
BoxC()

if cCDX=="D"
 fCDX:=.t.
endif

fRecurse:=.f.

cKom:="unzip -t "+alltrim(cDisk)+alltrim(cIme)+" "+alltrim(cDest)



save screen to cScr

cls
?
? "Vrsim testiranja arhive :"
? cKom
?


? "Pritisni <ENTER> za nastavak ...."
inkey(5)
?
if !swpruncmd(cKom,0,"","")
  fret:=.f.
endif
if swperrlev()<>0
 fRet:=.f.
endif
inkey(10)
if !fret
  msgbeep("Arhiva nije ispravna !!")


  restore screen from cScr
  closeret

else
  // sasda ide pravo arhiviranje
  cKom:="unzip -o "+alltrim(cDisk)+alltrim(cIme)+" "+alltrim(cDest)
  cls
  ? cKom
  ?

  ?
  if !swpruncmd(cKom,0,"","")
    fret:=.f.
  endif
  if swperrlev()<>0
    fRet:=.f.
  endif

  if !fret
    MsgBeep("Osvjezavanje nije uspjelo !?")
  endif

  restore screen from cScr

  if fret
    msgbeep("Osvjezavanje je zavrseno ")
  endif
endif


return

// ---------------------------------------------
// poruka prije pokretanja opcije
// ---------------------------------------------
function msg_info()

msgbeep("Prije nego li pocnete napravite arhive podataka:#"+;
        "1. Opcija 97 / arhiviraj na tvrdi disk#"+;
        "2. Takodje opcija 97 / arhiviraj na diskete##"+;
        "ZAPAMTITE : VI STE ODGOVORNI ZA SVOJE PODATKE !!")

return



