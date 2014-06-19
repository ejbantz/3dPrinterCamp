//
// Mendel90
//
// GNU GPL v2
// nop.head@gmail.com
// hydraraptor.blogspot.com
//
// Rail supports
//
include <conf/config.scad>
include <positions.scad>
include <MCAD/units.scad>

nut_trap_meat = 4;                  // how much plastic above the nut trap
wall = 3;

function bar_clamp_inner_rad(d) = d / 2;
function bar_clamp_outer_rad(d) = bar_clamp_inner_rad(d) + bar_clamp_band;
function bar_clamp_stem(d) = bar_clamp_inner_rad(d) + bar_clamp_outer_rad(d) + bar_clamp_tab - 2;
function bar_clamp_length(d) = bar_clamp_tab + bar_clamp_stem(d) + bar_clamp_tab;
function bar_rail_offset(d) = bar_clamp_tab + d / 2 + bar_clamp_band;

function bar_clamp_switch_y_offset() = 12;

function y_switch_x(w) = -w / 2 - bar_clamp_switch_y_offset();
function y_switch_y(d) = bar_clamp_inner_rad(d) + microswitch_thickness() / 2 + 2;
function y_switch_z(h) = h + microswitch_button_x_offset();

function bar_clamp_switch_x_offset() = y_switch_y(Y_bar_dia);
function bar_clamp_switch_z_offset() = microswitch_button_x_offset();

module bar_clamp_holes(d, yaxis) {
    nut = yaxis ? base_nut : frame_nut;
    nut_offset = (yaxis ? base_nut_traps : frame_nut_traps) ? -bar_clamp_tab / 2 + nut_radius(nut) + 0.5 : 0;

    for(y = [bar_rail_offset(d) - bar_clamp_length(d) + 0.5 * bar_clamp_tab - nut_offset,
             bar_rail_offset(d)                       - 0.5 * bar_clamp_tab + nut_offset])
        translate([0, y, 0])
            child();
}

module bar_clamp(d, h, w, switch = false, yaxis = false, side = 1, carve = -1) {
    stl(str(yaxis ? "y_bar_clamp" : "z_bar_clamp", (switch && yaxis) ? "_switch" : ""));
    nutty = yaxis ? base_nut_traps : frame_nut_traps;
    mount_screw = yaxis ? base_screw : frame_screw;
    nut_depth = nut_trap_depth(screw_nut(mount_screw));
    gap = 1.5;
    inner_rad = bar_clamp_inner_rad(d);
    outer_rad = bar_clamp_outer_rad(d);
    stem = bar_clamp_stem(d) - 7;
    length = bar_clamp_length(d);
    rail_offset = bar_rail_offset(d);

    cavity_l = stem - 2 * wall;
    cavity_h = h - nut_trap_meat - nut_trap_depth;
    cavity_w = w - 2 * wall;

    sbracket_length = -y_switch_x(w) + 4;
    sbracket_thickness = 7;
    sbracket_height = microswitch_length();

    tab_height = part_base_thickness + (nutty ? nut_depth : 0);


