Shader "100DaysOfShaders/02_UnlitBlendTexturesVertexColors"
{
    Properties
    {
        _Color("Tint Color", Color) = (0.0, 0.0, 0.0, 1.0)
        _BaseTex("Texture 1", 2D) = "white" {}
        _BlendTex("Texture 2", 2D) = "white" {}
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
                float2 uv2 : TEXCOORD1;
                float4 vertexColor: COLOR;
            };

            struct vertexOutput
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float2 uv2 : TEXCOORD1;
                float4 vertexColor: COLOR;
            };

            float4 _Color;
            sampler2D _BaseTex;
            float4 _BaseTex_ST;
            sampler2D _BlendTex;
            float4 _BlendTex_ST;

            vertexOutput vert (vertexInput v)
            {
                vertexOutput o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                
                //Repeat Textures
                o.uv = TRANSFORM_TEX (v.uv, _BaseTex); 
                o.uv2 = TRANSFORM_TEX (v.uv2, _BlendTex);

                o.vertexColor = v.vertexColor;
                return o;
            }
            
            fixed4 frag (vertexOutput i) : SV_Target
            {
                fixed4 baseTexture = tex2D(_BaseTex, i.uv);
                fixed4 blendTexture = tex2D(_BlendTex, i.uv2);

            #if DEBUGVC_ON
                return i.vertexColor;
            #else
                // Blend textures based on the vertex color data
                return lerp(baseTexture, blendTexture, i.vertexColor);
            #endif
            }
            ENDCG
        }
    }
}
