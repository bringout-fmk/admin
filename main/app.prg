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


/*! \fn TAdminModNew()
 *  \brief
 */

function TAdminModNew()
local oObj

#ifdef CLIP

#else
	oObj:=TAdminMod():new()
#endif

oObj:self:=oObj
return oObj


#ifdef CPP

/*! \class TAdminMod
 *  \brief ADMIN aplikacijski modul
 */

class TAdminMod: public TAppMod
{
	public:
	*void dummy();
	*void setGVars();
	*void mMenu();
	*void mMenuStandard();
	*void sRegg();
	*void initdb();
	*void srv();	
#endif

#ifndef CPP
#include "class(y).ch"
CREATE CLASS TAdminMod INHERIT TAppMod
	EXPORTED:
	method dummy 
	method setGVars
	method mMenu
	method mMenuStandard
	method sRegg
	method initdb
	method srv
END CLASS
#endif


/*! \fn TAdminMod::dummy()
 *  \brief dummy
 */

*void TAdminMod::dummy()
*{
method dummy()
return
*}


*void TAdminMod::initdb()
*{
method initdb()

::oDatabase:=TDBAdminNew()

return nil
*}


/*! \fn *void TAdminMod::mMenu()
 *  \brief Osnovni meni ADMIN modula
 */
*void TAdminMod::mMenu()
*{
method mMenu()

private Izbor
private lPodBugom

public gSQL:="N"

SETKEY(K_SH_F1,{|| Calc()})
Izbor:=1

//TrebaRegistrovati(10)
use

@ 1,2 SAY padc(gTS+": "+gNFirma,50,"*")
@ 4,5 SAY ""

::mMenuStandard()

::quit()

return nil
*}


*void TAdminMod::mMenuStandard()
*{
method mMenuStandard

private opc:={}
private opcexe:={}

AADD(opc,   "1. promjena kontnog plana                ")
AADD(opcexe, {|| KKonto2()} )
AADD(opc,   "2. promjena sifarskog sistema - robe")
AADD(opcexe, {|| KRoba()})
AADD(opc,   "3. promjena jedinica mjere artikala")
AADD(opcexe, {|| K2Roba()})
AADD(opc,   "4. promjena sifarskog sistema - partneri")
AADD(opcexe, {|| KPartn()})
AADD(opc,   "5. import txt -> tbl ")
AADD(opcexe, {|| txt_2_tbl() })
AADD(opc,   "-----------------------------------------")
AADD(opcexe, {|| nil })
AADD(opc,   "8. administriranje baze podataka") 
AADD(opcexe, {|| goModul:oDataBase:install()})
AADD(opc,   "-----------------------------------------")
AADD(opcexe, {|| nil })
AADD(opc,   "9. sifrarnici")
AADD(opcexe, {|| mnu_sif()})
AADD(opc,   "-----------------------------------------")
AADD(opcexe, {|| nil })
AADD(opc,   "A. parametri")
AADD(opcexe, {|| pars()})
AADD(opc,   "B. osvjezavanje verzija")
AADD(opcexe, {|| OsvjeziV()})

private Izbor:=1

Menu_SC( "gadm", .t. )

return


*void TAdminMod::sRegg()
*{
method sRegg()
sreg("ADMIN.EXE","ADMIN")
return
*}


*void TAdminMod::srv()
*{
method srv()
? "Pokrecem ADMIN aplikacijski server"
if (MPar37("/KONVERT", goModul))
	if LEFT(self:cP5,3)=="/S="
		cKonvSez:=SUBSTR(self:cP5,4)
		? "Radim sezonu: " + cKonvSez
		if cKonvSez<>"RADP"
			// prebaci se u sezonu cKonvSez
			goModul:oDataBase:cSezonDir:=SLASH+cKonvSez
 			goModul:oDataBase:setDirKum(trim(goModul:oDataBase:cDirKum)+SLASH+cKonvSez)
 			goModul:oDataBase:setDirSif(trim(goModul:oDataBase:cDirSif)+SLASH+cKonvSez)
 			goModul:oDataBase:setDirPriv(trim(goModul:oDataBase:cDirPriv)+SLASH+cKonvSez)
		endif
	endif
	goModul:oDataBase:KonvZN()
	goModul:quit(.f.)
endif
return
*}


/*! \fn *void TAdminMod::setGVars()
 *  \brief opste funkcije Admin modula
 */
*void TAdminMod::setGVars()
*{
method setGVars()
O_PARAMS

::super:setTGVars()

SetFmkRGVars()

SetFmkSGVars()

SetSpecifVars()

O_PARAMS

private cSection:="("
private cHistory:=" "
private aHistory:={}

public gFinKum:=""
public gFinPri:=""

public gKalkKum:=""
public gKalkPri:=""

public gFaktKum:=""
public gFaktPri:=""

public gVirmKum:=""
public gVirmPri:=""

public gOsKum:=""
public gOsPri:=""

public gTopsKum:=""
public gTopsPri:=""

public gHopsKum:=""
public gHopsPri:=""

public gEPDVKum:=""
public gEPDVPri:=""

public gScData:="C:\SCDATA"

Rpar("e1",@gEPDVKum)
Rpar("e2",@gEPDVPri)

Rpar("f1",@gFinKum)
Rpar("f2",@gFinPri)

Rpar("k1",@gKalkKum)
Rpar("k2",@gKalkPri)

Rpar("a1",@gFaktKum)
Rpar("a2",@gFaktPri)

Rpar("v1",@gVirmKum)
Rpar("v2",@gVirmPri)

Rpar("o1",@gOsKum)
Rpar("o2",@gOsPri)

Rpar("t1",@gTopsKum)
Rpar("t2",@gTopsPri)

Rpar("h1",@gHopsKum)
Rpar("h2",@gHopsPri)

Rpar("D1",@gScData)

select params
use
release cSection, cHistory, aHistory

return



