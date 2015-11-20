include <at_global.scad>;

*difference(){
    
    difference(){
        rod_clamp(pos=0.30,slot=0.6);
        translate([0,-13,-0.55*rod_clamp_z])
        cube([0.8,
            0.7*rod_clamp_y,1.1*rod_clamp_z]);
    }
    rotate(90,[0,1,0])
    cylinder(d=rod_d,h=30,$fn=100);
}
difference(){
    rod_clamp();
    rotate(90,[0,1,0])
    cylinder(d=rod_d,h=30,$fn=100);
}
translate([-3,-13,-5])cube([3,20,10]);
   

