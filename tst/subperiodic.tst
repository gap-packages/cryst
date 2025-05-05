gap> START_TEST( "Cryst: subperiodic.tst" );

# This test is for the subperiodic group features.
gap> SetAssertionLevel(1);
gap> SetCrystGroupDefaultAction(RightAction);

# Test that layer groups are conjured correctly.
gap> G := LayerGroupIT( 5 );
SubPeriodicGroupOnRightIT(Layer,5,'1')

gap> IsAffineCrystGroupOnRight( G );
true

gap> G^IdentityMat(4);
<matrix group with 3 generators>

gap> TranslationBasis( G );
[ [ 1, 0, 0 ], [ 0, 1, 0 ] ]

gap> G := LayerGroupIT( 8, 'b' );
SubPeriodicGroupOnRightIT(Layer,8,'b')

# Test that rod groups are conjured correctly
gap> G := RodGroupIT( 7 );
SubPeriodicGroupOnRightIT(Rod,7,'abc')

gap> IsAffineCrystGroupOnRight( G );
true

gap> G^IdentityMat(4);
<matrix group with 3 generators>

gap> TranslationBasis( G );
[ [ 0, 0, 1 ] ]

gap> G := RodGroupIT( 12, "bca" );
SubPeriodicGroupOnRightIT(Rod,12,'bca')

gap> TranslationBasis( G );
[ [ 0, 1, 0 ] ]

# Test that frieze groups are conjured correctly
gap> G := FriezeGroupIT( 2 );
SubPeriodicGroupOnRightIT(Frieze,2,'a')

gap> IsAffineCrystGroupOnRight( G );
true

gap> G^IdentityMat(3);
Group([ [ [ -1, 0, 0 ], [ 0, -1, 0 ], [ 0, 0, 1 ] ], 
  [ [ 1, 0, 0 ], [ 0, 1, 0 ], [ 1, 0, 1 ] ] ])

gap> TranslationBasis( G );
[ [ 1, 0 ] ]

gap> G := FriezeGroupIT( 2, 'b' );
SubPeriodicGroupOnRightIT(Frieze,2,'b')

gap> TranslationBasis( G );
[ [ 0, 1 ] ]

# Test that different ways of calling the same group work
gap> SubPeriodicGroupIT("Layer", 23) = LayerGroupIT(23);
true

gap> SubPeriodicGroupOnRightIT("Rod", 14) = RodGroupIT(14);
true

gap> SubPeriodicGroupOnRightIT("Frieze", 3, 'a') = FriezeGroupIT(3);
true

# Confirm that different groups are different
gap> RodGroupIT(4) = RodGroupIT(3);
false

gap> LayerGroupIT(15) = RodGroupIT(15);
false

gap> FriezeGroupIT(1) = RodGroupIT(1);
false

# Test conjugation without Wyckoff positions
gap> G := FriezeGroupIT(3);;
gap> C := [[0,1,0],[1,0,0],[0,0,1]];;
gap> G^C;
Group([ [ [ 1, 0, 0 ], [ 0, -1, 0 ], [ 0, 0, 1 ] ], 
  [ [ 1, 0, 0 ], [ 0, 1, 0 ], [ 0, 1, 1 ] ] ])

# Test generation of Wyckoff positions
gap> G := LayerGroupIT(56);;
gap> pos := WyckoffPositions(G);
[ < Wyckoff position, point group 2, translation := [ 0, 0, 0 ], 
    basis := [ [ 0, 0, 1 ] ] >
    , < Wyckoff position, point group 2, translation := [ 0, 1/2, 0 ], 
    basis := [ [ 0, 0, 1 ] ] >
    , < Wyckoff position, point group 3, translation := [ 0, 1/2, 0 ], 
    basis := [ [ 1, 1, 0 ], [ 0, 0, 1 ] ] >
    , < Wyckoff position, point group 1, translation := [ 0, 0, 0 ], 
    basis := [ [ 1, 0, 0 ], [ 0, 1, 0 ], [ 0, 0, 1 ] ] >
     ]

# Some GAP versions give Group([  ]), some <matrix group of size 1>.
gap> IsTrivial( WyckoffStabilizer( pos[4] ) );
true

gap> WyckoffStabilizer( pos[3] );
Group(
[ [ [ 0, 1, 0, 0 ], [ 1, 0, 0, 0 ], [ 0, 0, 1, 0 ], [ -1/2, 1/2, 0, 1 ] ] ])

