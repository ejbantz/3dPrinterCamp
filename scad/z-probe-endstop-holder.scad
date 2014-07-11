include <mcad\boxes.scad>;
include <mcad\units.scad>;


length = 50;
width = 10;

motorHoleRadius = 3.75;
innerArmLength = 28.5;



difference(){
  union(){
    difference(){
	 translate([0,0,2])
     roundedBox([width,length,8],4,true); //main body
      translate([0, 0 ,3 + 2])
        roundedBox([0.21 * inch,45,5 + 4],2.4,true);  //slot for servo arm
      translate([0,-(length / 2 - motorHoleRadius - (width/2-motorHoleRadius)),-5])
      	cylinder(r=motorHoleRadius,h=10 + 4, $fn=30); //  Hole for servo spindle
     }

    translate([0,length / 2 - 5/2,2])
    	roundedBox([20,5,4 + 4],1.75,true); // Microswtich mount body
  }
	 

	
	
	translate([0,length / 2 - 5/2,0])
		rotate([0,0,90])
			pairOfHoles(10); // holes for mounting screws
}



module pairOfHoles(distance)
{

    for (side = [-1,1])
		translate([0,distance / 2 * side,0])
	       cylinder(r = .8, h=100, $fn=20, center = true);

}