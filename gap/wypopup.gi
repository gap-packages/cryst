
BindGlobal( "WyckoffInfoDisplays",
  rec( 
    Default     := rec( name := "",            func := Ignore ),
    StabSize    := rec( name := "StabSize",    func := Ignore ),
    StabDim     := rec( name := "StabDim",     func := Ignore ),
    OrbitLength := rec( name := "OrbitLength", func := Ignore ),
    Translation := rec( name := "Translation", func := Ignore ),
    Basis       := rec( name := "Basis",       func := Ignore ),
    Isomorphism := rec( name := "Isomorphism", func := 
                        x -> IdGroup( PointGroup( WyckoffStabilizer( x ) ) ) )
  ) 
);

############################################################################
##
#M  GGLRightClickPopup . . . . . . . . . . called if user does a right click
##
##  This is called if the user does a right click on a vertex or somewhere
##  else on the sheet. This operation is highly configurable with respect
##  to the Attributes of groups it can display/calculate. See the 
##  configuration section in "ilatgrp.gi" for an explanation.
##
InstallMethod( GGLRightClickPopup, "for a Wyckoff graph", true,
    [ IsGraphicSheet and IsWyckoffGraph, IsObject, IsInt, IsInt ], 0,
function(sheet,v,x,y)

  local w, r, textselectfunc, text, pg, ps, i, str, basis, vec,
        funcclose, funcall, maxlengthofname;
  
  # did we get a vertex?
  if v = fail then
    return;
  fi;
  
  # destroy other text selectors flying around
  if sheet!.selector <> false then
    Close(sheet!.selector);
    sheet!.selector := false;
  fi;
  
  # get the Wyckoff position of <obj>
  w := v!.data.wypos;
  
  # how long are the names of the info displays?
  r := sheet!.infodisplays;
  maxlengthofname := Maximum( List( RecNames(r), x -> Length( r.(x).name ) ) );

  # text select function
  textselectfunc := function( sel, name )
    local tid, text, str, curr, value;
    
    tid  := sel!.selected;
    text := ShallowCopy(sel!.labels);
    str  := text[tid]{[1..maxlengthofname+1]};
    name := str{[1..Position(str,' ')-1]};
    if name = "" then
      name := "Default";
    fi;
    curr := sheet!.infodisplays.(name);

    if IsIdenticalObj( curr.func, Ignore ) then
      return true;
    fi;

    if not IsBound( v!.data.info.(name) ) then
      value := curr.func( w );
      v!.data.info.(name) := value;
    else
      value := v!.data.info.(name);
    fi;
    if IsBound( curr.tostr ) then
      Append( str, curr.tostr( value ) );
    else
      Append( str, String( value ) );
    fi;
    text[tid] := str;
    Relabel( sel, text );
    LastResultOfInfoDisplay := value;
    
    return true;
  end;

  # construct the initial text selector
  text := [];
  pg := PointGroup( WyckoffStabilizer( w ) );
  ps := PointGroup( WyckoffSpaceGroup( w ) );

  # the stabilizer size
  str := String( "StabSize", -(maxlengthofname+1) );
  Append( str, String( Size( pg ) ) );
  Append( text, [ str, textselectfunc ] );

  # the stabilizer dimension
  str := String( "StabDim", -(maxlengthofname+1) );
  Append( str, String( Length( WyckoffBasis( w ) ) ) );
  Append( text, [ str, textselectfunc ] );

  # the orbit length modulo lattice translations
  str := String( "OrbitLength", -(maxlengthofname+1) );
  Append( str, String( Size( ps ) / Size( pg ) ) );
  Append( text, [ str, textselectfunc ] );

  # the translation of the affine subspace
  str := String( "Translation", -(maxlengthofname+1) );
  Append( str, String( WyckoffTranslation( w ) ) );
  Append( text, [ str, textselectfunc ] );

  # the basis of the affine subspace
  basis := WyckoffBasis( w );
  str   := String( "Basis", -(maxlengthofname+1) );
  if basis = [] then
    Append( str, "[ ]" );
    Append( text, [ str, textselectfunc ] );
  elif Length( basis ) = 1 then
    Append( str, String( basis ) );
    Append( text, [ str, textselectfunc ] );
  else
    Append( str, "[ " );
    Append( str, String( basis[1] ) );
    for vec in basis{[2..Length(basis)]} do
      Append( text, [ str, textselectfunc ] );
      str := String( " ", -(maxlengthofname+3) );
      Append( str, String( vec ) );
    od;
    Append( str, " ]" );
    Append( text, [ str, textselectfunc ] );
  fi;

  # the isomorphism type
  str := String( "Isomorphism", -(maxlengthofname+1) );
  if HasIdGroup( pg ) then
    Append( str, String( IdGroup( pg ) ) );
  else
    Append( str, "unknown" );
  fi;
  Append( text, [ str, textselectfunc ] );

  # button select functions:
  funcclose := function( sel, bt )
    Close(sel);
    sheet!.selector := false;
    return true;  
  end;
  funcall := function( sel, bt )
    local i;
    for i  in [ 1 .. Length(sel!.labels) ]  do
      sel!.selected := i;
      sel!.textFuncs[i]( sel, sel!.labels[i] );
    od;
    Enable( sel, "all", false );
    return true;  
  end;
  
  # construct text selector
  sheet!.selector := TextSelector(
        Concatenation( " Information about ", v!.label ),
        text,
        [ "all", funcall, "close", funcclose ] );

end);

