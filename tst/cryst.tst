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

gap> S := SpaceGroupBBNWZ( 4, 29, 7, 2, 1 );
SpaceGroupOnRightBBNWZ( 4, 29, 7, 2, 1 )

gap> S := WyckoffStabilizer( WyckoffPositions(S)[1] );
<matrix group with 4 generators>

gap> cl := ConjugacyClasses( S );
[ [ [ 1, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0 ], [ 0, 0, 1, 0, 0 ], 
      [ 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 1 ] ]^G, 
  [ [ -1, -1, -1, -1, 0 ], [ 0, 1, 0, 1, 0 ], [ 1, 1, 0, 0, 0 ], 
      [ 0, -1, 0, 0, 0 ], [ 0, 0, 0, 0, 1 ] ]^G, 
  [ [ -1, -1, 0, 0, 0 ], [ 0, 0, -1, -1, 0 ], [ 1, 0, 0, 0, 0 ], 
      [ 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1 ] ]^G, 
  [ [ -1, -1, 0, 0, 0 ], [ 0, 1, 0, 0, 0 ], [ 1, 1, 1, 1, 0 ], 
      [ 0, -1, 0, -1, 0 ], [ 0, 0, 0, 0, 1 ] ]^G, 
  [ [ -1, -1, 0, 0, 0 ], [ 1, 0, 0, 0, 0 ], [ 0, 0, -1, -1, 0 ], 
      [ 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1 ] ]^G, 
  [ [ -1, 0, 0, 0, 0 ], [ 0, -1, 0, 0, 0 ], [ 1, 0, 1, 0, 0 ], 
      [ 0, 1, 0, 1, 0 ], [ 0, 0, 0, 0, 1 ] ]^G, 
  [ [ 0, -1, 0, -1, 0 ], [ 0, 1, 0, 0, 0 ], [ 1, 1, 1, 1, 0 ], 
      [ -1, -1, 0, 0, 0 ], [ 0, 0, 0, 0, 1 ] ]^G, 
  [ [ 0, -1, 0, -1, 0 ], [ 1, 1, 1, 1, 0 ], [ 0, 1, 0, 0, 0 ], 
      [ -1, -1, 0, 0, 0 ], [ 0, 0, 0, 0, 1 ] ]^G, 
  [ [ -1, -1, -1, -1, 0 ], [ 0, 0, 1, 1, 0 ], [ 1, 0, 1, 0, 0 ], 
      [ 0, 0, -1, 0, 0 ], [ 0, 0, 0, 0, 1 ] ]^G ]

gap> Size( cl[1] );
1

gap> G := SpaceGroupBBNWZ( 4, 29, 7, 2, 1 );
SpaceGroupOnRightBBNWZ( 4, 29, 7, 2, 1 )

gap> H := MaximalSubgroupRepsTG( G )[4];
<matrix group with 7 generators>

gap> C := ColorGroup( G, H );
<matrix group with 8 generators>

gap> ColorPermGroup( C );
Group([ (2,4)(3,8)(5,6), (2,5,6,4)(3,7,8,9), (1,2,6)(3,7,5)(4,9,8), (1,3,8)
(2,7,4)(5,9,6), (), (), (), () ])

gap> P := PointGroup( C );
<matrix group of size 72 with 4 generators>

gap> IsColorGroup( P );
true

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

gap> if IsPackageMarkedForLoading( "carat", "" ) then
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

gap> G := SpaceGroupIT(3, 214);;
gap> iso := IsomorphismPcpGroup(G);;
gap> H := Image(iso);;
gap> h := Cgs(H)[1];;
gap> g := PreImage(iso, h);
[ [ 1, 0, 0, 0 ], [ 0, 0, 1, 0 ], [ 0, -1, 0, 0 ], [ -7/4, 5/4, 3/4, 1 ] ]
gap> h = Image(iso, g);
true

gap> STOP_TEST( "cryst.tst", 10000 );
