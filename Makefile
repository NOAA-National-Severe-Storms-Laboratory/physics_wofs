.SUFFIXES: .F .F90 .o

.PHONY: physics_wofs physics_wofs_lib

all: dummy physics_wofs

dummy:
	echo "****** compiling physics_wofs ******"

OBJS = \
	bl_shinhong.o \
	module_bl_shinhong.o

physics_wofs: $(OBJS)

physics_wofs_lib:
	ar -ru ./../libphys.a $(OBJS)

# DEPENDENCIES:
module_bl_shinhong.o: \
	bl_shinhong.o

clean:
	$(RM) *.f90 *.o *.mod
	@# Certain systems with intel compilers generate *.i files
	@# This removes them during the clean process
	$(RM) *.i

# Cancel the built-in implicit rule for Modula-2 files (.mod) to avoid having
# make try to create .o files from Fortran .mod files
%.o : %.mod

.F.o:
ifeq "$(GEN_F90)" "true"
	$(CPP) $(CPPFLAGS) $(COREDEF) $(CPPINCLUDES) $< > $*.f90
	$(FC) $(FFLAGS) -c $*.f90 $(FCINCLUDES) -I.. -I../../../framework -I../../../external/esmf_time_f90 $(MPAS_ESMF_INC)
else
	$(FC) $(CPPFLAGS) $(COREDEF) $(FFLAGS) -c $*.F $(CPPINCLUDES) $(FCINCLUDES) -I.. -I../../../framework -I../../../external/esmf_time_f90 $(MPAS_ESMF_INC)
endif

.F90.o:
ifeq "$(GEN_F90)" "true"
	$(CPP) $(CPPFLAGS) $(COREDEF) $(CPPINCLUDES) $< > $*.f90
	$(FC) $(FFLAGS) -c $*.f90 $(FCINCLUDES) -I.. -I../../../framework -I../../../external/esmf_time_f90 $(MPAS_ESMF_INC)
else
	$(FC) $(CPPFLAGS) $(COREDEF) $(FFLAGS) -c $*.F90 $(CPPINCLUDES) $(FCINCLUDES) -I.. -I../../../framework -I../../../external/esmf_time_f90 $(MPAS_ESMF_INC)
endif
