#############################################################################
##
#A  zass.gd                 CrystGap library                     Bettina Eick
#A                                                              Franz G"ahler
#A                                                              Werner Nickel
##
#Y  Copyright 1990-1997,  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
##
##  Routines for the determination of space groups for a given a point group
##

#############################################################################
##
#F  SpaceGroupsByPointGroupOnRight( <grp> [, <norm>] ) . . . . .compute group
#F     . . . . . extensions, inequivalent by conjugation with elems from norm
##
DeclareGlobalFunction( "SpaceGroupsByPointGroupOnRight" );

#############################################################################
##
#F  SpaceGroupsByPointGroupOnLeft( <grp> [, <norm>] ) . . . . . compute group
#F     . . . . . extensions, inequivalent by conjugation with elems from norm
##
DeclareGlobalFunction( "SpaceGroupsByPointGroupOnLeft" );

#############################################################################
##
#F  SpaceGroupsByPointGroup( <grp> [, <norm>] ) . . compute group extensions,
#F     . . . . . . . . . . . inequivalent by conjugation with elems from norm
##
DeclareGlobalFunction( "SpaceGroupsByPointGroup" );

#############################################################################
##
#F  SpaceGroupTypesByPointGroupOnRight( <G> ) . . . . . space group type reps
##
DeclareGlobalFunction( "SpaceGroupTypesByPointGroupOnRight" );

#############################################################################
##
#F  SpaceGroupTypesByPointGroupOnLeft( <G> ) . . . . . .space group type reps
##
DeclareGlobalFunction( "SpaceGroupTypesByPointGroupOnLeft" );

#############################################################################
##
#F  SpaceGroupTypesByPointGroup( <G> ) . . . . . . . . .space group type reps
##
DeclareGlobalFunction( "SpaceGroupTypesByPointGroup" );

