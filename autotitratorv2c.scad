// Autotitrator version 2


include <at_globalv2.scad>;

include <at_carriagev2.scad>;
include <at_idlerv2.scad>;
include <at_motor_assemblyv2.scad>;
build_mode = false;

translate([-10,0,0]+trodPosition)
rotate(90,[0,1,0])
cylinder(d=trod[boltDiameter],h=140,$fn=20);

for(i = [-1,1] ) {
    translate(trodPosition+vp([1,i,1],
        rodDisplacement))
    rotate(90,[0,1,0])
    cylinder(d=srod[boltDiameter],h=140,$fn=20);
}


motorAssembly();
color("red",0.4)
translate([40,0,0])rotate(180,[0,0,1])carriage();
color("red",0.4)
translate([130,0,0])rotate(180,[0,0,1])idler();


