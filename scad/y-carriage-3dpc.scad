include <MCAD/units.scad>
include <conf/config.scad>
use <bearing-holder.scad>

height = 15;
width_on_center = 8 * inch;
length_on_center = 3.5 * inch;
pad_diameter = 1.5 * inch;
connecting_bar_thickness = 1;


union(){

for (set  = [-1,1])
for (side = [-1,1])
translate([width_on_center / 2 * side ,length_on_center / 2 * set ,height])
bearing_holder(X_bearings, height);


for (set  = [-1,1])
for (side = [-1,1])
translate([width_on_center / 2 * side ,length_on_center / 2 * set ,connecting_bar_thickness/2])
cylinder(connecting_bar_thickness,pad_diameter/2,pad_diameter/2, center=true);

translate([0,0,connecting_bar_thickness/2])
difference() 
{
cube([8.2 * inch,3.75 * inch,connecting_bar_thickness], center=true);
cube([7.7 * inch,3.25 * inch,connecting_bar_thickness + 1], center=true);
}

}