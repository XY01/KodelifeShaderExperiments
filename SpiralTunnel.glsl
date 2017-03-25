#version 150

uniform float time;
uniform vec2 resolution;
out vec4 fragColor;

void main(void)
{
    const float pi = 3.1415926535;
    float modifiedTime = time * 8;

    // Centers the frag coord so zero is middle of the canvas
    vec2 centeredFragCoord = gl_FragCoord.xy - (resolution / 2);
    // Centers the frag coord so zero is middle of the canvas and normalizes values
    vec2 centeredFragCoordNorm = centeredFragCoord / (resolution / 2);

    // Gets the radian value at cartesian 
    //returns the angle @ of the same point with polar coordinates (r, @).
    // Not sure why you need to add the small value to x, maybe it doesn't like zeros 
    float radianValue = atan(centeredFragCoord.y, centeredFragCoord.x + 1e-6);

    // number of segments
    float segments = 6;
    // Gets index of each of the segments
    float index = mod(floor(radianValue * (segments * .5) / pi + 0.5), segments);

    
    float val = (sin(modifiedTime + radianValue + 1 / length(centeredFragCoordNorm))+1)/2;
    val *= val;
    //float phi_fin = fin * pi / 3;

/*
    float phi_fin = fin * pi / 3;

    vec2 dir = vec2(cos(phi_fin), sin(phi_fin));
    float l = dot(dir, p) - time * resolution.y / 5;

    float ivr = 20;
    float seg = l / ivr;

    float w = sin(floor(seg) * 0.2 - time) * 0.4 + 0.5;
    float c = (w / 2 - abs(fract(seg) - 0.5)) * ivr;
*/

  //  fragColor = vec4(centeredFragCoordNorm.x, centeredFragCoordNorm.y, 0, 1);  
  //  fragColor = vec4(radianValue); 
    fragColor = vec4(val); 
}
