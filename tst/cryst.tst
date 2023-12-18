gap> START_TEST( "Cryst: cryst.tst" );

gap> SetAssertionLevel(1);

gap> C := SpaceGroupIT( 3, 133 );
SpaceGroupOnRightIT(3,133,'2')

gap> m := IdentityMat(4);
[ [ 1, 0, 0, 0 ], [ 0, 1, 0, 0 ], [ 0, 0, 1, 0 ], [ 0, 0, 0, 1 ] ]

gap> C^m;
<matrix group with 7 generators>

gap> C := SpaceGroupIT( 3, 133 );
SpaceGroupOnRightIT(3,133,'2')

gap> P := PointGroup( C );
<matrix group of size 16 with 4 generators>

gap> NormalizerInGLnZ( P );
<matrix group of size 16 with 7 generators>

gap> G := SpaceGroupIT(3,68);
SpaceGroupOnRightIT(3,68,'2')

gap> pos := WyckoffPositions(G);
[ < Wyckoff position, point group 3, translation := [ 0, 3/4, 1/4 ], 
    basis := [  ] >
    , < Wyckoff position, point group 3, translation := [ 0, 3/4, 3/4 ], 
    basis := [  ] >
    , < Wyckoff position, point group 6, translation := [ 0, 0, 1/2 ], 
    basis := [  ] >
    , < Wyckoff position, point group 6, translation := [ 1/4, 1/4, 1/2 ], 
    basis := [  ] >
    , < Wyckoff position, point group 2, translation := [ 1/4, 0, 0 ], 
    basis := [ [ 0, 0, 1 ] ] >
    , < Wyckoff position, point group 2, translation := [ 0, 3/4, 0 ], 
    basis := [ [ 0, 0, 1 ] ] >
    , < Wyckoff position, point group 4, translation := [ 0, 0, 1/4 ], 
    basis := [ [ 0, 1, 0 ] ] >
    , < Wyckoff position, point group 5, translation := [ 1/4, 1/4, 1/4 ], 
    basis := [ [ 1, 0, 0 ] ] >
    , < Wyckoff position, point group 1, translation := [ 0, 0, 0 ], 
    basis := [ [ 1/2, 1/2, 0 ], [ 0, 1, 0 ], [ 0, 0, 1 ] ] >
     ]

gap> WyckoffStabilizer(pos[5]);
Group(
[ [ [ -1, 0, 0, 0 ], [ 0, -1, 0, 0 ], [ 0, 0, 1, 0 ], [ 1/2, 0, 0, 1 ] ] ])

gap> S := SpaceGroupIT(2,7);
SpaceGroupOnRightIT(2,7,'1')

gap> P := PointGroup(S);
Group([ [ [ -1, 0 ], [ 0, -1 ] ], [ [ -1, 0 ], [ 0, 1 ] ] ])

gap> N := NormalizerInGLnZ(P);
Group([ [ [ -1, 0 ], [ 0, -1 ] ], [ [ -1, 0 ], [ 0, 1 ] ], 
  [ [ -1, 0 ], [ 0, -1 ] ], [ [ 1, 0 ], [ 0, -1 ] ], [ [ 0, 1 ], [ 1, 0 ] ] ])

gap> gen := Filtered( GeneratorsOfGroup(N), x -> not x in P );
[ [ [ 0, 1 ], [ 1, 0 ] ] ]

gap> n := AugmentedMatrix( gen[1], [1/5,1/7] );
[ [ 0, 1, 0 ], [ 1, 0, 0 ], [ 1/5, 1/7, 1 ] ]

gap> S2 := S^n;
<matrix group with 4 generators>

gap> c := ConjugatorSpaceGroupsStdSamePG( S, S2 );;
gap> S^c=S2;
true

gap> if IsPackageMarkedForLoading( "CaratInterface", "" ) then
>   c := ConjugatorSpaceGroupsStdSamePG( S2, S );;
>   if not S2^c=S then
>     Error( "Cryst: conjugator test failed" );
>   fi;
> fi;

gap> C1 := [ [ 4, -3, 0 ], [ -3, -1, 0 ], [ 1/5, 1/7, 1 ] ];
[ [ 4, -3, 0 ], [ -3, -1, 0 ], [ 1/5, 1/7, 1 ] ]

gap> C2 := [ [ -1, 4, 0 ], [ -1, -2, 0 ], [ 1/9, 1/13, 1 ] ];
[ [ -1, 4, 0 ], [ -1, -2, 0 ], [ 1/9, 1/13, 1 ] ]

gap> S1 := S^C1; IsSpaceGroup(S1);
<matrix group with 4 generators>
true

gap> S2 := S^C2; IsSpaceGroup(S2);
<matrix group with 4 generators>
true

gap> C  := ConjugatorSpaceGroups( S1, S2 );;
gap> S1^C = S2;
true

