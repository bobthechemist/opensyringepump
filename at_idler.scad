

include <at_global.scad>;
use <MCAD/2dshapes.scad>;

//idler
idler_x = 5;
idler_y = 45;
idler_z = 50;

idler_trod_y = 0.5*idler_y;
idler_trod_z = 12; //0.15*idler_z;
idler_rod1_y = idler_trod_y - rod_disp_y;
idler_rod2_y = idler_trod_y + rod_disp_y;
idler_rod_z = idler_trod_z + rod_disp_z;

syringe_hole_d = 22.4;
syringe_hole_r = 1/2 * syringe_hole_d;
syringe_lip_x = 7;
syringe_lip_t = 2;
syringe_pos_y = idler_y/2;
syringe_pos_z = 38;

module idler(){
    difference(){
        // Buildup
        union(){
            // Base
            cube([idler_x,idler_y,idler_z]);  
            translate([idler_x,idler_rod1_y,idler_rod_z])
            rod_clamp();
            translate([idler_x,idler_rod2_y,idler_rod_z])
            rod_clamp(rot=true);
            //Syringe support
            translate([idler_x, 
                syringe_pos_y,syringe_pos_z])
            rotate(90,[0,1,0])
            rotate(-90,[0,0,1])
            linear_extrude(syringe_lip_x)
            donutSlice(syringe_hole_r, syringe_hole_r +
                syringe_lip_t,0,180,$fn=100);
        }
        // Remove
        union(){
            // Threaded rod 
            //   The 0.4/0.6 can be adjusted if
            //   threaded rod needs more support.
            //   Possibly make this a variable.
            translate([0.4*idler_x,
                idler_trod_y,idler_trod_z])
            rotate(90,[0,1,0])
            cylinder(d=trod_d, h=0.6*idler_x+tol,$fn=100);
            // Structural rod 
            for (loop = [idler_rod1_y,idler_rod2_y]){
                translate([-tol,loop,idler_trod_z +
                    rod_disp_z])
                rotate(90,[0,1,0])
                cylinder(d=rod_d,
                    h=idler_x+rod_clamp_x+2*tol,$fn=100);
            }
            // Syringe hole and support
            translate([-tol,syringe_pos_y,syringe_pos_z])
            rotate(90,[0,1,0])
            cylinder(d=syringe_hole_d, h=idler_x+2*tol,
                $fn=100);
        }
    }
}

module idler_centered(){
    translate([-idler_x/2,-idler_trod_y,-idler_trod_z])
    idler();
}    
  

if (build_mode) idler();
