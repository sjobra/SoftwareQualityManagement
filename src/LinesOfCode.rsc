module LinesOfCode

import IO;
import Set;
import List;
import util::Math;
import analysis::graphs::Graph;
import lang::java::m3::AST;
import Map;
import String;

import CommentHandling;

public map[loc, int] getMethodvsLoc(map[loc,str] methods)
{
	map[loc, int] methodVsLoc = ();
	
	// Loop through methods and get amount of lines per method
	for(<location, contentOfMethod> <- toList(methods))
	{
		methodVsLoc += (location : getLinesOfCode(contentOfMethod));
	}
	
	return methodVsLoc;	
}

public int getLinesOfCode(str input)
{
	// convert string to a list of Strings by splitting it up at \r\n 
	list[str] inputWithNewLines = split("\n", input);
	
	// TODO: Remove empty Lines
	
		return size(inputWithNewLines);	
}

public int getLinesOfCodeProgram()
{
	int linesOfCode = 0;
	map[loc, str] fileAndContentWithoutComment = getSourceCodeWithoutComments();
	
	for(<location, content> <- toList(fileAndContentWithoutComment)) 
	{	
		list[str] cleanCode = convertToArray(content);
		linesOfCode += size(cleanCode);
	}
	
	return linesOfCode;	
}

public int rankingLOC(int linesOfCode) {
	if(linesOfCode <= 66000)
		return 4;
	elseif(linesOfCode > 66000 && linesOfCode <= 246000)
		return 3;
	elseif(linesOfCode > 246000 && linesOfCode <= 665000)
		return 2;
	elseif(linesOfCode > 665000 && linesOfCode <= 1310000)
		return 1;
	else return 0;
}