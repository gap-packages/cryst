LoadPackage( "cryst" );

alltests := DirectoriesPackageLibrary( "cryst", "tst" );

# crystcat tests will only be run if crystcat is present 
exclude  := ["crystcat.tst"];
if LoadPackage( "crystcat" ) = true then
  exclude := [];
fi;

TestDirectory( alltests,
  rec( exclude     := exclude,
       exitGAP     := true,
       testOptions := rec( compareFunction := "uptowhitespace") ) );

FORCE_QUIT_GAP(1); # if we ever get here, there was an error
