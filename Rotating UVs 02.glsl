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
    float speed = 2;    // Time speed scaler
    float adjustedTime = time * speed; // Adjusted time sped up by 
    float adjustedSlowTime = time * speed * .5; // Adjusted time sped up by scaler

    float normSin = (sin(adjustedTime) + 1)/2;
    float normCos = (cos(adjustedSlowTime) + 1)/2;

    vec2 coord = gl_FragCoord.xy; // screen coord
    vec2 uv = coord / resolution.x;  // UV coord using height
    vec2 centeredUV = uv - vec2(.5,.5);
    centeredUV *= 4; // scale UVs

    // Rotates the UV
    float sin_factor = sin(adjustedTime);
    float cos_factor = cos(adjustedTime);
    vec2 rotatedUV =  centeredUV * mat2(cos_factor, sin_factor, -sin_factor, cos_factor);  

    // Mix rotated and normal UVs
    vec2 mixedUV = mix(centeredUV, rotatedUV, length(rotatedUV)*normCos);
    vec2 modUVs = vec2(mod(mixedUV.x,1), mod(mixedUV.y, 1));
 

    // Making dots
    modUVs += vec2(-.5,-.5);
    float modUVsLength = length(modUVs);
    modUVsLength = pow(1 - modUVsLength, 2 + (normSin * 1));
    modUVsLength *= 5;
    modUVsLength = floor(modUVsLength);
    
    
    //fragColor = vec4((mixedUV.x), abs(mixedUV.y), 0, 0);
    //fragColor = vec4(modUVs.x, modUVs.y, 0, 0);
    fragColor = vec4(modUVsLength, modUVsLength, modUVsLength, 0);
}



