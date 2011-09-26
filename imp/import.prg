#include "admin.ch"


// ------------------------------------------
// import txt 2 tbl
// ------------------------------------------
function txt_2_tbl()
local cTxtPath := PADR("C:\", 200)
local cImpId := PADR("KONTO", 8)
local cImpShema := PADR("", 2)
local cTxtDelimiter := PADR("##", 10)
local cKonvVal := "4"
local nCount := 0

// uzmi varijable...
if _get_vars( @cTxtPath, @cImpId, @cImpShema, @cTxtDelimiter, @cKonvVal ) == 0
	return
endif

// importuj txt
nCount := _imp_txt( cTxtPath, cImpId, cImpShema, cTxtDelimiter, cKonvVal )

if nCount > 0
	
	if Pitanje(,"importovati podatke u originalnu tabelu (D/N)?", "D") == "D"
		// kopiraj _tmp
		_cp_tmp_( cImpId )
	endif

endif

close all

return


// ------------------------------------------------
// kopiranje podataka iz _tmp u orig.tabelu
// ------------------------------------------------
static function _cp_tmp_( cTbl )
local nPom

cOTbl := "O_" + ALLTRIM(cTbl)
cOrigTbl := ALLTRIM(cTbl)

O_SIFK
O_SIFV

O__TMP
nPom := &cOTbl

select _tmp
go top
do while !EOF()

	Scatter()
		
	select &cOrigTbl
	append blank
	Gather()

	select _tmp
	
	if _tmp->(FieldPOS("SIFK1")) <> 0
		cMacro := ALLTRIM(_tmp->sifk1)
		nRet := &cMacro
	endif
	
	if _tmp->(FieldPOS("SIFK2")) <> 0
		cMacro := ALLTRIM(_tmp->sifk2)
		nRet := &cMacro
	endif

	if _tmp->(FieldPOS("SIFK3")) <> 0
		cMacro := ALLTRIM(_tmp->sifk3)
		nRet := &cMacro
	endif

	select _tmp
	skip

enddo

return


// --------------------------------------------
// importovanje sifranika
// --------------------------------------------
static function _imp_txt( cTxtPath, ;
			cImpId, ;
			cShema, ;
			cTxtDelimiter, ;
			cKonvVal )
local aShema := {}
local aTmp := {}
local cTmp := ""
local aText := {}
local nRet := 0
local nFLines := 0
local nLStart := 0
local i
private txt
private GetList:={}

// read shema to aShema
if _arr_shema( @aShema, cImpId, cShema ) == .f.

	msgbeep("shema ne postoji !!!")
	return nRet
	
endif

// cre tmp.dbf from aShema
_cre_tmp( @aShema )

O__TMP
O_IMP_PARM

// import txt into tmp.dbf

// lines count of txt file
nFLines := brlinfajla( cTxtPath )

Box(, 5, 70)

@ m_x + 1, m_y + 2 SAY "import podataka u pomocnu tabelu ...."

for i:=1 to nFLines

	// pomocna matrica...
	aTmp := sljedlin( cTxtPath, nLStart )
	
	// pocetak sljedece pretrage...
	nLStart := aTmp[2]

	// tekst ...
	cTmp := aTmp[1]

	// konverzija teksta
	if cKonvVal <> "0"
		cTmp := KonvZnWin( cTmp, cKonvVal )
	endif

	if ALLTRIM(cTxtDelimit) $ cTmp
		// matrica sa tekstom
		aText := TokToNiz( cTmp, ALLTRIM(cTxtDelimit) )
		txt := aText[1]
	endif

	if EMPTY( txt )
		loop
	endif
	
	select _tmp
	Scatter()
	
	select imp_parm
	go top
	
	seek cImpId + cShema

	nTmpCnt := 0
	nTextCnt := 1
	
	// sada prodji po definiciji polja....
	do while !EOF() .and. field->id == cImpId ;
			.and. field->imp_sheme == cShema

		
		if LEN(aText) > 0
		
			txt := aText[ nTextCnt ]
			
			++ nTextCnt
			
		else
			txt := cTmp
		endif

		cXField := "_" + ALLTRIM(field->fld_name)
		cXVal := ALLTRIM(field->imp_cond)
		cXType := LEFT( ALLTRIM(field->fld_type), 1 )
		
		select _tmp
		
		if LEFT(cXField, 5) == "_SIFK"
			
			++ nTmpCnt
			&cXField := cXVal
			select imp_parm
			skip
			loop
	
		endif
		
		if cXType == "C"
			&cXField := &cXVal
		endif
		
		if cXType == "N"
			&cXField := VAL( &cXVal )
		endif
		
		if cXType == "D"
			&cXField := CTOD( &cXVal )
		endif
	
		++ nTmpCnt
	
		@ m_x + 3, m_y + 2 SAY "count: " + ALLTRIM(STR(i))
		@ m_x + 5, m_y + 2 SAY "value: " + PADR( &cXVal, 20)
	
		select imp_parm
		skip
		
	enddo

	if nTmpCnt > 0
		// dodaj u _tmp
		select _tmp
		append blank
	
		Gather()
	endif

next

BoxC()

select _tmp
nRet := RecCount2()

if nRet > 0
	
	msgbeep("Importovano " + ALLTRIM(STR(nRet)) + " zapisa !")

	// pregledaj podatke...
	p__tmp( aShema )

endif

return nRet


// ---------------------------------------------------
// read shema into aArr
// ---------------------------------------------------
static function _arr_shema( aArr, cImpId, cShema )
local nTArea := SELECT()
local lRet := .t.
local cFType
local nFWid
local nFDec

O_IMP_PARM
set order to tag "1"
go top
seek cImpId + cShema

if FOUND()
	do while !EOF() .and. field->id == cImpId ;
			.and. field->imp_sheme == cShema
		
		// uzmi parametre polja
		_get_fparm( field->fld_type, @cFType, ;
				@nFWid, @nFDec )
		
		AADD( aArr, { ALLTRIM(field->fld_name), cFType, ;
				nFWid, nFDec })
		skip
	enddo
else
	lRet := .f.
endif

select (nTArea)
return lRet


// -----------------------------------------------------
// kreiraj TMP tabelu prema strukturi iz aDBF
// -----------------------------------------------------
static function _cre_tmp( aDbf )
local cTbl := "_TMP"

// izbrisi _tmp
FERASE( PRIVPATH + cTbl + ".DBF" )

// kreiraj _tmp
if !FILE( PRIVPATH + cTbl + ".DBF" )
	DBCREATE2(PRIVPATH + cTbl + ".DBF", aDbf )
endif

return



// --------------------------------------------------------
// uzmi parametre polja na osnovu fld_type
// --------------------------------------------------------
static function _get_fparm( xVal, cFType, nFWid, nFDec )
// xVal= C(10,0)
local cPom
local aPom := {}

xVal := ALLTRIM(xVal)
// type je
cFType := LEFT(xVal, 1)
// (10,0)
cPom := SUBSTR(xVal, 2, LEN(xVal) )
// ukini zagrade...
cPom := STRTRAN(cPom, "(", "")
cPom := STRTRAN(cPom, ")", "")

aPom := TokToNiz( cPom, "," )

nFWid := VAL( aPom[1] )
nFDec := VAL( aPom[2] )

return



// --------------------------------------------
// setovanje varijabli importa
// --------------------------------------------
static function _get_vars( cTxtPath, ;
			cImpId, ;
			cImpShema, ;
			cTxtDelimit, ;
			cKonvVal )
local nX := 1
local nBoxX := 10
local nBoxY := 70
private GetList:={}

Box(, nBoxX, nBoxY )

	@ m_x + nX, m_y + 2 SAY "PARAMETRI IMPORTA..."

	nX += 2

	@ m_x + nX, m_y + 2 SAY "Lokacija txt fajla:" GET cTxtPath VALID val_path( cTxtPath ) PICT "@S40"
	
	nX += 1
	
	@ m_x + nX, m_y + 2 SAY "Sifrarnik (npr. KONTO, ROBA):" GET cImpId VALID !EMPTY(cImpId) .and. valimpid( cImpId )
	
	nX += 1

	@ m_x + nX, m_y + 2 SAY "Shema importa:" GET cImpShema 
	
	nX += 2

	@ m_x + nX, m_y + 2 SAY "TXT delimiter:" GET cTxtDelimit 
	
	nX += 2
	
	@ m_x + nX, m_y + 2 SAY "Konverzija pri importu (1 - 7, 0 - bez):" GET cKonvVal VALID cKonvVal $ "01234567" PICT "9" 
	
	read
BoxC()


if LastKey() == K_ESC
	return 0
endif

return 1


// ----------------------------------------------
// validacija path-a txt fajla
// ----------------------------------------------
static function val_path( cFile )
local lRet := .t.

if EMPTY(cFile) .or. !FILE( cFile )
	lRet := .f.
endif

if lRet == .f.
	MsgBeep("Lokacija mora biti unesena !!!")
endif

return lRet


// ---------------------------------------
// validacija import id-a
// ---------------------------------------
static function valimpid( cId )
local lRet := .t.
local nTArea := SELECT()

O_IMP_PARM
set order to tag "1"
go top
seek cId

if !FOUND()
	lRet := .f.
endif

select (nTArea)

if lRet == .f.
	MsgBeep("Ovaj import ne postoji u sifrarniku parametara !!!")
endif

return lRet 

