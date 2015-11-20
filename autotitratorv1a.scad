// Set screw hole diameter to 3
// Set 1/4" threaded rod hole diamter to 6.5
// Set 1/4" steel rod hole diameter to 6.6
// Set nut trap to circle(3.9,$fn=6).  3.8 might work for a tight fit.
//polygon([[0., 1.], [-0.866025, 0.5], [-0.866025, -0.5], [0., -1.], [0.866025, -0.5], [0.866025, 0.5]]);

//Global parameters
rod_d = 6.6; // Diameter to use for structural rod holes
trod_d = 6.5; // Diameter to use for threaded rod holes
bolt_d = 3; // Diameter to use for bolts
nut_d = 3.9; // Diameter to use for nut traps
tol = .01; // Used to avoid overlapping boundaries

//idler
idler_x = 5;
idler_y = 40;
idler_z = 20;
rod_clamp_x = 5; // Rod clamp dimensions
rod_clamp_y = rod_d+8; // Diameter of the clamp for securing rods
rod_clamp_z = rod_d+2;
srod1_pos = 0.25; // Positions (relative to idler_y, of support rods
srod2_pos = 0.75; 

difference(){
    // Buildup
    union(){
        cube([idler_x,idler_y,idler_z]);  //Base
        // Structural rod supports
        *for(loop = [0.25,0.75]){
            translate([0.4*idler_x,loop*idler_y,0.7*idler_z])rotate(90,[0,1,0])cylinder(d=rod_clamp_d,h=0.6*idler_x+rod_clamp_x,$fn=100);
        }
        for(loop = [0, idler_y-rod_clamp_y]){
            translate([idler_x,loop,0.7*idler_z-0.5*rod_clamp_z])cube([rod_clamp_x,rod_clamp_y,rod_clamp_z]);
        }
    }
    // Remove
    union(){
        // Threaded rod 
        color("red",1)translate([0.4*idler_x,0.5*idler_y,0.25*idler_z])rotate(90,[0,1,0])cylinder(d=trod_d, h=0.6*idler_x+tol,$fn=100);
        // Structural rod 
        color("red",1)
        for (loop = [0.25, 0.75]){
            translate([0.4*idler_x,loop*idler_y,0.7*idler_z])rotate(90,[0,1,0])cylinder(d=rod_d,h=0.6*idler_x+rod_clamp_x+tol,$fn=100);
        }
        // Structural rod clamp
        color("red",1)
        for (loop = [0-tol,0.75*idler_y]){
            translate([idler_x-tol,loop,0.65*idler_z])cube([rod_clamp_x+2*tol,0.8*rod_clamp_y,2]);
        }
        // bolt holes in rod clamp
        color("red",1)
        for (loop = [-1,1]) {
            translate([idler_x+0.5*rod_clamp_x,0.5*idler_y+loop*(0.25*idler_y+6),0])cylinder(d=bolt_d,h=idler_z,$fn=100);
        }
        // nut clamp in rod clamp
        color("red",1)
        for (loop = [-1,1]) {
            translate([idler_x+0.5*rod_clamp_x,0.5*idler_y+loop*(0.25*idler_y+6),0.7*idler_z+0.5*rod_clamp_z-2])cylinder(d=nut_d,h=3+tol,$fn=6);
        }
    }
}