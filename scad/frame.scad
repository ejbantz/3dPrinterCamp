

include <MCAD/units.scad>

osb_thickness = 7/16 * inch;

base_width = 20.5 * inch;
base_length = 22 * inch;
base_thickness = osb_thickness;

arch_width = 20.5 * inch;
arch_length = 20.5 * inch;
arch_thickness = osb_thickness;

arch_opening_width = 10 * inch;
arch_opening_height = 15 * inch;

room_in_front = 13 * inch;


module base() {
	translate([0,0,base_thickness/2])
		cube([base_length, base_width, base_thickness], center = true);
} 

module arch() {

    fudge = 1;
	translate([0,0,base_thickness/2])
		difference() {
			cube([arch_length, arch_width, arch_thickness], center = true);
			translate([(arch_length - arch_opening_height) / 2,0,0])
				cube([arch_opening_height, arch_opening_width, arch_thickness + fudge], center = true);
		}
}

translate([base_length/2 - arch_thickness - room_in_front,0,(arch_length/2) + base_thickness])
	rotate([0,90,0])
		arch();
base();