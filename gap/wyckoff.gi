#############################################################################
##
#A  wyckoff.gi                Cryst library                      Bettina Eick
#A                                                              Franz G"ahler
#A                                                              Werner Nickel
##
#Y  Copyright 1997-2012  by  Bettina Eick,  Franz G"ahler  and  Werner Nickel
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
    Print( "< Wyckoff position, point group ", w!.class, 
           ", translation := ", w!.translation, 
           ", \nbasis := ", w!.basis, " >\n" );
end );

#############################################################################
##
#M  ViewObj . . . . . . . . . . . . . . . . . . . . . View a Wyckoff position
##
InstallMethod( ViewObj,
    "Wyckoff position", true, [ IsWyckoffPosition ], 0,
function( w )
    Print( "< Wyckoff position, point group ", w!.class, 
           ", translation := ", w!.translation, 
           ", \nbasis := ", w!.basis, " >\n" );
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
#F  IsVectorInSpan . . . . . . .is a vector in the span of a list of vectors?
##
IsVectorInSpan := function( v, T )
  # Catch trivial cases
  if IsEmpty(T) then
    return false;
  fi;
  if IsZero(v) then
    return true;
  fi;
  # I could catch errors, but for an internal function I can assume
  # well-behaved input
  # Check if is in span
  return Rank(Concatenation(T,[v])) = Rank(T);
end;

#############################################################################
##
#F  ReducedLatticeBasisByOrbits . .helper function for SymmetricInternalBasis
##
ReducedLatticeBasisByOrbits := function( T, S )
  # Like ReducedLatticeBasis, but recursively optimises the basis to have
  # elements in the same orbit. This is because, when building the internal
  # basis, only the orientations of the fictitious lattice vectors are defined;
  # the lengths are free variables. But we want the lattive to respect the 
  # symmetries, so the lengths need to be related.
  # T: fictitious basis vectors to reduce.
  # S: Crystallographic group (to get point group and dimensionality).
  local P, d, T2, t;
  # Catch trivial case
  if IsEmpty(T) then
    return [];
  fi;
  P := PointGroup(S);
  d := DimensionOfMatrixGroup(P);
  # Initial reduction so have consistent starting point
  T := ReducedLatticeBasis(T);
  T2 := [];
  # Iterate through vectors in T until we have full basis or exhaust T.
  for t in T do
    # Only consider a vector if it expands the basis.
    if not IsVectorInSpan(t, T2) then
      # Get all vectors in the same orbit.
      Append(T2, Orbit(P, t));
      # Reduce to minimal basis set.
      T2 := ReducedLatticeBasis(T2);
      if Length(T2) = d then
        return T2;
      fi;
    fi;
  od;
  return T2;
end;

#############################################################################
##
#M  SymmetricInternalBasis . .internal basis that respects lattice symmetries
##
InstallMethod( SymmetricInternalBasis,
    true, [ IsAffineCrystGroupOnLeftOrRight ], 0,
function( S )
    local d, T, gens, g, vecs, eigenvals, ev, i, v, spare_eigenvecs, k, comp,
          idx, e, j, order, rotations, M, vlist, newbasis, T2, tmpbasis;
    d := DimensionOfMatrixGroup(S) - 1;
    T := TranslationBasis(S);
    # If we have a space group, no need to find extra vectors
    if Length(T) = d then
      return T;
    fi;
    T := ShallowCopy(T);
    # Get to consistent Action (okay, this might falter for point groups)
    if not IsAffineCrystGroupOnRight(S) then
      S := TransposedMatrixGroup(S);
    fi;
    # Grab the linear part of the non-trivial generators
    gens := Filtered(PointGroup(S), x -> (x <> IdentityMat(d)) and (x <> -IdentityMat(d)));
    # If we have no non-trivial operators, then the regular InternalBasis
    # will do
    if Length(gens) = 0 then
      return InternalBasis( S );
    fi;
    # We want to consider not just the generators, but sums of generator products.
    # This solves for a different set of vectors, like the rotational plane.
    # (If GAP allowed complex numbers, we could get all eigenvectors from gens,
    # but it doesn't.)
    for i in [1..Length(gens)] do
      order := Order(gens[i]);
      if order > 2 then
        # Order > 2 allows complex eigenvalues, so need a supplemental matrix
        # to get complementary eigenvectors.
        # Sum of products of the matrix up to the Order. This is guaranteed to
        # have real eigenvalues (but not necessarily the same sets of degeneracy).
        M := Sum(List([0..order-1], x -> gens[i]^x));
        if not M in gens then
          Add(gens, M);
        fi;
      fi;
    od;
    spare_eigenvecs := rec();
    newbasis := [];
    # Go over each generator. Find the eigenvectors.
    for g in gens do
      vecs := Eigenvectors(Rationals, g);
      # Get the eigenvalues for each eigenvector
      eigenvals := [];
      for v in vecs do
        ev := v * g; # ev: v times eigenvalue
        # Find the first non-zero value, if present, and divide
        if ev = Zero(v) then
          # If ev is zero vector, then eigenvalue is zero
          Add(eigenvals, 0);
        else
          # Find the first non-zero value
          i := PositionProperty(ev, x -> x <> 0);
          Add(eigenvals, ev[i] / v[i]);
        fi;
      od;
      # We'll sort the eigenvalues
      StableSortParallel(eigenvals, vecs);
      # Single out the eigenvectors with non-degenerate eigenvalues
      # but keep the degenerate ones in case we exhaust the non-degenerate ones.
      for e in eigenvals do
        idx := Positions(eigenvals, e);
        if Length(idx) > 1 then
          # Pop degenerate eigenvectors
          if IsBound(spare_eigenvecs.(Length(idx))) then
            # Don't record duplicates
            if not vecs{idx} in spare_eigenvecs.(Length(idx)) then
              Add(spare_eigenvecs.(Length(idx)), vecs{idx});
            fi;
          else
            spare_eigenvecs.(Length(idx)) := [vecs{idx}];
          fi;
          for i in Reversed(idx) do
            Remove(vecs, i);
            Remove(eigenvals, i);
          od;
        fi;
        # Otherwise, just keep the vector in vecs
      od;
      # The vectors remaining in vecs have unique eigenvalues.
      for v in vecs do
        # Check whether this new vector extends T and we don't already have it
        # If yes, Add to list of candidate vectors
        if not IsVectorInSpan(v, T) and not v in newbasis then
          Add(newbasis, v);
        fi;
      od;
    od;
    # Now that we have candidate (non-degenerate) vectors for the internal basis,
    # let us reduce this fictional lattice.
    newbasis := ReducedLatticeBasisByOrbits(newbasis, S);
    if Length(newbasis) + Length(T) > d then
      ErrorNoReturn("Somehow have more basis vectors than dimensions!?!");
    fi;
    if Length(newbasis) + Length(T) = d then
      # We've found a full basis!
      T := Concatenation(T, newbasis);
      if Determinant(T) < 0 then
        # Ensure our basis has a positive determinant. This is to avoid
        # accidentally changing chirality when going to standard basis.
        T[d] := -T[d];
      fi;
      return T;
    fi;
    # If we've made it here, we've exhausted the non-degenerate eigenvectors
    # Now let's go through the spares in increasing order of degeneracy.
    for i in Set(RecNames(spare_eigenvecs), Int) do
      tmpbasis := [];
      for vlist in spare_eigenvecs.(i) do
        for v in vlist do
          if not IsVectorInSpan(v, Concatenation(T, newbasis, tmpbasis)) then
            # Add all rotations of this vector, but cut out redundant vectors
            Append(tmpbasis, ReducedLatticeBasis(Orbit(PointGroup(S), v)));
          fi;
        od;
        # Add our new basis vectors to the set
        Append(newbasis, tmpbasis);
        newbasis := ReducedLatticeBasisByOrbits(newbasis, S);
        if Length(newbasis) + Length(T) > d then
          ErrorNoReturn("Somehow have more basis vectors than dimensions!?!");
        fi;
        if Length(newbasis) + Length(T) = d then
          # We've found a full basis!
          T := Concatenation(T, newbasis);
          if Determinant(T) < 0 then
            # Ensure our basis has a positive determinant. This is to avoid
            # accidentally changing chirality when going to standard basis.
            T[d] := -T[d];
          fi;
          return T;
        fi;
      od;
    od;
    # Iterate over all vectors until Length(T) = d.
    # If somehow we exhaust all vectors before then, resort to InternalBasis'
    # algorithm for filling out the remaining vectors.
    if Length(T) = 0 then
      return IdentityMat(d);
    else
      T2 := ReducedLatticeBasis(T); # InternalBasis assumes T is reduced
      comp := NullMat( d - Length(T2), d );
      i:=1; j:=1; k:=1;
      while i <= Length( T2 ) do
          while T2[i][j] = 0 do
              comp[k][j] := 1;
              k := k+1; j:=j+1;
          od;
          i := i+1; j := j+1;
      od;
      while j <= d do
          comp[k][j] := 1;
          k := k+1; j:=j+1;
      od;
      Append(T, comp);
    fi;
    if Determinant(T) < 0 then
      # Change sign to be positive determinant.
      T[d] := -T[d];
    fi;
    return T;
end );

#############################################################################
##
#M  ReduceAffineSubspaceLattice . . . . reduce affine subspace modulo lattice
##
InstallGlobalFunction( ReduceAffineSubspaceLattice, 
function( r )

    local rk, d, T, Ti, M, R, Q, Qi, P, v, j;

    r.basis := ReducedLatticeBasis( r.basis );
    rk := Length( r.basis );
    d  := Length( r.translation );
    T  := SymmetricInternalBasis( r.spaceGroup );
    # Using SymmetricInternalBasis allows handling subperiodic groups.
    Ti := T^-1;

    if rk = d then
        v := 0 * r.translation;
    elif rk > 0 then
        M := r.basis;
        v := r.translation;
        if T <> One(T) then
            M := M * Ti;
            v := v * Ti;
        fi;

        # these three lines are faster than the other four
        Q := IdentityMat(d);
        RowEchelonFormT(TransposedMat(M),Q);
        Q := TransposedMat(Q);

        # R := NormalFormIntMat( TransposedMat( M ), 4 );
        # Q := TransposedMat( R.rowtrans );
        # R := NormalFormIntMat( M, 9 );
        # Q := R.coltrans; 

        Qi := Q^-1;
        P := Q{[1..d]}{[rk+1..d]} * Qi{[rk+1..d]};
        v := List( v * P, FractionModOne );
        if T <> One(T) then
            v := v * T;
        fi;
        v := VectorModL( v, TranslationBasis(r.spaceGroup) );
    else
        v := VectorModL( r.translation, TranslationBasis(r.spaceGroup) );
    fi;
    r.translation := v;

end );

#############################################################################
##
#F  ImageAffineSubspaceLattice . . . .image of affine subspace modulo lattice
##
InstallGlobalFunction( ImageAffineSubspaceLattice, function( s, g )
    local d, m, t, b, r;
    d := Length( s.translation );
    m := g{[1..d]}{[1..d]};
    t := g[d+1]{[1..d]};
    b := s.basis;
    if not IsEmpty(b) then b := b * m; fi;
    r := rec( translation := s.translation * m + t,
              basis       := b,
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
    local d, m, t, b, L, r;
    d := Length( s.translation );
    m := g{[1..d]}{[1..d]};
    t := g[d+1]{[1..d]};
    b := s.basis;
    if not IsEmpty(b) then b := b * m; fi;
    L := TranslationBasis( s.spaceGroup );
    r := rec( translation := VectorModL( s.translation * m + t, L ),
              basis       := b,
              spaceGroup  := s.spaceGroup );
    return r;
end );

#############################################################################
##
#M  \= . . . . . . . . . . . . . . . . . . . . . . .for two Wyckoff positions 
##
InstallMethod( \=, IsIdenticalObj,
    [ IsWyckoffPosition, IsWyckoffPosition ], 0,
function( w1, w2 )
    local S, r1, r2, d, gens, U, rep;
    S := WyckoffSpaceGroup( w1 );
    if S <> WyckoffSpaceGroup( w2 ) then
        return false;
    fi;
    r1 := rec( translation := WyckoffTranslation( w1 ),
               basis       := WyckoffBasis( w1 ),
               spaceGroup  := WyckoffSpaceGroup( w1 ) );
    r2 := rec( translation := WyckoffTranslation( w2 ),
               basis       := WyckoffBasis( w2 ),
               spaceGroup  := WyckoffSpaceGroup( w2 ) );
    r1 := ImageAffineSubspaceLattice( r1, One(S) );
    r2 := ImageAffineSubspaceLattice( r2, One(S) );
    d := DimensionOfMatrixGroup( S ) - 1;
    gens := Filtered( GeneratorsOfGroup( S ),
                      x -> x{[1..d]}{[1..d]} <> One( PointGroup( S ) ) );
    U := SubgroupNC( S, gens );
    if IsAffineCrystGroupOnLeft( U ) then
      U := TransposedMatrixGroup( U );
    fi;
    rep := RepresentativeAction( U, r1, r2, ImageAffineSubspaceLattice );
    return rep <> fail;
end );

#############################################################################
##
#M  \< . . . . . . . . . . . . . . . . . . . . . . .for two Wyckoff positions 
##
InstallMethod( \<, IsIdenticalObj,
    [ IsWyckoffPosition, IsWyckoffPosition ], 0,
function( w1, w2 )
    local S, r1, r2, d, gens, U, o1, o2;
    S := WyckoffSpaceGroup( w1 );
    if S <> WyckoffSpaceGroup( w2 ) then
        return S < WyckoffSpaceGroup( w2 );
    fi;
    r1 := rec( translation := WyckoffTranslation( w1 ),
               basis       := WyckoffBasis( w1 ),
               spaceGroup  := WyckoffSpaceGroup( w1 ) );
    r2 := rec( translation := WyckoffTranslation( w2 ),
               basis       := WyckoffBasis( w2 ),
               spaceGroup  := WyckoffSpaceGroup( w2 ) );
    r1 := ImageAffineSubspaceLattice( r1, One(S) );
    r2 := ImageAffineSubspaceLattice( r2, One(S) );
    d := DimensionOfMatrixGroup( S ) - 1;
    gens := Filtered( GeneratorsOfGroup( S ),
                      x -> x{[1..d]}{[1..d]} <> One( PointGroup( S ) ) );
    U := SubgroupNC( S, gens );
    if IsAffineCrystGroupOnLeft( U ) then
      U := TransposedMatrixGroup( U );
    fi;
    o1 := Orbit( U, r1, ImageAffineSubspaceLattice );
    o2 := Orbit( U, r2, ImageAffineSubspaceLattice );
    o1 := Set( List( o1, x -> rec( t := x.translation, b := x.basis ) ) );
    o2 := Set( List( o2, x -> rec( t := x.translation, b := x.basis ) ) ); 
    return o1[1] < o2[1];
end );

#############################################################################
##
#M  WyckoffStabilizer . . . . . . . . . . .stabilizer of representative space
##
InstallMethod( WyckoffStabilizer,
    true, [ IsWyckoffPosition ], 0, 
function( w )
    local S, t, B, d, I, gen, U, r, new, n, g, v;
    # BUG: Potentially returns Wyckoff Stabilizers that are too small if S is
    # a subperiodic group with an origin outside the span of its translation
    # basis.
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
        n[d+1] := g[d+1] - v;
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
    # BUG: Potentially returns Wyckoff Orbits with too many members if S is
    # a subperiodic group with an origin outside the span of its translation
    # basis.
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
    s := List( o, x -> WyckoffPositionObject( 
                              rec( translation := x.translation, 
                                   basis       := x.basis, 
                                   spaceGroup  := w!.spaceGroup,
                                   class       := w!.class ) ) );
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
##  If onRight = true, compute the set of solutions of the equation
##
##                           x * M = b  (mod Z).
##
##  If onRight = false, compute the set of solutions of the equation
##
##                           M * x = b  (mod Z).
##
##  RowEchelonFormT() returns a matrix Q such that Q * M is in row echelon
##  form.  This means that (modulo column operations) we have the equation
##         x * Q^-1 * D = b       with D a diagonal matrix.
##  Solving y * D = b we get x = y * Q.
##
SolveInhomEquationsModZ := function( M, b, onRight )

    local   Q,  j,  L,  space,  i,  v;
    
    b := ShallowCopy(b);
    if onRight then
        M := TransposedMat(M);
    fi;
    Q := IdentityMat( Length(M[1]) );
    M := RowEchelonFormVector( M,b );

    while Length(M) > 0 and not IsDiagonalMat(M) do
        M := TransposedMat(M);
        M := RowEchelonFormT(M,Q);
        if Length(M) > 0 and not IsDiagonalMat(M) then
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
    if Length(M[1]) = 0 then M := List( [1..d], x->[0] ); b := [0]; fi;
    
    ##  Compute the spaces of points fixed modulo translations.
    F := SolveInhomEquationsModZ( M, b, true );
    return List( F[1], f -> rec( translation := f, basis := F[2] ) );

end;
    
#############################################################################
##
#F  IntersectionsAffineSubspaceLattice( <U>, <V> )
##
IntersectionsAffineSubspaceLattice := function( U, V )

    local T, m, t, Ti, s, b, lst, x, len, tt;

    T  := TranslationBasis( U.spaceGroup );
    m  := Concatenation( U.basis, -V.basis );
    t  := V.translation - U.translation;
    Ti := T^-1;

    s  := SolveInhomEquationsModZ( m*Ti, t*Ti, true );

    if s[1] = [] then
        return fail;
    fi;

    b := IntersectionModule( U.basis, -V.basis );

    lst := [];
    for x in s[1] do
        tt := x{[1..Length(U.basis)]} * U.basis + U.translation;
        Add( lst, rec( translation := tt, basis := b, 
                       spaceGroup  := U.spaceGroup ) );
    od;

    for x in lst do
        ReduceAffineSubspaceLattice( x );
    od;

    return lst;

end;

#############################################################################
##
#F  IsSubspaceAffineSubspaceLattice( <U>, <V> )  repres. of V contained in U?
##
IsSubspaceAffineSubspaceLattice := function( U, V ) 
    local s;
    s := IntersectionsAffineSubspaceLattice( U, V );
    if s = fail then
        return false;
    else
        return V in s;
    fi;
end;

#############################################################################
##
#F  IsTranslationInBasis( S ) . . . . tests if Wyckoff position is in lattice
##
IsTranslationInBasis := function(f)
  local STB, t, d, S, gens, xs, translations, basis, t2, Q, R, sol, M, fvecs;
  # From our record f, checks whether the translation vector lies within 
  # the group's translation basis. Returns Boolean.
  # Also corrects the translation vector in-place to account for false
  # translations from the fake internal basis vectors.
  S := f.spaceGroup;
  # Trivial case: we have a space group
  if IsSpaceGroup(S) then
    return true;
  fi;
  # Otherwise, consider if the translation vector lies within the translation basis
  t := f.translation;
  d := Length(t);
  STB := TranslationBasis(S);
  # If the Wyckoff basis is non-empty, then maybe another point on the Wyckoff
  # position lies in the crystal's translation basis.
  if Length(f.basis) > 0 then
    STB := Concatenation(STB, -f.basis);
  fi;
  # Make all vectors in STB integers, so can use RowEchelonForm safely.
  # We can do this safely because we don't care about the magnitude of these
  # vectors, only their span.
  STB := List( STB, v -> v * Lcm(List(v, DenominatorRat)) );
  # Simplify (so Rank = Length)
  STB := RowEchelonForm(STB);
  # Trivial case: the basis of allowed points fills the whole space
  if Length(STB) = d then
    return true;
  fi;
  # Now, we can't simply check if t is in the span of STB, because
  # the origin may be non-zero. Instead, we must check if the vectors,
  # when operated on, fit the span.
  gens := GeneratorsOfGroup(S);
  if IsAffineCrystGroupOnLeft(S) then
    gens := List(gens, TransposedMat);
  fi;
  # We'll also filter the pure translations out of gens, because those have
  # been caught in TranslationBasis(S);
  gens := Filtered(gens, g -> g{[1..d]}{[1..d]} <> IdentityMat(d));
  # Let us check for a simpler case: the origin is at zero.
  # This is guaranteed if there are no translation components in the generators,
  # or the translation components are within the span of the translation basis.
  translations := List(gens, g -> g[d+1]{[1..d]});
  if RankMat(Concatenation(STB, translations)) = Length(STB) then
    # There are no symmetry operators to take the origin outside the lattice
    # Can use a cheaper check, as solutions don't need to account for an
    # extra translation.
    if RankMat(Concatenation(STB, [t])) = Length(STB) then
      return true;
    else
      # Check if t modulo Z is usable
      # Because earlier parts of the algorithm give the translation modulo
      # fictitious lattice vectors, so we want to choose the correct modulo.
      # Convert to standard basis
      basis := SymmetricInternalBasis(S);
      t := t * Inverse(basis);
      STB := STB * Inverse(basis);
      Q := IdentityMat(d);
      R := RowEchelonFormT(TransposedMat(STB), Q);
      # Q * TransposedMat(STB) = R (except R drops zero rows)
      t2 := Q * t;
      # Grab just the inconsistent part of the solution vector.
      t2{[1..Length(R)]} := 0 * [1..Length(R)];
      t2 := Inverse(Q) * t2; # Convert out of row echelon form
      # Check that it is integers
      if not ForAll(t2, IsInt) then
        return false;
      fi;
      # If it is, correct the translation.
      f.translation := f.translation - t2 * basis;
      ReduceAffineSubspaceLattice(f);
      return true;
    fi;
  fi;
  # xs are the difference between point t and point t after being operated on.
  xs := List(gens, g -> (Concatenation(t, [1]) * (g - One(g))){[1..d]});
  # If xs are all in the span of the translation basis, then the point being
  # acted on is staying inside the lattice, so is valid.
  if Length(STB) = RankMat(Concatenation(STB, xs)) then
    return true;
  fi;
  # Otherwise, we need to test if this point shifted by an integer number of
  # fictitious lattice vectors would give a point in the lattice.
  # First, grab the fictitious lattice vectors.
  fvecs := Filtered( SymmetricInternalBasis(S), v -> not v in TranslationBasis(S) );
  # We now solve the system of all xs simultaneously.
  Q := IdentityMat(d * Length(gens));
  R := RowEchelonFormT(KroneckerProduct(IdentityMat(Length(gens)), TransposedMat(STB)), Q);
  t2 := Q * Flat(xs); # Q is the transformation taking to REF.
  # Grab just the inconsistent part
  t2{[1..Length(R)]} := 0 * [1..Length(R)];
  # We now have (g-I) * fvec * n = t2.
  # We want to find n if it is integers.
  # Stack up all the linear parts of the generators.
  # (Remember that gens are RightAction, so normally act on row vectors.)
  # (But I'm doing maths with column vectors at the moment.)
  M := Concatenation(List(gens, g -> TransposedMat(g{[1..d]}{[1..d]}) - IdentityMat(d) ));
  # Multiply by the vectors of interest.
  # Move to the same REF
  M := Q * M * TransposedMat(fvecs);
  # Find an integer solution, for just the inconsistent part.
  # (IntSolutionMat works on RightAction)
  sol := IntSolutionMat(TransposedMat(M{[Length(R)+1..Length(M)]}), t2{[Length(R)+1..Length(t2)]});
  if sol = fail then
    return false;
  else
    # We have a solution. Correct the translation and go home.
    f.translation := f.translation - sol * fvecs;
    ReduceAffineSubspaceLattice(f);
    return true;
  fi;
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
    T := SymmetricInternalBasis( S );
    for i in [1..Length(stabs)] do
        lst := List( GeneratorsOfGroup( stabs[i] ), lift );
        if IsAffineCrystGroupOnLeft( S ) then
            lst := List( lst, TransposedMat );
        fi;
        lst := FixedPointsModZ( lst, d ); 
        for w in lst do
            dim := Length( w.basis ) + 1; 
            w.translation := w.translation * T;
            if not IsEmpty( w.basis ) then
                w.basis       := w.basis * T;
            fi;
            w.spaceGroup  := S;
            w.class       := i;
            ReduceAffineSubspaceLattice( w );
            if IsTranslationInBasis(w) then
              Add( W[dim], w );
            fi;
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
            orb := Orbit( U, Immutable(s), ImageAffineSubspaceLattice );
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
#F  WyPosSGL( S ) . . . Wyckoff positions via subgroup lattice of point group 
##
WyPosSGL := function( S )

    local P, N, lift, stabs, W;

    # get point group P, and its nice representation N
    P := PointGroup( S );
    N := NiceObject( P );

    # set up lift from nice rep to std rep
    if IsSpaceGroup(S) then
      lift  := x -> NiceToCrystStdRep( P, x );
    else
      lift := x -> NiceToCrystStdRepSymmetric( P, x );
    fi;
    stabs := List( ConjugacyClassesSubgroups( N ), Representative );
    Sort( stabs, function(x,y) return Size(x) > Size(y); end );

    # now get the Wyckoff positions
    return WyPos( S, stabs, lift );

end;

#############################################################################
##
#F  WyPosStep . . . . . . . . . . . . . . . . . . .induction step for WyPosAT 
##
WyPosStep := function( idx, G, M, b, lst )

    local g, G2, M2, b2, F, c, added, stop, f, d, w, O;

    g := lst.z[idx];
    if not g in G then
        G2 := ClosureGroup( G, g );
        M2 := Concatenation( M, lst.mat[idx] );
        b2 := Concatenation( b, lst.vec[idx] );
        if M <> [] then
            M2 := RowEchelonFormVector( M2, b2 );
        fi;
        if ForAll( b2{[Length(M2)+1..Length(b2)]}, IsInt ) then
            b2 := b2{[1..Length(M2)]};
            F := SolveInhomEquationsModZ( M2, b2, false );
            F := List( F[1], f -> rec( translation := f, basis := F[2] ) );
        else
            F := [];
        fi;
        # At this stage, F contains possible basis and translation information
        # for the Wyckoff positions
        c := lst.c + 1;
        added := false;
        for f in F do
            d := Length( f.basis ) + 1; 
            stop := d=lst.dim+1;
            # Multiplying by the translation basis of the group takes it back
            # to the original setting from the standard setting
            f.translation := f.translation * lst.T;
            if not IsEmpty( f.basis ) then
                f.basis   := f.basis * lst.T;
            fi;
            f.spaceGroup  := lst.S;
            ReduceAffineSubspaceLattice( f );
            if IsTranslationInBasis(f) then
              # Exclude f if f.translation lies
              # outside the span of TranslationBasis(lst.S).
              # IsTranslationInBasis also accounts for f.translation possibly
              # being off modulo 1 and corrects it, and accounts for
              # non-centered origins.
              if not f in lst.sp[d] then
                # We check for duplicates after we potentially correct
                # the translation.
                O := Orbit( lst.S2, Immutable(f), ImageAffineSubspaceLattice );
                w := ShallowCopy( f );
                w.class := c;
                UniteSet( lst.sp[d], O );
                Add( lst.W[d], WyckoffPositionObject(w) );
                added := true;
              fi;
            fi;
        od;
        if added and not stop then
            lst.c := lst.c+1;
            if idx < Length(lst.z) then
                WyPosStep( idx+1, G2, M2, b2, lst );
            fi;
        fi;
    fi;
    if idx < Length(lst.z) then
        WyPosStep( idx+1, G, M, b, lst );
    fi;

end;

#############################################################################
##
#F  WyPosAT( S ) . . . . Wyckoff positions with recursive method by Ad Thiers 
##
WyPosAT := function( S )

    local d, P, gen, S2, lst, zz, mat, vec, g, m, M, b, s, w;

    d := DimensionOfMatrixGroup(S)-1;
    P := PointGroup( S );
    gen := Filtered( GeneratorsOfGroup(S), x -> x{[1..d]}{[1..d]} <> One(P) );
    S2 := Subgroup( S, gen );
    if IsAffineCrystGroupOnLeft( S ) then
        S2 := TransposedMatrixGroup( S2 );
    fi;
    
    lst := rec( dim := d, T := SymmetricInternalBasis(S), S := S, c := 1,
                S2 := S2 );
    # T used to be TranslationBasis, but it's used for changing from Standard
    # form to original form, so needs to be a full matrix.

    zz := []; mat := []; vec := [];
    for g in Zuppos( NiceObject( P ) ) do
        if g <> () then
            # Record a point group operation *in standard basis*
            # Meaning you might have permuted the bases.
            if IsSpaceGroup( S ) then
              m := NiceToCrystStdRep(P,g);
            else
              # If a sub-periodic group, need to do some slightly more expensive checks.
              m := NiceToCrystStdRepSymmetric(P,g);
            fi;
            if IsAffineCrystGroupOnRight( S ) then
                m := TransposedMat(m);
            fi;
            # The matrix M and vector b are used in a set of equations
            # to solve for the Wyckoff positions
            M := m{[1..d]}{[1..d]}-IdentityMat(d);
            b := m{[1..d]}[d+1];
            M := RowEchelonFormVector(M,b);
            if ForAll( b{[Length(M)+1..Length(b)]}, IsInt ) then
                Add( zz,  g );
                Add( mat, M );
                Add( vec, -b{[1..Length(M)]} );
            fi;
        fi;
    od;
    lst.z   := zz;
    lst.mat := mat;
    lst.vec := vec;
    
    # This record is used to build the general position.
    s := rec( translation := ListWithIdenticalEntries(d,0),
              basis       := SymmetricInternalBasis(S),
              spaceGroup  := S );
    ReduceAffineSubspaceLattice(s);
    lst.sp := List( [1..d+1], x-> [] ); Add( lst.sp[d+1], s );
    
    # Here we make the general position
    w := ShallowCopy( s );
    w.class := 1;
    w := WyckoffPositionObject( w );
    lst.W := List( [1..d+1], x -> [] ); Add( lst.W[d+1], w );

    if 1 <= Length(lst.z) then
        WyPosStep(1,TrivialGroup(IsPermGroup),[],[],lst);
    fi;

    return Flat(lst.W);

end;

#############################################################################
##
#M  WyckoffPositions( S ) . . . . . . . . . . . . . . . . . Wyckoff positions 
##
InstallMethod( WyckoffPositions, "for AffineCrystGroupOnLeftOrRight", 
    true, [ IsAffineCrystGroupOnLeftOrRight ], 0,
function( S )

    # for small dimensions, the recursive method is faster
    if DimensionOfMatrixGroup( S ) < 6 then
        return WyPosAT( S );
    else
        return WyPosSGL( S );
    fi;

end );

#############################################################################
##
#M  WyckoffPositionsByStabilizer( S, stabs ) . . Wyckoff pos. for given stabs 
##
InstallGlobalFunction( WyckoffPositionsByStabilizer, function( S, stb )

    local stabs, P, lift;

    # check the arguments
    if IsGroup( stb ) then
        stabs := [ stb ];
    else
        stabs := stb;
    fi;

    # get point group P
    P := PointGroup( S );

    # set up lift from nice rep to std rep
    if IsSpaceGroup(S) then
      lift  := x -> NiceToCrystStdRep( P, x );
    else
      lift  := x -> NiceToCrystStdRepSymmetric( P, x );
    fi;
    stabs := List( stabs, x -> Image( NiceMonomorphism( P ), x ) );
    Sort( stabs, function(x,y) return Size(x) > Size(y); end );

    # now get the Wyckoff positions
    return WyPos( S, stabs, lift );

end );

#############################################################################
##
#M  WyckoffGraphFun( S, def ) . . . . . . . . . . . . display a Wyckoff graph 
##
InstallMethod( WyckoffGraph, true, 
    [ IsAffineCrystGroupOnLeftOrRight, IsRecord ], 0,
function( S, def )
    return WyckoffGraphFun( WyckoffPositions( S ), def );
end );

InstallOtherMethod( WyckoffGraph, true, 
    [ IsAffineCrystGroupOnLeftOrRight ], 0,
function( S )
    return WyckoffGraphFun( WyckoffPositions( S ), rec() );
end );

InstallOtherMethod( WyckoffGraph, true, 
    [ IsList, IsRecord ], 0,
function( L, def )
    if not ForAll( L, IsWyckoffPosition ) then
       Error("L must be a list of Wyckoff positions of the same space group");
    fi;
    return WyckoffGraphFun( L, def );
end );

InstallOtherMethod( WyckoffGraph, true, 
    [ IsList ], 0,
function( L )
    if not ForAll( L, IsWyckoffPosition ) then
       Error("L must be a list of Wyckoff positions of the same space group");
    fi;
    return WyckoffGraphFun( L, rec() );
end );