gap> S1 := AffineCrystGroupOnRight(
> [ [ [ -1, 0, 2, 0 ], [ -2, 1, 2, 0 ], [ 0, 0, 1, 0 ], [ 0, 0, 1/2, 1 ] ], 
>   [ [ -1, 0, 0, 0 ], [ 0, -1, 0, 0 ], [ 0, 0, -1, 0 ], [ 0, 1/2, 0, 1 ] ], 
>   [ [ 1, 0, 0, 0 ], [ 0, 1, 0, 0 ], [ 0, 0, 1, 0 ], [ 1, 0, 0, 1 ] ], 
>   [ [ 1, 0, 0, 0 ], [ 0, 1, 0, 0 ], [ 0, 0, 1, 0 ], [ 0, 1, 0, 1 ] ], 
>   [ [ 1, 0, 0, 0 ], [ 0, 1, 0, 0 ], [ 0, 0, 1, 0 ], [ 0, 0, 1, 1 ] ] ] ); 
<matrix group with 5 generators>
gap> 
gap> S2 := AffineCrystGroupOnRight(
> [ [ [ -1, 0, 0, 0 ], [ 0, -1, 0, 0 ], [ 0, 0, -1, 0 ], [ 0, 0, 0, 1 ] ], 
>   [ [ 1, 0, -2, 0 ], [ 2, -1, -2, 0 ], [ 0, 0, -1, 0 ], [ 0, 1/2, 0, 1 ] ], 
>   [ [ 1, 0, 0, 0 ], [ 0, 1, 0, 0 ], [ 0, 0, 1, 0 ], [ 1, -1, 0, 1 ] ], 
>   [ [ 1, 0, 0, 0 ], [ 0, 1, 0, 0 ], [ 0, 0, 1, 0 ], [ 1, 0, -1, 1 ] ], 
>   [ [ 1, 0, 0, 0 ], [ 0, 1, 0, 0 ], [ 0, 0, 1, 0 ], [ -1, 1, 1, 1 ] ] ] );
<matrix group with 5 generators>

gap> if IsPackageMarkedForLoading( "CaratInterface", "" ) then
>     c1 := ConjugatorSpaceGroups(S1,S2);;
>     c2 := ConjugatorSpaceGroups(S2,S1);;
>     if not ( S1^c1 = S2 and S2^c2 = S1 ) then
>         Error( "Cryst: conjugator test 2 failed" );
>     fi;
> fi;

gap> G := SpaceGroupIT(3, 214);;
gap> iso := IsomorphismPcpGroup(G);;
gap> H := Image(iso);;
gap> h := Cgs(H)[1];;
gap> g := PreImage(iso, h);;
gap> h = Image(iso, g);
true
gap> IsomorphismPcpGroup( PointGroup( G ) );;

gap> gen := GeneratorsOfGroup( SpaceGroupIT(3,149) ){[1..3]};;
gap> Gr := AffineCrystGroup( gen );
<matrix group with 3 generators>
gap> Gr = AsAffineCrystGroup( Group( gen ) );
true
gap> TranslationBasis( Gr );
[ [ 1, 0, 0 ], [ 0, 1, 0 ] ]
gap> InternalBasis( Gr );
[ [ 1, 0, 0 ], [ 0, 1, 0 ], [ 0, 0, 1 ] ]
gap> CheckTranslationBasis( Gr );
gap> StandardAffineCrystGroup( Gr );
<matrix group with 3 generators>
gap> TransParts( Gr );
[ [ 0, 0, 0 ], [ 0, 0, 0 ] ]
gap> PointHomomorphism( Gr );
[ [ [ 0, 1, 0, 0 ], [ -1, -1, 0, 0 ], [ 0, 0, 1, 0 ], [ 0, 0, 0, 1 ] ], 
  [ [ 0, -1, 0, 0 ], [ -1, 0, 0, 0 ], [ 0, 0, -1, 0 ], [ 0, 0, 0, 1 ] ], 
  [ [ 1, 0, 0, 0 ], [ 0, 1, 0, 0 ], [ 0, 0, 1, 0 ], [ 1, 0, 0, 1 ] ] ] -> 
[ [ [ 0, 1, 0 ], [ -1, -1, 0 ], [ 0, 0, 1 ] ], 
  [ [ 0, -1, 0 ], [ -1, 0, 0 ], [ 0, 0, -1 ] ], 
  [ [ 1, 0, 0 ], [ 0, 1, 0 ], [ 0, 0, 1 ] ] ]

