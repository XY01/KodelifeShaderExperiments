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

    float normSin = (sin(adjustedTime*.5) + 1) / 2; // normalized sin value
    float normCos = (cos(adjustedTime*.5) + 1) / 2; // normalized cos value

    vec2 coord = gl_FragCoord.xy; // screen coord
    vec2 screenUV = coord / resolution.x;  // UV coord using height
    float tile = 6 + (8 * normSin * .5);

    screenUV *= 1 + (tile); // tile UVs
    screenUV -= vec2(tile * .5 ); // offset to it tiles from center


    vec2 rowColIndex = floor(screenUV);
    vec2 screenUVCentered = fract(screenUV); // get fraction of tiles
    screenUVCentered = (screenUVCentered + vec2(-.5, -.5)) * 2; // UVs based around center -1 - 1


  // Rotates the UV
    float sin_factor = sin(adjustedTime);
    float cos_factor = cos(adjustedTime);
    //screenUVCentered =  screenUVCentered * mat2(cos_factor, sin_factor, -sin_factor, cos_factor);


    float stepCutoff = mix(.9, 1.2, normCos * .5);

    /// ------------- SHAPES
    float circle = length(screenUVCentered);     

    float diamond = abs(screenUVCentered.x) + abs(screenUVCentered.y);

    float square = max(abs(screenUVCentered.x), abs(screenUVCentered.y));
      
    float tri = abs(screenUVCentered.x*1.7) + screenUVCentered.y;
    tri = clamp(tri,0,1);
    float tribottomCutoff = 1-step(-stepCutoff, screenUVCentered.y); // kinda haxy triangle not a proper tringle gradient
    tri += tribottomCutoff;
    
   

    /// ------------- MIXING
   
   float mixValue = mod(adjustedTime, 3);
    //mixValue = 1;

    // Mix square to tri
    float mixedShapes = mix(circle, diamond, smoothstep(0,1,mixValue));
    mixedShapes = mix(mixedShapes, square, smoothstep(1,2,mixValue));
    mixedShapes = mix(mixedShapes, circle, smoothstep(2,3,mixValue));
   // mixedShapes = mix(mixedShapes, tri, smoothstep(3,4,mixValue));
    
    
    mixedShapes = step(mixedShapes, stepCutoff);

    fragColor = vec4(mixedShapes);
    

}

//float square = abs(screenUVCentered.x) + screenUVCentered.y; // makes cool trianle shape
