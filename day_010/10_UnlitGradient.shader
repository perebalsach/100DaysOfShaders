Shader "100DaysOfShaders/10_UnlitGradient"
{
    Properties
    {
        _Color("Top Color", Color) = (0.0, 0.0, 0.0, 1.0)
        _Color2("Bottom Color", Color) = (1.0, 0.0, 0.0, 1.0)
        [KeywordEnum(U, V)] _Direction("Direction", Float) = 0
        _Offset("Gradient Offset", Range(0, 1)) = 0
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
            #pragma multi_compile _DIRECTION_U _DIRECTION_V

            struct vertexInput
            {
                float4 vertex : POSITION;
                float2 uv: TEXCOORD0;
            };

            struct vertexOutput
            {
                float4 vertex : SV_POSITION;
                float2 uv: TEXCOORD0;
            };

            float4 _Color;
            float4 _Color2;
            float _Offset;

            vertexOutput vert (vertexInput v)
            {
                vertexOutput o;

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }
            
            fixed4 frag (vertexOutput i) : SV_Target
            {
            #if _DIRECTION_U
                fixed4 col = lerp(_Color, _Color2, i.uv.x + _Offset);
            #elif _DIRECTION_V
                fixed4 col = lerp(_Color, _Color2, i.uv.y + _Offset); 
            #endif

                return col;
            }
            ENDCG
        }
    }
}