gap> Gl := AffineCrystGroupOnLeft( List( gen, TransposedMat ) );
<matrix group with 3 generators>
gap> Gl = AsAffineCrystGroupOnLeft( Group( List( gen, TransposedMat ) ) );
true
gap> TranslationBasis( Gl );
[ [ 1, 0, 0 ], [ 0, 1, 0 ] ]
gap> InternalBasis( Gl );
[ [ 1, 0, 0 ], [ 0, 1, 0 ], [ 0, 0, 1 ] ]
gap> CheckTranslationBasis( Gl );
gap> StandardAffineCrystGroup( Gl );
<matrix group with 3 generators>
gap> TransParts( Gl );
[ [ 0, 0, 0 ], [ 0, 0, 0 ] ]
gap> PointHomomorphism( Gl );
[ [ [ 0, -1, 0, 0 ], [ 1, -1, 0, 0 ], [ 0, 0, 1, 0 ], [ 0, 0, 0, 1 ] ], 
  [ [ 0, -1, 0, 0 ], [ -1, 0, 0, 0 ], [ 0, 0, -1, 0 ], [ 0, 0, 0, 1 ] ], 
  [ [ 1, 0, 0, 1 ], [ 0, 1, 0, 0 ], [ 0, 0, 1, 0 ], [ 0, 0, 0, 1 ] ] ] -> 
[ [ [ 0, -1, 0 ], [ 1, -1, 0 ], [ 0, 0, 1 ] ], 
  [ [ 0, -1, 0 ], [ -1, 0, 0 ], [ 0, 0, -1 ] ], 
  [ [ 1, 0, 0 ], [ 0, 1, 0 ], [ 0, 0, 1 ] ] ]

gap> SpaceGroupIT(3,213) < SpaceGroupIT(3,217);
false

gap> G := SpaceGroupIT(3,183);;
gap> W := WyckoffPositions(G);;
gap> C := [ [ 3, 1, 0, 0 ], [ -1, -2, 0, 0 ], [ 2, 0, 1, 0 ], [ 0, 0, 0, 1 ] ];;
gap> IsSpaceGroup( G^C );
true

# The next checks verify that including a translation component in conjugation
# works correctly, as from <https://github.com/gap-packages/cryst/issues/44>.
gap> C := [ [ 3, 1, 0, 0 ], [ -1, -2, 0, 0 ], [ 2, 0, 1, 0 ], [ 1/2, 0, 0, 1 ] ];;
gap> IsSpaceGroup( G^C );
true

# Test that caching of Wyckoff followed by conjugation works as expected
# Use Set because the order of the Wyckoff positions is semi-arbitrary.
gap> Set(WyckoffPositions( G^C )) = Set(WyckoffPositions(SpaceGroupIT(3,183)^C));
true

gap> G := TransposedMatrixGroup( G );
<matrix group with 6 generators>
gap> W := WyckoffPositions(G);;
gap> IsSpaceGroup( G^TransposedMat(C) );
true

gap> Set(WyckoffPositions( G^TransposedMat(C) )) = Set(WyckoffPositions(SpaceGroupOnLeftIT(3,183)^TransposedMat(C)));
true

# Test Wyckoff positions in a case that involves an empty basis (see <https://github.com/gap-packages/cryst/issues/42>).
gap> G := SpaceGroupIT( 3, 12 );;
gap> W := WyckoffPositions(G);;
gap> IsSpaceGroup( G^C );
true

gap> G := SpaceGroupIT( 3, 208 );
SpaceGroupOnRightIT(3,208,'1')
gap> M := MaximalSubgroupClassReps( G, rec( primes := [2,3] ) );
[ <matrix group with 7 generators>, <matrix group with 6 generators>, 
  <matrix group with 7 generators>, <matrix group with 7 generators>, 
  <matrix group with 5 generators>, <matrix group with 7 generators>, 
  <matrix group with 6 generators>, <matrix group with 7 generators> ]
gap> List( M, x -> Index( G, x ) );
[ 2, 2, 2, 4, 4, 4, 3, 27 ]
gap> List( Cartesian(M{[2,3,5]},M{[4,7,8]}),
> x -> Index( G, Intersection2(x[1],x[2]) ) );
[ 8, 6, 54, 8, 6, 54, 16, 12, 108 ]
gap> gen := GeneratorsOfGroup( M[1] );;
gap> Centralizer( M[1], gen[1] );
<matrix group with 3 generators>
gap> Centralizer( M[1], Subgroup( M[1], gen{[3]} ) );
<matrix group with 3 generators>
gap> C := RightCosets( G, M[3] );;
gap> CanonicalRightCosetElement( M[3], Representative(C[2]) );
[ [ -1, 0, 0, 0 ], [ 0, -1, 0, 0 ], [ 0, 0, 1, 0 ], [ 0, 0, 1, 1 ] ]
gap>  List( M, TranslationNormalizer );
[ <matrix group with 3 generators>, <matrix group with 3 generators>, 
  <matrix group with 3 generators>, <matrix group with 3 generators>, 
  <matrix group with 3 generators>, <matrix group with 3 generators>, 
  <matrix group with 3 generators>, <matrix group with 3 generators> ]
