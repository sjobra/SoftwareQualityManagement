module ProjectReader

import IO;
import util::Resources;
import Set;
import Map;
import List;

private loc project = |project://smallsql/|;

// Function to open a project and retrieve the java files of that project
public set[loc] javaFiles(loc project) 
{
	Resource r = getProject(project);	
	return { a | /file(a) <- r, a.extension == "java" };
}

// Function to determine if it is descending
public bool descending(tuple[&a, num] x, tuple[&a, num] y) {
return x[1] > y[1];
}

// Create a set of files to get all the javaFiles from the project. 
private set[loc] files = javaFiles(project); 

// This function determines the amount of java files in the project. 
public void amountOfJavaFiles() 
{		
	print("The amount of Java files: ");
	println(size(files));	
}

// This function determines the amount of lines per java file
public void amountOfLines()
{
	println("Amount of Lines");
	map[loc, int] lines = ( file:size(readFileLines(file)) | file <- files );

	for(<file, amountOfLines> <- sort(toList(lines), descending))
		println("<file.file>: <amountOfLines> lines");
}

// Print an overview of all the statistics. 
public void Overview()
{
	println("Overview");
	amountOfJavaFiles();
	amountOfLines();
}