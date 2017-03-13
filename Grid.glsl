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
    float speed = 4;
    float adjustedTime = time * speed;

    vec2 coord = gl_FragCoord.xy; // screen coord
    vec2 screenUV = coord / resolution.x;  // UV coord using height

    float normSin = (sin(adjustedTime) + 1) / 2; // normalized sin value
    float normCos = (cos(adjustedTime) + 1) / 2; // normalized cos value


    float curveIn = (cos(screenUV.x * 6.283) + 1)/2;
curveIn = 0;

//grid
    float gridSize = 4;
    vec2 grid = screenUV * gridSize;
    grid = mod(grid,1);
    grid += vec2(-.5,-.5);
    grid *= 2;
    grid.x = max( abs(grid.x), abs(grid.y));
    grid.y = max( abs(grid.x), abs(grid.y));
   // grid = min(grid,vec2(.7,.4));
//grid = pow(grid, vec2(2,2));

    fragColor = vec4(curveIn + grid.x,curveIn + grid.x,curveIn + grid.y, 0);
}
