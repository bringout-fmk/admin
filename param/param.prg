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


// -----------------------------------------
// parametri modula
// -----------------------------------------
function pars()

// FIN
_set_dir( @gFinKum, "FIN", cDirRad )
_set_dir( @gFinPri, "FIN", cDirPriv )

// KALK
_set_dir( @gKalkKum, "KALK", cDirRad )
_set_dir( @gKalkPri, "KALK", cDirPriv )

// FAKT
_set_dir( @gFaktKum, "FAKT", cDirRad )
_set_dir( @gFaktPri, "FAKT", cDirPriv )

// OS
_set_dir( @gOSKum, "OS", cDirRad )
_set_dir( @gOsPri, "OS", cDirPriv )

// VIRM
_set_dir( @gVirmKum, "VIRM", cDirRad )
_set_dir( @gVirmPri, "VIRM", cDirPriv )

// TOPS
_set_dir( @gTopsKum, "TOPS", cDirRad )
_set_dir( @gTopsPri, "TOPS", cDirPriv )

// HOPS
_set_dir( @gHopsKum, "HOPS", cDirRad )
_set_dir( @gHopsPri, "HOPS", cDirPriv )

// EPDV
_set_dir( @gEPDVKum, "EPDV", cDirRad )
_set_dir( @gEPDVPri, "EPDV", cDirPriv )

Box(,22,70)
 
 set cursor on
 gFinKum:=padr(gFinKum,30)
 gFinPri:=padr(gFinPri,30)
 
 @ m_x+1,m_y+2  SAY "FIN  Kumulativ:" GET gFinKum pict "@!"
 @ m_x+2,m_y+2  SAY "FIN  Priv     :" GET gFinPri pict "@!"

 gKalkKum:=padr(gKalkKum,30)
 gKalkPri:=padr(gKalkPri,30)
 
 @ m_x+3,m_y+2  SAY "KALK Kumulativ:" GET gKalkKum pict "@!"
 @ m_x+4,m_y+2  SAY "KALK Priv     :" GET gKalkPri pict "@!"

 gFaktKum:=padr(gFaktKum,30)
 gFaktPri:=padr(gFaktPri,30)
 @ m_x+5,m_y+2  SAY "Fakt Kumulativ:" GET gFaktKum pict "@!"
 @ m_x+6,m_y+2  SAY "Fakt Priv     :" GET gFaktPri pict "@!"

 gVirmKum:=padr(gVirmKum,30)
 gVirmPri:=padr(gVirmPri,30)
 @ m_x+7,m_y+2  SAY "Virm Kumulativ:" GET gVirmKum pict "@!"
 @ m_x+8,m_y+2  SAY "Virm Priv     :" GET gVirmPri pict "@!"

 gOSKum:=padr(gOSKum,30)
 gOSPri:=padr(gOSPri,30)
 @ m_x+9,m_y+2  SAY "OS   Kumulativ:" GET gOSKum pict "@!"
 @ m_x+10,m_y+2 SAY "OS   Priv     :" GET gOSPri pict "@!"

 gTopsKum:=padr(gTopsKum,30)
 gTopsPri:=padr(gTopsPri,30)
 @ m_x+11,m_y+2  SAY "TOPS Kumulativ:" GET gTopsKum pict "@!"
 @ m_x+12,m_y+2 SAY "TOPS Priv     :" GET gTopsPri pict "@!"

 gHopsKum:=padr(gHopsKum,30)
 gHopsPri:=padr(gHopsPri,30)
 @ m_x+13,m_y+2  SAY "Hops Kumulativ:" GET gHopsKum pict "@!"
 @ m_x+14,m_y+2 SAY "Hops Priv     :" GET gHopsPri pict "@!"
 
 gEPDVKum:=padr(gEPDVKum,30)
 gEPDVPri:=padr(gEPDVPri,30)
 @ m_x+15,m_y+2  SAY "ePDV Kumulativ:" GET gEPDVKum pict "@!"
 @ m_x+16,m_y+2 SAY "ePDV Priv     :" GET gEPDVPri pict "@!"


 gScData:=padr(gScData,30)
 @ m_x+18,m_y+2 SAY "SC Data       :" GET gScData pict "@!"


 read

 gFinKum:=trim(gFinKum)
 gFinPri:=trim(gFinPri)

 gKalkKum:=trim(gKalkKum)
 gKalkPri:=trim(gKalkPri)

 gFaktKum:=trim(gFaktKum)
 gFaktPri:=trim(gFaktPri)

 gVirmKum:=trim(gVirmKum)
 gVirmPri:=trim(gVirmPri)

 gOSKum:=trim(gOSKum)
 gOSPri:=trim(gOSPri)

 gTopsKum:=trim(gTopsKum)
 gTopsPri:=trim(gTopsPri)

 gHopsKum:=trim(gHopsKum)
 gHopsPri:=trim(gHopsPri)

 gEPDVKum:=trim(gEPDVKum)
 gEPDVPri:=trim(gEPDVPri)

BoxC()

if lastkey()<>K_ESC
   
   O_PARAMS
   private cSection:="("
   private cHistory:=" "
   private aHistory:={}

   WPar("f1",@gFinKum)
   WPar("f2",@gFinPri)

   WPar("k1",@gKalkKum)
   WPar("k2",@gKalkPri)

   WPar("a1",@gFaktKum)
   WPar("a2",@gFaktPri)

   WPar("v1",@gVirmKum)
   WPar("v2",@gVirmPri)

   WPar("o1",@gOsKum)
   WPar("o2",@gOsPri)

   WPar("t1",@gTopsKum)
   WPar("t2",@gTopsPri)

   WPar("h1",@gHopsKum)
   WPar("h2",@gHopsPri)

   WPar("e1",@gEPDVKum)
   WPar("e2",@gEPDVPri)

   Wpar("D1",@gScData)
   
   select params
   use
   
endif

closeret


// ------------------------------------------------------------
// setovanje direktorija
// cDir - direktorij koji se setuje, proslijeduje se po ref.
// cModul - koji modul FIN, FAKT, ...
// cTmpDir - prema kojem direktoriju PRIVPATH, KUMPATH...
// ------------------------------------------------------------
static function _set_dir( cDir, cModul, cTmpDir )
if EMPTY( cDir )
	cDir := STRTRAN( cTmpDir, "ADMIN", cModul ) + "\"
endif
return .t.


