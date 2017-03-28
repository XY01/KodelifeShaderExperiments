#version 150
/// 
/// Following tutorial at : http://coding-experiments.blogspot.com.au/2010/07/convolution.html
///

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




vec4 get_pixel(in vec2 coords, in float dx, in float dy)
{ 
   return texture2D(prevFrame,coords + vec2(dx, dy));
}


float Convolve(in float[9] kernel, in float[9] matrix, 
               in float denom, in float offset)
{
    float res = 0.0;
    for (int i=0; i<9; i++) 
    {
        res += kernel[i]*matrix[i];
    }
    return clamp(res/denom + offset,0.0,1.0);
}


float[9] GetData(in int channel) 
{
    float dxtex = 1.0 / float(textureSize(prevFrame,0));  
    float dytex = 1.0 / float(textureSize(prevFrame,0));
    float[9] mat;
    int k = -1;
    for (int i=-1; i<2; i++)
    {   
        for(int j=-1; j<2; j++) 
        {    
            k++;    
         mat[k] = get_pixel(inData.v_texcoord,float(i)*dxtex,
                           float(j)*dytex)[channel];
        }
    }
    return mat;
}

float[9] GetMean(in float[9] matr, in float[9] matg, in float[9] matb) 
{
    float[9] mat;
    for (int i=0; i<9; i++) 
    {
        mat[i] = (matr[i]+matg[i]+matb[i])/3.;
    }
    return mat;
}

void main(void)
{
  float[9] kerEmboss = float[]  (2.,0.,0.,
                                 0., -1., 0.,
                                 0., 0., -1.);   

  float[9] kerSharpness = float[] (-1, -1, -1,
                                    -1., 9, -1,
                                    -1, -1, -1);

  float[9] kerGausBlur = float[]  (1.,2.,1.,
                                    2., 4., 2.,
                                    1., 2., 1.);

   float[9] kerEdgeDetect = float[] (-1./8.,-1./8.,-1./8.,
                                     -1./8., 1., -1./8.,
                                     -1./8., -1./8., -1./8.);



    float matr[9] = GetData(0);
    float matg[9] = GetData(1);
    float matb[9] = GetData(2);
    float mata[9] = GetMean(matr,matg,matb);

    float convolve = Convolve(kerSharpness,mata,1.,1./2.);
    // Emboss kernel
   fragColor =  mix( texture2D(prevFrame, inData.v_texcoord), vec4(convolve), .1);



}
