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
    // coord -= resolution * 0.5; // screen coord with 0,0 centered
    vec2 uv = coord / resolution.y;  // UV coord using height

    float normSin = (sin(adjustedTime) + 1) / 2; // normalized sin value
    float normCos = (cos(adjustedTime) + 1) / 2; // normalized cos value


    float cellsize = 4; // size of the cells   
    vec2 rowColnormalized = floor(uv * cellsize) / cellsize; // column, row   
    vec2 rowColIndex = floor(uv * cellsize);

    vec2 normCells = mod(uv * cellsize, 1);

    vec2 distFrmCntr = abs(normCells - vec2(.5, .5)); // distance from center of the cell
    vec2 distFrmCntrNorm = abs(normCells - vec2(.5, .5)) * 2; // distance normalized
   
    //float diamond = (distFrmCntrNorm.x + distFrmCntrNorm.y) / 2;
    float dot = length(distFrmCntrNorm); //length of the distance from the center


    float rowColTimeOffset = (sin(adjustedTime + rowColIndex.x + rowColIndex.y) + 1) / 2;
    float rowOffsetSin = (sin(adjustedTime + ( rowColIndex.x * (rowColIndex.y+1))) + 1) / 2;
    float colOffsetSin = (sin(adjustedTime + rowColIndex.y) + 1) / 2;
    float colOffsetCos = (acos(adjustedTime + rowColIndex.y) + 1) / 2;


    dot = pow(dot, 4 * ( rowOffsetSin) );
    dot = floor(dot * 2);


    //fragColor = vec4(distFrmCntr.x,distFrmCntr.y, 0, 0); // dist from cell center
    fragColor = vec4(1 - dot, 1 - dot, 1 - dot, 0);
}