    color("orange") {
        translate([0, rail_offset, 0]) {
            difference() {
				union() {
				if (yaxis == false)
				{
					translate([0,-length/2,0]) rotate([90,0,90]) 
					difference()
					{
						translate([0,32,-6.5])
							cube([30,15,13]);
						
						translate([(stem/2 - outer_rad), h, 0])
							translate([21,0,0]) 
								cylinder(100, 22/64 * inch / 2, 5/16 * inch / 2, center = true);
							
						translate([(stem/2 - outer_rad), h, 0])
							cylinder(100, inner_rad, inner_rad, center = true);
						echo(side);
						translate([16, - 0.5 * bar_clamp_tab - 0.5,0]) // screwdriver access
							rotate([90 * side,180,0])
								teardrop(h = 200, r = 0.30 * inch / 2 , center = true, truncate = false);							
					}				
												
				}
			
                difference() {
                    translate([0,-length/2,0]) rotate([90,0,90]) linear_extrude(height = w, center = true, convexity = 6) {
                        difference() {
                            union() {
                                translate([0, tab_height / 2, 0])
                                    square([length, tab_height], center = true);            // base
                                translate([0, h / 2, 0])
                                    square([stem, h], center = true);                       // stem
                                translate([(stem/2 - outer_rad), h, 0])
                                    circle(r = outer_rad, center = true);                   // band
                     

                            }
                            translate([(stem/2 - outer_rad), h, 0])
							{
                                poly_circle(r = inner_rad, center = true);                  // bore
						   
							}

                            translate([-rail_offset + 2, h , 0])
                                square([stem, gap]);                                        // gap

                            }
                        }
            
  
  
                    //
                    // mounting holes
                    //
                    translate([0, -rail_offset, tab_height])
                        bar_clamp_holes(d, yaxis)
                            rotate([0,0,90])
                                if(nutty)
                                    nut_trap(screw_clearance_radius(mount_screw), nut_radius(screw_nut(mount_screw)), nut_depth, true);
                                else
                                    tearslot( h = 100, r = screw_clearance_radius(frame_screw) + .5 , center = true, w = 2); // mounting screw

                 
                        

                    *translate([0,-50,-1]) cube([100,100,100]);             // cross section for debug
					
                }
                if(switch && yaxis) {                                       // switch bracket
					 
                    difference() {
						union() {
                            translate([w / 2 -sbracket_length,
                                        y_switch_y(d) + microswitch_thickness() / 2 - rail_offset ,
                                        y_switch_z(h) - microswitch_button_x_offset() - microswitch_length() / 2])
                                cube([sbracket_length, sbracket_thickness, sbracket_height]);

                            translate([w / 2 - eta - sbracket_thickness,
                                       y_switch_y(d) - microswitch_thickness() / 2 - rail_offset +0.5 - 4,
                                       y_switch_z(h) - microswitch_button_x_offset() - microswitch_length() / 2])
                                cube([sbracket_thickness,
                                      y_switch_y(d) - outer_rad + microswitch_thickness() / 2 + 1 + 4,
                                      h - (y_switch_z(h) - microswitch_button_x_offset() - microswitch_length() / 2)]);
                        }
                        translate([y_switch_x(w), y_switch_y(d) - rail_offset, y_switch_z(h)])
                            mirror([0,1,0]) rotate([0, 90, 90])
                                microswitch_holes();

                        if(!nutty)
                            translate([0, - 0.5 * bar_clamp_tab - 0.5,0]) // screwdriver access
                                rotate([0,0,90])
                                    teardrop(h = 100, r = 0.30 * inch / 2 , center = true, truncate = false);
                    }
                }
            }
				if (yaxis)
				  translate([-6.5 + (carve * -2),-length/2 - 3,5]) rotate([90,0,90]) cube([6,16,13]);
				else
				  translate([-6.5 + (carve * -2),-length/2 - 3,5]) rotate([90,0,90]) cube([6,27.25,13]);				
				    
			}
		}
    }
}

module bar_clamp_assembly(d, h, w, switch = false, yaxis = true) {
    inner_rad = bar_clamp_inner_rad(d);
    outer_rad = bar_clamp_outer_rad(d);
    length = bar_clamp_length(d);
    rail_offset = bar_rail_offset(d);

