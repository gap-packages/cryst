#############################################################################
##
#A  wyckoff.gi              CrystGap library                     Bettina Eick
#A                                                              Franz G"ahler
#A                                                              Werner Nickel
##
#Y  Copyright 1990-1997,  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
##
##  Routines for the determination of Wyckoff positions
##

#############################################################################
##
#M  WyckoffPositionObject . . . . . . . . . . .make a Wyckoff position object
##
InstallGlobalFunction( WyckoffPositionObject, function( w )
    return Objectify( NewType( FamilyObj( w ), IsWyckoffPosition ), w );
end );

#############################################################################
##
#M  PrintObj . . . . . . . . . . . . . . . . . . . . . Print Wyckoff position
##
InstallMethod( PrintObj,
    "Wyckoff position", true, [ IsWyckoffPosition ], 0,
function( w )
    Print( "[ class: ", w!.class, ", translation: ",w!.translation,
           ", basis: ", w!.basis, " ]" );
end );

#############################################################################
##
#M  ViewObj . . . . . . . . . . . . . . . . . . . . . View a Wyckoff position
##
InstallMethod( ViewObj,
    "Wyckoff position", true, [ IsWyckoffPosition ], 0,
function( w )
    Print( "[ class: ", w!.class, ", translation: ",w!.translation,
           ", basis: ", w!.basis, " ]" );
end );

#############################################################################
##
#M  WyckoffSpaceGroup . . . . . . . . . . . . .space group of WyckoffPosition
##
InstallMethod( WyckoffSpaceGroup,
    true, [ IsWyckoffPosition ], 0, w -> w!.spaceGroup );

#############################################################################
##
#M  WyckoffTranslation . . . . . . . . . .translation of representative space
##
InstallMethod( WyckoffTranslation,
    true, [ IsWyckoffPosition ], 0, w -> w!.translation );

#############################################################################
##
#M  WyckoffBasis . . . . . . . . . . . . . . . .basis of representative space
##
InstallMethod( WyckoffBasis, 
    true, [ IsWyckoffPosition ], 0, w -> w!.basis );

#############################################################################
##
#F  ReduceAffineSubspaceLattice . . . . reduce affine subspace modulo lattice
##
InstallGlobalFunction( ReduceAffineSubspaceLattice, function( r )

    local v, d, L, N, i, n, l, x, k;

    v := r.translation;
    d := Length( v );
    r.basis   := ReducedLatticeBasis( r.basis );
    L := TranslationBasis( r.spaceGroup );

    #  reduce the translation
    if r.basis <> [] then
        L := ReducedLatticeBasis( Concatenation(  L, r.basis ) );
        N := List( r.basis, ShallowCopy );
        for i in [1..d] do
            if N <> [] then
                n := N[1]; N := N{[2..Length(N)]};
                l := L[1]; 
                if n[i] <> 0 then
                    v := v - n * v[i] / n[i];
                    n := n * l[i] / n[i] - l;
                    L := ShallowCopy( L );
                    L[1] := n;
                    L := ReducedLatticeBasis( L );
                else
                    x :=  v[i] / l[i];
                    k := Int( x );
                    if x < 0 and not IsInt( x ) then k := k-1; fi;
                    if k <> 0 then
                        v := v - k * l;
                    fi; 
                    L := L{[2..Length(L)]};
                fi;
            fi;
        od;
    fi;

    r.translation := VectorModL( v, L );

end );

#############################################################################
##
#F  ImageAffineSubspaceLattice . . . .image of affine subspace modulo lattice
##
InstallGlobalFunction( ImageAffineSubspaceLattice, function( s, g )
    local d, m, t, r;
    d := Length( s.translation );
    m := g{[1..d]}{[1..d]};
    t := g[d+1]{[1..d]};
    r := rec( translation := s.translation * m + t,
              basis       := s.basis * m,
              spaceGroup  := s.spaceGroup );
    ReduceAffineSubspaceLattice( r );
    return r;
end );

#############################################################################
##
#F  ImageAffineSubspaceLatticePointwise . . . . . . image of pointwise affine 
#F                                                    subspace modulo lattice
##
InstallGlobalFunction( ImageAffineSubspaceLatticePointwise, function( s, g )
    local d, m, t, L, r;
    d := Length( s.translation );
    m := g{[1..d]}{[1..d]};
    t := g[d+1]{[1..d]};
    L := TranslationBasis( s.spaceGroup );
    r := rec( translation := VectorModL( s.translation * m + t, L ),
              basis       := s.basis * m,
              spaceGroup  := s.spaceGroup );
    return r;
end );

