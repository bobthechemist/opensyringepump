// Autotitrator motor assembly
// rod_clamp_[x,y,z] probably belong as global variables
// They are currently declared in idler as well.

include <at_global.scad>;
include <at_gears.scad>; //Needs to know the pitch radius


//motor
motor_x = 4;
motor_y = 45;
motor_z = 68;



motor_trod_y = 0.5*motor_y;
motor_trod_z = 12; //0.2*motor_z;
motor_rod1_y = motor_trod_y - rod_disp_y;
motor_rod2_y = motor_trod_y + rod_disp_y;
motor_rod_z = motor_trod_z + rod_disp_z;
/* Deprecated
motor_body_d = 28.4; // Diameter of stepper motor
motor_body_y = 0.5*motor_y;
motor_body_z = motor_trod_z + gears_pr;
motor_body_support_d = 4;
motor_body_support_y = 35.3/2;
*/

module motor(){
    difference(){
        // Buildup
        union(){
            // Base
            cube([motor_x,motor_y,motor_z]);  
            // Structural rod supports
            translate([motor_x,motor_rod1_y,motor_rod_z])
            rod_clamp();
            translate([motor_x,motor_rod2_y,motor_rod_z])
            rod_clamp(rot=true);
            
        }
        // Remove
        union(){
            // Threaded rod 
            translate([-tol,motor_trod_y,motor_trod_z])
            rotate(90,[0,1,0])
            cylinder(d=trod_d, h=motor_x+2*tol,$fn=100);
            // Structural rod 
            for (loop = [motor_rod1_y,motor_rod2_y]){
                translate([0.5*motor_x,loop,motor_trod_z +
                    rod_disp_z])
                rotate(90,[0,1,0])
                cylinder(d=rod_d,
                    h=motor_x+rod_clamp_x+2*tol,$fn=100);
            }
            // motor 
            translate([-tol,motor_y/2,
               motor_rod_z+gears_pr])
            motor_holes(2*motor_x);
            
        }
    }
}

module motor_centered(){
    translate([-motor_x/2,-motor_trod_y,
        -motor_trod_z])
    motor();
}

// I presume this information is most likely to be 
//    changed in remixes, and therefore I'm pulling it
//    out for easy modification.  Assuming that the 
//    shaft is centered.  Designed as a remove
module motor_holes(height = motor_x){
    translate([0,0,-9])
    rotate(90,[0,1,0])
    linear_extrude(height=height)
    union(){
        circle(d=9,$fn=100);
        for (loop=[-1,1]) {
            translate([-8,loop*17.5,0])
            circle(d=4,$fn=100);
        }
    }
}

*motor_holes();


if (build_mode) motor();