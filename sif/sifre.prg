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


// --------------------------------------------
// menij sifrarnika
// --------------------------------------------
function mnu_sif()
private izbor := 1
private opc := {}
private opcexe := {}


AADD(opc, "1. opci sifrarnici                  ")
AADD(opcexe, {|| SifFmkSvi() })
AADD(opc, "2. robno-materijalno poslovanje ")
AADD(opcexe, {|| SifFmkRoba() })
AADD(opc, "3. admin - sifrarnik / promjene")
AADD(opcexe, {|| admin_sifre() })
AADD(opc, "4. admin - import parametri")
AADD(opcexe, {|| imp_sif_params() })

Menu_SC( "sifrarnik" )

return



// ------------------------------------------
// sifrarnik - admin
// ------------------------------------------
function admin_sifre()
private opc:={}
private opcexe:={}
private Izbor:=1

_o_sif()

AADD(opc, "1. promjene konta                " ) 
AADD(opcexe, {|| P_KKonto() })
AADD(opc, "2. promjene artikli" )
AADD(opcexe, {|| P_KRoba() })
AADD(opc, "3. promjena artikli, jed.mjere" )
AADD(opcexe, {|| P_K2Roba() })
AADD(opc, "4. promjene partneri" )
AADD(opcexe, {|| P_KPartn() })

Menu_SC("admin_sif")

return


// ------------------------------------------
// sifrarnik - admin, import sifrarnika
// ------------------------------------------
function imp_sif_params()
private opc:={}
private opcexe:={}
private Izbor:=1

AADD(opc, "1. txt import sifrarnika, parametri   " ) 
AADD(opcexe, {|| p_imp_parm() })

Menu_SC("imp_parm")

return


// ----------------------------------------
// otvaranje sifrarnika
// ----------------------------------------
static function _o_sif()

O_KKONTO
O_KROBA
O_K2ROBA
O_KPARTN
O_IMP_PARM
O_KONTO
O_ROBA
O_PARTN
O_SIFK
O_SIFV

return

// -----------------------------------------
// pregled __tmp tabele
// -----------------------------------------
function p__tmp( aShema, cId, dx, dy )
local i
local ii
private ImeKol := {}
private Kol := {}

O__TMP

for i:=1 to LEN(aShema)
	cFld := aShema[i, 1]
	AADD(ImeKol, { cFld, {|| &cFld }, cFld })
next
for ii:=1 to LEN( ImeKol )
	AADD( Kol, ii )
next

return PostojiSifra(F__TMP, 1, 16, 70, "Pomocna tabela importa - pregled", @cId, dx, dy)




// ------------------------------------------
// sifrarnik KKonto
// ------------------------------------------
function p_imp_parm(cId,dx,dy)
private ImeKol := {}
private Kol := {}

O_IMP_PARM

AADD(ImeKol,{ "sifr.", {|| id }, "id" , {|| .t.}, {|| .t.} })
AADD(ImeKol,{ "shema", {|| imp_sheme}, "imp_sheme", {|| .t.}, {|| .t.}  })
AADD(ImeKol,{ "br.polja", {|| fld_no}, "fld_no", {|| .t.}, {|| .t.}  })
AADD(ImeKol,{ "tip polja", {|| fld_type }, "fld_type", {|| .t.}, {|| .t.}  })
AADD(ImeKol,{ "naz polja", {|| fld_name }, "fld_name", {|| .t.}, {|| .t.}  })
AADD(ImeKol,{ "uslov", {|| PADR(imp_cond, 30) + ".." }, "imp_cond", {|| .t.}, {|| .t.} })

for i:=1 to LEN( ImeKol )
	AADD( Kol, i )
next

return PostojiSifra(F_IMP_PARM, 1, 12, 70, "Parametri: import txt", @cId, dx, dy)


// ------------------------------------------
// sifrarnik KKonto
// ------------------------------------------
function P_KKonto(cId,dx,dy)
private ImeKol
private Kol

O_KKONTO
set order to tag "BR"

ImeKol:={ { PADR("Stari ID",7),  {|| id },     "id"  , {|| .t.}, {|| vpkonto(@wId,@wNaz)} },;
          { "Novi Id",         {|| id2},     "id2"  },;
          { "Naziv",{|| padr(naz,40)},     "naz"      },;
          { "Status",      {|| status},  "status"   };
        }
Kol:={1,2,3,4}
return PostojiSifra(F_KKONTO,"BR",10,60,"Lista: Shema promjene: Konta ",@cId,dx,dy)

// ----------------------------------
// validacija PKOnto 
// ----------------------------------
function VPkonto(wId,wNaz)
local nLen:=len(wId)
local cPom:=""

cPom:=trim(wid)
select konto
seek cPom
if found()
 wNaz:=konto->naz
endif
select kkonto
wId:=cPom

wId:=padr(wid,nLen)

return .t.



// -------------------------------------
// K2ROBA, zamjena jmj
// -------------------------------------
function P_K2Roba(cId,dx,dy)
private ImeKol
private Kol

O_K2ROBA

ImeKol:={ { PADR("ID artikla",10),  {|| id },     "id", {|| .t.}, {|| vprobajmj(@wId,@wNaz) .and. vpsifra(wid)}    },;
          { "Nova JMJ",    {|| naz}    , "naz"      },;
          { "Kol.stare",   {|| nstare} , "nstare"   },;
          { "Kol.nove",    {|| nnove}  , "nnove"    },;
          { "Status",      {|| status},  "status"   };
        }
Kol:={1,2,3,4,5}
return PostojiSifra(F_K2ROBA,1,10,60,"Lista: Shema promjene JMJ artikala: ",@cId,dx,dy)


