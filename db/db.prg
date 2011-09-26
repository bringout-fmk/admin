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
 
function TDbAdminNew()
*{
local oObj
oObj:=TDbAdmin():new()
oObj:self:=oObj
oObj:cName:="ADMIN"
oObj:lAdmin:=.f.
return oObj
*}

/*! \file fmk/admin/db/2g/db.prg
 *  \brief admin Database
 *
 * TDbAdmin Database objekat 
 */


/*! \class TDbAdmin
 *  \brief Database objekat
 */


#ifdef CPP
class TDbAdmin: public TDB 
{
     public:
     	TObject self;
	string cName;
	*void dummy();
	*void install(string cKorisn,string cSifra,variant p3,variant p4,variant p5,variant p6,variant p7);
	*void setgaDBFs();
	*void obaza(int i);
	*void ostalef();
	*void kreiraj(int nArea);
}
#endif

#ifndef CPP
#include "class(y).ch"
CREATE CLASS TDbAdmin INHERIT TDB

	EXPORTED:
	var    self
	var    cName
	method install	
	method setgaDBFs	
	method ostalef	
	method obaza	
	method kreiraj	
	
END CLASS
#endif


/*! \fn *void TDbAdmin::dummy()
 */
*void TDbAdmin::dummy()
*{
method dummy
return
*}


/*! \fn *void TDbAdmin::setgaDbfs()
 *  \brief Setuje matricu gaDbfs 
 */
*void TDbAdmin::setgaDbfs()
*{
method setgaDBFs()

public gaDbfs := {;
{ F_KROBA   ,"KROBA"  ,  P_SIFPATH     },;
{ F_K2ROBA  ,"K2ROBA" ,  P_SIFPATH     },;
{ F_KKONTO  ,"KKONTO" ,  P_SIFPATH     },;
{ F_IMP_PARM  ,"IMP_PARM" ,  P_SIFPATH     },;
{ F_KPARTN  ,"KPARTN" ,  P_SIFPATH     };
}

return
*}


/*! \fn *void TDbAdmin::install(string cKorisn,string cSifra,variant p3,variant p4,variant p5,variant p6,variant p7)
 *  \brief osnovni meni za instalacijske procedure
 */

*void TDbAdmin::install(string cKorisn,string cSifra,variant p3,variant p4,variant p5,variant p6,variant p7)
*{

method install(cKorisn,cSifra,p3,p4,p5,p6,p7)
	ISC_START(goModul,.f.)
return
*}

/*! \fn *void TDbAdmin::kreiraj(int nArea)
 *  \brief kreirane baze podataka ADMIN-a
 */
 
