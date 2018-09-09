Shader "100DaysOfShaders/08_UnlitShore"
{
    Properties
    {
        _Color("Tint Color", Color) = (0.0, 0.0, 0.0, 1.0)
        _BaseTex("Water Texture", 2D) = "white" {}
        _ShoreTex("Shore Texture", 2D) = "white" {}
        [Header(Shore Options)]
        _ShoreSpeed("Speed", Range(0, 50)) = 0
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
                float2 uv2 : TEXCOORD2;
                float4 vertColor: COLOR;
            };

            struct vertexOutput
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float2 uv2 : TEXCOORD3;
                float4 vertColor: COLOR;
            };

            float4 _Color;
            sampler2D _BaseTex;
            float4 _BaseTex_ST;
            sampler2D _ShoreTex;
            float4 _ShoreTex_ST;
            float _ShoreSpeed;

            vertexOutput vert (vertexInput v)
            {
                vertexOutput o;

                o.vertex = UnityObjectToClipPos(v.vertex);
                // Vertex Colors
                o.vertColor = v.vertColor;
                //Repeat Textures
                o.uv = TRANSFORM_TEX(v.uv, _BaseTex); 
                o.uv2 = TRANSFORM_TEX(v.uv2, _ShoreTex); 

                return o;
            }
            
            fixed4 frag (vertexOutput i) : SV_Target
            {
                float shoreU = i.uv2.x;
                // float shoreV = (i.uv2.y + sin(_Time * _ShoreSpeed) * 0.5 + 0.5);
                float shoreV = i.uv2.y + (_Time * _ShoreSpeed) * 0.5 + 0.5;

                fixed4 texCol = tex2D(_ShoreTex, float2(shoreU, shoreV));
                fixed4 col = tex2D(_BaseTex, i.uv);

                texCol.a *= i.vertColor.r; 
                return texCol;
            }
            ENDCG
        }
    }
}
