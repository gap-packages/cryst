
   C := SpaceGroupIT( 3, 133 );
   m := IdentityMat(4);
   C^m;

   C := SpaceGroupIT( 3, 133 );
   P := PointGroup( C );
   NormalizerInGLnZ( P );

CrystGroupOps.Centralizer( G, g ) funktioniert nicht. Dieser Fehler
ist bei einer Berechnung der Size von einer ConjugacyClass eines Elementes
einer CrystGroup aufgetreten.

1.) Size einer ConjugacyClass von Elementen geht nicht immer:

   G := SpaceGroupBBNWZ( 4, 29, 7, 2, 1 );
   S := WyckoffStabilizer(WyckoffPositions(S)[1]);
   cl := ConjugacyClasses(S);
   Size( cl[1] );

...st"urzt dann ab. Es gibt da ein Problem mit den ParentGroups.

3.) ColorPermGroup( C ) geht nicht:

   H := MaximalSubgroupRepsTG( G )[4];
   C := ColorGroup( G, H );
   ColorPermGroup( C );

4.) Als Folge von 3. funktioniert auch ColorHomomorphism nicht.

5.) PointGroup for Color Groups:

   P := PointGroup( C );
   IsColorGroup( P );

... gibt false zur"uck. Soll das so sein? Wir hatten das Manual
anders verstanden.

6.) Subgroup( C, H.generators ) braucht sehr viel Speicher. Wir
haben bei 30 MB abgebrochen. Soll das so sein?

5.) Color Groups:
Sei G eine CrystGroup und U eine translationengleiche Untergruppe.
Sei C = ColorGroup( G, U ) und P := PointGroup( C ). Dann kommt es vor,
da"s ColorOfElement( P, l ) f"ur jeden Erzeuger die Farbe 1 liefert,
obwohl U eine echte Untergruppe von G ist. Das kann doch nicht
richtig sein, oder? Oder darf man das so nicht aufrufen, weil P
keine CrystGroup ist? Das sollte dann in den Funktionen aber 
abgefragt werden und eine Error-message ergeben und au"serdem im
Manual klargestellt werden.








