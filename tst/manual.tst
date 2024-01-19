gap> START_TEST( "Cryst: manual.tst" );

gap> SetAssertionLevel(1);

gap> S := SpaceGroupIT(3,222);
SpaceGroupOnRightIT(3,222,'2')

gap> L := MaximalSubgroupClassReps( S, rec( primes := [3,5] ) );;

gap> List( L, IndexInParent );
[ 3, 27, 125 ]

gap> L := MaximalSubgroupClassReps( S,             
>                  rec( classequal := true, primes := [3,5] ) );;

gap> List( L, IndexInParent );                                                 
[ 27, 125 ]

gap> L := MaximalSubgroupClassReps( S,
>                  rec( latticeequal := true, primes := [3,5] ) );;

gap> List( L, IndexInParent );                                       
[ 3 ]

gap> L := MaximalSubgroupClassReps( S, rec( latticeequal := true ) );;
gap> Length(L);
5

gap> List( L, IndexInParent );                                       
[ 2, 2, 2, 3, 4 ]

gap> P := Group([ [ [ -1, 0 ], [ 0, -1 ] ], [ [ -1, 0 ], [ 0, 1 ] ] ]);
Group([ [ [ -1, 0 ], [ 0, -1 ] ], [ [ -1, 0 ], [ 0, 1 ] ] ])

gap> norm := [ [ [ -1, 0 ], [ 0, -1 ] ], [ [ -1, 0 ], [ 0, 1 ] ], [ [ -1, 0 ],
>           [ 0, -1 ] ], [ [ 1, 0 ], [ 0, -1 ] ], [ [ 0, 1 ], [ 1, 0 ] ] ];
[ [ [ -1, 0 ], [ 0, -1 ] ], [ [ -1, 0 ], [ 0, 1 ] ], [ [ -1, 0 ], [ 0, -1 ] ],
  [ [ 1, 0 ], [ 0, -1 ] ], [ [ 0, 1 ], [ 1, 0 ] ] ]

gap> if IsPackageMarkedForLoading( "CaratInterface", "" ) then
>   if not norm = GeneratorsOfGroup( NormalizerInGLnZ( P ) ) then
>     Error( "Cryst: NormalizerInGLnZ failed" );
>   fi;
> fi;

gap> SpaceGroupsByPointGroupOnRight( P );
[ <matrix group with 4 generators>, <matrix group with 4 generators>, 
  <matrix group with 4 generators>, <matrix group with 4 generators> ]

gap> SpaceGroupsByPointGroupOnRight( P, norm );
[ <matrix group with 4 generators>, <matrix group with 4 generators>, 
  <matrix group with 4 generators> ]

gap> SpaceGroupsByPointGroupOnRight( P, norm, true );
[ [ <matrix group with 4 generators> ], 
  [ <matrix group with 4 generators>, <matrix group with 4 generators> ], 
  [ <matrix group with 4 generators> ] ]
  
gap> if IsPackageMarkedForLoading( "CaratInterface", "" ) then
>   if not ( 3 = Length( SpaceGroupTypesByPointGroupOnRight( P ) ) and
>     [1,2,1] = List( SpaceGroupTypesByPointGroupOnRight( P, true ), Length ) )
>   then
>     Error( "Cryst: NormalizerInGLnZ failed" );
>   fi;
> fi;

gap> S := SpaceGroupIT(2,14);
SpaceGroupOnRightIT(2,14,'1')

gap> W := WyckoffPositions(S);
[ < Wyckoff position, point group 3, translation := [ 0, 0 ], 
    basis := [  ] >
    , < Wyckoff position, point group 3, translation := [ 2/3, 1/3 ], 
    basis := [  ] >
    , < Wyckoff position, point group 3, translation := [ 1/3, 2/3 ], 
    basis := [  ] >
    , < Wyckoff position, point group 2, translation := [ 0, 0 ], 
    basis := [ [ 1, -1 ] ] >
    , < Wyckoff position, point group 1, translation := [ 0, 0 ], 
    basis := [ [ 1, 0 ], [ 0, 1 ] ] >
     ]

gap> sub := Group([ [ [ 0, -1 ], [ -1, 0 ] ] ]);
Group([ [ [ 0, -1 ], [ -1, 0 ] ] ])

gap> IsSubgroup( PointGroup( S ), sub );
true