gap> WyckoffStabilizer( pos[2] );
<matrix group with 2 generators>

# Test that conjugation of Wyckoff positions works as expected
# Make sure to include a Wyckoff with an empty basis
gap> G := LayerGroupIT(54);;
gap> pos := WyckoffPositions(G);
[ < Wyckoff position, point group 3, translation := [ 1/2, 0, 0 ], 
    basis := [  ] >
    , < Wyckoff position, point group 2, translation := [ 0, 0, 0 ], 
    basis := [ [ 0, 0, 1 ] ] >
    , < Wyckoff position, point group 2, translation := [ 0, 1/2, 0 ], 
    basis := [ [ 0, 0, 1 ] ] >
    , < Wyckoff position, point group 4, translation := [ 0, 1/2, 0 ], 
    basis := [ [ 1, 1, 0 ] ] >
    , < Wyckoff position, point group 1, translation := [ 0, 0, 0 ], 
    basis := [ [ 1, 0, 0 ], [ 0, 1, 0 ], [ 0, 0, 1 ] ] >
     ]

# An arbitrary transformation, with translation
gap> C := [ [ 5, -1, 0, 0 ], [ 2, 0, 1, 0 ], [ -3, 1, -1, 0 ], [ 1/2, 1/3, 1, 1 ] ];;
gap> IsAffineCrystGroupOnRight( G^C );
true

gap> Set(WyckoffPositions( G^C )) = Set(WyckoffPositions( LayerGroupIT(54)^C ));
true

gap> G := RodGroupIT(17);;
gap> Length(WyckoffPositions( G^C )) = Length(WyckoffPositions( RodGroupIT(17) ));
true

# Test that WyckoffPositionsByStabilizer (and, by extension, WyPos) works
gap> G := LayerGroupIT(24);;
gap> W := WyckoffPositions(G);;
gap> sub := Group([[[-1,0,0],[0,1,0],[0,0,1]]]);;
gap> IsSubgroup(PointGroup(G), sub);
true

gap> wp := WyckoffPositionsByStabilizer(G, sub);
[ < Wyckoff position, point group 1, translation := [ 1/4, 0, 0 ],
	basis := [ [ 0, 1, 0 ], [ 0, 0, 1 ] ] >
	 ]

gap> wp[1] = W[3];
true

# Test that the WyPosSGL algorithm works just as well as default.
gap> G := LayerGroupIT(26);;
gap> W1 := WyPosSGL(G);;
gap> W2 := WyPosAT(G);;
gap> Set(W1) = Set(W2);
true

gap> C := [ [ 5, -1, 0, 0 ], [ 2, 0, 1, 0 ], [ -3, 1, -1, 0 ], [ 1/2, 1/3, 1, 1 ] ];;
gap> W1 := WyPosSGL( G^C );;
gap> W2 := WyPosAT( G^C );;
gap> Set(W1) = Set(W2);
true

# Test that Wyckoff works on the left
gap> G := SubPeriodicGroupOnLeftIT("Layer", 12);
SubPeriodicGroupOnLeftIT(Layer,12,'a')

gap> G = TransposedMatrixGroup(LayerGroupIT(12));
true

gap> G := SubPeriodicGroupOnLeftIT("Layer", 54);;
gap> pos := WyckoffPositions(G);
[ < Wyckoff position, point group 3, translation := [ 1/2, 0, 0 ],
    basis := [  ] >
    , < Wyckoff position, point group 2, translation := [ 0, 0, 0 ],
    basis := [ [ 0, 0, 1 ] ] >
    , < Wyckoff position, point group 2, translation := [ 0, 1/2, 0 ],
    basis := [ [ 0, 0, 1 ] ] >
    , < Wyckoff position, point group 4, translation := [ 0, 1/2, 0 ],
    basis := [ [ 1, -1, 0 ] ] >
    , < Wyckoff position, point group 1, translation := [ 0, 0, 0 ],
    basis := [ [ 1, 0, 0 ], [ 0, 1, 0 ], [ 0, 0, 1 ] ] >
     ]

# Some GAP versions give Group([  ]), some <matrix group of size 1>
gap> IsTrivial( WyckoffStabilizer( pos[5] ) );
true

gap> WyckoffStabilizer( pos[4] );
Group(
[ [ [ 0, -1, 0, 1/2 ], [ -1, 0, 0, 1/2 ], [ 0, 0, -1, 0 ], [ 0, 0, 0, 1 ] ] ])

gap> IsAffineCrystGroupOnLeft( G^TransposedMat(C) );
true

