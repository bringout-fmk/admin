#include "admin.ch"


// ----------------------------------------------------
// zamjena podataka kontnog plana
// ----------------------------------------------------
function KKonto()

// prijavi poruku, info, arhiva
msg_info()

msgbeep("Prije nego zapocnete ovu operaciju DOBRO provjerite #"+;
        "da li su parovi stari - novi konto ispravni !")

if pitanje(,"Jeste li sigurni da zelite izvrsiti promjene ?","N")=="N"
	closeret
endif

// FIN
cKPFin:="N"
cKSFin:="N"
cKKFin:="N"

// KALK
cKPKalk:="N"
cKKKalk:="N"
cKSKalk:="N"

// OS
cKKOS:="N"

cKKFAkt:="N"

cKKVirm:="N"

// ePDV
cKKePDV:="N"
cKPePDV:="N"
cKSePDV:="N"

cSamoProv:="D"

Box(, 20, 65)

  @ m_X+1,m_Y+2 SAY "Konverzija pripreme   FIN  " get cKPFin  pict "@!" valid ckpfin  $ "DN"
  @ m_X+2,m_Y+2 SAY "Konverzija kumulativ  FIN  " get cKKFin  pict "@!" valid ckkfin  $ "DN"
  @ m_X+3,m_Y+2 SAY "Konverzija sifrarnik  FIN  " get cKSFin  pict "@!" valid cksfin  $ "DN"

  @ m_X+5,m_Y+2 SAY "Konverzija pripreme  KALK " get cKPKalk pict "@!" valid ckpkalk $ "DN"
  @ m_X+6,m_Y+2 SAY "Konverzija kumulativ KALK " get cKKKalk pict "@!" valid ckkkalk $ "DN"
  @ m_X+7,m_Y+2 SAY "Konverzija sifrarnik KALK " get cKSKalk pict "@!" valid ckskalk $ "DN"

  @ m_X+9, m_Y+2 SAY "Konverzija kumulativ  OS" get cKKOS pict "@!" valid ckkos $ "DN"

  @ m_X+10,m_Y+2 SAY "Konverzija kumulativ FAKT" get cKKFakt pict "@!" valid ckkfakt $ "DN"

  @ m_X+11,m_Y+2 SAY "Konverzija sifrarnik VIRM" get cKKVirm pict "@!" valid ckkVirm $ "DN"

  @ m_X+13,m_Y+2 SAY "Konverzija kumulativ ePDV " get cKKePDV pict "@!" valid cKKePDV $ "DN"
  @ m_X+14,m_Y+2 SAY "Konverzija sifrarnik ePDV " get cKSePDV pict "@!" valid cKSePDV $ "DN"

  @ m_X+15,m_Y+2 SAY "Izvrsiti samo provjere" get cSamoPRov pict "@!" valid cSamoProv $ "DN"
  
  read

BoxC()

