include <at_global.scad>;
use<MCAD/involute_gears.scad>;

gears_pr = 16.667+5.833; // Pitch radius

module gears_v1(){
    union(){difference(){
        gear (number_of_teeth=20,
                circular_pitch=500,
                circles=8,
                bore_diameter=trod_d,
                hub_thickness=8);
    color("red",1)translate([0,0,3])cylinder(d=trod_nut_d,h=5.1,$fn=6);
    }

    rotate(0,[1,0,0])translate([gears_pr,0,0])gear (number_of_teeth=7,
            circular_pitch=500,
            clearance = 0.2,
            gear_thickness = 10,
            rim_thickness = 10,
            rim_width = 15,
            hub_thickness = 20,
            hub_diameter=2*12.6,
            bore_diameter=5.2,
            circles=0);          
    }
}

module gears(){
    union(){difference(){
        gear (number_of_teeth=20,
                circular_pitch=300,
                circles=0,
                bore_diameter=trod_d,
                hub_thickness=3,
                rim_width=0,
                gear_thickness=3,
                rim_thickness=3);
    color("red",1)translate([0,0,1])cylinder(d=trod_nut_d,h=5.1,$fn=6);
    }

    rotate(0,[1,0,0])translate([gears_pr,0,0])gear (number_of_teeth=7,
            circular_pitch=300,
            clearance = 0.2,
            gear_thickness = 5,
            rim_thickness = 5,
            rim_width = 15,
            hub_thickness = 12,
            hub_diameter=15,
            bore_diameter=5.1,
            circles=0);          
    }
}
/*
	number_of_teeth=15,
	circular_pitch=false, diametral_pitch=false,
	pressure_angle=28,
	clearance = 0.2,
	gear_thickness=5,
	rim_thickness=8,
	rim_width=5,
	hub_thickness=10,
	hub_diameter=15,
	bore_diameter=5,
	circles=0,
	backlash=0,
	twist=0,
	involute_facets=0,
	flat=false)
*/
module gears_centered(){
    // Nothing changes at the moment, just for consistency
    gears();
}


if (build_mode) gears();