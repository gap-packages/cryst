#############################################################################
##
#A  read.g                  CrystGap library                     Bettina Eick
#A                                                              Franz G"ahler
#A                                                              Werner Nickel
##
#Y  Copyright 1990-1997,  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
##
##              CrystGap - the crystallographic groups package
##  
##                            GAP 4 Version
##

#############################################################################
##
#R  read the general stuff for integer matrix groups
##
ReadPkg( "cryst/gap/common.gi" );  # routines for integral matrices

#############################################################################
##
#R  read the crystallographic groups specific functions
##
ReadPkg( "cryst/gap/hom.gi" );     # methods for PointHomomorphisms
ReadPkg( "cryst/gap/cryst.gi" );   # methods for CrystGroups
ReadPkg( "cryst/gap/cryst2.gi" );  # more methods for CrystGroups
ReadPkg( "cryst/gap/fpgrp.gi" );   # FpGroup for CrystGroups and PointGroups
ReadPkg( "cryst/gap/zass.gi" );    # methods for Zassenhaus algorithm
ReadPkg( "cryst/gap/max.gi" );     # methods for maximal subgroups
ReadPkg( "cryst/gap/wyckoff.gi" ); # methods for Wyckoff positions
ReadPkg( "cryst/gap/color.gi" );   # methods for color groups

if IsBound( LOADED_PACKAGES.xgap ) then
   ReadPkg("cryst/gap/wypopup.gi");  # popup menu for Wyckoff graph
   ReadPkg("cryst/gap/wygraph.gi");  # Wyckoff graph methods; needs XGAP
fi;

#############################################################################
##
#R  read the orbit stabilizer methods
##
ReadPkg( "cryst/gap/infstab.gi" ); # Stabilizer without membership test
ReadPkg( "cryst/gap/orbstab.gi" ); # Orbit, Stabilizer & Co.
ReadPkg( "cryst/gap/equiv.gi" );   # conjugator between space groups

#############################################################################
##
#R  load the space group catalogue
##
ReadPkg( "cryst/grp/grp2D.gi" );   # the 2D space groups
ReadPkg( "cryst/grp/grp3D.gi" );   # the 3D space groups
ReadPkg( "cryst/grp/grps.gi" );    # access function
ReadPkg( "cryst/grp/grpE68.gi" );  # the groups E6 and E8

#############################################################################
##
#R  load the new IT space group catalogue
##
ReadPkg( "cryst/grp/spacegrps.grp" ); # the catalogue
ReadPkg( "cryst/grp/spacegrps.gi" );  # access functions
