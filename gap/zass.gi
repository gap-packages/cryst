#############################################################################
##
#A  zass.gi                 CrystGap library                     Bettina Eick
#A                                                              Franz G"ahler
#A                                                              Werner Nickel
##
#Y  Copyright 1990-1997,  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
##
##  Routines for the determination of space groups for a given a point group
##

#############################################################################
##
#F  NullBlockMat( <d>, <d1>, <d2> ). . . . . . d1xd2-matrix of d-NullMatrices
##
NullBlockMat := function( d, d1, d2 )
   # return d1 x d2 matrix, whose entries are d x d NullMatrices
   return List( [1..d1], i -> List( [1..d2], j -> NullMat( d, d ) ) );
end;

#############################################################################
##
#F  AugmentedMatrix( <matrix>, <trans> ). . . . .  construct augmented matrix
##
AugmentedMatrix := function( m, b )
   local g, t, x;
   g := MutableMatrix( m ); 
   for x in g do 
       Add( x, 0 ); 
   od;
   t := ShallowCopy( b ); 
   Add( t, 1 );
   Add( g, t );
   return g;
end;

#############################################################################
##
#F  MakeSpaceGroup( <d>, <Pgens>, <trans> ). . . . . . .construct space group
##
MakeSpaceGroup := function( d, Pgens, t )
   # construct space group from point group and translation vector
   local Sgens, i, m, S;

   # first the non-translational generators
   Sgens := List( [1..Length( Pgens )], 
                  i -> AugmentedMatrix( Pgens[i], t{[(i-1)*d+1..i*d]} ) );

   # the pure translation generators
   for i in [1..d] do
      m := IdentityMat( d+1 );
      m[d+1][i] := 1;
      Add( Sgens, m );
   od;

   # make the space group and return it
   S := AffineCrystGroupOnRight( Sgens, IdentityMat(d+1) );
   AddTranslationBasis( S, IdentityMat( d ) );
   return S;

end;

#############################################################################
##
#F  GroupExtEquations( <d>, <gens>, <rels> ) . equations for group extensions
##
GroupExtEquations := function( d, gens, rels )
   # construct equations which determine the non-primitive translations
   local mat, i, j, k, r, r0, prod;

   mat := NullBlockMat( d, Length(gens), Length(rels) );
   for i in [1..Length(rels)] do

      # interface to GAP-3 format
      r0 := rels[i]; r := [];
      for k in [1..Length(r0)/2] do
          for j in [1..r0[2*k]] do 
              Add( r, r0[2*k-1] );
          od;
      od; 

      prod := IdentityMat(d);
      for j in Reversed([1..Length(r)]) do
         if r[j]>0 then
            mat[ r[j] ][i] := mat[ r[j] ][i]+prod;
            prod := gens[ r[j] ]*prod;
         else
            prod := gens[-r[j] ]^-1*prod;
            mat[-r[j] ][i] := mat[-r[j] ][i]-prod;
         fi;
      od;

   od;
   return FlatBlockMat( mat );
end;


#############################################################################
##
#F  StandardTranslation( <trans>, <nullspace> ) . .reduce to std. translation
##
StandardTranslation := function( L, NN )
   # reduce non-primitive translations to "standard" form
   local N, j, k;

   # first apply "continuous" translations
   for N in NN[1] do
      j := PositionProperty( N, x -> x=1 );
      L := L-L[j]*N;
   od;
   L := List( L, FractionModOne );

   # and then "discrete" translations
   for N in NN[2] do
      j := PositionProperty( N, x -> x<>0 );
      k := Int( L[j] / N[j] );
      if k > 0 then
         L := List( L-k*N, FractionModOne );
      fi;
   od;

   return L;

end;


