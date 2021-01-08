module MainVisualisation

import analysis::graphs::Graph;
import Relation;
import vis::Figure;
import vis::Render;
import Map;


import FileHandler;

map[loc, int] properties = readFileProperties(); 
list[tuple[loc, str, int, int]] complexity = readComplexity();

 
 public void main()
{
	// Create Main menu
	
	Figure btnMaintainability = button("Maintainability", mainPressed, fillColor("grey"), size(150,20), resizable(false) );
	Figure btnVolume= button("Volume", volumePressed, fillColor("grey"), size(150,20), resizable(false));
	//Figure btnComplexity= box(size(150,50), text("Maintainability"), fillColor("blue"));
	
	render(vcat([btnMaintainability, btnVolume], gap(20),  resizable(false)));
	
	//Figure treeMapProperties = treemap([box(text(name.file), area(amountOfLines), fillColor(arbColor())) | <name, amountOfLines> <- toRel(properties)]);
	//render("SmallSql", treeMapProperties);
}

public void mainPressed()
{
}

public void volumePressed()
{
}