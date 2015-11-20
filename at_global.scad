// Auto Titrator Global 

//Parameters and functions declared here.

//Global parameters
rod_d = 6.6; // Diameter to use for structural rod holes
trod_d = 6.5; // Diameter to use for threaded rod holes
bolt_d = 3; // Diameter to use for bolts
nut_r = 3.9; // Radius to use for nut traps not DIAMETER
nut_t = 3; // Thickness of small nut
nut_d = 2*nut_r;
trod_nut_d = 12.5;
trod_nut_d_snug = 12.4; // A tight fit for the nut trap
trod_nut_t = 5.8; // Thickness of threaded rod nut
tol = .01; // Used to make preview prettier, should set to 0 for production.

build_mode = false;  // Set to false if trying to view the entire project.

// Need threaded rod bolt size.  Using approximate at the moment.

//trod_bolt_d = 7.8;  Not sure if this is needed

rod_clamp_x = 12; // Rod clamp dimensions
rod_clamp_y = rod_d+2.5*nut_r; // Diameter of the clamp for securing rods
rod_clamp_z = rod_d+2;
// Consider rod_clamp_slot = 2; // height of slot

// Support rod positions are placed relative to the threaded rod.
rod_disp_z = 9;
rod_disp_y = 10;
/*
 When refactoring, create 'local' variables such as carriage_rod_z and carriage_rod_y, the latter can be an array for looping instead of doing the +/- 1 trick I'm using right now.
 
 Motor assembly has not been updated since I feel this refactoring should be done before I make the code more complex.
 */
 


// ** Old notes **
// Set screw hole diameter to 3
// Set 1/4" threaded rod hole diamter to 6.5
// Set 1/4" steel rod hole diameter to 6.6
// Set nut trap to circle(3.9,$fn=6).  3.8 might work for a tight fit.
//polygon([[0., 1.], [-0.866025, 0.5], [-0.866025, -0.5], [0., -1.], [0.866025, -0.5], [0.866025, 0.5]]);

/* *** VARIABLE DEFINITIONS ***
rod is for support rods
trod is for the threaded rod
the three parts are idler, carriage and motor_assembly

*/

module rod_clamp(pos = 0.3,slot=.6,rot=false){
// Rod hole will not be included initially, as doing so
// may result in alignment problems later on.
// rod_clamp will be considered a build up module    
    translate([rot==true?rod_clamp_x:0,0,0])
    rotate(rot==true?180:0,[0,0,1])
    translate([0,-0.70*rod_clamp_y,-0.5*rod_clamp_z])
    difference(){
        cube([rod_clamp_x,rod_clamp_y,rod_clamp_z]);
        union(){
            // bolt
            translate([rod_clamp_x/2, 
                pos*rod_clamp_y,-tol])
            cylinder(d=bolt_d,h=rod_clamp_z,$fn=100);
            // nut
            translate([rod_clamp_x/2, pos*rod_clamp_y,
                rod_clamp_z-nut_t])
            cylinder(d=nut_d,h=nut_t+tol,$fn=6);
            // slot
            translate([-tol,-tol,(rod_clamp_z-slot)/2])
            cube([rod_clamp_x+2*tol,0.75*rod_clamp_y,
                slot]);
            // strain release
            // 0.6*rod_clamp_y is arbitrary, 
            //   and a mix between
            //   relieving strain and having the clamp
            //   come loose from the base.
            //   Cutout thickness (0.8) seems to work OK.
            translate([rot==true?rod_clamp_x-0.8+tol:-tol,
                -tol,-tol])
            cube([0.8,0.6*rod_clamp_y,rod_clamp_z+2*tol]);
        }
    }
}

// My first attempt at a linear bearing.  This module
//    creates a perimeter of circles to minimize the 
//    surface area between plastic and rod and possibly
//    allows for holding in grease.  Radius is the 
//    size of the rod and ridge is the radius of the
//    ridge circles.  Ignore tol for the moment.
//  
// This is a build up module but will also need the rod
//    hole cut out.
module bearing(radius=rod_d/2,ridge=1.0,tol=0, debug=false){
    ro = radius+tol;
    ri = ridge;
    r = ro+ri;
    max = floor(360/acos(1-pow(ri,2)/pow(ro,2)));
    if (debug) {
        echo (max);
        echo (str("cut out ", r+ri));
    };
    
    difference(){
    circle(r+ri,$fn=100);
    circle(r,$fn=100);
    }
    for(i=[1:max]){
    translate([r*sin(i/max*360),r*cos(i/max*360),0])circle(r=ri,$fn=100);
    }
    
}
// Helper function to return the size of the cutout.  Not
//   a great solution, IMO.  Pass the same paramters as
//   you will to bearing.
function bearing_cutout(radius=rod_d/2,ridge=1.0) = 
    radius + 2*ridge;

    
