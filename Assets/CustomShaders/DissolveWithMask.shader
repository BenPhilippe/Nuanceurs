Shader "Test/DissolveWithMask"
{
	Properties{
		_Color("Main Color", Color) = (1, 1, 1, 1)
		_MainTex("Main Texture", 2D) = "white" {}
		_NoiseTex("Noise Texture", 2D) = "white" {}
		_MaskTex("Mask", 2D) = "white" {}
		_DissolveCutoff("Dissolve Cutoff", Range(0, 1)) = 1
		_ScrollX("Scoll Noise X", Range(-10, 10)) = 1
		_ScrollY("Scoll Noise Y", Range(-10, 10)) = 1
		_Frequency("Dissolve Frequency", Float) = 1.0
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
			sampler2D _MainTex, _NoiseTex, _MaskTex;
			float4 _NoiseTex_ST, _MaskTex_ST;
			float _DissolveCutoff, _ScrollX, _ScrollY;
			half _Frequency;

			struct appdata{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f{
				float4 position : SV_POSITION;
				float2 uv : TEXCOORD1;
				float2 uv2 : TEXCOORD2;
				float2 uv3 : TEXCOORD3;
			};

			v2f vert(appdata IN){
				v2f OUT;
				OUT.position = UnityObjectToClipPos(IN.vertex);	//Rasterisation
				OUT.uv = IN.uv;
				OUT.uv2 = TRANSFORM_TEX(IN.uv, _NoiseTex);
				OUT.uv3 = TRANSFORM_TEX(IN.uv, _MaskTex);

				return OUT;
			}

			fixed4 frag(v2f IN) : SV_TARGET{
				//Fixed
				fixed4 outColor = tex2D(_MainTex, IN.uv);
				//fixed4 noise = tex2D(_NoiseTex, IN.uv2);

				//Animated
				//fixed4 outColor = tex2D(_MainTex, fixed2((IN.uv.x + _Time.x * _ScrollX), (IN.uv.y + _Time.x * _ScrollY)));
				fixed4 noise = tex2D(_NoiseTex, fixed2((IN.uv2.x + _Time.x * _ScrollX), (IN.uv2.y + _Time.x * _ScrollY)));

				//Mask
				fixed4 mask = tex2D(_MaskTex, IN.uv3);
				noise = (noise + (1 - mask));
				
				//Positive Sine
				//half posSin = 0.5 * sin(_Frequency * _Time.x) + 0.5;
				//float animatedDissolveAmount = (1 - _DissolveCutoff) * posSin + _DissolveCutoff;

				//Check if value < 0, if so draw nothing
				//clip(noise.rgb - animatedDissolveAmount);
				clip(noise.rgb - _DissolveCutoff);

				return outColor * _Color;
			}

			ENDCG
		}
	}
    Fallback "Diffuse"
}
