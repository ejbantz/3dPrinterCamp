include <MCAD/units.scad>
include <MCAD/nuts_and_bolts.scad>


width = 27;
length = 65;
height = 11;
jhead_diameter = .63 * inch;
jhead_diameter_inner = .42 * inch;


module no6nut() { cylinder(r= .31/2 * inch, h=.12 * inch, $fn = 6, center=[0,0]); }
module no6rod() { cylinder(r= .16/2 * inch, h=2 * inch, $fn = 20, center=[0,0]); }

difference(){
cube([width,length,height]);


// JHead Hole
translate([width/2,length/2,0])
union(){
	translate([0,0,.18 * inch])
		cylinder(100,jhead_diameter/2,jhead_diameter/2);

	cylinder(100,jhead_diameter_inner/2,jhead_diameter_inner/2);
};

	// Cut in half
	for (side = [-1,1])
	translate([width/4,length/2 + length/2*side,0])
	cube([1,length/2,100], center=true);
	
	for (side = [-1,1])
	translate([width/2.6666,length/2 + length/4*side,0])
	cube([width/4 + 1,1,100], center=true);

	translate([width/2,length/2,0])
	cube([1,length/2,100], center=true);	
	
	

// nut holder
    for (side = [-1,1])
	translate([-0.001, length/2 +   length/6 * side,height/2])
	rotate([0,90,0])
	rotate([0,0,90])
	union(){
	no6nut();
	no6rod();
	}

	// holes to connect to carriage
	for (side = [-1,1])
	{
       translate([width/2,length/2 + 50/2 * side ,0])
	  no6rod();
	}	
	
	
	// made side thinner
	for (side=[0,1])
	translate([0,side * (length-12),5])
	# cube([width,12,height]);
	
	
	
};