gap> if IsPackageMarkedForLoading( "CaratInterface", "" ) then
>   List( M, AffineNormalizer );;
> fi;
gap> List( M{[2,5,7]}, x -> Orbit( G, x, OnPoints ) );;
gap> List( M{[3,6]}, x -> OrbitStabilizer( G, x, OnPoints ) );;
gap> List( M, x -> IsomorphismPcpGroup( PointGroup(x) ) );;

gap> G := SpaceGroupOnLeftIT( 3, 208 );
SpaceGroupOnLeftIT(3,208,'1')
gap> M := MaximalSubgroupClassReps( G, rec( primes := [2,3] ) );
[ <matrix group with 7 generators>, <matrix group with 6 generators>, 
  <matrix group with 7 generators>, <matrix group with 7 generators>, 
  <matrix group with 5 generators>, <matrix group with 7 generators>, 
  <matrix group with 6 generators>, <matrix group with 7 generators> ]
gap> List( M, x -> Index( G, x ) );
[ 2, 2, 2, 4, 4, 4, 3, 27 ]
gap> List( Cartesian(M{[4,6,7]},M{[2,5,8]}),
> x -> Index( G, Intersection2(x[1],x[2]) ) );
[ 8, 16, 108, 8, 16, 108, 6, 12, 81 ]
gap> gen := GeneratorsOfGroup( M[1] );;
gap> Centralizer( M[1], gen[1] );
<matrix group with 3 generators>
gap> Centralizer( M[1], Subgroup( M[1], gen{[3]} ) );
<matrix group with 3 generators>
gap> C := RightCosets( G, M[3] );;
gap> CanonicalRightCosetElement( M[3], Representative(C[2]) );
[ [ -1, 0, 0, 0 ], [ 0, -1, 0, 0 ], [ 0, 0, 1, 1 ], [ 0, 0, 0, 1 ] ]
gap>  List( M, TranslationNormalizer );
[ <matrix group with 3 generators>, <matrix group with 3 generators>, 
  <matrix group with 3 generators>, <matrix group with 3 generators>, 
  <matrix group with 3 generators>, <matrix group with 3 generators>, 
  <matrix group with 3 generators>, <matrix group with 3 generators> ]
gap> if IsPackageMarkedForLoading( "CaratInterface", "" ) then
>   List( M, AffineNormalizer );;
> fi;
gap> List( M{[3,7]}, x -> Orbit( G, x, OnPoints ) );;
gap> List( M{[5,6]}, x -> OrbitStabilizer( G, x, OnPoints ) );;
gap> List( M, x -> IsomorphismPcpGroup( PointGroup(x) ) );;

gap> G := SpaceGroupOnRightIT( 3, 214 );;
gap> K := Kernel( PointHomomorphism( G ) );
<matrix group with 3 generators>
gap> NaturalHomomorphismByNormalSubgroup( G, K );;

gap> G := SpaceGroupOnLeftIT( 3, 222 );;
gap> K := Kernel( PointHomomorphism( G ) );
<matrix group with 3 generators>
gap> NaturalHomomorphismByNormalSubgroup( G, K );;

gap> G := SpaceGroupOnRightIT( 3, 222 );;
gap> C := ConjugacyClassesMaximalSubgroups( G, rec(primes:=[2,3,5] ) );;
gap> List( C, Size );
[ 1, 1, 1, 4, 3, 27, 125 ]
gap> List( C{[1..6]}, x -> Length( AsList(x) ) );
[ 1, 1, 1, 4, 3, 27 ]
gap> L := AsList( C[5] );
[ <matrix group with 7 generators>, <matrix group with 7 generators>, 
  <matrix group with 7 generators> ]
gap> List(L, x -> RepresentativeAction( G, L[1], x, OnPoints ) );;
gap> List( C, x -> Normalizer( G, Representative(x) ) );;

gap> G := SpaceGroupOnLeftIT( 3, 222 );;
gap> C := ConjugacyClassesMaximalSubgroups( G, rec(primes:=[2,3,5] ) );;
gap> List( C, Size );
[ 1, 1, 1, 4, 3, 27, 125 ]
gap> List( C{[1..6]}, x -> Length( AsList(x) ) );
[ 1, 1, 1, 4, 3, 27 ]
gap> L := AsList( C[5] );
[ <matrix group with 7 generators>, <matrix group with 7 generators>, 
  <matrix group with 7 generators> ]
gap> List(L, x -> RepresentativeAction( G, L[1], x, OnPoints ) );;
gap> List( C, x -> Normalizer( G, Representative(x) ) );;

gap> STOP_TEST( "cryst.tst", 10000 );
