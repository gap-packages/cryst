#############################################################################
##
#A  hom.gd                  CrystGap library                     Bettina Eick
#A                                                              Franz G"ahler
#A                                                              Werner Nickel
##
#Y  Copyright 1990-1997,  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
##

#############################################################################
##
#A  IsPointHomomorphism . . . . . . . . . . . . . . . . . IsPointHomomorphism
##
DeclareProperty( "IsPointHomomorphism", IsGroupGeneralMappingByImages );

#############################################################################
##
#A  NiceToCryst . . . . . . .Lift from NiceObject of PointGroup to CrystGroup 
##
DeclareAttribute( "NiceToCryst", IsPointGroup );

#############################################################################
##
#F  NiceToCrystStdRep( P, perm )
##
DeclareGlobalFunction( "NiceToCrystStdRep" );
