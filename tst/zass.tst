gap> START_TEST( "Cryst: zass.tst" );

gap> SetAssertionLevel(1);

gap> List( List( [1..17], i -> SpaceGroupIT( 2, i ) ),
>             g -> Length( SpaceGroupsByPointGroup( PointGroup( g ) ) ) );
[ 1, 1, 2, 2, 2, 4, 4, 4, 4, 1, 2, 2, 1, 1, 1, 1, 1 ]

gap> List( List( [1..23], i -> SpaceGroupIT( 3, 10*i-7 ) ),
>             g -> Length( SpaceGroupsByPointGroup( PointGroup( g ) ) ) );
[ 2, 8, 8, 16, 16, 64, 64, 64, 4, 8, 8, 4, 16, 16, 3, 3, 2, 6, 4, 4, 4, 4, 4 ]

gap> STOP_TEST( "zass.tst", 10000 );
