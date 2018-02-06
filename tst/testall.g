LoadPackage( "cryst" );
LoadPackage( "crystcat" );

TestDirectory( DirectoriesPackageLibrary( "cryst", "tst" ),
  rec( exitGAP     := true,
       testOptions := rec( compareFunction := "uptowhitespace") ) );

FORCE_QUIT_GAP(1); # if we ever get here, there was an error
