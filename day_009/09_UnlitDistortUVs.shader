Shader "100Days/09_UnlitDistortUVs"
{
    Properties
    {
        _Color("Tint Color", Color) = (0.0, 0.0, 0.0, 1.0)
        _BaseTex("Water Texture", 2D) = "white" {}
        _DistortionTex("Distorion Texture", 2D) = "white" {}
        _DistorionAmount("Distortion Amount", Range(0, 1)) = 0
        _Speed("Speed", Range(0,1)) = 0
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
                float2 uvDist: TEXCOORD1;
            };

            struct vertexOutput
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float2 uvDist: TEXCOORD1;
            };

            float4 _Color;
            sampler2D _BaseTex;
            float4 _BaseTex_ST;
            sampler2D _DistortionTex;
            float4 _DistortionTex_ST;
            float _DistorionAmount;
            float _Speed;

            vertexOutput vert (vertexInput v)
            {
                vertexOutput o;

                o.vertex = UnityObjectToClipPos(v.vertex);
                //Repeat Textures
                o.uvDist = TRANSFORM_TEX(v.uvDist, _DistortionTex);
                o.uv = TRANSFORM_TEX(v.uv, _BaseTex); 
                return o;
            }
            
            fixed4 frag (vertexOutput i) : SV_Target
            {
                fixed4 dist = tex2D(_DistortionTex, i.uvDist);
                float2 distUVs = i.uvDist;
                distUVs += ((dist.g * 0.4 + (_Time.g * _Speed)+ 0.5) * 0.5) * _DistorionAmount; 

                fixed4 col = tex2D(_BaseTex, distUVs);

                return col;
            }
            ENDCG
        }
    }
}
