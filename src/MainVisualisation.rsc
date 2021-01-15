module MainVisualisation

import analysis::graphs::Graph;
import Relation;
import vis::Figure;
import vis::Render;
import List;
import Map;
import IO;
import util::Math;

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
	list[tuple[loc location, str name, int complexity]] methodvolume = readMethodVolumePerFile();
	list[tuple[loc location, str name, int complexity]]  biggestMethods = take(6, methodvolume);
	int maxsize = sum(biggestMethods.complexity);
	int totalsize = sum(methodvolume.complexity);
	
	int incr = 0;
	int batchSize = 0;
	list[Figure] vertical = [];
	
	list[Figure] boxes = [];
	
	for(file <- methodvolume) {
		batchSize = batchSize + file.complexity;
		if(batchSize > maxsize) {
			vertical += hcat(boxes);
			boxes = [];
			batchSize=0;
		}
		boxes += box(text(file.name, fontSize(12), fontColor("blue")), area(file.complexity), fillColor("white"));
	}
	if(size(boxes) != 0) {
		vertical += hcat(boxes);
	}
	Figure megabox = box(vcat(vertical),  area(totalsize*2), fillColor("white"));
	render(megabox);
}

public real calculateBoxSize(int boxsize, int maxSize) {
	return toReal(boxsize)/toReal(maxSize);
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