#############################################################################
##
#M  WyckoffStabilizer . . . . . . . . . . .stabilizer of representative space
##
InstallMethod( WyckoffStabilizer,
    true, [ IsWyckoffPosition ], 0, 
function( w )
    local S, t, B, d, I, gen, U, r, new, n, g, v;
    S := WyckoffSpaceGroup( w );
    t := WyckoffTranslation( w );
    B := WyckoffBasis( w );
    d := Length( t );
    I := IdentityMat( d );
    gen := GeneratorsOfGroup( S );
    gen := Filtered( gen, g -> g{[1..d]}{[1..d]} <> I );
    if IsAffineCrystGroupOnLeft( S ) then
        gen := List( gen, TransposedMat );
    fi;
    U := AffineCrystGroupOnRight( gen, One( S ) );
    r := rec( translation := t, basis := B, spaceGroup := S );
    U := Stabilizer( U, r, ImageAffineSubspaceLatticePointwise );
    t := ShallowCopy( t );
    Add( t, 1 );
    gen := GeneratorsOfGroup( U );
    new := [];
    for g in gen do
        v := t * g - t;
        n := List( g, ShallowCopy );
        n{[1..d]} := g{[1..d]} - v;
        if n <> One( S ) then
            AddSet( new, n );
        fi;
    od;
    if IsAffineCrystGroupOnLeft( S ) then
        new := List( new, TransposedMat );
    fi;
    return SubgroupNC( S, new );
end );

#############################################################################
##
#M  WyckoffOrbit( w )  . . . . . . . . . orbit of pointwise subspace lattices
##
InstallMethod( WyckoffOrbit,
    true, [ IsWyckoffPosition ], 0,
function( w )
    local S, t, B, d, I, gen, U, r, o, s;
    S := WyckoffSpaceGroup( w );
    t := WyckoffTranslation( w );
    B := WyckoffBasis( w );
    d := Length( t );
    I := IdentityMat( d );
    gen := GeneratorsOfGroup( S );
    gen := Filtered( gen, g -> g{[1..d]}{[1..d]} <> I );
    if IsAffineCrystGroupOnLeft( S ) then
        gen := List( gen, TransposedMat );
    fi;
    U := AffineCrystGroupOnRight( gen, One( S ) );
    r := rec( translation := t, basis := B, spaceGroup  := S );
    o := Orbit( U, r, ImageAffineSubspaceLatticePointwise );
    s := List( o, x -> rec( translation := x.translation, basis := x.basis));
    return s;
end );

#############################################################################
##
#F  SolveOneInhomEquationModZ . . . . . . . .  solve one inhom equation mod Z
##
##  Solve the inhomogeneous equation
##
##            a x = b (mod Z).
##
##  The set of solutions is
##                    {0, 1/a, ..., (a-1)/a} + b/a.
##  Note that 0 < b <  1, so 0 < b/a and (a-1)/a + b/a < 1.
##
SolveOneInhomEquationModZ := function( a, b )
    
    return [0..a-1] / a + b/a;
end;

#############################################################################
##
#F  SolveInhomEquationsModZ . . . . .solve an inhom system of equations mod Z
##
##  This function computes the set of solutions of the equation
##
##                           x * M = b  (mod Z).
##
##  RowEchelonFormT() returns a matrix Q such that Q * M is in row echelon
##  form.  This means that (modulo column operations) we have the equation
##         x * Q^-1 * D = b       with D a diagonal matrix.
##  Solving y * D = b we get x = y * Q.
##
SolveInhomEquationsModZ := function( M, b )
    local   Q,  j,  L,  space,  i,  v;
    
    b := ShallowCopy(b);
    Q := IdentityMat( Length(M) );
    
    M := TransposedMat(M);
    M := RowEchelonFormVector( M,b );
    while not IsDiagonalMat(M) do
        M := TransposedMat(M);
        M := RowEchelonFormT(M,Q);
        if not IsDiagonalMat(M) then
            M := TransposedMat(M);
            M := RowEchelonFormVector(M,b);
        fi;
    od;

    ##  Now we have D * y = b with  y =  Q * x

    ##  Check if we have any solutions modulo Z.
    for j in [Length(M)+1..Length(b)] do
        if not IsInt( b[j] ) then
            return [ [], [] ];
        fi;
    od;

    ##  Solve each line in D * y = b separately.
    L := List( [1..Length(M)], i->SolveOneInhomEquationModZ( M[i][i],b[i] ) );
    
    L := Cartesian( L );
    L := List( L, l->Concatenation( l,  0 * [Length(M)+1..Length(Q)] ) );
    L := List( L, l-> l * Q );

    L := List( L, l->List( l, q->FractionModOne(q) ) );
    
    return [ L, Q{[Length(M)+1..Length(Q)]} ];
end;

