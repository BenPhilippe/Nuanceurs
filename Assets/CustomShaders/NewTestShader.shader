Shader "Test/NewTestShader"
{
	Properties{
		_Color("Color", Color) = (1, 1, 1, 1)
		_MainTex("Texture", 2D) = "white" {}
		_NoiseTex("Noise", 2D) = "white" {}
	}
	SubShader{

		Tags{
			"Queue" = "Transparent"
		}

		Pass{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			// Properties
			sampler2D _MainTex;
			float4 _Color;
			sampler2D _NoiseTex;

			struct appdata{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f{
				float4 position : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			v2f vert(appdata IN){
				v2f OUT;
				// vertex in local object space -> rendering camera space
				OUT.position = UnityObjectToClipPos(IN.vertex);
				OUT.uv = IN.uv;

				return OUT;
			}

			float4 frag(v2f IN) : SV_TARGET{
				float4 outColor = tex2D(_MainTex, IN.uv);
				
				// choosing what will be transparent
				//if(noise < (1.0f - gradient.r) * _GradientThreshold) col.a=1;
				//else col.a=0;

				return outColor;
			}

			ENDCG
		}
	}
    Fallback "Diffuse"
}
