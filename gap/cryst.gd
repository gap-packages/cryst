#############################################################################
##
#A  cryst.gd                CrystGap library                     Bettina Eick
#A                                                              Franz G"ahler
#A                                                              Werner Nickel
##
#Y  Copyright 1990-1997,  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
##
##  The main declarations
##  

#############################################################################
##
##  Identification and construction of affine crystallographic groups
##
#############################################################################

#############################################################################
##
#P  IsAffineCrystGroupOnRight( <S> )  . . . . AffineCrystGroup acting OnRight
##
DeclareProperty( "IsAffineCrystGroupOnRight", IsCyclotomicMatrixGroup );

#############################################################################
##
#P  IsAffineCrystGroupOnLeft( <S> ) . . . . .  AffineCrystGroup acting OnLeft
##
DeclareProperty( "IsAffineCrystGroupOnLeft", IsCyclotomicMatrixGroup );

#############################################################################
##
#P  IsAffineCrystGroupOnLeftOrRight( <S> )  . . . . . AffineCrystGroup acting 
#P  . . . . . . . . . . . . . . . . . . . . . . . .  either OnLeft or OnRight
##
DeclareProperty( "IsAffineCrystGroupOnLeftOrRight",IsCyclotomicMatrixGroup );

#############################################################################
##
#P  IsAffineCrystGroup( <S> ) . . . . . . . . . . . . AffineCrystGroup acting
#P  . . . . . . . . . . . . . . . . . as specified by CrystGroupDefaultAction
##
DeclareGlobalFunction( "IsAffineCrystGroup" );

#############################################################################
##
#F  AffineCrystGroupOnRight( <gens> ) . . . . . . . . . . . . . . . . . . . .
#F  AffineCrystGroupOnRight( <genlist> )  . . . . . . . . . . . . . . . . . .
#F  AffineCrystGroupOnRight( <genlist>, <identity> )  . . . . . . constructor
##
DeclareGlobalFunction( "AffineCrystGroupOnRight" );

#############################################################################
##
#F  AffineCrystGroupOnLeft( <gens> )  . . . . . . . . . . . . . . . . . . . .
#F  AffineCrystGroupOnLeft( <genlist> ) . . . . . . . . . . . . . . . . . . .
#F  AffineCrystGroupOnLeft( <genlist>, <identity> ) . . . . . . . constructor
##
DeclareGlobalFunction( "AffineCrystGroupOnLeft" );

#############################################################################
##
#F  AffineCrystGroup( <gens> )  . . . . . . . . . . . . . . . . . . . . . . .
#F  AffineCrystGroup( <genlist> ) . . . . . . . . . . . . . . . . . . . . . .
#F  AffineCrystGroup( <genlist>, <identity> ) . . . . . . . . . . constructor
##
DeclareGlobalFunction( "AffineCrystGroup" );

#############################################################################
##
#F  AsAffineCrystGroupOnRight( <S> ) . . . . . . . . . . convert matrix group
##
DeclareGlobalFunction( "AsAffineCrystGroupOnRight" );

#############################################################################
##
#F  AsAffineCrystGroupOnLeft( <S> ) . . . . . . . . . .  convert matrix group
##
DeclareGlobalFunction( "AsAffineCrystGroupOnLeft" );

#############################################################################
##
#F  AsAffineCrystGroup( <S> ) . . . . . . . . . . . . .  convert matrix group
##
DeclareGlobalFunction( "AsAffineCrystGroup" );


#############################################################################
##
##  Utility functions
##
#############################################################################

#############################################################################
##
#F  IsAffineMatrixOnRight( <mat> ) . . . . . . . affine matrix action OnRight
##
DeclareGlobalFunction( "IsAffineMatrixOnRight" );

#############################################################################
##
#F  IsAffineMatrixOnLeft( <mat> ) . . . . . . . . affine matrix action OnLeft
##
DeclareGlobalFunction( "IsAffineMatrixOnLeft" );


#############################################################################
##
##  Properties and Attributes for matrix groups 
##  (AffineCrystGroups or PointGroups)
##
#############################################################################

#############################################################################
##
#P  IsSpaceGroup( <S> )  . . . . . . . . . . . . . . . .  is S a space group?
##
DeclareProperty( "IsSpaceGroup", IsCyclotomicMatrixGroup );