#############################################################################
##
#F  FixedPointsModZ  . . . . . . fixed points up to translational equivalence
##
##  This function takes a space group and computes the fixpoint spaces of
##  this group modulo the translation subgroup.  It is assumed that the
##  translation subgroup has full rank.
##
FixedPointsModZ := function( gens, d )
    local   I,  M,  b,  i,  g,  f,  F;
    
    #  Solve x * M + t = x modulo Z for all pairs (M,t) in the generators.
    #  This leads to the system
    #        x * [ M_1 M_2 ... ] = [ b_1 b_2 ... ]  (mod Z)

    M := List( [1..d], i->[] ); b := []; i := 0;
    I := IdentityMat(d+1);
    for g in gens do
        g := g - I;
        M{[1..d]}{[1..d]+i*d} := g{[1..d]}{[1..d]};
        Append( b, -g[d+1]{[1..d]} );
        i := i+1;
    od;

    # Catch trivial case
    if Length(M[1]) = 0 then M := List( [1..d], x->[0] ); b := [1..d]*0; fi;
    
    ##  Compute the spaces of points fixed modulo translations.
    F := SolveInhomEquationsModZ( M, b );
    return List( F[1], f -> rec( translation := f, basis := F[2] ) );

end;
    
#############################################################################
##
#F  WyPos( S, stabs, lift ) . . . . . . . . . . . . . . . . Wyckoff positions
##
WyPos := function( S, stabs, lift )

    local d, W, T, i, lst, w, dim, a, s, r, new, orb, I, gen, U, c; 

    # get representative affine subspace lattices
    d := DimensionOfMatrixGroup( S ) - 1;
    W := List( [0..d], i -> [] );
    T := TranslationBasis( S );
    for i in [1..Length(stabs)] do
        lst := List( GeneratorsOfGroup( stabs[i] ), lift );
        if IsAffineCrystGroupOnLeft( S ) then
            lst := List( lst, TransposedMat );
        fi;
        lst := FixedPointsModZ( lst, d ); 
        for w in lst do
            dim := Length( w.basis ) + 1; 
            w.translation := w.translation * T;
            w.basis       := w.basis * T;
            w.spaceGroup  := S;
            w.class       := i;
            ReduceAffineSubspaceLattice( w );
            Add( W[dim], w );
        od;
    od;

    # eliminate multiple copies
    I := IdentityMat( d );
    gen := Filtered( GeneratorsOfGroup( S ), g -> g{[1..d]}{[1..d]} <> I );
    if IsAffineCrystGroupOnLeft( S ) then
        gen := List( gen, TransposedMat );
    fi;
    U := AffineCrystGroupOnRight( gen, One( S ) );
    for i in [1..d+1] do
        lst := ShallowCopy( W[i] );
        new := [];
        while lst <> [] do
            s := lst[1];
            c := s.class;
            Unbind( s.class );
            orb := Orbit( U, s, ImageAffineSubspaceLattice );
            lst := Filtered( lst, 
                   x -> not rec( translation := x.translation,
                                 basis       := x.basis,
                                 spaceGroup  := x.spaceGroup   ) in orb );
            s.class := c;
            Add( new, WyckoffPositionObject( s ) );
        od;
        W[i] := new;
    od;
    return Flat( W );

end; 

#############################################################################
##
#M  WyckoffPositions( S ) . . . . . . . . . . . . . . . . . Wyckoff positions 
##
InstallMethod( WyckoffPositions, "for AffineCrystGroupOnLeftOrRight", 
    true, [ IsAffineCrystGroupOnLeftOrRight ], 0,
function( S )

    local P, N, lift, stabs, W;

    # check if we have indeed a space group
    if not IsSpaceGroup( S ) then
        Error("S must be a space group");
    fi;

    # get point group P, and its nice representation N
    P := PointGroup( S );
    N := NiceObject( P );

    # set up lift from nice rep to std rep
    lift  := x -> NiceToCrystStdRep( P, x );
    stabs := List( ConjugacyClassesSubgroups( N ), Representative );
    Sort( stabs, function(x,y) return Size(x) > Size(y); end );

    # now get the Wyckoff positions
    return WyPos( S, stabs, lift );

end );

#############################################################################
##
#M  WyckoffPositionsByStabilizer( S, stabs ) . . Wyckoff pos. for given stabs 
##
InstallGlobalFunction( WyckoffPositionsByStabilizer, function( S, stb )

    local stabs, P, lift;

    # check the arguments
    if not IsSpaceGroup( S ) then
        Error( "S must be a space group" );
    fi;
    if IsGroup( stb ) then
        stabs := [ stb ];
    else
        stabs := stb;
    fi;

    # get point group P
    P := PointGroup( S );

    # set up lift from nice rep to std rep
    lift  := x -> NiceToCrystStdRep( P, x );
    stabs := List( stabs, x -> Image( NiceMonomorphism( P ), x ) );
    Sort( stabs, function(x,y) return Size(x) > Size(y); end );

    # now get the Wyckoff positions
    return WyPos( S, stabs, lift );

end );


