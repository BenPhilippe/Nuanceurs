Shader "Test/Dissolve Offset"
{
	Properties{
		_Color("Main Color", Color) = (1, 1, 1, 1)
		_MainTex("Main Texture", 2D) = "white" {}
		_NoiseTex("Noise Texture", 2D) = "white" {}
		_DissolveCutoff("Dissolve Cutoff", Range(0, 1)) = 1
		_ScrollX("Scoll Noise X", Range(-10, 10)) = 1
		_ScrollY("Scoll Noise Y", Range(-10, 10)) = 1
	}
	SubShader{

		Tags{
			"Queue" = "Transparent"
		}

		Pass{

			Cull Off

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			// Properties
			float4 _Color;
			sampler2D _MainTex;
			sampler2D _NoiseTex;
			float _DissolveCutoff, _ScrollX, _ScrollY;
			half _Frequency;

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
				OUT.position = UnityObjectToClipPos(IN.vertex);	//Rasterisation
				OUT.uv = IN.uv;

				return OUT;
			}

			float4 frag(v2f IN) : SV_TARGET{
				float4 outColor = tex2D(_MainTex, IN.uv);
				//Animated noise
				fixed4 noise = tex2D(_NoiseTex, fixed2((IN.uv.x + _Time.x * _ScrollX), (IN.uv.y + _Time.x * _ScrollY)));
				//Check if value < 0, if so draw nothing
				clip(noise.rgb - _DissolveCutoff);

				return outColor * _Color;
			}

			ENDCG
		}
	}
    Fallback "Diffuse"
}