*void TDbAdmin::kreiraj(int nArea)
*{
method kreiraj(nArea)

if (nArea==nil)
	nArea:=-1
endif

if (nArea<>-1)
	CreSystemDb(nArea)
endif

CreFMKSvi()
CreRoba()

aDBf:={}
AADD(aDBf,{ 'ID'                  , 'C' ,  10 ,  0 })
AADD(aDBf,{ 'NAZ'                 , 'C' ,  40 ,  0 })
AADD(aDBf,{ 'ID2'                 , 'C' ,  10 ,  0 })
AADD(aDBf,{ 'Status'              , 'C' ,   1 ,  0 })
if !file( SIFPATH+'Kroba.DBF' )
 DBCREATE2(SIFPATH+'Kroba.DBF',aDbf)
endif
CREATE_INDEX("ID","id",SIFPATH+"KROBA")
CREATE_INDEX("ID2","id2",SIFPATH+"KROBA")
CREATE_INDEX("NAZ","NAZ",SIFPATH+"KROBA")


aDBf:={}
AADD(aDBf,{ 'ID'                  , 'C' ,  10 ,  0 })
AADD(aDBf,{ 'NAZ'                 , 'C' ,   3 ,  0 })
AADD(aDBf,{ 'NSTARE'              , 'N' ,   5 ,  0 })
AADD(aDBf,{ 'NNOVE'               , 'N' ,   5 ,  0 })
AADD(aDBf,{ 'STATUS'              , 'C' ,   1 ,  0 })
if !file(SIFPATH+"K2ROBA.DBF")
   DBCREATE2(SIFPATH+'K2ROBA.DBF',aDbf)
endif
CREATE_INDEX("ID","id",SIFPATH+"K2ROBA")
CREATE_INDEX("NAZ","NAZ",SIFPATH+"K2ROBA")

if !file(SIFPATH+"KPARTN.DBF")
  aDBf:={}
   aDBf:={}
   AADD(aDBf,{ 'ID'                  , 'C' ,   6 ,  0 })
   AADD(aDBf,{ 'NAZ'                 , 'C' ,  25 ,  0 })
   AADD(aDBf,{ 'ID2'                 , 'C' ,   6 ,  0 })
   AADD(aDBf,{ 'STATUS'              , 'C' ,   1 ,  0 })
   DBCREATE2(SIFPATH+'KPARTN.DBF',aDbf)
endif
CREATE_INDEX("ID","id",SIFPATH+"KPARTN")
CREATE_INDEX("ID2","id2",SIFPATH+"KPARTN")
CREATE_INDEX("NAZ","NAZ",SIFPATH+"KPARTN")

aDBf:={}
AADD(aDBf,{ 'ID'                  , 'C' ,   7 ,  0 })
AADD(aDBf,{ 'NAZ'                 , 'C' ,  57 ,  0 })
AADD(aDBf,{ 'ID2'                 , 'C' ,   7 ,  0 })
AADD(aDBf,{ 'Status'              , 'C' ,   1 ,  0 })
if !file(SIFPATH+"kkonto.dbf")
   DBCREATE2(SIFPATH+'KKONTO.DBF',aDbf)
endif
CREATE_INDEX("ID","id",SIFPATH+"KKONTO")
CREATE_INDEX("ID2","id2",SIFPATH+"KKONTO")
CREATE_INDEX("BR","id+id2",SIFPATH+"KKONTO")
CREATE_INDEX("NAZ","NAZ",SIFPATH+"KKONTO")

// IMP_PARM
aDBf:={}
AADD(aDBf,{ 'ID'                  , 'C' ,   8 ,  0 })
AADD(aDBf,{ 'IMP_SHEME'           , 'C' ,   2 ,  0 })
AADD(aDBf,{ 'IMP_COND'            , 'C' , 200 ,  0 })
AADD(aDBf,{ 'FLD_TYPE'            , 'C' ,  10 ,  0 })
AADD(aDBf,{ 'FLD_NO'              , 'N' ,   3 ,  0 })
AADD(aDBf,{ 'FLD_NAME'            , 'C' ,  20 ,  0 })
if !FILE(SIFPATH+"IMP_PARM.DBF")
	DBCREATE2(SIFPATH+'IMP_PARM.DBF',aDbf)
endif
CREATE_INDEX( "1" , "ID+IMP_SHEME+STR(FLD_NO,3)", SIFPATH + "IMP_PARM" )

return


/*! \fn *void TDbAdmin::obaza(int i)
 *  \brief otvara odgovarajucu tabelu
 *  
 *      
 */

*void TDbAdmin::obaza(int i)
*{

method obaza(i)

local lIdIDalje
local cDbfName

lIdiDalje:=.f.

if i==F_KROBA .or. i==F_KKONTO .or. i==F_K2ROBA .or. i==F_KPARTN .or. i==F_IMP_PARM 
	lIdiDalje:=.t.
endif

if lIdiDalje
	cDbfName:=DBFName(i,.t.)
	if gAppSrv 
		? "OPEN: " + cDbfName + ".DBF"
		if !File(cDbfName + ".DBF")
			? "Fajl " + cDbfName + ".dbf ne postoji!!!"
			use
			return
		endif
	endif
	
	select(i)
	usex(cDbfName)
else
	use
	return
endif

return
*}

/*! \fn *void TDbAdmin::ostalef()
 *  \brief Ostalef funkcije (bivsi install modul)
 *  \note  sifra: SIGMAXXX
*/

*void TDbAdmin::ostalef()
*{
method ostalef()

return
*}


