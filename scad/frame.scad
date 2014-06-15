

include <MCAD/units.scad>

osb_thickness = 7/16 * inch;

base_width = 21.5 * inch;
base_length = 22 * inch;
base_thickness = osb_thickness;

arch_width = 21.5 * inch;
arch_length = 20.5 * inch;
arch_thickness = osb_thickness;

arch_opening_width =  14.625 * inch;
arch_opening_height = 18 * inch;

wing_width = 6 * inch;
wing_length = 20.5 * inch;
wing_thickness = osb_thickness;

space_in_front = 13 * inch;

wing_inset = 1.5 * inch;


arch_setback = base_length/2 - arch_thickness - space_in_front;
wing_setback = arch_setback - (wing_width/2);




echo("Max Arch Opening", (base_width - (wing_inset*4) - (wing_thickness*2)   ) / inch);

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

module wing() {

	translate([0,0,base_thickness/2])
		cube([wing_length, wing_width, wing_thickness], center = true);
}

translate([arch_setback,0,(arch_length/2) + base_thickness])
	rotate([0,90,0])
		arch();
		
for (side = [-1,1])
translate([wing_setback, (base_width/2 - wing_thickness/2 - wing_inset )*side +  -wing_thickness/2 ,(arch_length/2) + base_thickness])
	rotate([0,90,90])
		wing();
		
base();