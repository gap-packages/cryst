LoadPackage( "cryst" );

alltests := DirectoriesPackageLibrary( "cryst", "tst" );;
crystcat := List(["crystcat.tst"], f -> Filename(alltests,f));;

if LoadPackage( "crystcat" ) = true then
  TestDirectory( crystcat,
    rec( exitGAP     := false,
         testOptions := rec( compareFunction := "uptowhitespace") ) );
fi;

TestDirectory( alltests,
  rec( exclude     := ["crystcat.tst"],
       exitGAP     := true,
       testOptions := rec( compareFunction := "uptowhitespace") ) );

FORCE_QUIT_GAP(1); # if we ever get here, there was an error
