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
<matrix group with 4 generators>

gap> TranslationBasis( G );
[ [ 1, 0, 0 ], [ 0, 1, 0 ] ]

# Test that rod groups are conjured correctly
gap> G := RodGroupIT( 7 );
SubPeriodicGroupOnRightIT(Rod,7,'1')

gap> IsAffineCrystGroupOnRight( G );
true

gap> G^IdentityMat(4);
<matrix group with 4 generators>

gap> TranslationBasis( G );
[ [ 0, 0, 1 ] ]

# Test that frieze groups are conjured correctly
gap> G := FriezeGroupIT( 2 );
SubPeriodicGroupOnRightIT(Frieze,2,'1')

gap> IsAffineCrystGroupOnRight( G );
true

gap> G^IdentityMat(3);
Group([ [ [ -1, 0, 0 ], [ 0, -1, 0 ], [ 0, 0, 1 ] ], 
  [ [ 1, 0, 0 ], [ 0, 1, 0 ], [ 1, 0, 1 ] ] ])

gap> TranslationBasis( G );
[ [ 1, 0 ] ]

# Test that different ways of calling the same group work
gap> SubPeriodicGroupIT("Layer", 23) = LayerGroupIT(23);
true

gap> SubPeriodicGroupIT("Rod", 14) = RodGroupIT(14);
true

gap> SubPeriodicGroupIT("Frieze", 3) = FriezeGroupIT(3);
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

gap> WyckoffStabilizer( pos[4] );
Group([  ])

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

# Test that Wyckoff works on the left
gap> G := SubPeriodicGroupOnLeftIT("Layer", 12);
SubPeriodicGroupOnLeftIT(Layer,12,'1')

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

gap> WyckoffStabilizer( pos[5] );
Group([  ])

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

# Check that changing CrystGroupDefaultAction works as expected
gap> CrystGroupDefaultAction;
"RightAction"

gap> SetCrystGroupDefaultAction(LeftAction);

gap> G := LayerGroupIT(12);
SubPeriodicGroupOnLeftIT(Layer,12,'1')

gap> G ^ IdentityMat(4);
<matrix group with 4 generators>

gap> IsAffineCrystGroupOnLeft(G);
true

gap> G := RodGroupIT(5);
SubPeriodicGroupOnLeftIT(Rod,5,'1')

gap> IsAffineCrystGroupOnLeft(G);
true

gap> G := FriezeGroupIT(2);
SubPeriodicGroupOnLeftIT(Frieze,2,'1')

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
