Shader "100Days/06_UnlitWaveFlag"
{
    Properties
    {
        _Color("Tint Color", Color) = (0.0, 0.0, 0.0, 1.0)
        _BaseTex("Texture 1", 2D) = "white" {}
        _Speed("Speed", Range(0, 10)) = 0
        _Amplitude ("Amplitude", Range(0, 0.1)) = 0.002
        _Freq("Frequency", Range(0, 100)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

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
            };

            struct vertexOutput
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float4 vertexColor: COLOR;
            };

            float4 _Color;
            sampler2D _BaseTex;
            float4 _BaseTex_ST;
            float _Speed;
            float _Amplitude;
            float _Freq;

            vertexOutput vert (vertexInput v)
            {
                vertexOutput o;
                v.vertex.x += (sin( _Time * _Freq) * _Amplitude) * v.vertexColor;
                o.vertex = UnityObjectToClipPos(v.vertex);
                //Repeat Textures
                o.uv = TRANSFORM_TEX(v.uv, _BaseTex); 
                o.vertexColor = v.vertexColor;
                return o;
            }
            
            fixed4 frag (vertexOutput i) : SV_Target
            {
                fixed4 col = tex2D(_BaseTex, i.uv);
                return col * _Color;
            }
            ENDCG
        }
    }
}
