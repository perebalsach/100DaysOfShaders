Shader "100Days/01_vertexColorUnlit"
{
	Properties
	{
		_Color("Tint Color", Color) = (0.0, 0.0, 0.0, 1.0)
		[Toggle] DEBUGVC ("View Vertex Colors", Float) = 0
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#pragma multi_compile DEBUGVC_OFF DEBUGVC_ON
			
			#include "UnityCG.cginc"

			struct vertexInput
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float4 vColor: COLOR;
			};

			struct vertexOutput
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
				float4 vColor: COLOR;
			};

			float4 _Color;
			
			vertexOutput vert (vertexInput v)
			{
				vertexOutput o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.vColor = v.vColor;
				return o;
			}
			
			fixed4 frag (vertexOutput i) : SV_Target
			{
				#if DEBUGVC_ON
					return i.vColor * _Color;
				#else
					return _Color;
				#endif
			}
			ENDCG
		}
	}
}