    color(clamp_color) render() bar_clamp(d, h, w, switch, yaxis);
    //
    // screw and washer for clamp
    //
    translate([0, rail_offset - length + 1.5 * bar_clamp_tab, h + inner_rad + bar_clamp_band])
         screw_and_washer(cap_screw, screw_longer_than(outer_rad + nut_trap_meat + washer_thickness(washer) + nut_thickness(nut, true)));
    //
    // Captive nut
    //
    translate([0, rail_offset - length + 1.5 * bar_clamp_tab, h - nut_trap_meat])
        rotate([180, 0, 90])
            nut(nut, true);
    //
    // mounting screws and washers
    //
    bar_clamp_holes(d, yaxis)
        translate([0, 0, part_base_thickness])
            rotate([0, 0, 90])
                if(yaxis)
                    base_screw(part_base_thickness);
                else
                    frame_screw(part_base_thickness);
    //
    // limit switch
    //
    if(switch)
        if(yaxis)
            translate([y_switch_x(w), y_switch_y(d), y_switch_z(h)])
                mirror([0,1,0]) rotate([0, 90, 90]) {
                    microswitch();
                    microswitch_hole_positions()
                        screw_and_washer(No2_screw, 13);
                }
        else
            if(top_limit_switch)
                translate([-w / 2 - limit_switch_offset,
                           outer_rad + microswitch_thickness() / 2,
                           h - outer_rad + microswitch_first_hole_x_offset()])
                    rotate([0, 90, 90]) {
                        microswitch();
                        microswitch_hole_positions()
                            screw_and_washer(No2_screw, 13);
                    }
}


module y_bar_clamp_assembly(d, h, w, switch = false) {
     bar_clamp_assembly(d, h, w, switch, yaxis = true);
}

module z_bar_clamp_assembly(d, h, w, switch = false) {
     bar_clamp_assembly(d, h, w, switch, yaxis = false);
}

//bar_clamp(Z_bar_dia, gantry_setback, bar_clamp_depth, true);

module y_bar_clamp_stl(carve = -1)        translate([0,0,bar_clamp_depth/2]) rotate([0,90,0]) bar_clamp(Y_bar_dia, Y_bar_height, bar_clamp_depth, false, true, 1, carve);
module y_bar_clamp_switch_stl() translate([0,0,bar_clamp_depth/2]) rotate([0,90,0]) bar_clamp(Y_bar_dia, Y_bar_height, bar_clamp_depth, true, true, 1, 1);

module z_bar_clamp_stl()        translate([0,-4,bar_clamp_depth/2]) rotate([180,-90,0]) bar_clamp(Z_bar_dia, gantry_setback, bar_clamp_depth, false, false, -1);
module z_bar_clamp_switch_stl() translate([0,-3,bar_clamp_depth/2]) rotate([0,90,0]) bar_clamp(Z_bar_dia, gantry_setback, bar_clamp_depth, true, false, 1, 1);

module bar_clamps_stl() {
    y2 = bar_clamp_length(Z_bar_dia) - bar_clamp_tab + 2;
    y3 = y2 + bar_clamp_length(Y_bar_dia) - bar_clamp_tab + 2;
                                                                                         rotate([0, 0, 180]) z_bar_clamp_switch_stl();
    translate([2, -2 * bar_rail_offset(Z_bar_dia) + bar_clamp_length(Z_bar_dia), 0])                         z_bar_clamp_stl();

    translate([-7, y2 , 0])                                                              rotate([0, 0, 180]) y_bar_clamp_switch_stl();
    translate([10, y2 -2 * bar_rail_offset(Y_bar_dia) + bar_clamp_length(Y_bar_dia) - 8, 13]) rotate([180, 0, 0])                    y_bar_clamp_stl();

    translate([0, y3 - 4, 0])                                                                rotate([0, 0, 180])  y_bar_clamp_stl(1);
    translate([2, y3 -2 * bar_rail_offset(Y_bar_dia) + bar_clamp_length(Y_bar_dia) - 12, 13])  rotate([180, 0, 0])                    y_bar_clamp_stl();
}

if(1)
    bar_clamps_stl();
else {
    z_bar_clamp_assembly(Z_bar_dia, gantry_setback, bar_clamp_depth, true);
    //bar_clamp(Z_bar_dia, gantry_setback, bar_clamp_depth, true, false);

    //translate([30, 0, 0]) y_bar_clamp_assembly(Y_bar_dia, Y_bar_height, bar_clamp_depth, true);
    //translate([30, 0, 0]) bar_clamp(Y_bar_dia, Y_bar_height, bar_clamp_depth, true, true);

}