#############################################################################
##
#P  IsStandardAffineCrystGroup( <S> ) . . . AffineCrystGroup in standard form
##
DeclareProperty( "IsStandardAffineCrystGroup", IsCyclotomicMatrixGroup );

#############################################################################
##
#P  IsStandardSpaceGroup( <S> )  . . . . . . . .space group in standard form?
##
DeclareSynonym( "IsStandardSpaceGroup", 
                IsSpaceGroup and IsStandardAffineCrystGroup );

#############################################################################
##
#P  IsSymmorphicSpaceGroup( <S> ) . . . . . . . . . . . . . .is S symmorphic? 
##
DeclareProperty( "IsSymmorphicSpaceGroup", IsCyclotomicMatrixGroup);

#############################################################################
##
#P  IsPointGroup( <P> ) . . . . . . . . . . PointGroup of an AffineCrystGroup
##
DeclareProperty( "IsPointGroup", IsCyclotomicMatrixGroup );

#############################################################################
##
#A  NormalizerPointGroupInGLnZ( <P> ) . . . . . . .Normalizer of a PointGroup
##
DeclareAttribute( "NormalizerPointGroupInGLnZ", IsPointGroup );

#############################################################################
##
#A  CentralizerPointGroupInGLnZ( <P> ) . . . . . .Centralizer of a PointGroup
##
DeclareAttribute( "CentralizerPointGroupInGLnZ", IsPointGroup );

#############################################################################
##
#A  AffineCrystGroupOfPointGroup( <P> ) . .  AffineCrystGroup of a PointGroup
##
DeclareAttribute( "AffineCrystGroupOfPointGroup", IsPointGroup );


#############################################################################
##
##  Properties and Attributes for AffineCrystGroups
##
#############################################################################

#############################################################################
##
#A  TransposedAffineCrystGroup( <S> ) . . . . . transpose of AffineCrystGroup
##
DeclareAttribute( "TransposedAffineCrystGroup",
                  IsAffineCrystGroupOnLeftOrRight );

#############################################################################
##
#A  PointGroup( <S> ) . . . . . . . . . . . PointGroup of an AffineCrystGroup
##
DeclareAttribute( "PointGroup", IsAffineCrystGroupOnLeftOrRight );

#############################################################################
##
#A  PointHomomorphism( <S> ) . . . . PointHomomorphism of an AffineCrystGroup
##
DeclareAttribute( "PointHomomorphism", IsAffineCrystGroupOnLeftOrRight );

#############################################################################
##
#A  TranslationBasis( <S> )  . . . . . . . . . . basis of translation lattice
##
DeclareAttribute( "TranslationBasis", IsAffineCrystGroupOnLeftOrRight );

#############################################################################
##
#F  AddTranslationBasis( <S>, <T> )  . . . . add basis of translation lattice
##
DeclareGlobalFunction( "AddTranslationBasis" );

#############################################################################
##
#A  CheckTranslationBasis( <S> ) . . . . . check basis of translation lattice
##
DeclareGlobalFunction( "CheckTranslationBasis" );

#############################################################################
##
#A  InternalBasis( <S> )  . . . . . . . . . . . . . . . . . . .internal basis
##
DeclareAttribute( "InternalBasis", IsAffineCrystGroupOnLeftOrRight );

#############################################################################
##
#A  TransParts( <S> ) . . . . . translation parts (reduced modulo lattice) of
##  . . . . . . . . . . . . . . . . . . . . .GeneratorsSmallest of PointGroup
##
DeclareAttribute( "TransParts", IsAffineCrystGroupOnLeftOrRight );

#############################################################################
##
#A  TranslationNormalizer( <S> ) . . . . . . . . . . translational normalizer
##
DeclareAttribute( "TranslationNormalizer", IsAffineCrystGroupOnLeftOrRight );

#############################################################################
##
#A  AffineNormalizer( <S> ) . . . . . . . . . . . . . . . . affine normalizer
##
DeclareAttribute( "AffineNormalizer", IsAffineCrystGroupOnLeftOrRight );

#############################################################################
##
#F  StandardAffineCrystGroup( <S> ) . . . . . . . . . change basis to std rep
##
DeclareGlobalFunction( "StandardAffineCrystGroup" );

#############################################################################
##
#F  AffineInequivalentSubgroups( <S>, <subs> ) reps of affine ineq. subgroups
##
DeclareGlobalFunction( "AffineInequivalentSubgroups" );