gap> Set(WyckoffPositions( G^TransposedMat(C) )) = Set(WyckoffPositions(SubPeriodicGroupOnLeftIT("Layer",54)^TransposedMat(C)));
true

gap> G := SubPeriodicGroupOnLeftIT("Rod", 17);;
gap> Length(WyckoffPositions( G )) = Length(WyckoffPositions( RodGroupIT(17) ));
true

gap> Length(WyckoffPositions( G^TransposedMat(C) )) = Length(WyckoffPositions( G ));
true

# Test that we get the right number of Wyckoff positions
gap> List( [1..7], i -> Length( WyckoffPositions( FriezeGroupIT(i) ) ) );
[ 1, 3, 3, 2, 1, 6, 3 ]

gap> List( [0..7], i -> Length( WyckoffPositions( RodGroupIT(10*i + 3) ) ) );
[ 3, 8, 2, 3, 1, 2, 3, 12 ]

gap> List( [1..8], i -> Length( WyckoffPositions( LayerGroupIT(10*i - 2) ) ) );
[ 3, 6, 3, 11, 10, 5, 5, 10 ]

gap> List( [1..8], i -> Length( WyckoffPositions( LayerGroupIT(10*i - 2)^C ) ) );
[ 3, 6, 3, 11, 10, 5, 5, 10 ]

# An arbitrary transformation without a translation,
# just to ensure code coverage of the non-shifted case.
gap> C := [ [ 5, -1, 0, 0 ], [ 2, 0, 1, 0 ], [ -3, 1, -1, 0 ], [ 0, 0, 0, 1 ] ];;
gap> List( [1..8], i -> Length( WyckoffPositions( LayerGroupIT(10*i - 2)^C ) ) );
[ 3, 6, 3, 11, 10, 5, 5, 10 ]

# Also need to ensure I get good results in the harder case where two
# internal basis vectors need to be generated
gap> List( [0..7], i -> Length( WyckoffPositions( RodGroupIT(10*i + 3)^C ) ) );
[ 3, 8, 2, 3, 1, 2, 3, 12 ]

# Check that changing CrystGroupDefaultAction works as expected
gap> CrystGroupDefaultAction;
"RightAction"

gap> SetCrystGroupDefaultAction(LeftAction);

gap> G := LayerGroupIT(12);
SubPeriodicGroupOnLeftIT(Layer,12,'a')

gap> G ^ IdentityMat(4);
<matrix group with 3 generators>

gap> IsAffineCrystGroupOnLeft(G);
true

gap> LayerGroupIT(8, 'b');
SubPeriodicGroupOnLeftIT(Layer,8,'b')

gap> G := RodGroupIT(5);
SubPeriodicGroupOnLeftIT(Rod,5,'abc')

gap> IsAffineCrystGroupOnLeft(G);
true

gap> G := FriezeGroupIT(2);
SubPeriodicGroupOnLeftIT(Frieze,2,'a')

gap> IsAffineCrystGroupOnLeft(G);
true

gap> G := SubPeriodicGroupIT("Layer", 54);
SubPeriodicGroupOnLeftIT(Layer,54,'1')

gap> pos := WyckoffPositions(G);
[ < Wyckoff position, point group 3, translation := [ 1/2, 0, 0 ],
    basis := [  ] >
    , < Wyckoff position, point group 2, translation := [ 0, 0, 0 ],
    basis := [ [ 0, 0, 1 ] ] >
    , < Wyckoff position, point group 2, translation := [ 0, 1/2, 0 ],
    basis := [ [ 0, 0, 1 ] ] >
    , < Wyckoff position, point group 4, translation := [ 0, 1/2, 0 ],
    basis := [ [ 1, -1, 0 ] ] >
    , < Wyckoff position, point group 1, translation := [ 0, 0, 0 ],
    basis := [ [ 1, 0, 0 ], [ 0, 1, 0 ], [ 0, 0, 1 ] ] >
     ]

gap> C := [ [ 5, 2, -3, 1/2 ], [ -1, 0, 1, 1/3 ], [ 0, 1, -1, 1 ], [ 0, 0, 0, 1 ] ];;
gap> IsAffineCrystGroup( G^C );
true

gap> Set( WyckoffPositions( G^C ) ) = Set( WyckoffPositions( LayerGroupIT(54)^C ) );
true

# Revert to default
gap> SetCrystGroupDefaultAction(RightAction);

gap> STOP_TEST( "subperiodic.tst", 10000 );