#############################################################################
##
#F  SolveHomEquationsModZ( <mat> ) . . . . . . . . . . .  solve x*mat=0 mod Z
##
SolveHomEquationsModZ := function( M )

    local Q, L, N, N2;

    Q := IdentityMat( Length(M) );
    
    # first diagonalize M
    M := TransposedMat(M);
    M := RowEchelonForm( M );
    while not IsDiagonalMat(M) do
        M := TransposedMat(M);
        M := RowEchelonFormT(M,Q);
        if not IsDiagonalMat(M) then
            M := TransposedMat(M);
            M := RowEchelonForm(M);
        fi;
    od;

    # and then determine the solutions of x*M=0 mod Z
    if Length(M)>0 then
        L := List( [1..Length(M)], i -> [ 0 .. M[i][i]-1 ] / M[i][i] );
        L := List( Cartesian( L ), l -> l * Q{[1..Length(M)]} );
    else
        L := NullMat( 1, Length(Q) );
    fi;

    # we later need the space in which one can freely shift
    # non-primitive translations; first the translations which 
    # can be applied with rational coefficients

    if Length(M)<Length(Q) then
        N := Q{[Length(M)+1..Length(Q)]};
        TriangulizeMat( N );
    else
        N := [];
    fi; 

    # and now those which allow only integral coefficients
    if N<>[] then
       N2 := List( N, n -> List( n, FractionModOne ) );
       N2 := ReducedLatticeBasis( N2 );
       N2 := List( N2, n -> List( n, FractionModOne ) );
       N2 := Filtered( N2, n -> n<>0*N[1] );
    else
       N2 := [];
    fi;

    # reduce non-primitive translations to standard form
    L := Set( List( L, x -> StandardTranslation( x, [ N, N2 ] ) ) );

    return [ L, [ N, N2 ] ];

end;


#############################################################################
##
#F  EliminateEquivExtensions( <trans>, <nullspace>, <norm>, <grp> ) . . . . .
#F  . .  . . remove extensions equivalent by conjugation with elems from norm
##
EliminateEquivExtensions := function( ll, nn, norm, grp )

   # check for conjugacy with generators of the normalizer of grp in GL(n,Z)

   local cent, d, gens, sgens, res, orb, x, y, c, n, i, j, sg, h, m;

   cent := Filtered( norm, 
             x -> ForAll( GeneratorsOfGroup( grp ), g -> x*g=g*x ) );
   SubtractSet( norm, cent );

   d     := DimensionOfMatrixGroup( grp );
   gens  := GeneratorsOfGroup( grp );
   sgens := List( gens, g -> AugmentedMatrix( g, List( [1..d], x -> 0 ) ) );

   res := [ ];
   while ll<>[] do
      Add( res, ll[1] );
      orb := [ ll[1] ]; 
      for x in orb do

         # first the generators which are in the centralizer
         for c in cent do
            y := List([1..Length(gens)], i -> x{ [(i-1)*d+1..i*d] }*c );
            y := StandardTranslation( Concatenation(y), nn );
            if not y in orb then 
               Add( orb, y ); 
            fi;
         od;

         # then the remaining ones; this is more complicated
         for n in norm do
            for i in [1..Length(gens)] do
               for j in [1..d] do
                  sgens[i][d+1][j]:=x[(i-1)*d+j];
               od;
            od;
            sg := Group( sgens, IdentityMat( d+1 ) );
            SetIsFinite( sg, false );
            h :=GroupHomomorphismByImagesNC( sg, grp, sgens, gens );
            y :=[];
            for i in [1..Length(gens)] do
               m := PreImagesRepresentative( h, n*gens[i]*n^-1 );
               Append( y, m[d+1]{[1..d]}*n );
            od;
            y := StandardTranslation( y, nn );
            if not y in orb then
               Add( orb, y ); 
            fi;
         od;

      od;
      SubtractSet( ll, orb );
   od;

   return res;

end;


#############################################################################
##
#F  SpaceGroupsByPointGroupOnRight( <grp> [, <norm>] ) . . . . .compute group
#F     . . . . . extensions, inequivalent by conjugation with elems from norm
##
InstallGlobalFunction( SpaceGroupsByPointGroupOnRight, function( arg )

# construct group extensions of Z^d by grp

   local d, grp, norm, N, F, Fam, rels, gens, mat, ext;

   grp := arg[1];
   if Length(arg)>1 then 
      norm := arg[2]; 
   else 
      norm := []; 
   fi;
   d := DimensionOfMatrixGroup( grp );

   # catch the trivial case
   if IsTrivial( grp ) then
#      return [ [ List( [1..d], i -> 0 ) ], [ IdentityMat(d), [] ] ];
      return [ MakeSpaceGroup( d, [], [] ) ];
   fi;

   # first get group relators for grp
   N := NiceObject( grp );
   F := Image( IsomorphismFpGroupByGenerators( N, GeneratorsOfGroup( N ) ) );
   rels := List( RelatorsOfFpGroup( F ), ExtRepOfObj );
   gens := GeneratorsOfGroup( grp );

   # construct equations which determine the non-primitive translations
   mat := GroupExtEquations( d, gens, rels );

   # now solve them modulo integers
   ext := SolveHomEquationsModZ( mat );
   
   # eliminate group extensions which are equivalent as space groups
   if Length( ext[1] ) > 2 then
      norm := Set( Filtered( norm, x -> not x in grp ) );
      if Length( norm ) > 0 then
         ext[1] := EliminateEquivExtensions( ext[1], ext[2], norm, grp );
      fi;
   fi;
   
#   return ext;
   return List( ext[1], x -> MakeSpaceGroup( d, gens, x ) );

end );


