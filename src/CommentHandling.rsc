module CommentHandling

import IO;
import lang::java::jdt::m3::Core;
import lang::java::m3::AST;
import util::Resources;
import List;
import Set;
import Map;
import Relation;
import String;

import ProjectReader;

// This function creates a map that contains the file and the location of all the comments.
public map[str, set[loc]] getCommentsPerFile() 
{
	map[str,set[loc]] commentsPerFile= ();
	
	// First initialize map with all keys and empty sets
	for(comment <- range(myModel.documentation)) {
		commentsPerFile[comment.uri] = {};
	}
	
	// Fill map with actual comment locations
	for(comment <- range(myModel.documentation)) {
		commentsPerFile[comment.uri] += comment;
	}
	
	return commentsPerFile;
}

// This function loops over the sourcecode and removes comments from the sourcecode / methods whatever provided
public map[loc, str] deleteCommentsFromSourceCode(map[loc, str] inputFiles, map[str, set[loc]] comments) {
	
	// Map initialisation containing sourceCodeWithoutComments
	map[loc, str] sourceCodeWithoutComments = ();
	
	// Loop through all the locations, if there is comment on that location, remove it
	for(<location, content> <- toList(inputFiles)) 
	{	
		if(location.uri in comments)
			sourceCodeWithoutComments += (location : removeCommentsFromFile(content, comments[location.uri]));
		else
			sourceCodeWithoutComments += (location: content);
	}
	
	return sourceCodeWithoutComments;
}

// This function actually removes the comment
public str removeCommentsFromFile(str file, set[loc] comments)
{
	// replaceAll : String that contains comment, the actual comment, replacement
	return (file | replaceAll(it, readFile(comment), "") | comment <- comments);
}


public map[loc, str] getSourceCodeWithoutComments()
{
	map[str, set[loc]] commentsPerFile = getCommentsPerFile();
	map[loc, str] sourceCodeWithoutComments = deleteCommentsFromSourceCode(getFileAndContent(), commentsPerFile);

	return sourceCodeWithoutComments;
}

// This function returnt all the methods without there comment
public map[loc, str] getMethodsWithoutComments()
{
	map [loc, str] allMethods = getMethodAndContent(allJavaMethods);
	map[str, set[loc]] commentsPerFile = getCommentsPerFile();
				
	return deleteCommentsFromSourceCode(allMethods, commentsPerFile);
}

// Create a map containing filelocation and the content of the file. 
public map[loc, str] getMethodAndContent(set[loc] javaMethods)
{
	map[loc, str] fileAndContent = ();
	for (file <- javaMethods)
	{	
		fileAndContent += ( file : readFile(file));
	}
	return fileAndContent;
}

public list[str] convertToArray(str input) 
{
	list[str] inputWithNewLines = split("\r\n", input);
	return removeBlankLines(inputWithNewLines);	
}


public list[str] removeBlankLines(list[str] input) = [x | x <- input, /^\S/ := trim(x)];


