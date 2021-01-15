module MainVisualisation

import analysis::graphs::Graph;
import lang::java::jdt::m3::Core;
import Relation;
import vis::Figure;
import vis::Render;
import Map;
import List;
import Set;

import ProjectReader;
import FileHandler;
import CyclomaticComplexity;
import GraphNode;

//map[loc, int] properties = readFileProperties(); 
Graph[loc] m3Graph = createGraph();
 
 public void main()
{
	// Create Main menu
	//Figure legend = vcat(text("Legend:") + createGraphInfo(), resizable(false));
	//render(legend);
	
	Figure btnMaintainability = button("Maintainability", mainPressed, fillColor("grey"), size(150,20), resizable(false) );
	Figure btnVolume= button("Volume", volumePressed, fillColor("grey"), size(150,20), resizable(false));
	Figure btnMethodVol = button("Method Volume", volumeMethodPressed, fillColor("grey"), size(150,20), resizable(false));
	Figure btnDupl= button("Duplication", duplicationPressed, fillColor("grey"), size(150,20), resizable(false));
	Figure btnComplex= button("Complexity", complexityPressed, fillColor("grey"), size(150,20), resizable(false));
	
	render(vcat([btnMaintainability, btnVolume, btnMethodVol, btnDupl, btnComplex], gap(20),  resizable(false)));
	
	
	
	//render(vcat([btnMaintainability, btnVolume, btnComplex], gap(20),  resizable(false)));
	
	//Figure treeMapProperties = treemap([box(text(name.file), area(amountOfLines), fillColor(arbColor())) | <name, amountOfLines> <- toRel(properties)]);
	//render("SmallSql", treeMapProperties);
}

public void mainPressed()
{
}

public void volumePressed()
{
}

public void complexityPressed()
{
	locPerFile = readLocPerFile();
	boxes = treemap([box( id(filename), area(linesOfCode), fillColor("blue")) |
	<filename, linesOfCode> <- locPerFile]);
	render(boxes);		
}

public void volumeMethodPressed()
{
}

public void duplicationPressed()
{
}

private Figures createGraphInfo() 
{
	return [box(text("++"),fillColor("Green"), size(25), resizable(false)),
			box(text("+"), fillColor("Lightblue"), size(25), resizable(false)),
			box(text("O"),fillColor("Yellow"), size(25), resizable(false)),
			box(text("-"),fillColor("Orange"), size(25), resizable(false)),
			box(text("--"),fillColor("Red"), size(25), resizable(false))];
}