if cSamoprov == "N"
	
	aDirs:={}
	if PostDir(gFINKUM)
 		AADD(aDirs,gFinkum)
	endif

	if PostDir(gFinPri)
 		AADD(aDirs,gFinPri)
	endif
	
	if PostDir(gKalkKum)
 		AADD(aDirs,gKalkKum)
	endif

	if PostDir(cDirSif+"\")
 		AADD(aDirs,cdirSif+"\")
	endif

	if PostDir(gKalkPri)
 		AADD(aDirs,gKalkPri)
	endif

	if PostDir(gFaktKum)
 		AADD(aDirs,gFaktKum)
	endif

	if PostDir(gVirmKum)
 		AADD(aDirs,gVirmKum)
	endif
	
	if PostDir(gEPDVKum)
 		AADD(aDirs,gEPDVKum)
	endif

	if PostDir(gEPDVKum)
 		AADD(aDirs,gEPDVKum)
	endif

	if PostDir(gOsKum)
 		AADD(aDirs,gOsKum)
	endif
	
	ZaSvakiSlucaj(,.t.,aDirs,.f.)

endif

O_KKONTO

Box(,10,65)


altd()

if cKKFin == "D"

  fDrugikrug := .t.
  aPolja:={  {"IDKONTO", "C" , 7 , 0}  }
  fdrugikrug:=fdrugikrug .and. ZamjenaSif(.t.,"K",gFinKum,"suban.dbf",aPolja)
  fdrugikrug:=fdrugikrug .and. ZamjenaSif(.t.,"K",gFinKum,"anal.dbf",aPolja)
  fdrugikrug:=fdrugikrug .and. ZamjenaSif(.t.,"K",gFinKum,"sint.dbf",aPolja)
  
  if cSamoProv == "N"
   	if !fDrugikrug
     		MSGBEEP("FIN KUMULATIV: ZAMJENA NECE BITI IZVRSENA")
   	else
    		// drugi krug
    		@ m_x+8,m_y+2 SAY "ENTER za drugi krug ..."
    		inkey(10)
    		ZamjenaSif(.f.,"K",gFinKum,"suban.dbf",aPolja)
    		ZamjenaSif(.f.,"K",gFinKum,"anal.dbf",aPolja)
    		ZamjenaSif(.f.,"K",gFinKum,"sint.dbf",aPolja)
   	endif
  endif

endif

if cKSFin=="D"
  
  fDrugikrug:=.t.
  aPolja:={  {"ID","C",7, 0}  }
  fdrugikrug:=fdrugikrug .and. ZamjenaSif(.t.,"K",SIFPATH,"konto.dbf",aPolja,"KKONTO",,,,"ID")

  if csamoprov=="N"
  if !fdrugikrug
     MSGBEEP("FIN SIFRARNICI: ZAMJENA NECE BITI IZVRSENA")
  else
     // drugi krug
     @ m_x+8,m_y+2 SAY "ENTER za drugi krug ..."
     inkey(10)
     ZamjenaSif(.f.,"K",SIFPATH,"konto.dbf",aPolja,"KKONTO",,"D","NAZ","ID")
  endif
  endif
endif


if cKPFin=="D"
  fDrugikrug:=.t.
  aPolja:={  {"IDKONTO","C",7, 0}  }
  fdrugikrug:=fdrugikrug .and. ZamjenaSif(.t.,"K",gFinPri,"pripr.dbf",aPolja)
  if csamoprov=="N"
  if !fdrugikrug
     MSGBEEP("FIN PRIPREMA: ZAMJENA NECE BITI IZVRSENA")
  else
    // drugi krug
    @ m_x+8,m_y+2 SAY "ENTER za drugi krug ..."
    inkey(10)
    ZamjenaSif(.f.,"K",gFinPri,"pripr.dbf",aPolja)
  endif
  endif

endif

if cKKKalk=="D"
  fDrugikrug:=.t.
  aPolja:={  {"IDKONTO","C",7, 0} ,;
             {"IDKONTO2","C",7, 0},;
             {"MKONTO","C",7, 0},;
             {"PKONTO","C",7, 0} }
  fdrugikrug:=fdrugikrug .and. ZamjenaSif(.t.,"K",gKALKKUM,"KALK.dbf",aPolja)
  aPolja:={ ;
             {"MKONTO","C",7, 0},;
             {"PKONTO","C",7, 0} }
  fdrugikrug:=fdrugikrug .and. ZamjenaSif(.t.,"K",GKALKKUM,"DOKS.dbf",aPolja)
  if csamoprov=="N"
  if !fdrugikrug
     MSGBEEP("KALK KUMULATIV: ZAMJENA NECE BITI IZVRSENA")
  else
    @ m_x+8,m_y+2 SAY "ENTER za drugi krug ..."
    inkey(10)
    // drugi krug
    aPolja:={  {"IDKONTO","C",7, 0} ,;
               {"IDKONTO2","C",7, 0},;
               {"MKONTO","C",7, 0},;
               {"PKONTO","C",7, 0} }
    ZamjenaSif(.f.,"K",gKalkKum,"kalk.dbf",aPolja)
    aPolja:={ ;
             {"MKONTO","C",7, 0},;
             {"PKONTO","C",7, 0} }
    ZamjenaSif(.f.,"K",GKALKKUM,"DOKS.dbf",aPolja)
  endif
  endif
endif

if cKPKalk=="D"
  fDrugikrug:=.t.
  aPolja:={  {"IDKONTO","C",7, 0} ,;
             {"IDKONTO2","C",7, 0},;
             {"MKONTO","C",7, 0},;
             {"PKONTO","C",7, 0} }
  fdrugikrug:=fdrugikrug .and. ZamjenaSif(.t.,"K",gKALKPri,"pripr.dbf",aPolja)
  if csamoprov=="N"
  if !fdrugikrug
     MSGBEEP("KALK priprema: ZAMJENA NECE BITI IZVRSENA")
  else
    @ m_x+8,m_y+2 SAY "ENTER za drugi krug ..."
    inkey(10)
    // drugi krug
    aPolja:={  {"IDKONTO","C",7, 0} ,;
             {"IDKONTO2","C",7, 0},;
             {"MKONTO","C",7, 0},;
             {"PKONTO","C",7, 0} }
     ZamjenaSif(.f.,"K",gKALKPri,"pripr.dbf",aPolja)
  endif
  endif
endif


if cKSKalk=="D"
  fDrugikrug:=.t.
  aPolja:={  {"ID","C",7, 0} }
  fdrugikrug:=fdrugikrug .and. ZamjenaSif(.t.,"K",SIFPATH,"koncij.dbf",aPolja)
  aPolja:={  {"IDKONTO","C",7, 0} }
  fdrugikrug:=fdrugikrug .and. ZamjenaSif(.t.,"K",SIFPATH,"TRFP.dbf",aPolja)
  if csamoprov=="N"
  if !fdrugikrug
     MSGBEEP("KALK sifrarnici: ZAMJENA NECE BITI IZVRSENA")
  else
    @ m_x+8,m_y+2 SAY "ENTER za drugi krug ..."
    inkey(10)
     // drugi krug
     aPolja:={  {"ID","C",7, 0} }
     ZamjenaSif(.f.,"K",SIFPATH,"koncij.dbf",aPolja)
     aPolja:={  {"IDKONTO","C",7, 0} }
     ZamjenaSif(.F.,"K",SIFPATH,"TRFP.dbf",aPolja)
  endif
  endif
endif


//ePDV
if cKKePDV == "D"
  
  fDrugikrug:=.t.
  aPolja:={  {"ID_KTO", "C", 160, 0}, ;
             {"ID_KTO_NAZ" , "C", 10, 0} }
	     
  fdrugikrug:=fdrugikrug .and. ZamjenaSif(.t., "K", gEPDVKUM, "sg_kuf.dbf",aPolja)
  fdrugikrug:=fdrugikrug .and. ZamjenaSif(.t., "K", gEPDVKUM, "sg_kif.dbf",aPolja)
  
  if cSamoProv == "N"
  	if !fdrugikrug
     		MSGBEEP("KALK priprema: ZAMJENA NECE BITI IZVRSENA")
  	else
    		@ m_x+8,m_y+2 SAY "ENTER za drugi krug ..."
    		inkey(10)
    		// drugi krug
    		aPolja:={  {"ID_KTO", "C", 160, 0}, ;
             		{"ID_KTO_NAZ" , "C", 10, 0} }

		ZamjenaSif(.f., "K", gEPDVKUM,"sg_kuf.dbf", aPolja)
		ZamjenaSif(.f., "K", gEPDVKUM,"sg_kif.dbf", aPolja)
  	endif
  endif

endif

if cKKos=="D"
  fDrugikrug:=.t.
  aPolja:={  {"IDKONTO","C",7, 0} }
  fdrugikrug:=fdrugikrug .and. ZamjenaSif(.t.,"K",gOSKum,"os.dbf",aPolja)
  if csamoprov=="N"
  if !fdrugikrug
     MSGBEEP("OS sifrarnici: ZAMJENA NECE BITI IZVRSENA")
  else
    @ m_x+8,m_y+2 SAY "ENTER za drugi krug ..."
    inkey(10)
     // drugi krug
     aPolja:={  {"IDKONTO","C",7, 0} }
     ZamjenaSif(.f.,"K",gOSKum,"os.dbf",aPolja)
  endif
  endif
endif

if cKKVirm=="D"
  fDrugikrug:=.t.
  aPolja:={  {"IDKONTO","C",7, 0} }
  fdrugikrug:=fdrugikrug .and. ZamjenaSif(.t.,"K",gVirmKum,"vrprim.dbf",aPolja)
  if csamoprov=="N"
  if !fdrugikrug
     MSGBEEP("VIRM kumulativ: ZAMJENA NECE BITI IZVRSENA")
  else
    @ m_x+8,m_y+2 SAY "ENTER za drugi krug ..."
    inkey(10)
     // drugi krug
     aPolja:={  {"IDKONTO","C",7, 0} }
     ZamjenaSif(.f.,"K",gVirmKum,"vrprim.dbf",aPolja)
  endif
  endif
endif

BoxC()


if cSamoProv=="N"
	msgbeep("Sada provjerite da li su konverzije uspjele.#"+;
        	"Ako nisu NEMOJTE PONOVO POKRETATI KONVERZIJE##"+;
        	"U tom slucaju Zovite S-COM SERVIS!!!")
	
endif
closeret



// -------------------------------------------------------------
// coznaka = "K"
// fprovjera := .t. - provjeri samo jeli sve u redu
// cPoljeNaz - polje naziva u bazi sa kojim se mjenja naziv
// cKKDBF - npr kkonto!
// -------------------------------------------------------------
function ZamjenaSif( fPRovjera, ;
			cOznaka, ;
			cDir, ;
			cDBF, ;
			aPolja, ;
			cKKdbf, ;
			cPoljeNaz, ;
			cDodaji, ;
			cPoljenaz2, ;
			cTag)
			
local cPocetak 
local fIzadji
local nLen
fizadji:=.t.
fRet:=.t.

if cKKdbf==NIL
	cKKdbf:="Kkonto"
endif

select (ckkdbf)
set order to tag "ID"

if !file(cdir+cdbf)  // nema dbf-a
	return .f.
endif

select 20
USEX(cDir+cDbf)

altd()

if fProvjera
	start print cret
	//@ m_X+1,m_Y+2 SAY "******* "+ cdir+cDBF +" *********"
	?   "******* "+ cdir+cDBF +" *********"
endif

//  R_FAKT.DBF i sl.
//cIme:=cdir+coznaka+"_"+cdbf
//if !file(cime)
//   aDBf:={}
//   AADD(aDBf,{ 'recno  '            , 'N' ,  10 ,  0 })
//   AADD(aDBf,{ 'datum'              , 'D' ,   8 ,  0 })
//   AADD(aDBf,{ 'Status'             , 'C' ,   1 ,  0 })
//   for i:=1 to len(aPolja)
//      // aPolje[x] = {"idkonto","C",1,0}
//      AADD(aDbf,aPolja[i])
//      AADD(aDbf,{"N"+aPolja[i,1],aPolja[i,2],aPolja[i,3],aPolja[i,4]})
//      // aPolje[x+1] = {"nidkonto","C",1,0}
//   next
//   DBCREATE2(cime,aDbf)
//endif
//select 54  !!!! kontrolna baza
//usex (cime); set order to tag "recno"
//index on brisano tag "BRISAN"
//index on recno tag "RECNO"
//select 20; set order to 0

if fprovjera .and. cTag<>NIL  // radim provjeru
 //select 20
 //set order to tag (cTAG)
endif

set order to 0       // dodao 26.03.01. MS (mislim da je zbog nedostatka ove
                     // linije dolazilo do greçke tipa viçestruke konverzije
                     // na istom podatku)
go top // suban

altd()
do while !eof()
	for nSifri:=1 to len(aPolja)  // prolaz kroz sve sifre
		cPolje:=aPolja[nsifri,1]    // "idkonto"
    		cNPolje:="N"+cPolje         // "nidkonto"
    		cVrijednost:=&cPolje        // "5600   "
    		nLen:=len(cVrijednost)      // 7
    		cVrtrim:=trim(cVrijednost)  // "5600"
		select (cKKDbf)
    		for i:=len(cVrTrim) to 0   step -1
       			seek padr(left(cVrtrim,i),nLen)     // 1) tra§i identiŸnu çifru
       			if found()                          // 2), 3)... tra§i sintetiku
         			fRet:=.t.
				fProvjera:=.f.
         			exit
       			else
         			fRet:=.f.
				fProvjera:=.f.
       			endif
    		next
    		// npr kkonto->id=56  ,  kkonto->id2=121
    		// cvrtrim:=5601
		cTPRNaz:=""
    		if fRet
      			cGlavniDio:=left(cVrtrim,i)
      			cOstatak:=substr(cVrtrim,i+1)
			//select 54  // k_suban
      			// 26.01.01 izbaciti iz igre R_FAKT , R_KALK itd ....
			if !fprovjera
        			//seek (20)->(recno())
        			//if !found()
        			//   append blank
        			//   replace recno with  (20)->(recno())
        			//endif
        			//replace  &cPolje with cvrijednost         ,;
        			//         &cNPolje with trim((cKKDbf)->id2)+cOstatak,;
        			//         datum with date()  ,;
        			//         status with "1"

				select 20 // suban
        			replace &cpolje with trim((ckkdbf)->id2)+cOstatak
        			if cPoljeNaz<>NIL .and. left((ckkdbf)->naz,1)<>"."
          				// ako naz pocinje sa . ne mjenjaj ga !
          				private cPN:=cPoljeNaz
          				if len(&cPn)<=len((ckkdbf)->naz)
            					replace &cPN with (ckkdbf)->naz
         				endif
          				cTPRNaz:=&cPN
        			endif
      			endif
    		else
      			cOld:=cVrijednost
      			if fprovjera
        			? "Ne postoji sema za sifru:", cVrijednost
      			endif
      			fizadji:=.f.
      			exit    // napustam petlju "for nsifri:=1 to len(apolja) ... next"
    		endif // fret

    		cNovaVrijednost:=trim((ckkdbf)->id2)+cOstatak
    		if len(cNovaVrijednost)>nLen
       			fRet:=.f.
       			cOld:=cVrijednost + " -> " + cNovaVrijednost+"  ! PREVELIKA SIFRA"
       			fizadji:=.f.
       			if fprovjera
         			? cOld
       			endif
       			exit
    		else
       			if fprovjera
        			? cVrijednost + " -> "+ padr(cNovaVrijednost,11), cTPRNaz
       			endif
    		endif

  	next //  nsifri:=1 to len(aPolja)
	//if !fret // greska
    	// exit
  	//endif
  	select 20; skip 1
enddo  // !eof()

if !fprovjera .and. cDodaji<>NIL
	msgo("Dodajem nove sifre u: "+ckkdbf)
	if cTag<>NIL
 		select 20
 		set order to tag (cTAG)
	endif
	select (ckkdbf)
	go top  // drugi krug dodavanje çifarskog sistema
	do while !eof()
  		if status="N"
    			select 20  // konto.dbf
    			seek (ckkdbf)->id2
    			if !found()
      				append blank
    			endif
    			private cPN:=cPoljeNaz2
    			replace id with (ckkdbf)->id2,;
              		&cPN with (ckkdbf)->naz
    			skip
    			do while !eof() .and. id==(ckkdbf)->id2  // brisi suvisne sifre
       				skip; nTrec:=recno(); skip -1
       				delete
       				go nTrec
    			enddo


  endif
  select (ckkdbf)
  skip
enddo
msgc()
endif // cpoljenaz

select 20; use

//select 54; use

if fprovjera
 end print
endif
return fizadji

