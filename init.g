#############################################################################
##
#A  init.g                  CrystGap library                     Bettina Eick
#A                                                              Franz Gaehler
#A                                                              Werner Nickel
##
#Y  Copyright 1990-1997,  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
##
##               Cryst - the crystallographic groups package
##  
##                            GAP 4 Version
##

DeclareAutoPackage( "cryst", "4.1.1", ReturnTrue );
DeclarePackageAutoDocumentation( "cryst", "doc" );

#############################################################################
##
#R  read the declaration files
##
ReadPkg( "cryst", "gap/cryst.gd" );    # declarations for AffineCrystGroups
ReadPkg( "cryst", "gap/hom.gd" );      # declarations for homomorphism
ReadPkg( "cryst", "gap/wyckoff.gd" );  # declarations for Wyckoff position
ReadPkg( "cryst", "gap/zass.gd" );     # declarations for Zassenhaus alg.
ReadPkg( "cryst", "gap/max.gd" );      # declarations for maximal subgroups
ReadPkg( "cryst", "gap/color.gd" );    # declarations for color groups
ReadPkg( "cryst", "gap/equiv.gd" );    # isomorphism test for space groups
ReadPkg( "cryst", "grp/spacegrp.gd" ); # the IT space group catalogue

#############################################################################
##
#R  try to load some other packages; 
#R  do not complain if they are not available
#R  this is needed only before GAP 4.4
##
if not IsBound( GAPInfo ) then
  if TestPackageAvailability( "carat", "1.0" ) <> fail then
    RequirePackage( "carat" );
  fi;
  if TestPackageAvailability( "polycyclic", "1.0" ) <> fail then
    RequirePackage( "polycyclic" );
  fi;
fi;
