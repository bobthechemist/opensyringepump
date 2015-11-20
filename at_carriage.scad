// Autotitrator carriage

include <at_global.scad>;



//carriage variables
carriage_x = 6;
carriage_y = 40;
carriage_z = 46;


carriage_trod_y = 0.5*carriage_y;
carriage_trod_z = 8; //0.2*carriage_z;
carriage_rod1_y = carriage_trod_y - rod_disp_y;
carriage_rod2_y = carriage_trod_y + rod_disp_y;
carriage_rod_z = carriage_trod_z + rod_disp_z;

syringe_slot_y = 25.2; // Width of syringe plunger slot
syringe_slot_x = 0.25*carriage_x; // Depth of slot
syringe_slot_z = carriage_z-carriage_rod_z + rod_d; // Use as much space as possible for the slot.



module carriage(){
    difference(){
        // Build up
        union(){
            // Base
            cube([carriage_x,carriage_y,carriage_z]); 
        }
        // Remove
        union(){
            // Threaded rod nut trap 
            translate([1,carriage_trod_y,carriage_trod_z])
            rotate(90,[0,1,0])
            rotate(30,[0,0,1])
            // If using a backstop, must have hole for threaed
            //    rod.
            if(true) {
                cylinder(d=trod_nut_d, h=carriage_x+2*tol,$fn=6);
                cylinder(d=trod_d, h=carriage_x+2*tol,
                    $fn=100,center=true);
            }
            
            
            // Structural rod 
            for (loop = [carriage_rod1_y,carriage_rod2_y]){
                translate([-tol,loop,carriage_rod_z])
                rotate(90,[0,1,0])
                cylinder(r=bearing_cutout(radius=rod_d/2),
                    h=carriage_x+2*tol,$fn=100);
            
            }
            // slot for syringe plunger
            translate([carriage_x-syringe_slot_x+tol,
                0.5*(carriage_y-syringe_slot_y),
                carriage_rod_z + rod_d])
            cube([syringe_slot_x,
                syringe_slot_y,syringe_slot_z]);
        }
    }
    // Epilog - Touch-ups and additions
    // Add linear bearings
    for (loop = [carriage_rod1_y,carriage_rod2_y]){
        translate([-tol,loop,carriage_rod_z])
        rotate(90,[0,1,0])
        linear_extrude(height=2*carriage_x)
        bearing(radius=rod_d/2);
    }
    
}

module carriage_centered() {
    translate([-carriage_x/2,-carriage_trod_y,-carriage_trod_z])
    carriage();
}


if (build_mode) carriage();
