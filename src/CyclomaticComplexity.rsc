module CyclomaticComplexity

import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import util::Resources;
import Map;
import util::Math;

import ProjectReader;
import LinesOfCode;
import CommentHandling;
import Utilities;
import FileHandler;


alias Categories = tuple[int,int,int,int,int];

// To determine everything, alse the lines of Code per unit is needed. 
// Lines of code needs to be filtered, so without comment. 

// Location, Name of function, complexity, loc per Unit
public list[tuple[loc, str, int, int]] calculateCyclomaticComplexity()
{
	// First get all the methods without comment
	map[loc,str] methods = getMethodsWithoutComments();
	
	// Determine linesOfCode and put them in a map. 
	map[loc, int] linesOfCode = getMethodvsLoc(methods);
	saveLoc(linesOfCode);
	
	// Prepare map for cyclomatic complexity
	list[tuple[loc, str, str, int, int]] cyclComp = [];

	// We need the declarations to know what is happening in a method.
	// First obtain all the declarations from the java files (Exercise 9)
	set[Declaration] declarationsPerFile = {createAstFromFile(file, false) | file <- getJavaFiles(project)};
	
	// Now we can get the declarationsPerMethod by looking per file
	set[Declaration] declarationsPerMethod = { d | /Declaration d := declarationsPerFile, d	is method || d is constructor }; 
	
	list[tuple[loc, str, int, int]] result =[];
	for(Declaration decl <- declarationsPerMethod)
	{
		result += <decl.src, decl.name, cyclomaticComplexity(decl), linesOfCode[decl.src]>;
		cyclComp += <decl.src, decl.src.file, decl.name, cyclomaticComplexity(decl), linesOfCode[decl.src]>;
	}
	
	
	saveCC(cyclComp);
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


// This function evaluates the lines of code that belong to which risk. 
public map[str, int] riskEvalCC(list[tuple[loc, str, int, int]] CCList)
{
	map[str, int] ccInCategory = ( "simple": 0, "more complex" : 0, "complex": 0, "untestable": 0);
	
	for( cc <- CCList )
	{
		// Iterate through list and find the bin where cc belongs to
		if (cc[2] > 50)
			ccInCategory["untestable"] += cc[3];
		else if (cc[2] >20)
			ccInCategory["complex"] += cc[3];
		else if (cc[2] >10)
			ccInCategory["more complex"] += cc[3];
		else
			ccInCategory["simple"] += cc[3];	
	}
	
	return ccInCategory;
}

// This function calculates the percentage of code that belongs to each category
public map [str, real] calculateComplexityPercentage(map[str, int] categoryVsLoc)
{
	int totalLinesOfCode = 0;
	for (<category, linesOfCodePerCategory> <- toList(categoryVsLoc))
	{
		totalLinesOfCode += linesOfCodePerCategory;
	}
	
	map [str, real] catVsPerc = ( "simple": 0.0, "more complex" : 0.0, "complex": 0.0, "untestable": 0.0);
	catVsPerc["simple"] = (toReal(categoryVsLoc["simple"]) / toReal(totalLinesOfCode)) * 100;
	catVsPerc["complex"] = (toReal(categoryVsLoc["complex"]) / toReal(totalLinesOfCode)) * 100;
	catVsPerc["more complex"] = (toReal(categoryVsLoc["more complex"]) / toReal(totalLinesOfCode)) * 100;
	catVsPerc["untestable"] = (toReal(categoryVsLoc["untestable"]) / toReal(totalLinesOfCode)) * 100;
	
	return catVsPerc;
}

public int rankingComplexity(list[tuple[loc, str, int, int]] CC)
{	
	map[str, int] ccInCat = riskEvalCC(CC);
	map [str, real] catVsPerc = calculateComplexityPercentage(ccInCat);

	// m <=25 h = 0 vh = 0;
	if(catVsPerc["more complex"] <= 25.0 && catVsPerc["complex"] == 0.0 && catVsPerc["untestable"] == 0.0)
		return 4;
	if(catVsPerc["more complex"] <= 35.0 && catVsPerc["complex"] <= 5.0 && catVsPerc["untestable"] == 0.0)
		return 3;
	if(catVsPerc["more complex"] <= 40.0 && catVsPerc["complex"] <= 10.0 && catVsPerc["untestable"] == 0.0)
		return 2;
	if(catVsPerc["more complex"] <= 50.0 && catVsPerc["complex"] <= 15.0 && catVsPerc["untestable"] == 0.0)
		return 1;
	else
		return 0;	
}

public void printEvalCC(list[tuple[loc, str, int, int]] CC)
{	
	map[str, int] ccInCat = riskEvalCC(CC);
	
	int totalAmountOfMethods = 0;
	for (<category, amountOfMethods> <- toList(ccInCat))
	{
		totalAmountOfMethods += amountOfMethods;
	}
	
	map[str, real] riskMatrix = ( "simple": 0.0, "moderate" : 0.0, "high": 0.0, "very high": 0.0);
	riskMatrix["simple"] = (toReal(ccInCat["simple"]) / toReal(totalAmountOfMethods)) * 100;
	riskMatrix["moderate"] = (toReal(ccInCat["more complex"]) / toReal(totalAmountOfMethods)) * 100;
	riskMatrix["high"] = (toReal(ccInCat["complex"]) / toReal(totalAmountOfMethods)) * 100;
	riskMatrix["very high"] = (toReal(ccInCat["untestable"]) / toReal(totalAmountOfMethods)) * 100;	
							
	println(" * simple: "  + toString(round(riskMatrix["simple"])) + "%");
	println(" * moderate: "  + toString(round(riskMatrix["moderate"])) + "%");
	println(" * high: "  + toString(round(riskMatrix["high"])) + "%");
	println(" * very high: "  + toString(round(riskMatrix["very high"])) + "%");
}

public map[str, int] determineComplFile()
{
	// First find all the methods of the file
	list[tuple[loc, str,  str, int, int ]] cyclComp = readComplexity();
	
	// Create map that contains complexity per file
	map[str, Categories] fileComplexity = ();
	emptyCategories = <0,0,0,0,0>;
	
	// Create map for percentages
	map[str, tuple[real,real,real,real]] percentages = ();
	
	map[str, int] result = ();
	
	// Fill map with filenames
	for(entry <- cyclComp)
	{
		fileComplexity += ( entry[1] : emptyCategories);
		percentages += ( entry[1] : <0.0, 0.0, 0.0, 0.0>);
		result += ( entry[1] : 0 );
	}
	
	
	for(entry <- cyclComp)
	{
		for (<filename, category> <- toList(fileComplexity))
		{
			// Determine if files are the same, then fetch linesOfCode and complexity
			if(entry[1] == filename) 
			{
				int methodComplexity = entry[3];
				int linesOfCode = entry[4];
				
				// Determine complexity bin
				int bin = rankIndividualComplexity(methodComplexity);
				
				// Put lines of code in correct bin
				// get currentValues
				currentCatValues = fileComplexity[filename];
				
				currentCatValues[bin] += linesOfCode;
				currentCatValues[4] += linesOfCode;
				
				fileComplexity[filename] = currentCatValues;
			}
		}
	}
	
	// Now Calculate back to percentage of complexity code per bin / total lines of code
	// Fill map with filenames
	
	
	for(<filename, category> <- toList(fileComplexity))
	{
		binSimple = toReal(category[0]) / toReal(category[4]);
		binMComplex = toReal(category[1]) / toReal(category[4]);
		binComplex = toReal(category[2]) / toReal(category[4]);
		binUntestable = toReal(category[3]) / toReal(category[4]);
		
		percentages[filename] = <binSimple , binMComplex, binComplex , binUntestable >;
	}
	
	// Now determine the overall complexity per file
	for(<filename, perc> <- toList(percentages))
	{
		if(perc[1] <= 0.25 && perc[2] == 0.0 && perc[3] == 0.0)
		{
			result[filename] = 4;			
		}
		else if(perc[1] <= 0.35 && perc[2] <= 0.05 && perc[3] == 0.0)
		{
			result[filename] = 3;			
		}
		else if(perc[1] <= 0.40 && perc[2] <= 0.10 && perc[3] == 0.0)
		{
			result[filename] = 2;		
		}
		else if(perc[1] <= 0.50 && perc[2] <= 0.15 && perc[3] == 0.0)
		{
			result[filename] = 1;	
		}
		else
			result[filename] =  0;	
	}	
	saveComplexityPerFile(result);
	return result;	
}

public int rankIndividualComplexity(int cc)
{
	if (cc > 50)
		return 3;
	else if (cc > 20)
		return 2;
	else if (cc > 10)
		return 1;
	else
		return 0;	
}