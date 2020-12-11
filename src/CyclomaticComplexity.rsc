module CyclomaticComplexity

import IO;
import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import util::Resources;
import List;
import Set;
import Map;
import Relation;
import String;

import ProjectReader;

public list[rel[str, int]] calculateCyclomaticComplexity()
{
	// We need the declarations to know what is happening in a method.
	// First obtain all the declarations from the java files (Exercise 9)
	set[Declaration] declarationsPerFile = {createAstFromFile(file, false) | file <- getJavaFiles(project)};
	
	// Now we can get the declarationsPerMethod by looking per file
	set[Declaration] declarationsPerMethod = { d | /Declaration d := declarationsPerFile, d	is method || d is constructor }; 
	
	list[rel[str, int]] result =[];
	for(Declaration decl <- declarationsPerMethod)
	{
		result += {<x,y> | x := decl.name, y:=cyclomaticComplexity(decl)};
	}
	return result;
}

int cyclomaticComplexity(Declaration method) { 
  result = 1;
  visit (method) {
  	case \if(_,_): result = result + 1;
  	case \if(_,_,_): result = result + 1;
  	case \case(_): result = result + 1;
  	case \do(_,_): result = result + 1;
  	case \while(_,_): result = result + 1;
  	case \for(_,_,_): result = result + 1;
  	case \for(_,_,_,_): result = result + 1;
  	case \foreach(_,_,_): result =  result + 1;
    case \catch(_,_): result += 1;
    case \conditional(_,_,_): result += 1;
   	case \infix(_,"&&",_) : result += 1;
   	case \infix(_,"||",_) : result += 1;
  }
  return result;
}