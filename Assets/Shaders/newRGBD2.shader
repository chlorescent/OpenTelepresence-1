Shader "Unlit/RGBD2"
{
	Properties
	{
		// we have removed support for texture tiling/offset,
		// so make them not be displayed in material inspector
		[NoScaleOffset] _MainTex("Texture", 2D) = "white" {}
	}
		SubShader
	{
		Pass
	{
		CGPROGRAM
		// use "vert" function as the vertex shader
#pragma vertex vert
		// use "frag" function as the pixel (fragment) shader
#pragma fragment frag

		// vertex shader inputs
	struct appdata
	{
		float4 vertex : POSITION; // vertex position
		float2 uv : TEXCOORD0; // texture coordinate
	};

	// vertex shader outputs ("vertex to fragment")
	struct v2f
	{
		float2 uv : TEXCOORD0; // texture coordinate
		float4 vertex : SV_POSITION; // clip space position
	};

	float depth(float4 color) 
	{
		float range = 7600.0;
		float z = 0.0;
		float r = color.r;
		float g = color.g;
		float b = color.b;

		float d = range / 3.0; // distance jump between r g and b
		if (r > 0.0) {
			z = (r*d);
			//z = range*(3.004 - (r + 2.0) )/3.0;
		}
		else if (g > 0.0) {
			z = (d)+(g*d);
			//z = range*(3.004 - (g + 1.0)) / 3.0;
		}
		else {
			z = (d*2.0) + (b*d);
			//z = range*(b) / 3.0;
			//z = 2*d + b*d

		}

		return z / d *10;
	}
	// texture we will sample
	sampler2D _MainTex;

	// vertex shader
	v2f vert(appdata v)
	{
		v2f o;
		// transform position to clip space
		// (multiply with model*view*projection matrix)
		float SCALE = 1.0;
		o.uv = v.uv;
		o.uv.y *= 0.5;
		o.uv.y += 0.5;

		float4 color = tex2Dlod(_MainTex, float4(o.uv.xy,0,0));

		float z_offset = depth(color);
		float4 pos = float4(v.vertex.x, v.vertex.y, v.vertex.z + z_offset, SCALE);
		o.vertex = mul(UNITY_MATRIX_MVP, pos);
		o.uv.y -= 0.5;
		// just pass the texture coordinate
		
		return o;
	}

	// pixel shader; returns low precision ("fixed4" type)
	// color ("SV_Target" semantic)
	fixed4 frag(v2f i) : SV_Target
	{
		// sample texture and return it
		fixed4 col = tex2D(_MainTex, i.uv);
	return col;
	}
		ENDCG
	}
	}
}
