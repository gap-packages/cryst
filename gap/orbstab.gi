#############################################################################
##
#A  orbstab.gi              CrystGap library                     Bettina Eick
#A                                                              Franz G"ahler
#A                                                              Werner Nickel
##
#Y  Copyright 1990-1997,  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
##

#############################################################################
##
#M  Stabilizer( G, d, opr ) . . . . . . . . . . . . . for an AffineCrystGroup
##
InstallOtherMethod( StabilizerOp,
        "G, pnt, opr for AffineCrystGroups", true,
        [ IsAffineCrystGroupOnLeftOrRight, IsObject, IsFunction ], 0,
function( G, d, opr )
    local   stb,        # stabilizer, result
            orb,        # orbit
            rep,        # representatives for the points in the orbit <orb>
            gen,        # generator of the group <G>
            pnt,        # point in the orbit <orb>
            img,        # image of the point <pnt> under the generator <gen>
            sch;        # schreier generator of the stabilizer

    # standard operation
    if opr = OnPoints then
        orb := [ d ];
        rep := [ One( G ) ];
        stb := TrivialSubgroup( G );
        for pnt in orb do
            for gen in GeneratorsOfGroup( G ) do
                img := pnt^gen;
                if not img in orb then
                    Add( orb, img );
                    Add( rep, rep[Position(orb,pnt)]*gen );
                else
                    sch := rep[Position(orb,pnt)]*gen
                           / rep[Position(orb,img)];
                    if not sch in stb then
                        stb := ClosureGroup( stb, sch );
                    fi;
                fi;
            od;
        od;

    # compute iterated stabilizers for the operation on pairs or on tuples
    elif opr = OnPairs or opr = OnTuples then
        stb := G;
        for pnt in d  do
            stb := Stabilizer( stb, pnt, OnPoints );
        od;
        return stb;

    # other operation
    else
        orb := [ d ];
        rep := [ One( G ) ];
        stb := TrivialSubgroup( G );
        for pnt in orb do
            for gen in GeneratorsOfGroup( G ) do
                img := opr( pnt, gen );
                if not img in orb then
                    Add( orb, img );
                    Add( rep, rep[Position(orb,pnt)]*gen );
                else
                    sch := rep[Position(orb,pnt)]*gen
                           / rep[Position(orb,img)];
                    if not sch in stb then
                        stb := ClosureGroup( stb, sch );
                    fi;
                fi;
            od;
        od;
    fi;

    # return the stabilizer <stb>
    return stb;

end );


#############################################################################
##
#M  RepresentativeOperation( G, d, e, opr ) . . .repres. operation of a point
##
InstallOtherMethod( RepresentativeOperationOp, true,
    [ IsAffineCrystGroupOnLeftOrRight, IsObject, IsObject, IsFunction ], 0,
function( G, d, e, opr )
    local   rep,        # representative, result
            orb,        # orbit
            gen,        # generator of the group <G>
            pnt,        # point in the orbit <orb>
            img,        # image of the point <pnt> under the generator <gen>
            by,         # <by>[<pnt>] is a gen taking <frm>[<pnt>] to <pnt>
            frm;        # where <frm>[<pnt>] lies earlier in <orb> than <pnt>

    orb := [ d ];
    by  := [ One( G ) ];
    frm := [ 1 ];

    # standard operation
    if   opr = OnPoints  then
        if d = e then return One( G ); fi;
        for pnt in orb do
            for gen in GeneratorsOfGroup( G ) do
                img := pnt^gen;
                if img = e then
                    rep := gen;
                    while pnt <> d do
                        rep := by[ Position(orb,pnt) ] * rep;
                        pnt := frm[ Position(orb,pnt) ];
                    od;
                    return rep;
                elif not img in orb then
                    Add( orb, img );
                    Add( frm, pnt );
                    Add( by,  gen );
                fi;
            od;
        od;
        return false;

    # special case for operation on pairs
    elif opr = OnPairs then
        if d = e  then return One( G );  fi;
        for pnt in orb do
            for gen in GeneratorsOfGroup( G ) do
                img := [ pnt[1]^gen, pnt[2]^gen ];
                if img = e then
                    rep := gen;
                    while pnt <> d do
                        rep := by[ Position(orb,pnt) ] * rep;
                        pnt := frm[ Position(orb,pnt) ];
                    od;
                    return rep;
                elif not img in orb then
                    Add( orb, img );
                    Add( frm, pnt );
                    Add( by,  gen );
                fi;
            od;
        od;
        return false;

    # other operation
    else
        if d = e then return One( G ); fi;
        for pnt in orb do
            for gen in GeneratorsOfGroup( G ) do
                img := opr( pnt, gen );
                if img = e then
                    rep := gen;
                    while pnt <> d do
                        rep := by[ Position(orb,pnt) ] * rep;
                        pnt := frm[ Position(orb,pnt) ];
                    od;
                    return rep;
                elif not img in orb then
                    Add( orb, img );
                    Add( frm, pnt );
                    Add( by,  gen );
                fi;
            od;
        od;
        return false;
    fi;

end );



