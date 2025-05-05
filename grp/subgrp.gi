#############################################################################
##
#A  subgrp.gi                 Cryst library                     Bernard Field
##
#Y  Copyright 1997-1999  by  Bettina Eick,  Franz G"ahler  and  Werner Nickel
#Y  Copyright 2023  by  Bernard Field
##
##  Extraction functions for IT subperiodic groups
##

#############################################################################
##
#M  SubPeriodicGroupSettingsIT . .available settings of IT subperiodic groups
##
InstallGlobalFunction( SubPeriodicGroupSettingsIT, function( type, nr )
   if   type = "Frieze" then
      if nr in [1..7] then
         return List( RecNames( FriezeGroupList[nr] ), x -> x[1] );
      else
         Error( "frieze group number must be in [1..7]" );
      fi;
   elif type = "Rod" then
      if nr in [3..22] then
        # The settings are "abc" etc, not single characters.
        # Sorry if this breaks the convention, but the alternative is to
        # not follow the International Tables.
        return RecNames( RodGroupList[nr] );
      elif nr in [1..75] then
         return List( RecNames( RodGroupList[nr] ), x -> x[1] );
      else
         Error( "rod group number must be in [1..75]" );
      fi;
   elif type = "Layer" then
      if nr in [1..80] then
         return List( RecNames( LayerGroupList[nr] ), x -> x[1] );
      else
         Error( "layer group number must be in [1..80]" );
      fi;
   else
      Error( "only types Frieze, Rod, or Layer are supported, but got ", type );
   fi;
end );

#############################################################################
##
#M  SubPeriodicGroupDataIT . . . . . data extractor for IT subperiodic groups
##
InstallGlobalFunction( SubPeriodicGroupDataIT, function( r )

   local settings, setting;
   settings := SubPeriodicGroupSettingsIT(r.type, r.nr);
   if IsBound(r.setting) then
     if not (r.setting in settings) then
       Error( "requested setting is not available" );
     fi;
   else
     # No setting provided. Find the default setting.
     if r.type = "Frieze" then
       r.setting := 'a';
     elif r.type = "Rod" then
       if "abc" in settings then
         r.setting := "abc";
       else
         r.setting := '1';
       fi;
     elif r.type = "Layer" then
       if 'a' in settings then
         r.setting := 'a';
       elif r.nr in [52,62,64] then
         # The alternative origin choice.
         r.setting := '2';
       else
         r.setting := '1';
       fi;
     else
       Error( "only types Frieze, Rod, or Layer are supported, but got ", r.type );
     fi;
   fi;
   # Convert from character to string, if required.
   if not IsList(r.setting) then
     setting := [r.setting];
   else
     setting := r.setting;
   fi;
   if   r.type = "Frieze" then
     if r.nr in [1..7] then
       return FriezeGroupList[r.nr].(setting);
     else
       Error( "frieze group number must be in [1..7]" );
     fi;
   elif r.type = "Rod" then
     if r.nr in [1..75] then
       return RodGroupList[r.nr].(setting);
     else
       Error( "rod group number must be in [1..75]" );
     fi;
   elif r.type = "Layer" then
     if r.nr in [1..80] then
       return LayerGroupList[r.nr].(setting);
     else
       Error( "layer group number must be in [1..80]" );
     fi;
   else
      Error( "only types Frieze, Rod, or Layer are supported, but got ", r.type );
   fi;
end );

#############################################################################
##
#M  SubPeriodicGroupFunIT . . . constructor function for IT subperiodic group
##
InstallGlobalFunction( SubPeriodicGroupFunIT, function( r )
   local data, gens, vec, name, S, setting, d;
   data := SubPeriodicGroupDataIT( r );
   gens := ShallowCopy( data.generators );
   d := Length(data.basis[1]);
   for vec in data.basis do
     Add( gens, AugmentedMatrix( IdentityMat( d ), vec ) );
   od;
   if r.action = LeftAction then
      gens := List( gens, TransposedMat );
      S := AffineCrystGroupOnLeftNC( gens, IdentityMat(d+1) );
      name := "SubPeriodicGroupOnLeftIT(";
   else
      S := AffineCrystGroupOnRightNC( gens, IdentityMat(d+1) );
      name := "SubPeriodicGroupOnRightIT(";
   fi;
   if not IsList(r.setting) then
     setting := [r.setting];
   else
     setting := r.setting;
   fi;
   AddTranslationBasis( S, data.basis );
   SetName( S, Concatenation( name, r.type, ",", String(r.nr),
                              ",'", setting, "')" ) );
   return S;
end );

#############################################################################
##
#M  SubPeriodicGroupOnRightIT . .constructor for IT subperiodic group OnRight
##
InstallGlobalFunction( SubPeriodicGroupOnRightIT, function( arg )
   local r;
   r := rec( type := arg[1], nr := arg[2], action := RightAction );
   if IsBound( arg[3] ) then
      r.setting := arg[3];
   fi;
   return SubPeriodicGroupFunIT( r );
end );

#############################################################################
##
#M  SubPeriodicGroupOnLeftIT . . .constructor for IT subperiodic group OnLeft
##
InstallGlobalFunction( SubPeriodicGroupOnLeftIT, function( arg )
   local r;
   r := rec( type := arg[1], nr := arg[2], action := LeftAction );
   if IsBound( arg[3] ) then
      r.setting := arg[3];
   fi;
   return SubPeriodicGroupFunIT( r );
end );

#############################################################################
##
#M  SubPeriodicGroupIT . . . . . . . . . constructor for IT subperiodic group
##
InstallGlobalFunction( SubPeriodicGroupIT, function( arg )
   local r;
   r := rec( type := arg[1], nr := arg[2], action := CrystGroupDefaultAction );
   if IsBound( arg[3] ) then
      r.setting := arg[3];
   fi;
   return SubPeriodicGroupFunIT( r );
end );

#############################################################################
##
#M  FriezeGroupIT . . . . . . . . . . . . . . constructor for IT frieze group
##
InstallGlobalFunction( FriezeGroupIT, function( arg )
   Add(arg, "Frieze", 1);
   return CallFuncList(SubPeriodicGroupIT, arg);
end );

#############################################################################
##
#M  RodGroupIT . . . . . . . . . . . . . . . . . constructor for IT rod group
##
InstallGlobalFunction( RodGroupIT, function( arg )
   Add(arg, "Rod", 1);
   return CallFuncList(SubPeriodicGroupIT, arg);
end );

#############################################################################
##
#M  LayerGroupIT . . . . . . . . . . . . . . . constructor for IT layer group
##
InstallGlobalFunction( LayerGroupIT, function( arg )
   Add(arg, "Layer", 1);
   return CallFuncList(SubPeriodicGroupIT, arg);
end );