#############################################################################
##
#F  SpaceGroupsByPointGroupOnLeft( <grp> [, <norm>] ) . . . . . compute group
#F     . . . . . extensions, inequivalent by conjugation with elems from norm
##
InstallGlobalFunction( SpaceGroupsByPointGroupOnLeft, function( arg )
   local gen, norm, G, tmp, lst, S, R;
   gen := List( GeneratorsOfGroup( arg[1] ), TransposedMat );
   if Length(arg)>1 then 
      norm := List( arg[2], TransposedMat ); 
   else 
      norm := []; 
   fi;
   G := Group( gen, One( arg[1] ) );
   tmp := SpaceGroupsByPointGroupOnRight( G, norm );
   lst := [];
   for S in tmp do
       gen := List( GeneratorsOfGroup( S ), TransposedMat );
       R := AffineCrystGroupOnLeft( gen, One( S ) );
       AddTranslationBasis( R, TranslationBasis( S ) );
       Add( lst, R );
   od;
   return lst;
end );


#############################################################################
##
#F  SpaceGroupsByPointGroup( <grp> [, <norm>] ) . . compute group extensions,
#F     . . . . . . . . . . . inequivalent by conjugation with elems from norm
##
InstallGlobalFunction( SpaceGroupsByPointGroup, function( arg )
    local G, norm;
    G := arg[1];
    if Length( arg ) > 1 then
        norm := arg[2];
    else
        norm := [];
    fi;
    if CrystGroupDefaultAction = RightAction then
        return SpaceGroupsByPointGroupOnRight( G, norm );
    else
        return SpaceGroupsByPointGroupOnLeft( G, norm );
    fi;
end );

#############################################################################
##
#M  SpaceGroupTypesByPointGroupOnRight( <G> ) . . . . . space group type reps
##
InstallGlobalFunction( SpaceGroupTypesByPointGroupOnRight, function( G )
    local N;
    if not IsIntegerMatrixGroup( G ) then
        Error( "G must be an integer matrix group" );
    fi;
    if not IsFinite( G ) then
        Error( "G must be finite" );
    fi;
    N := NormalizerInGLnZ( G );
    return SpaceGroupsByPointGroupOnRight( G, GeneratorsOfGroup( N ) );
end );

#############################################################################
##
#M  SpaceGroupTypesByPointGroupOnLeft( <G> ) . . . . . .space group type reps
##
InstallGlobalFunction( SpaceGroupTypesByPointGroupOnLeft, function( G )
    local N;
    if not IsIntegerMatrixGroup( G ) then
        Error( "G must be an integer matrix group" );
    fi;
    if not IsFinite( G ) then
        Error( "G must be finite" );
    fi;
    N := NormalizerInGLnZ( G );
    return SpaceGroupsByPointGroupOnLeft( G, GeneratorsOfGroup( N ) );
end );

#############################################################################
##
#M  SpaceGroupTypesByPointGroup( <G> ) . . . . . . . . .space group type reps
##
InstallGlobalFunction( SpaceGroupTypesByPointGroup, function( G )
    local N;
    if not IsIntegerMatrixGroup( G ) then
        Error( "G must be an integer matrix group" );
    fi;
    if not IsFinite( G ) then
        Error( "G must be finite" );
    fi;
    N := NormalizerInGLnZ( G );
    return SpaceGroupsByPointGroup( G, GeneratorsOfGroup( N ) );
end );