gap> WyckoffPositionsByStabilizer( S, sub );
[ < Wyckoff position, point group 1, translation := [ 0, 0 ], 
    basis := [ [ 1, -1 ] ] >
     ]

gap> ForAll( W, IsWyckoffPosition );
true

gap> WyckoffBasis( W[4] );
[ [ 1, -1 ] ]

gap> WyckoffTranslation( W[3] );
[ 1/3, 2/3 ]

gap> WyckoffSpaceGroup( W[1] );
SpaceGroupOnRightIT(2,14,'1')

gap> stab := WyckoffStabilizer( W[4] );
Group([ [ [ 0, -1, 0 ], [ -1, 0, 0 ], [ 0, 0, 1 ] ] ])

gap> IsAffineCrystGroupOnRight( stab );
true

gap> orb := WyckoffOrbit( W[4] );
[ < Wyckoff position, point group 2, translation := [ 0, 0 ], 
    basis := [ [ 1, -1 ] ] >
    , < Wyckoff position, point group 2, translation := [ 0, 0 ], 
    basis := [ [ 1, 2 ] ] >
    , < Wyckoff position, point group 2, translation := [ 0, 0 ], 
    basis := [ [ -2, -1 ] ] >
     ]
gap> Set(orb);
[ < Wyckoff position, point group 2, translation := [ 0, 0 ], 
    basis := [ [ 1, -1 ] ] >
     ]

gap> G := Group(  (1,2,3), (2,3,4) );
Group([ (1,2,3), (2,3,4) ])

gap> H := Group( (1,2,3) ); 
Group([ (1,2,3) ])

gap> C := ColorGroup( G, H );
Group([ (1,2,3), (2,3,4) ])

gap> ColorSubgroup( C ) = H;
true

gap> ColorCosetList( C );
[ RightCoset(Group( [ (1,2,3) ] ),()), RightCoset(Group( [ (1,2,3) ] ),(1,2)
    (3,4)), RightCoset(Group( [ (1,2,3) ] ),(1,3)(2,4)), 
  RightCoset(Group( [ (1,2,3) ] ),(1,4)(2,3)) ]

gap> List( last, x -> ColorOfElement( C, Representative(x) ) );
[ 1, 2, 3, 4 ]

gap> U := Subgroup( C, [(1,3)(2,4)] );
Group([ (1,3)(2,4) ])

gap> IsColorGroup( U );
true

gap> ColorSubgroup( U );
Group(())

gap> ColorCosetList( U );
[ RightCoset(Group( () ),()), RightCoset(Group( () ),(1,3)(2,4)) ]

gap> List( last, x -> ColorOfElement( U, Representative(x) ) );
[ 1, 3 ]

gap> S := SpaceGroupIT( 2, 10 );                                  
SpaceGroupOnRightIT(2,10,'1')

gap> m := MaximalSubgroupClassReps( S, rec( primes := [2] ) );    
[ <matrix group with 4 generators>, <matrix group with 3 generators>, 
  <matrix group with 4 generators> ]

gap> List( last, x -> TranslationBasis(x) = TranslationBasis(S) );
[ false, true, false ]

gap> C := ColorGroup( S, m[1] );; IsColorGroup( PointGroup( C ) );
false

gap> C := ColorGroup( S, m[2] );; IsColorGroup( PointGroup( C ) );
true

gap> sub := MaximalSubgroupClassReps( S, rec( primes := [2] ) );
[ <matrix group with 4 generators>, <matrix group with 3 generators>, 
  <matrix group with 4 generators> ]

gap> List( sub, Size );
[ infinity, infinity, infinity ]

gap> sub := Filtered( sub, s -> IndexInParent( s ) = 2 );
[ <matrix group of size infinity with 4 generators>, 
  <matrix group of size infinity with 3 generators>, 
  <matrix group of size infinity with 4 generators> ]

gap> Length( AffineInequivalentSubgroups( S, sub ) );
2

gap> SpaceGroupSettingsIT( 3, 146 );
"hr"

gap> SpaceGroupOnRightIT( 3, 146 );        
SpaceGroupOnRightIT(3,146,'h')

gap> SpaceGroupOnRightIT( 3, 146, 'r' );
SpaceGroupOnRightIT(3,146,'r')

gap> STOP_TEST( "manual.tst", 10000 );
