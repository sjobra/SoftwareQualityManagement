module MainVisualisation

import analysis::graphs::Graph;
import Relation;
import vis::Figure;
import vis::Render;
import Map;


import FileHandler;
import CyclomaticComplexity;

map[loc, int] properties = readFileProperties(); 


 
 public void main()
{
	// Create Main menu
	
	Figure btnMaintainability = button("Maintainability", mainPressed, fillColor("grey"), size(150,20), resizable(false) );
	Figure btnVolume= button("Volume", volumePressed, fillColor("grey"), size(150,20), resizable(false));
	Figure btnComplex= button("Complexity", complexityPressed, fillColor("grey"), size(150,20), resizable(false));
	
	
	render(vcat([btnMaintainability, btnVolume, btnComplex], gap(20),  resizable(false)));
	
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
	list[tuple[loc, str, int, int]] complexity = readComplexity();
	map[str, int] complexityMatrix = riskEvalCC(complexity);
	
	Figure boxSimple = box(text("Simple"), area(complexityMatrix["simple"]), fillColor("green"));
	Figure boxMoreComplex = box(text("More Complex"), area(complexityMatrix["more complex"]),  fillColor("yellow"));
	Figure boxComplex = box(text("Complex"), area(complexityMatrix["complex"]),  fillColor("orange"));
	Figure boxUntestable = box(text("Untestable"), area(complexityMatrix["untestable"]), fillColor("red"));
	
	t = box(vcat([
            	text("smallSQL Complexity"), 
            	treemap([boxSimple, boxMoreComplex, boxComplex, boxUntestable])],
            	shrink(0.9)), fillColor("lightblue"));
	//render(pack([boxSimple, boxMoreComplex, boxComplex, boxUntestable]));
	render(t);
}