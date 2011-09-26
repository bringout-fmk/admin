#include "admin.ch"

EXTERNAL RIGHT,LEFT,FIELDPOS

#ifdef LIB
function Main(cKorisn,cSifra,p3,p4,p5,p6,p7)
	MainAdmin(cKorisn,cSifra,p3,p4,p5,p6,p7)
return
#endif



function MainAdmin(cKorisn,cSifra,p3,p4,p5,p6,p7)
local oAdmin

oAdmin:=TAdminModNew()
cModul:="ADMIN"

PUBLIC goModul

goModul:=oAdmin
oAdmin:init(NIL, cModul, D_ADMIN_VERZIJA, D_ADMIN_PERIOD , cKorisn, cSifra, p3,p4,p5,p6,p7)

oAdmin:run()

return 

