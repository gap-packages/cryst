#############################################################################
##
#A  orbstab.gi              CrystGap library                     Bettina Eick
#A                                                              Franz G"ahler
#A                                                              Werner Nickel
##
#Y  Copyright 1997-1999  by  Bettina Eick,  Franz G"ahler  and  Werner Nickel
##

#############################################################################
##
#M  Orbit( G, H, gens, oprs, opr ) . . . . . . . . . .for an AffineCrystGroup
##
InstallOtherMethod( OrbitOp,
        "G, H, gens, oprs, opr for AffineCrystGroups", true,
        [ IsAffineCrystGroupOnRight, IsAffineCrystGroupOnRight, 
          IsList, IsList, IsFunction ], 10,
function( G, H, gens, oprs, opr )
    local  orb, grp, gen, img;

    if opr = OnPoints then
        orb := [ H ];
        for grp in orb do
            for gen in oprs do
                img := List( GeneratorsOfGroup( grp ), x -> x^gen );
                if not ForAny( orb, g -> ForAll( img, x -> x in g ) ) then
                    Add( orb, ConjugateGroup( grp, gen ) );
                fi;
            od;
        od;
        return orb;
    else
        TryNextMethod();
    fi;

end );

InstallOtherMethod( OrbitOp,
        "G, H, gens, oprs, opr for AffineCrystGroups", true,
        [ IsAffineCrystGroupOnLeft, IsAffineCrystGroupOnLeft, 
          IsList, IsList, IsFunction ], 10,
function( G, H, gens, oprs, opr )
    local  orb, grp, gen, img;

    if opr = OnPoints then
        orb := [ H ];
        for grp in orb do
            for gen in oprs do
                img := List( GeneratorsOfGroup( grp ), x -> x^gen );
                if not ForAny( orb, g -> ForAll( img, x -> x in g ) ) then
                    Add( orb, ConjugateGroup( grp, gen ) );
                fi;
            od;
        od;
        return orb;
    else
        TryNextMethod();
    fi;

end );

#############################################################################
##
#M  OrbitStabilizer( G, H, gens, oprs, opr ) . . . . .for an AffineCrystGroup
##
InstallOtherMethod( OrbitStabilizerOp,
        "G, H, gens, oprs, opr for AffineCrystGroups", true,
        [ IsAffineCrystGroupOnRight, IsAffineCrystGroupOnRight, 
          IsList, IsList, IsFunction ], 0,
function( G, H, gens, oprs, opr )
    local orb, rep, stb, grp, k, img, i, sch;

    if opr = OnPoints then

        orb := [ H ];
        rep := [ One( G ) ];
        if IsSubgroup( G, H ) then
            stb := H;
        else
            stb := Intersection2( G, H );
        fi;

        for grp in orb do
            for k in [1..Length(gens)] do
                img := List( GeneratorsOfGroup( grp ), x -> x^oprs[k] );
                i   := PositionProperty( orb, 
                              g -> ForAll( img, x -> x in g ) );
                if i = fail then
                    Add( orb, ConjugateGroup( grp, oprs[k] ) );
                    Add( rep, rep[Position(orb,grp)] * oprs[k] );
                else
                    sch := rep[Position(orb,grp)] * gens[k] / rep[i];
                    if not sch in stb then
                        stb := ClosureGroup( stb, sch );
                    fi;
                fi;
            od;
        od;
        return Immutable( rec( orbit := orb, stabilizer := stb ) );
    else
        TryNextMethod();
    fi;

end );

InstallOtherMethod( OrbitStabilizerOp,
        "G, H, gens, oprs, opr for AffineCrystGroups", true,
        [ IsAffineCrystGroupOnLeft, IsAffineCrystGroupOnLeft, 
          IsList, IsList, IsFunction ], 0,
function( G, H, gens, oprs, opr )
    local orb, rep, stb, grp, k, img, i, sch;

    if opr = OnPoints then

        orb := [ H ];
        rep := [ One( G ) ];
        if IsSubgroup( G, H ) then
            stb := H;
        else
            stb := Intersection2( G, H );
        fi;

        for grp in orb do
            for k in [1..Length(gens)] do
                img := List( GeneratorsOfGroup( grp ), x -> x^oprs[k] );
                i   := PositionProperty( orb, 
                              g -> ForAll( img, x -> x in g ) );
                if i = fail then
                    Add( orb, ConjugateGroup( grp, oprs[k] ) );
                    Add( rep, rep[Position(orb,grp)] * oprs[k] );
                else
                    sch := rep[Position(orb,grp)] * gens[k] / rep[i];
                    if not sch in stb then
                        stb := ClosureGroup( stb, sch );
                    fi;
                fi;
            od;
        od;
        return Immutable( rec( orbit := orb, stabilizer := stb ) );
    else
        TryNextMethod();
    fi;

end );



#############################################################################
##
#M  RepresentativeAction( G, d, e, opr ) . . . . . .  for an AffineCrystGroup
##
InstallOtherMethod( RepresentativeActionOp,
        "G, d, e, opr for AffineCrystGroups", true,
        [ IsAffineCrystGroupOnRight, IsAffineCrystGroupOnRight, 
          IsAffineCrystGroupOnRight, IsFunction ], 0,
function( G, d, e, opr )

    local orb, by, frm, gens, grp, k, img, pos, rep, i;

    orb  := [ d ];
    by   := [ One( G ) ];
    frm  := [ 1 ];
    gens := GeneratorsOfGroup( G );

    if opr = OnPoints then
        for grp in orb do
            for k in [1..Length(gens)] do
                img := List( GeneratorsOfGroup( grp ), x -> x^gens[k] );
                if ForAll( img, x -> x in e ) then
                    rep := gens[k];
                    while grp <> d  do
                        pos := Position( orb, grp );
                        rep := by[ pos ] * rep;
                        grp := orb[ frm[ pos ] ];
                    od;
                    return rep;
                else
                    i := PositionProperty( orb, 
                              g -> ForAll( img, x -> x in g ) );
                    if i = fail then
                        Add( frm, Position( orb, grp ) );
                        Add( orb, ConjugateGroup( grp, gens[k] ) );
                        Add( by,  gens[k] );
                    fi;
                fi;
            od;
        od;
        return fail ;
    else
        TryNextMethod();
    fi;

end );

InstallOtherMethod( RepresentativeActionOp,
        "G, d, e, opr for AffineCrystGroups", true,
        [ IsAffineCrystGroupOnLeft, IsAffineCrystGroupOnLeft, 
          IsAffineCrystGroupOnLeft, IsFunction ], 0,
function( G, d, e, opr )

    local orb, by, frm, gens, grp, k, img, pos, rep, i;

    orb  := [ d ];
    by   := [ One( G ) ];
    frm  := [ 1 ];
    gens := GeneratorsOfGroup( G );

    if opr = OnPoints then
        for grp in orb do
            for k in [1..Length(gens)] do
                img := List( GeneratorsOfGroup( grp ), x -> x^gens[k] );
                if ForAll( img, x -> x in e ) then
                    rep := gens[k];
                    while grp <> d  do
                        pos := Position( orb, grp );
                        rep := by[ pos ] * rep;
                        grp := orb[ frm[ pos ] ];
                    od;
                    return rep;
                else
                    i := PositionProperty( orb, 
                              g -> ForAll( img, x -> x in g ) );
                    if i = fail then
                        Add( frm, Position( orb, grp ) );
                        Add( orb, ConjugateGroup( grp, gens[k] ) );
                        Add( by,  gens[k] );
                    fi;
                fi;
            od;
        od;
        return fail ;
    else
        TryNextMethod();
    fi;

end );
