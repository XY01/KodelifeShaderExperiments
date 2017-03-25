#version 150

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform vec3 spectrum;
uniform sampler2D texture0;
uniform sampler2D texture1;
uniform sampler2D texture2;
uniform sampler2D texture3;
uniform sampler2D prevFrame;

in VertexData
{
    vec4 v_position;
    vec3 v_normal;
    vec2 v_texcoord;
} inData;

out vec4 fragColor;

void main(void)
{
    // ------------  VARIABLES
    const float pi = 3.1415926535;
    float speed = .5;
    float adjustedTime = time * speed;

    vec2 coord = gl_FragCoord.xy; // screen coord
    vec2 screenUV = coord / resolution.x;  // UV coord using height
    vec2 screenUVCentered = (screenUV + vec2(-.5, -.5)) * 2; // UVs based around center

    float radianValue = atan(centeredFragCoord.y, centeredFragCoord.x);

    float normSin = (sin(adjustedTime) + 1) / 2; // normalized sin value
    float normCos = (cos(adjustedTime) + 1) / 2; // normalized cos value

    float stepCutoff = .8;

    /// ------------- SHAPES
    float circle = length(screenUVCentered);     

    float diamond = abs(screenUVCentered.x) + abs(screenUVCentered.y);

    float square = max(abs(screenUVCentered.x), abs(screenUVCentered.y));
      
    float tri = abs(screenUVCentered.x*1.7) + screenUVCentered.y;
    tri = clamp(tri,0,1);
    float tribottomCutoff = 1-step(-stepCutoff, screenUVCentered.y); // kinda haxy triangle not a proper tringle gradient
    tri += tribottomCutoff;
    
   

    /// ------------- MIXING
   
    float mixValue = mod(adjustedTime + length(screenUV*.5), 3);
    // Mix square to tri
    float mixedShapes01 = mix(circle, diamond, smoothstep(0,1,mixValue));
    mixedShapes01 = mix(mixedShapes01, square, smoothstep(1,2,mixValue));
    mixedShapes01 = mix(mixedShapes01, circle, smoothstep(2,3,mixValue));

    
    mixedShapes01 = step(fract(fract(mixedShapes01+time*.25)), .1);

    fragColor = vec4(mixedShapes01);
    

}

/*
   

    // Gets the radian value at cartesian 
    //returns the angle @ of the same point with polar coordinates (r, @).
    // Not sure why you need to add the small value to x, maybe it doesn't like zeros 
    float radianValue = atan(centeredFragCoord.y, centeredFragCoord.x);
    //radianValue += centeredFragCoordNorm.x * sin(time) * 2 * length(centeredFragCoordNorm)*2;

   // radianValue += time;

    // number of segments
    float segments = 4;
    //segments = sin(time* .25) * 8 * length(centeredFragCoordNorm);

    // Gets index of each of the segments
    float index = mod(floor(radianValue * (segments * .5) / pi + 0.5), segments);
    

    // dont really understand why this is needed
    float phi_fin = index * pi / (segments/2);

    // direction from angle
    vec2 dir = vec2(cos(phi_fin), sin(phi_fin));
    
    float l = dot(dir, centeredFragCoord) - modifiedTime * resolution.y / 5;

    float freq = .1;
    float ivr = 80;
    float seg = l / ivr;
*/

