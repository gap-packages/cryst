#############################################################################
##
#A  infstab.gi              CrystGap library                     Bettina Eick
#A                                                              Franz G"ahler
#A                                                              Werner Nickel
##
#Y  Copyright 1990-1997,  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
##

#############################################################################
##
#F  StabilizerInfiniteGroup( G, d, opr ) . . . . stabilizer of infinite group
#F                              without membership test, acting on finite set
##
InstallGlobalFunction( StabilizerInfiniteGroup, function ( G, d, opr )
    local   stb,        # stabilizer, the result
            orb,        # orbit
            rep,        # representatives for the points in the orbit <orb>
            set,        # orbit <orb> as set for faster membership test
            gen,        # generator of the group <G>
            pnt,        # point in the orbit <orb>
            img,        # image of the point <pnt> under the generator <gen>
            sch,        # schreier generator of the stabilizer
            lst;        # list of schreier generators

    # standard operation
    if opr = OnPoints then
        orb := [ d ];
        set := [ d ];
        rep := [ One( G ) ];
        lst := [];
        for pnt in orb do
            for gen in GeneratorsOfGroup( G ) do
                img := pnt^gen;
                if not img in set then
                    Add( orb, img );
                    AddSet( set, img );
                    Add( rep, rep[Position(orb,pnt)]*gen );
                else
                    sch := rep[Position(orb,pnt)]*gen
                           / rep[Position(orb,img)];
                    AddSet( lst, sch );
                fi;
            od;
        od;

    # compute iterated stabilizers for the operation on pairs or on tuples
    elif opr = OnPairs or opr = OnTuples then
        stb := G;
        for pnt in d do
            stb := StabilizerInfiniteGroup( stb, pnt, OnPoints );
        od;

    # other operation
    else
        orb := [ d ];
        set := [ d ];
        rep := [ One( G ) ];
        lst := [];
        for pnt  in orb  do
            for gen in GeneratorsOfGroup( G ) do
                img := opr( pnt, gen );
                if not img in set then
                    Add( orb, img );
                    AddSet( set, img );
                    Add( rep, rep[Position(orb,pnt)]*gen );
                else
                    sch := rep[Position(orb,pnt)]*gen
                           / rep[Position(orb,img)];
                    AddSet( lst, sch );
                fi;
            od;
        od;
    fi;

    # return the stabilizer <stb>
    return GroupByGenerators( lst, One( G ) );

end );

