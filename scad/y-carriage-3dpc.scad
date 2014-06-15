include <MCAD/units.scad>
include <conf/config.scad>
use <bearing-holder.scad>
use <y-belt-anchor-3dpc.scad>

height = 15;
width_on_center = 8 * inch;
length_on_center = 3.5 * inch;
pad_diameter = 1.5 * inch;
connecting_bar_thickness = 1;


union(){

intersection(){
	union() {
		// The linear bearing mounts
		for (set  = [-1,1])
			for (side = [-1,1]){
				translate([width_on_center / 2 * side ,length_on_center / 2 * set ,height])
				{
					bearing_holder(X_bearings, height);
					translate([11.5 * side,13.5 * set,-9])
						cube([3,3,12], center = true);  // pad to hit the switch
				}
			}

		// Circle pads for gluing
		for (set  = [-1,1])
			for (side = [-1,1])
				translate([width_on_center / 2 * side ,length_on_center / 2 * set ,connecting_bar_thickness/2])
					cylinder(connecting_bar_thickness,pad_diameter/2,pad_diameter/2, center=true);
	}
				
	// Circle pads for gluing
	for (set  = [-1,1])
		for (side = [-1,1])
			translate([width_on_center / 2 * side ,length_on_center / 2 * set ,connecting_bar_thickness/2])
				cylinder(100,pad_diameter/2,pad_diameter/2, center=true);			
}
	// Bar connecting the bearing mounts
	translate([0,0,connecting_bar_thickness/2])
	difference() 
	{
		cube([8.2 * inch,3.75 * inch,connecting_bar_thickness], center=true);
		cube([7.7 * inch,3.25 * inch,connecting_bar_thickness + 1], center=true);
	}

	
	// Bar connecting the belt holders
	translate([0,0,connecting_bar_thickness/2])
	cube([.14 * inch,3.75 * inch,connecting_bar_thickness], center=true);
		
	 y_belt_anchors_stl();
	

	
}