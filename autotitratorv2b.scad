// Open hardware DIY 3D printed autotitrator
// Version 2b
/* Revisions
Version 1a - basic proof of concept prototype.  Testing
the idea of a idler/carriage/motor assembly
Version 2a - 1st version to be able to push an empty
syringe.  Issues with support clamps breaking, small
diameter openening for syringe, loose threaded rod nut
trap in carriage and misplaced motor holes.
Version 2b - Redesigned support clamps, added linear 
bearings to the carriage.
*/

// Be sure to set build = false in at_global.scad

include <at_global.scad>;
include <at_carriage.scad>;
include <at_idler.scad>;
include <at_motor_assembly.scad>;
include <at_gears.scad>;

// part positions
idler_pos = [130,0,0];
carriage_pos = [50,0,0];
motor_pos = [0,0,0];
gears_pos = [-15,0,0];

// Make it pretty
stainless = [0.45, 0.43, 0.5];
printed = "red";
fasteners = [0.85, 0.7, 0.45];



// Put intersection() in front of the brace below to check for overlaps.
{
/* 3D PRINTED */
color(printed){
    translate(idler_pos)
    rotate(180,[0,0,1])
    idler_centered();
    translate(carriage_pos)carriage_centered();
    translate(motor_pos)motor_centered();
    translate(gears_pos)
    rotate(180,[1,0,0])
    rotate(90,[0,1,0])
    gears_centered();
}

/* HARDWARE */

// Support rods
color(stainless)
for (loop=[-1,1]){
    translate([0,loop*rod_disp_y,rod_disp_z])
    rotate(90,[0,1,0])
    cylinder(d=rod_d-0.1,h=140,$fn=100);
}

// Threaded rod
color(stainless)
translate([-23,0,0])
rotate(90,[0,1,0])
threaded_rod(155,trod_d-1,20);

// Fasteners
color(fasteners){
    // Motor fasteners
    translate(motor_pos+[motor_x+0.5*rod_clamp_x-2.5,rod_disp_y+7,rod_disp_z+2]){
        nut(nut_d,bolt_d,nut_t);
        translate([0,0,-6.5])
        rotate(180,[0,1,0])
        bolt(bolt_d-.2,15,5);
    }
    translate(motor_pos+[motor_x+0.5*rod_clamp_x-2.5,-rod_disp_y-7,rod_disp_z+2]){
        nut(nut_d,bolt_d,nut_t); 
        translate([0,0,-6.5])
        rotate(180,[0,1,0])
        bolt(bolt_d,15,5);
    }
    

    // Idler fasteners
    translate(idler_pos+[-idler_x-0.5*rod_clamp_x+2.5,rod_disp_y+7,rod_disp_z+2]){
        nut(nut_d,bolt_d,nut_t);       
        translate([0,0,-6.5])
        rotate(180,[0,1,0])
        bolt(bolt_d-.2,15,5);
    }
    translate(idler_pos+[-idler_x-0.5*rod_clamp_x+2.5,-rod_disp_y-7,rod_disp_z+2]){
        nut(nut_d,bolt_d,nut_t);
        translate([0,0,-6.5])
        rotate(180,[0,1,0])
        bolt(bolt_d-.2,15,5);
    }        
    // Carriage fasteners
    translate(carriage_pos-[2.5,0,0])
    rotate(90,[0,1,0])
    rotate(30,[0,0,1])
    nut(trod_nut_d,trod_d,trod_nut_t);
    // Threaded rod
    for (loop=[1/2*motor_x+0.5,1/2*motor_x++trod_nut_t+0.8]){
        translate([loop,0,0])
        rotate(90,[0,1,0])
        nut(trod_nut_d,trod_d,trod_nut_t);
    }
    
    // Gear fasteners
    translate(gears_pos+[2,0,0])
    rotate(90,[0,1,0])
    rotate(30,[0,0,1])
    nut(trod_nut_d,trod_d,trod_nut_t);
}

}

/* HARDWARE MODULES */
// Will eventually be its own file

module threaded_rod(length, diameter, pitch)  {
	linear_extrude(height = length,  convexity = 10, twist = -360 * length / (diameter/pitch) )
		translate([diameter * 0.1 / 2, 0, 0])
			circle(r = diameter * 0.9 / 2);
} 

module nut(size,diameter,thickness){
    difference(){
        cylinder(d=size,h=thickness,$fn=6);
        translate([0,0,-0.01])cylinder(d=diameter,h=thickness+0.02,$fn=100);
    }
}

module bolt(diameter,length,cap){
    translate([0,0,-length])
    threaded_rod(length,diameter,20);
    difference(){
        translate([0,0,-0.5*cap])
        sphere(cap);
        translate([-cap,-cap,-2*cap])
        cube([2*cap,2*cap,2*cap]);
    }
}



