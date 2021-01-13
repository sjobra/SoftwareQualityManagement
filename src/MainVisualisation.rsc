module MainVisualisation

import analysis::graphs::Graph;
import Relation;
import vis::Figure;
import vis::Render;
import Map;


import FileHandler;
import CyclomaticComplexity;

//map[loc, int] properties = readFileProperties(); 


 
 public void main()
{
	// Create Main menu
	
	Figure btnMaintainability = button("Maintainability", mainPressed, fillColor("grey"), size(150,20), resizable(false) );
	Figure btnVolume= button("Volume", volumePressed, fillColor("grey"), size(150,20), resizable(false));
	Figure btnMethodVol = button("Method Volume", volumeMethodPressed, fillColor("grey"), size(150,20), resizable(false));
	Figure btnDupl= button("Duplication", duplicationPressed, fillColor("grey"), size(150,20), resizable(false));
	Figure btnComplex= button("Complexity", complexityPressed, fillColor("grey"), size(150,20), resizable(false));
	
	
	render(vcat([btnMaintainability, btnVolume, btnMethodVol, btnDupl, btnComplex], gap(20),  resizable(false)));
	
	//Figure treeMapProperties = treemap([box(text(name.file), area(amountOfLines), fillColor(arbColor())) | <name, amountOfLines> <- toRel(properties)]);
	//render("SmallSql", treeMapProperties);
}

public void mainPressed()
{
}

public void volumePressed()
{
}

public void volumeMethodPressed()
{
}

public void duplicationPressed()
{
}

public void complexityPressed()
{
	list[tuple[loc, str, int, int]] complexity = readComplexity();
	map[loc, int] methodAndCompl = ( l:c| <l,m,c,s> <- complexity);
	
	//map[str, int] complexityMatrix = riskEvalCC(complexity);
	
	Figure root = ellipse(size(30), fillColor("blue"));
	Figure childSimple = ellipse(size(30), fillColor("green"));
	Figure childMoreComplex= ellipse(size(30), fillColor("yellow"));
	Figure childComplex= ellipse(size(30), fillColor("orange"));
	Figure childUntestable = ellipse(size(30), fillColor("red"));
	
	// get Untestable functions > 50 from complexity based on information.
	//list[tuple[loc, str, int, int]] untestableFunctions = ();
	
	//map[loc, int] methodAndSize = ( l:s| <l,m,c,s> <- complexity);
	
	
	
	//untestableFunctions = {[a | a<-complexity,  a[2] > 50]};
	
	complexTree = tree(root, [childSimple, childMoreComplex, childComplex, childUntestable], gap(20), orientation(leftRight()));
	render(complexTree); 
	
	
	
	
	
	//Figure boxSimple = box(text("Simple"), area(complexityMatrix["simple"]), fillColor("green"));
	//Figure boxMoreComplex = box(text("More Complex"), area(complexityMatrix["more complex"]),  fillColor("yellow"));
	//Figure boxComplex = box(text("Complex"), area(complexityMatrix["complex"]),  fillColor("orange"));
	//Figure boxUntestable = box(text("Untestable"), area(complexityMatrix["untestable"]), fillColor("red"));
	
//	t = box(vcat([
//            	text("smallSQL Complexity"), 
//            	treemap([boxSimple, boxMoreComplex, boxComplex, boxUntestable])],
 //           	shrink(0.9)), fillColor("lightblue"));
	//render(pack([boxSimple, boxMoreComplex, boxComplex, boxUntestable]));
	//render(t);
}