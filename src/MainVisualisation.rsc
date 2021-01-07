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
	Figure treeMapProperties = treemap([box(text(name.file), area(amountOfLines), fillColor(arbColor())) | <name, amountOfLines> <- toRel(properties)]);
	render("SmallSql", treeMapProperties);
}