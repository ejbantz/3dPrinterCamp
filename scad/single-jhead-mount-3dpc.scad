include <MCAD/units.scad>
include <MCAD/nuts_and_bolts.scad>
include <MCAD/boxes.scad>


width = 27;
length = 70;
height = .31 * inch;
jhead_diameter = .63 * inch;
jhead_diameter_inner = .47 * inch;


module no6nut() { cylinder(r= .36/2 * inch, h=.12 * inch, $fn = 6, center=[0,0]); }
module no6rod() { cylinder(r= .16/2 * inch, h=2 * inch, $fn = 20, center=[0,0]); }


module wirefeed() {
	rotate([90,0,0])
	rotate_extrude(convexity = 10)
	translate([15, 0, 0])
	circle(r = 5, $fn = 100);
}


intersection() 
{

	difference(){
		cube([width,length,height]);

		// JHead Hole
		for (side = [0])
			translate([width/2,length/2  + (10 * side),0])
				union(){
					translate([0,0,.18 * inch])
				#		cylinder(100,jhead_diameter/2,jhead_diameter/2);

					cylinder(100,jhead_diameter_inner/2,jhead_diameter_inner/2);
				};

		// Cut in half
		for (side = [-1,1])
			translate([width/4,length/2 + length/1.6*side,0])
				cube([1,length/2,100], center=true);
		
		for (side = [-1,1])
			translate([width/2.6666,length/2 + length/2.7*side,0])
				cube([width/4 + 1,1,100], center=true);

		translate([width/2,length/2,0])
			cube([1,length/1.35,100], center=true);	
		
		

		// nut holder
		for (side = [-1,1])
			translate([-0.001, length/2 + length/3.2 * side ,height/2])
				rotate([0,90,0])
					rotate([0,0,90])
					#	union(){
					echo( length/2 + length/3.2 * side);
							no6nut();
							no6rod();
						}

		// holes to connect to carriage
		for (side = [-1,1])
		{
			translate([width/2,length/2 + 60/2 * side ,0])
			no6rod();
		}	
		
		translate([width/2,46,height/2])
			wirefeed();
		translate([width/2,24,height/2])
			wirefeed();
	};
	
	translate([width/2, length/2,height/2])
		roundedBox([width,length,40],5,true);

}
