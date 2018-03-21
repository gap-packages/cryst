gap> START_TEST( "Cryst: wyckoff.tst" );

gap> SetAssertionLevel(1);

gap> List( [1..17], i -> Length( WyckoffPositions( SpaceGroupIT(2,i) ) ) );
[ 1, 5, 3, 1, 2, 9, 4, 3, 6, 4, 7, 5, 4, 5, 4, 4, 6 ]

gap> List( [1..23], i -> Length( WyckoffPositions( SpaceGroupIT(3,10*i-3) ) ) );
[ 1, 5, 5, 5, 27, 5, 15, 5, 9, 12, 5, 11, 15, 9, 7, 4, 6, 14, 15, 7, 11, 8, 
  10 ]

gap> STOP_TEST( "wyckoff.tst", 10000 );
