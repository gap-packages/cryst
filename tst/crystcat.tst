gap> START_TEST( "Cryst: crystcat.tst" );

gap> SetAssertionLevel(1);

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

gap> H := MaximalSubgroupRepsTG( G )[4];;

gap> C := ColorGroup( G, H );
<matrix group with 8 generators>

gap> ColorPermGroup( C );
Group([ (2,4)(3,8)(5,6), (2,5,6,4)(3,7,8,9), (1,2,6)(3,7,5)(4,9,8), (1,3,8)
(2,7,4)(5,9,6), (), (), (), () ])

gap> P := PointGroup( C );
<matrix group of size 72 with 4 generators>

gap> IsColorGroup( P );
true

gap> STOP_TEST( "crystcat.tst", 10000 );
