include <MCAD/units.scad>

outer_diameter = 4 * inch;
pipe_diameter = 3 * inch;

module base() 
{

  
}

module ring()
{
	difference()
	{
		cylinder(r= outer_diameter/2, h=1*inch, center=true, $fn=20);
		cylinder(r= pipe_diameter/2, h=2*inch, center=true, $fn=20);
	}
}


ring();