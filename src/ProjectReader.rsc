module ProjectReader

import IO;
import lang::java::jdt::m3::Core;
import lang::java::m3::AST;
import util::Resources;
import List;
import Map;
import Relation;
import String;

// This module contains all the data that can be used for analysis.
// - M3 model
// - All java files with the content of that file (Map)
// - All methods with there content

// Project that needs to be analysed
public loc project = |project://smallsql/|;


//M3 Model created from project
public M3 myModel = createM3FromEclipseProject(project);

public rel[loc, loc] allCommentsInProject() = myModel.documentation;


// Function to open a project and retrieve the java files of that project
public set[loc] getJavaFiles(loc project) 
{
	Resource r = getProject(project);	
	return { a | /file(a) <- r, a.extension == "java" };
}



// Create a set of files to get all the javaFiles from the project. 
public set[loc] javaFiles = getJavaFiles(project); 

// Create a map containing filelocation and the content of the file. 
public map[loc, str] getFileAndContent()
{
	map[loc, str] fileAndContent = ();
	for (file <- javaFiles)
	{	
		fileAndContent += ( file : readFile(file));
	}
	return fileAndContent;
}


// From Introductory Assignment 9, obtain all methods and constructors.
// Creates a relation between java class and the methods / constructors
public rel[loc, loc] getAllMethods(M3 model)
{
	rel[loc,loc] allMethods = { <x,y> | <x,y> <- model.containment,
						x.scheme == "java+class",
                        y.scheme=="java+method" || y.scheme=="java+constructor" 
                       };
	return allMethods;
}

// Create a relation between files and methods containing all the methods
public rel[loc, loc] allMethods = getAllMethods(myModel);

public set[loc] getJavaMethods(M3 model) = { b | <a,b> <- model.declarations, a in methods(model)};

public set[loc] allJavaMethods = getJavaMethods(myModel);