// --------------------------------------
// KPARTN, zamjena partneri
// --------------------------------------
function P_KPartn(cId,dx,dy)
private ImeKol
private Kol

O_KPARTN

ImeKol:={ { PADR("Stari ID",10),  {|| id },     "id", {|| .t.}, {|| vppartn(@wId,@wNaz) .and. vpsifra(wid)}    },;
          { "Novi Id",     {|| id2},     "id2" ,{|| .t.}, {|| vppartn2(@wid2,@wNaz)}     },;
          { "Naziv",       {|| naz},     "naz"      },;
          { "Status",      {|| status},  "status"      };
        }
Kol:={1,2,3,4}
return PostojiSifra(F_KPARTN,1,10,60,"Lista: Shema promjene sifara partnera ",@cId,dx,dy)


// ----------------------------------------
// KROBA, zamjena roba
// ----------------------------------------
function P_KRoba(cId,dx,dy)
private ImeKol
private Kol

O_KROBA

IF IzFMKINI('ADMIN','NoveSifreRobeDuple','N')=="N"
 ImeKol:={ { PADR("Stari ID",10),  {|| id },     "id", {|| .t.}, {|| vproba(@wId,@wNaz) .and. vpsifra(wid)}    },;
           { "Novi Id",     {|| id2},     "id2" ,{|| .t.}, {|| vproba2(@wid2,@wNaz)}     },;
           { "Naziv",       {|| naz},     "naz"      },;
           { "Status",      {|| status},  "status"      };
         }
ELSE
 ImeKol:={ { PADR("Stari ID",10),  {|| id },     "id", {|| .t.}, {|| vproba(@wId,@wNaz) .and. vpsifra(wid)}    },;
           { "Novi Id",     {|| id2},     "id2"      },;
           { "Naziv",       {|| naz},     "naz"      },;
           { "Status",      {|| status},  "status"      };
         }
ENDIF
Kol:={1,2,3,4}
return PostojiSifra(F_KROBA,1,10,70,"Lista: Shema promjene: Roba ",@cId,dx,dy,{|Ch| KRobaBlok(Ch)})


// -------------------------------
// key handler roba
// -------------------------------
function KRobaBlok(Ch)
if Ch==K_CTRL_F2
   Box(,3,70)
     private cKFormula:=padr("LEFT(ID,3)+RIGHT(TRIM(ID),2)",100)
     @ m_x+1, m_y+2 SAY "Zadaj formulu za formiranje parova:"
     @ m_x+2, m_y+2 GET cKFormula pict "@!S50"
     read
   Boxc()
   if lastkey()<>K_ESC .and. Pitanje(,"Zelite li formirati parove ?","N")=="D"
     select roba; go top
     do while !eof()
        select kroba
        append blank
        replace id with roba->id
        replace id2 with roba->(&cKFormula)
        select roba
        skip
     enddo
     select kroba
     retur DE_REFRESH
   endif

endif

RETURN DE_CONT

// -----------------------------------
// VPROBA, validacija ROBA
// -----------------------------------
function VPRoba(wId,wNaz)
local fRet:=.t.
local nLen:=len(wId)
local cPom:=""

if right(trim(wId),1)=="."  // ne gledaj sifre
  cPom:=trim(wid)
  cPom:=left(cPom,len(cPom)-1)
  select roba
  seek cPom
  select kroba
  wId:=cPom
else
  P_Roba(@wId)
endif
wId:=padr(wid,nLen)
wNaz:=roba->naz
return fret

// ---------------------------------------
// validacija ROBA->JMJ
// ---------------------------------------
function VPRobajmj(wId,wNaz)
local fRet:=.t.
local nLen:=len(wId)
local cPom:=""

if right(trim(wId),1)=="."  // ne gledaj sifre
  cPom:=trim(wid)
  cPom:=left(cPom,len(cPom)-1)
  select roba
  seek cPom
  select kroba
  wId:=cPom
else
  P_Roba(@wId)
endif
wId:=padr(wid,nLen)
if empty(wNaz); wnaz:=roba->jmj; endif
return fret


// ----------------------------------
// validacija ROBA2
// ----------------------------------
function VPRoba2(wid2)
local fRet:=.t.
select kroba; set order to tag "id2"
nTrec:=recno()
seek wid2
if found()  .and. recno()<>nTrec
  MsgBeep("Vec postoji ista ovakva nova sifra!")
  fRet:=.f.
endif
set order to tag "id"
go nTrec
return fret


// ------------------------------------------
// validacija PARTN
// ------------------------------------------
function VPPartn(wId,wNaz)
local fRet:=.t.
local nLen:=len(wId)
local cPom:=""

if right(trim(wId),1)=="."  // ne gledaj sifre
  cPom:=trim(wid)
  cPom:=left(cPom,len(cPom)-1)
  select partn
  seek cPom
  select kpartn
  wId:=cPom
else
  P_Firma(@wId)
endif
wId:=padr(wid,nLen)
wNaz:=partn->naz
return fret

// -------------------------------------------
// validacija PARTN2
// -------------------------------------------
function VPPartn2(wid2)
local fRet:=.t.
select kpartn; set order to tag "id2"
nTrec:=recno()
seek wid2
if found()  .and. recno()<>nTrec
  MsgBeep("Vec postoji ista ovakva nova sifra!")
  fRet:=.f.
endif
set order to tag "id"
go nTrec
return fret


// ---------------------------------------------------
// odsjeca Prazne Linije na Kraju stringa
// ---------------------------------------------------
function OdsjPLK(cTxt)
local i
for i:=len(cTxt) to 1 step -1
  if !(substr(cTxt,i,1) $ Chr(13)+Chr(10)+" ç")
       exit
  endif
next
return left(cTxt,i)


