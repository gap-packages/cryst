#############################################################################
##
#A  orbstab.gi                Cryst library                      Bettina Eick
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

    local Td, Te, PG, f, r, n, Pd, Pe, r2, R, dim, gP, M, i, TG, tr1, tr2,
          tt, res, gN, orb, rep, x, g, dd, redtrans;

    if opr <> OnPoints then
        TryNextMethod();
    fi;

    redtrans := function( TG, tr1, tr2, t2, P, U )
      local dim, gen, t1, sol;
      dim := DimensionOfMatrixGroup( P );
      gen := List( GeneratorsOfGroup( P ), 
                 x -> PreImagesRepresentativeNC( PointHomomorphism( U ), x ) );
      t1  := Concatenation( List( gen, x -> x[dim+1]{[1..dim]} ) ) - t2;
      sol := IntSolutionMat( tr1, -t1 );
      if sol = fail then
          return VectorModL( t2, tr2 );
      else
          return AugmentedMatrix( One( P ), sol{[1..Length(TG)]} * TG );
      fi;
    end;

    # have the translation basis the same length?
    Td := TranslationBasis( d );
    Te := TranslationBasis( e );
    if Length( Td ) <> Length( Te ) then
        return fail;
    fi;

    # map translation basis onto each other
    PG := PointGroup( G );
    if Length( Td ) > 0 then
        f := function(x,g) return ReducedLatticeBasis( x*g ); end;
        r := RepresentativeAction( PG, Td, Te, f );
        if r = fail then
            return fail;
        fi;
        n := Stabilizer( PG, Te, f );
    else
        n := PG;
        r := One( PG );
    fi;

    # map point groups onto each other
    Pd := PointGroup( d );
    Pe := PointGroup( e );
    r2 := RepresentativeAction( n, Pd^r, Pe );
    if r2 = fail then
        return fail;
    fi;
    r := r*r2;
    R := PreImagesRepresentativeNC( PointHomomorphism( G ), r );

    dim := DimensionOfMatrixGroup( PG );
    gP := GeneratorsOfGroup( Pe );
    M  := NullMat( Length(gP) * Length(Te), dim * Length(gP) );
    if not IsEmpty( Te ) then
        for i in [1..Length(gP)] do
            M{[1..Length(Te)]+(i-1)*Length(Te)}{[1..dim]+(i-1)*dim} := Te;
        od;
    fi;

    TG  := TranslationBasis( G );
    tr1 := List( TG, t -> Concatenation( List( gP, x -> t * ( One(Pe)-x ) ) ) );
    tr1 := Concatenation( tr1, M );
    tr2 := ReducedLatticeBasis( tr1 );
    tt  := List( gP, x -> PreImagesRepresentativeNC( PointHomomorphism(e), x ));
    tt  := Concatenation( List( tt, x -> x[dim+1]{[1..dim]} ) );

    # is there a conjugating translation?
    res := redtrans( TG, tr1, tr2, tt, Pe, d^R );
    if IsMatrix( res ) then
        return R * res;
    fi;

    # now we have to try the normalizer
    gN := Filtered( GeneratorsOfGroup( Normalizer(n, Pe) ), x -> not x in Pe );
    gN := List( gN, x -> PreImagesRepresentativeNC( PointHomomorphism(G), x ) );

    orb := [ res ];
    rep := [ R ];
    for x in rep do
        for g in gN do
            dd := d ^ (x * g);
            res := redtrans( TG, tr1, tr2, tt, Pe, dd );
            if IsMatrix( res ) then
                return x * g * res;
            fi;
            if not res in orb then
                Add( orb, res );
                Add( rep, x * g );
            fi;
        od;
    od;
    return fail;

end );

InstallOtherMethod( RepresentativeActionOp,
        "G, d, e, opr for AffineCrystGroups", true,
        [ IsAffineCrystGroupOnLeft, IsAffineCrystGroupOnLeft, 
          IsAffineCrystGroupOnLeft, IsFunction ], 0,
function( G, d, e, opr )
    local C;
    C := RepresentativeAction( TransposedMatrixGroup( G ),
             TransposedMatrixGroup( d ), TransposedMatrixGroup( e ), opr );
    if C = fail then
        return fail;
    else
        return TransposedMat( C );
    fi;
end );


