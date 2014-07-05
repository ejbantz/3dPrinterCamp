include <mcad\boxes.scad>;

length = 50;
width = 10;

motorHoleRadius = 3.75;
innerArmLength = 28.5;



difference(){
  union(){
    difference(){
      roundedBox([width,length,4],4,true); //main body
      translate([0,-(length/2 - innerArmLength/2 - motorHoleRadius/2  - (width/2-motorHoleRadius) ) ,3])
        roundedBox([4.8,28,5],2.4,true);  //slot for servo arm
      translate([0,-(length / 2 - motorHoleRadius - (width/2-motorHoleRadius)),-5])
      	cylinder(r=motorHoleRadius,h=10, $fn=30); //  Hole for servo spindle
     }

    translate([0,length / 2 - 5/2,0])
    	roundedBox([20,5,4],1.75,true); // Microswtich mount body
  }
  translate([0,length / 2 - 5/2,-1])
  	roundedBox([16,2.8,10],1.4,true);  // slot for mounting screws
}
