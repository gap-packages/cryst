#############################################################################
##
#A  fpgrp.gi                CrystGap library                     Bettina Eick
#A                                                              Franz G"ahler
#A                                                              Werner Nickel
##
#Y  Copyright 1990-1997,  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
##

#############################################################################
##
#M  IsomorphismFpGroup( <P> ) . . . . . . . IsomorphismFpGroup for PointGroup
##
InstallMethod( IsomorphismFpGroup,
    "for PointGroup", true, [ IsPointGroup ], 0,
function ( P )

    local mono, N, F, gens, gensP, gensS, gensF, iso;

    # compute an isomorphic permutation group
    mono := NiceMonomorphism( P );
    N    := NiceObject( P );

    # distinguish between solvable and non-solvable case
    if IsSolvableGroup( N ) then
        F    := Image( IsomorphismFpGroupByPcgs( Pcgs( N ), "f" ) );
        gens := AsList( Pcgs( N ) );
    else
        gens := GeneratorsOfGroup( N );
        F    := Image( IsomorphismFpGroupByGenerators( N, gens ) );
    fi;

    gensP := List( gens, x -> PreImagesRepresentative( mono, x ) );
    gensS := List( gens, x -> ImagesRepresentative( NiceToCryst( P ), x ) );
    gensF := GeneratorsOfGroup( F );

    iso := GroupHomomorphismByImagesNC( P, F, gensP, gensF );
    SetIsBijective( iso, true );
    SetKernelOfMultiplicativeGeneralMapping( iso, TrivialSubgroup( P ) );
    iso!.preimagesInAffineCrystGroup := Immutable( gensS );

    return iso;

end );

#############################################################################
##
#M  IsomorphismFpGroup( <S> ) . . . . . . . for AffineCrystGroupOnLeftOrRight
##
InstallMethod( IsomorphismFpGroup,
    "for AffineCrystGroup", true, [ IsAffineCrystGroupOnLeftOrRight ], 0,
function( S )

    local P, hom, T, iso, F, gensP, relsP, matsP, d, n, t, R, 
          gensR, gensT, matsT, i, j, l, k, rels, relsR, rel, tail, 
          vec, word, gens, ims;

    P   := PointGroup( S );
    hom := PointHomomorphism( S );
    T   := TranslationBasis( S );
    iso := IsomorphismFpGroup( P );
    F   := Image( iso );

    gensP := GeneratorsOfGroup( FreeGroupOfFpGroup( F ) );
    relsP := RelatorsOfFpGroup( F );
    matsP := iso!.preimagesInAffineCrystGroup;

    d := DimensionOfMatrixGroup( S ) - 1;
    n     := Length( gensP );
    t     := Length( T );
    R     := FreeGroup( n + t );
    gensR := GeneratorsOfGroup( R ){[1..n]};
    gensT := GeneratorsOfGroup( R ){[n+1..n+t]};
    matsT := List( gensT, x -> IdentityMat( d+1 ) );
    for i in [1..Length( matsT )] do
        if IsAffineCrystGroupOnRight( S ) then
            matsT[i][d+1]{[1..d]} := T[i];
        else
            matsT[i]{[1..d]}[d+1] := T[i];
        fi;
    od;

    rels  := List( relsP, rel -> MappedWord( rel, gensP, gensR ) );
    relsR := [];

    # compute tails
    for rel in rels do
        tail := MappedWord( rel, gensR, matsP );
        if IsAffineCrystGroupOnRight( S ) then
            vec  := SolutionMat( T, - tail[d+1]{[1..d]} );
        else
            vec  := SolutionMat( T, - tail{[1..d]}[d+1] );
        fi;
        word := rel;
        for i in [1..t] do
            word := word * gensT[i]^vec[i];
        od;
        Add( relsR, word );
    od;

    # compute operation
    for i in [1..n] do
        for j in [1..t] do
            rel  := Comm( gensT[j], gensR[i] );
            tail := Comm( matsT[j], matsP[i] );
            if IsAffineCrystGroupOnRight( S ) then
                vec  := SolutionMat( T, - tail[d+1]{[1..d]} );
            else
                vec  := SolutionMat( T, - tail{[1..d]}[d+1] );
            fi;
            word := rel;
            for k in [1..t] do
                word := word * gensT[k]^vec[k];
            od;
            Add( relsR, word );
        od;
    od;

    # compute presentation of T
    for i in [1..t-1] do
        for j in [i+1..t] do
            Add( relsR, Comm( gensT[j], gensT[i] ) );
        od;
    od;
    
    # construct isomorphism
    R    := R / relsR;
    gens := Concatenation( matsP, matsT ); 
    ims  := GeneratorsOfGroup( R );
    iso  := GroupHomomorphismByImagesNC( S, R, gens, ims ); 
    SetIsBijective( iso, true );
    SetKernelOfMultiplicativeGeneralMapping( iso, TrivialSubgroup( S ) );

    return iso;

end );