#############################################################################
##
#F  ConjugatingTranslation( G, gen, T)
##
##  returns a translation t from the Z-span of T such that the elements
##  of gen conjugated with t are in G (or fail if no such t exists)
##
ConjugatingTranslation := function( G, gen, T )

    local d, b, TG, lt, lg, M, I, i, g, m, sol, t;

    d  := DimensionOfMatrixGroup( G ) - 1;
    TG := TranslationBasis( G );
    lt := Length( T  );
    lg := Length( TG );
    b  := [];
    M  := NullMat( lt + lg * Length(gen), d * Length(gen) );
    I  := IdentityMat( d );
    for i in [1..Length(gen)] do
        g := gen[i]{[1..d]}{[1..d]};
        if not g in PointGroup( G ) then
            return fail;
        fi;
        m := PreImagesRepresentativeNC( PointHomomorphism( G ), g );
        Append( b, -gen[i][d+1]{[1..d]} +  m[d+1]{[1..d]} );
        M{[1..lt]}{[1..d]+(i-1)*d} := T * (I - g);
        if lg > 0 then
            M{[1..lg]+lt+(i-1)*lg}{[1..d]+(i-1)*d} := TG;
        fi;
    od;
    sol := IntSolutionMat( M, b );
    if IsList( sol ) then
        sol := sol{[1..lt]} * T;
#        t   := AugmentedMatrix( I, sol );
#        for g in gen do
#            Assert( 0, g^t in G );
#        od;
        return sol;
    else
        return fail;
    fi;

end;


#############################################################################
##
#M  Normalizer( G, H ) . . . . . . . . . . . . . . . . . . . . . . normalizer
##
InstallMethod( NormalizerOp, "two AffineCrystGroupsOnRight", IsIdenticalObj, 
    [ IsAffineCrystGroupOnRight, IsAffineCrystGroupOnRight ], 0,
function( G, H )

    local P, TH, TG, d, I, gens, T, t, trn, orb, rep, stb, 
          grp, gen, img, i, sch, g, b, M, m, sol, Q, N;

    # we must normalize the point group and the translation subgroup
    P  := Normalizer( PointGroup( G ), PointGroup( H ) );
    TH := TranslationBasis( H );
    if TH <> [] then
        P := Stabilizer( P, TH, function( x, g ) 
                                  return ReducedLatticeBasis( x * g );
                                end );
    fi;

    # lift P to G
    d := DimensionOfMatrixGroup( P );
    I := IdentityMat( d );
    gens := List( GeneratorsOfGroup( P ), 
                  x -> PreImagesRepresentativeNC( PointHomomorphism( G ), x ) );

    # stabilizer of translation conjugacy class of H
    TG  := TranslationBasis( G );
    orb := [ H ];
    rep := [ One( G ) ];
    stb := TrivialSubgroup( G );
    for grp in orb do
        for gen in gens do
            img := List( GeneratorsOfGroup( grp ), x -> x^gen );
            i   := PositionProperty( orb, 
                      g -> ConjugatingTranslation( g, img, TG ) <> fail );
            if i = fail then
                Add( orb, ConjugateGroup( grp, gen ) );
                Add( rep, rep[Position(orb,grp)] * gen );
            else
                sch := rep[Position(orb,grp)] * gen / rep[i];
                stb := ClosureGroup( stb, sch );
            fi;
        od;
    od;
    gens := List( GeneratorsOfGroup( stb ), MutableMatrix );

    # fix the translations
    for gen in gens do
        img := List( GeneratorsOfGroup( H ), x -> x^gen );
        trn := ConjugatingTranslation( H, img, TG );
        gen[d+1]{[1..d]} := gen[d+1]{[1..d]} + trn;
    od;
    gens := Set( gens );

    # construct the pure translations
    T := TG;
    for g in GeneratorsOfGroup( PointGroup( H ) ) do
        if  T <> [] then
            M := Concatenation( T * (g-I), TH );
            M := M * Lcm( List( Flat( M ), DenominatorRat ) );
            Q := IdentityMat( Length( M ) );
            M := RowEchelonFormT( M, Q );
            T := Q{[Length(M)+1..Length(Q)]}{[1..Length(T)]} * T;
            T := ReducedLatticeBasis( T );
        fi;
    od;
    for t in T do
        Add( gens, AugmentedMatrix( I, t ) );
    od;

#    for g in gens do
#        Assert( 0, H^g = H );
#    od;

    # construct the normalizer
    N := AffineCrystGroupOnRight( gens, One( G ) );
    AddTranslationBasis( N, T );

    return N;

end );

InstallMethod( NormalizerOp, "two AffineCrystGroupsOnLeft", IsIdenticalObj, 
    [ IsAffineCrystGroupOnLeft, IsAffineCrystGroupOnLeft ], 0,
function( G, H )
    return TransposedMatrixGroup(
      Normalizer( TransposedMatrixGroup(G), TransposedMatrixGroup(H) ) );
end );
