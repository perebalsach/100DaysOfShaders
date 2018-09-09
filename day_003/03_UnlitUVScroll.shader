Shader "100DaysOfShaders/03_UnlitUVScroll"
{
    Properties
    {
        _Color("Tint Color", Color) = (0.0, 0.0, 0.0, 1.0)
        _BaseTex("Texture 1", 2D) = "white" {}
        _BlendTex("Texture 2", 2D) = "white" {}
        [Header(Scroll Parameters)] _Speed("Speed", range(0, 10)) = 0
        _UScroll("Scroll U", Range(0,10)) = 0
        _VScroll("Scroll V", Range(0, 10)) = 0
        _OffsetSpeed("Offset Texture Speed", range(0,10)) = 0
        [Header(Debug Parameters)] [Toggle] DEBUGVC ("Vertex Colors", Float) = 0
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
            float _Speed;
            float _UScroll;
            float _VScroll;
            float _OffsetSpeed;

            vertexOutput vert (vertexInput v)
            {
                vertexOutput o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                
                //Repeat Textures
                o.uv = TRANSFORM_TEX(v.uv, _BaseTex); 
                o.uv2 = TRANSFORM_TEX(v.uv2, _BlendTex);

                o.vertexColor = v.vertexColor;
                return o;
            }
            
            fixed4 frag (vertexOutput i) : SV_Target
            {
                fixed2 scrollUV_1 = i.uv;
                fixed2 scrollUV_2 = i.uv2;

                fixed xScroll = _UScroll * _Time * (_Speed + _OffsetSpeed);
                fixed yScroll = _VScroll * _Time * (_Speed - _OffsetSpeed);

                scrollUV_1 += fixed2(xScroll, yScroll);
                scrollUV_2 += fixed2(xScroll, yScroll);

                fixed4 baseTexture = tex2D(_BaseTex, scrollUV_1);
                fixed4 blendTexture = tex2D(_BlendTex, scrollUV_2);
                

            #if DEBUGVC_ON
                return i.vertexColor;
            #else
                // Blend textures based on the vertex color data
                fixed4 col = lerp(baseTexture, blendTexture, i.vertexColor);
                return col * _Color;
            #endif
            }
            ENDCG
        }
    }
}
