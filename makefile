
liball: 
	make -C main
	make -C db
	make -C db
	make -C sif
	make -C ut
	make -C imp
	make -C 1g exe
	
cleanall:	
	make -C main clean
	make -C db clean
	make -C db clean
	make -C sif clean
	make -C ut clean
	make -C imp clean
	make -C 1g clean

admin: cleanall liball

