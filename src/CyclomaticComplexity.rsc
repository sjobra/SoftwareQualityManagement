module CyclomaticComplexity

import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import util::Resources;


import ProjectReader;
import LinesOfCode;
import CommentHandling;

// To determine everything, alse the lines of Code per unit is needed. 
// Lines of code needs to be filtered, so without code. 

// Location, Name of function, complexity, loc per Unit
public list[tuple[loc, str, int]] calculateCyclomaticComplexity()
{
	map[loc,str] methods = getSourceCodeWithoutComments();
	
	map[loc, int] linesOfCode = getMethodvsLoc(methods);


	// We need the declarations to know what is happening in a method.
	// First obtain all the declarations from the java files (Exercise 9)
	set[Declaration] declarationsPerFile = {createAstFromFile(file, false) | file <- getJavaFiles(project)};
	
	// Now we can get the declarationsPerMethod by looking per file
	set[Declaration] declarationsPerMethod = { d | /Declaration d := declarationsPerFile, d	is method || d is constructor }; 
	
	list[tuple[loc, str, int]] result =[];
	for(Declaration decl <- declarationsPerMethod)
	{
		result += <decl.src, decl.name, cyclomaticComplexity(decl)>;
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


// This function evaluates the amount of functions that belong to which risk. 
public map[str, int] riskEvalCC(list[tuple[loc, str, int]] CCList)
{
	map[str, int] ccInCategory = ( "simple": 0, "more complex" : 0, "complex": 0, "untestable": 0);
	
	for( cc <- CCList )
	{
		// Iterate through list and find the bin where cc belongs to
		if (cc[2] > 50)
			ccInCategory["untestable"] += 1;
		else if (cc[2] >20)
			ccInCategory["complex"] += 1;
		else if (cc[2] >10)
			ccInCategory["more complex"] += 1;
		else
			ccInCategory["simple"] += 1;	
	}
	
	return ccInCategory;
}