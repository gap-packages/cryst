#############################################################################
##
#A  hom.gd                  CrystGap library                     Bettina Eick
#A                                                              Franz G"ahler
#A                                                              Werner Nickel
##
#Y  Copyright 1997-1999  by  Bettina Eick,  Franz G"ahler  and  Werner Nickel
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
