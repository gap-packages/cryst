gap> START_TEST( "Cryst: subgrp.tst" );

gap> SetAssertionLevel(1);

gap> le := rec( latticeequal := true );
rec( latticeequal := true )

gap> ce := rec( classequal := true, primes := [2,3,5] );
rec( classequal := true, primes := [ 2, 3, 5 ] )

gap> so := rec( primes := [2,3,5] );
rec( primes := [ 2, 3, 5 ] )

gap> l1 := List( [1..17], i -> Length( MaximalSubgroupClassReps(
>                     SpaceGroupIT( 2, i ), le ) ) );
[ 0, 1, 1, 1, 1, 3, 3, 3, 3, 1, 3, 3, 1, 2, 2, 2, 4 ]

gap> l2 := List( [1..17], i -> Length( MaximalSubgroupClassReps(
>                     SpaceGroupIT( 2, i ), ce ) ) );
[ 13, 16, 10, 6, 6, 16, 8, 4, 8, 5, 6, 2, 5, 5, 3, 3, 3 ]

gap> l3 := List( [1..17], i -> Length( MaximalSubgroupClassReps(
>                     SpaceGroupIT( 2, i ), so ) ) );
[ 13, 17, 11, 7, 7, 19, 11, 7, 11, 6, 9, 5, 6, 7, 5, 5, 7 ]

gap> l1 + l2 = l3;
true

gap> l1 := List( [1..23], i -> Length( MaximalSubgroupClassReps(
>                     SpaceGroupIT( 3, 10*i ), le ) ) );
[ 3, 3, 3, 3, 7, 7, 7, 1, 3, 3, 3, 3, 7, 7, 2, 2, 2, 4, 4, 3, 3, 3, 5 ]

gap> l2 := List( [1..23], i -> Length( MaximalSubgroupClassReps(
>                     SpaceGroupIT( 3, 10*i ), ce ) ) );
[ 40, 10, 10, 10, 14, 6, 6, 7, 8, 8, 4, 8, 4, 12, 9, 6, 4, 8, 5, 8, 4, 2, 2 ]

gap> l3 := List( [1..23], i -> Length( MaximalSubgroupClassReps(
>                     SpaceGroupIT( 3, 10*i ), so ) ) );
[ 43, 13, 13, 13, 21, 13, 13, 8, 11, 11, 7, 11, 11, 19, 11, 8, 6, 12,
  9, 11, 7, 5, 7 ]

gap> l1 + l2 = l3;
true

gap> STOP_TEST( "subgrp.tst", 10000 );
