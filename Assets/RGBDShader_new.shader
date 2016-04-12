
Shader "Custom/RGBDShader_new" {
	 Properties {
      _MainTex("Texture Image", 2D) = "white" {}
    }
	
	SubShader {
		Pass{ 
			GLSLPROGRAM
			
			//in float visibility;
			out vec2 vUv;
			uniform sampler2D _MainTex;
			uniform float _Opacity;
			uniform float _Range;
			uniform int _Mode;
			//uniform int _MaxRange;
			//uniform int _MinRange;
			//SetTexture[_MainTex]{
				//Matrix[_Matrix]
			//}
			
			
			#ifdef VERTEX // Begin vertex shader
	 
	 		// Convert RGB color to hue saturation lightness
			float rgba32( vec4 color , float _range) {
 
				float z = 0.0;
				float r = color.r;
				float g = color.g;
				float b = color.b;

				float d = _range/3.0; // distance jump between r g and b
				if (b > 0.0) {
					z = (d*2.0) + (b*d);
					//z = range*(3.004 - (r + 2.0) )/3.0;
				}
				else if (g > 0.0) {
					z = (d) + (g*d);
					//z = range*(3.004 - (g + 1.0)) / 3.0;
				}
				else {
					z = (r*d);
					//z = range*(b) / 3.0;
					//z = 2*d + b*d

				}
				if (color.w < 1.0)
					z = 0.0;

				
				return z/d;
			}

			void main() {
				// A positive float the stretches or shrinks the model along the depth axis
				float DEPTH_SCALE = 6.0;
			
				// A positive float that scales the model.
				//    I recommend leaving this value at 1.0 and scaling with the Unity inspector
				float MODEL_SCALE = 1.0;
				
				vUv = gl_MultiTexCoord0.st;
				
				// Scale the texture along the y-axis by .5
				//   (because the source image with depth data is twice as tall as the model)
				vUv.y = vUv.y * 0.5;
				
				// Translate the texture to align the depth data with the model
				//    (Removing this line will use the encoded depth data as color data)
				vUv.y += 0.5;
				// Retrieve the hue, saturation, lightness of our color data
				float z_offset = rgba32( texture2D( _MainTex, vUv ).xyzw , _Range);
				
				// Position and scale the model
				vec4 pos = vec4( gl_Vertex.x, gl_Vertex.y, DEPTH_SCALE * z_offset + gl_Vertex.z, MODEL_SCALE );

				// Translate the texture to align the color data with the model
				//    (Removing this line will use the encoded depth data as color data)
				if (_Mode == 0)
				vUv.y -= 0.5;
				
				// Correct the division by 2 which occurrs in the vertex shader
				//visibility = hsl.z * 2.0;

				gl_PointSize = 2.0;
				
				gl_Position = gl_ModelViewProjectionMatrix * pos;
				 
			}
	         
	        #endif // End vertex shader
	         
	        #ifdef FRAGMENT // Begin fragment shader

			void main() {

				vec4 color = texture2D( _MainTex, vUv );
				if (color.w == 0.0) discard;
				//color.w = _Opacity;
				//color.x = 0.2;
				//color.y = 0.4;
				//color.z = 1.0;
				
				gl_FragColor = color;
			}
	         
	        #endif 
	         
			ENDGLSL
		} 
	} 
}
