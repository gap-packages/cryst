#############################################################################
##
#A  hom.gi                  CrystGap library                     Bettina Eick
#A                                                              Franz G"ahler
#A                                                              Werner Nickel
##
#Y  Copyright 1990-1997,  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
##

#############################################################################
##
#M  ImagesRepresentative( <hom>, <elm> )  . . . . . . . for PointHomomorphism
##
InstallMethod( ImagesRepresentative, FamSourceEqFamElm,
        [ IsGroupGeneralMappingByImages and IsPointHomomorphism,
          IsMultiplicativeElementWithInverse ], 0,
    function( hom, elm )
    local d;
    d := Length( elm ) - 1;
    return elm{[1..d]}{[1..d]};
end );

#############################################################################
##
#M  PreImagesRepresentative( <hom>, <elm> ) . . . . . . for PointHomomorphism
##
InstallMethod( PreImagesRepresentative, FamRangeEqFamElm,
        [ IsGroupGeneralMappingByImages and IsPointHomomorphism,
          IsMultiplicativeElementWithInverse ], 0,
    function( hom, elm )
    local P, perm;
    P := PointGroup( Source( hom ) );
    perm := ImagesRepresentative( NiceMonomorphism( P ), elm );
    return ImagesRepresentative( NiceToCryst( P ), perm );
end );

#############################################################################
##
#M  CoKernelOfMultiplicativeGeneralMapping( <hom> ) . . for PointHomomorphism
##
InstallMethod( CoKernelOfMultiplicativeGeneralMapping,
    true, [ IsGroupGeneralMappingByImages and IsPointHomomorphism ], 0,
    hom -> TrivialSubgroup( Range( hom ) ) );

#############################################################################
##
#M  KernelOfMultiplicativeGeneralMapping( <hom> ) . . . for PointHomomorphism
##
InstallMethod( KernelOfMultiplicativeGeneralMapping,
    true, [ IsGroupGeneralMappingByImages and IsPointHomomorphism ], 0,
    function( hom )

    local S, d, T, gens, t, m;

    S := Source( hom );
    d := DimensionOfMatrixGroup( S ) - 1;
    T := TranslationBasis( S );
    gens := [];
    for t in T do
        m := IdentityMat( d+1 );
        m[d+1]{[1..d]} := t;
        Add( gens, m );
    od;
    return SubgroupNC( S, gens );

end );

#############################################################################
##
#F  NiceToCrystStdRep( P, perm )
##
InstallGlobalFunction( NiceToCrystStdRep, function( P, perm )
    local S, m, d, c;
    S := AffineCrystGroupOfPointGroup( P );
    m := ImagesRepresentative( NiceToCryst( P ), perm );
    if IsStandardAffineCrystGroup( S ) then
        return m;
    else
        return S!.lconj * m * S!.rconj;
    fi;
end );
