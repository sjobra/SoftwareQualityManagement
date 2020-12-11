module ProjectReader

import IO;
import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import util::Resources;


// This module contains all the data that can be used for analysis.
// - M3 model
// - All java files with the content of that file (Map)
// - All methods with there content

// Function to open a project and retrieve the java files of that project
public set[loc] getJavaFiles(loc project) 
{
	Resource r = getProject(project);	
	return { a | /file(a) <- r, a.extension == "java" };
}

// From Introductory Assignment 9, obtain all methods and constructors.
// Creates a relation between java class and the methods / constructors
public rel[loc, loc] getAllMethods(M3 model)
{
	rel[loc, loc] allMethods = { <x,y> | <x,y> <- model.containment
                       , x.scheme=="java+class"
                       , y.scheme=="java+method" || y.scheme=="java+constructor" 
                       };
	return allMethods;
}

// Project that needs to be analysed
public loc project = |project://smallsql/|;

//M3 Model created from project
public M3 myModel = createM3FromEclipseProject(project);

// Create a set of files to get all the javaFiles from the project. 
public set[loc] javaFiles = getJavaFiles(project); 

// Create a map containing filelocation and the content of the file. 
public map[loc, str] fileWithContent = (location:readFile(location) | location <- javaFiles);

// Create a relation between files and methods containing all the methods
public rel[loc, loc] methods = getAllMethods(myModel);

