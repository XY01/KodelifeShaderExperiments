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
    float speed = 1;
    float adjustedTime = time * speed;

    vec2 coord = gl_FragCoord.xy; // screen coord
    vec2 screenUV = coord / resolution.x;  // UV coord using height
    vec2 screenUVCentered = (screenUV + vec2(-.5, -.5)) * 2; // UVs based around center -1 - 1


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
   
    float mixValue = mod(adjustedTime , 4);
    // Mix square to tri
    float mixedShapes = mix(tri, diamond, smoothstep(0,1,mixValue));
    mixedShapes = mix(mixedShapes, square, smoothstep(1,2,mixValue));
    mixedShapes = mix(mixedShapes, circle, smoothstep(2,3,mixValue));
    mixedShapes = mix(mixedShapes, tri, smoothstep(3,4,mixValue));
    
    
    mixedShapes = step(mixedShapes, stepCutoff);

    fragColor = vec4(mixedShapes);
    

}

//float square = abs(screenUVCentered.x) + screenUVCentered.y; // makes cool trianle shape
