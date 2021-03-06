// Autotitrator carriage

include <at_globalv2.scad>;

module carriage(){
    difference(){
        // Build up
        union(){
            // Base
            translate([0,0,baseDim[z]/2])
            cube(baseDim,center=true); 
        }
        // Remove
        union(){
            // Threaded rod nut trap 
            translate([-1,trodPosition[y],trodPosition[z]])
            rotate(90,[0,1,0])
            rotate(30,[0,0,1])
            // If using a backstop, must have hole for threaed
            //    rod.
            if(true) {
                cylinder(d=trod[nutDiameter], 
                    h=baseDim[x]+2*tol,$fn=6);
                cylinder(d=trod[boltDiameter], 
                    h=baseDim[x]+2*tol,
                    $fn=100,center=true);
            }
            
            
            // Structural rod 
            for (loop = [-1,1]){
                translate([-tol,
                    loop*rodPosition[y],
                    rodPosition[z]])
                rotate(90,[0,1,0])
                cylinder(d=srod[boltDiameter],
                    h=baseDim[x]+4*tol,
                    $fn=100,center=true);
            }
            
            // Trim bottom, save plastic and avoid scraping
            translate(sa(-tol,vp([-1/2,-1/2,0],baseDim)))
            cube(sa(2*tol,vp([1.,1.,0.1],baseDim)));
            // Trim top, save plastic
            translate(sa(-tol,vp([-1/2,-1/2,0.9],baseDim)))
            cube(sa(2*tol,vp([1.,1.,0.1],baseDim)));
            
        }
    }
    // Epilog - Touch-ups and additions
    // Add linear bearings
    for (i = [-1,1]){
        translate([-tol,i*rodPosition[y],rodPosition[z]])
        rotate(90,[0,1,0])
        linear_extrude(height=2*baseDim[x])
        bearing(radius=srod[boltDiameter]/2);
    }
    
}




if (build_mode) carriage();
