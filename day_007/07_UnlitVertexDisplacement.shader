Shader "100Days/07_UnlitVertexDisplacement"
{
    Properties
    {
        _Color("Tint Color", Color) = (0.0, 0.0, 0.0, 1.0)
        _BaseTex("Base Texture", 2D) = "white" {}
        [Header(Displacement)]
        _DispAmount("Height", Range(0, 0.10)) = 0
        _DispTex("Displace Texture", 2D) = "white" {}
        _DispTextureStarts("Texture Intentsity", Range(0, 100)) = 0
        _HeightStarts("Start", Range(-0.1, 0.1)) = 0
        _DispTopTexture("Top Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "Queue"="Transparent" "RenderType"="Transparent" "IgnoreProjector"="True" }
        Blend SrcAlpha OneMinusSrcAlpha
        ZWrite On
        
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct vertexInput
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float4 vertexColor: COLOR;
                float2 uv2 : TEXCOORD2;
                float4 dispUV: TEXCOORD1;
                float4 normal: NORMAL;
            };

            struct vertexOutput
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float2 uv2 : TEXCOORD3;
                float4 vertexColor: COLOR;
                float4 dispUV: TEXCOORD1;
                float3 worldPos: TEXCOORD2;
            };

            float4 _Color;
            sampler2D _BaseTex;
            float4 _BaseTex_ST;
            sampler2D _DispTex;
            float4 _DispTex_ST;
            float _DispAmount;
            sampler2D _DispTopTexture;
            float4 _DispTopTexture_ST;
            float _DispTextureStarts;
            float _HeightStarts;

            vertexOutput vert (vertexInput v)
            {
                vertexOutput o;
                v.vertex.xyz += clamp((_DispAmount * v.normal) * tex2Dlod(_DispTex, v.dispUV), 0.0, 1.0);
                o.worldPos = v.vertex; 
                o.vertex = UnityObjectToClipPos(v.vertex);
                //Repeat Textures
                o.uv = TRANSFORM_TEX(v.uv, _BaseTex); 
                o.uv2 = TRANSFORM_TEX(v.uv2, _DispTopTexture); 
                o.vertexColor = v.vertexColor;
                return o;
            }
            
            fixed4 frag (vertexOutput i) : SV_Target
            {
                fixed4 col = tex2D(_BaseTex, i.uv);
                fixed4 topCol = tex2D(_DispTopTexture, i.uv2);
                float height = clamp((i.worldPos.y + _HeightStarts)* _DispTextureStarts, 0.0, 1.0);

                col = lerp(col, topCol, height); 
                return col * _Color;
            }
            ENDCG
        }
    }
}
