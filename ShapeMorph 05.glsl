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

    float radianValue = atan(screenUVCentered.y, screenUVCentered.x);
    float normalizedAngle = (radianValue+pi)/(pi*2);

    float normSin = (sin(adjustedTime) + 1) / 2; // normalized sin value
    float normCos = (cos(adjustedTime) + 1) / 2; // normalized cos value

    float stepCutoff = .8;

    /// ------------- SHAPES
    float circle = length(screenUVCentered);     

    float diamond = abs(screenUVCentered.x) + abs(screenUVCentered.y);

    float square = max(abs(screenUVCentered.x), abs(screenUVCentered.y));
      
    // -----------TRI-------
    float segments = 3;
    
    normalizedAngle += .25;
    float normSegmentAngle = mod(normalizedAngle * segments, 1);
   
    float dist = sin(normSegmentAngle*pi) * circle;
    float tri = (circle) + dist;
   

    /// ------------- MIXING
   
    float mixValue = mod(adjustedTime, 3);
    // Mix square to tri
    float mixedShapes01 = mix(tri, square, smoothstep(0,1,mixValue));
    mixedShapes01 = mix(mixedShapes01, circle, smoothstep(1,2,mixValue));
    mixedShapes01 = mix(mixedShapes01, tri, smoothstep(2,3,mixValue));
   // mixedShapes01 = mix(mixedShapes01, tri, smoothstep(3,4,mixValue));

    
    mixedShapes01 = step(fract(fract(mixedShapes01 - adjustedTime )), mix(.01,.99,normSin));

    
    fragColor = vec4(mixedShapes01);
    

}


