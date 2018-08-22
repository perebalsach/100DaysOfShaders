Shader "100Days/11_UnlitGradient3Colors"
{
    Properties
    {
        _ColorTop("Top Color", Color) = (0.0, 0.0, 0.0, 1.0)
        _ColorMiddle("Middle Color", Color) = (1.0, 0.0, 0.0, 1.0)
        _ColorBottom("Bottom Color", Color) = (0.0, 1.0, 0.0, 1.0)
        [Header(Gradient Options)]
        _Offset("Offset", Range(0.001, 0.999)) = 0.5
        [KeywordEnum(U, V)] _Direction("Direction", Float) = 0
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

            float4 _ColorTop;
            float4 _ColorMiddle;
            float4 _ColorBottom;
            float _Offset;
            float _Middle;

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
                fixed4 col = lerp(_ColorBottom, _ColorMiddle, i.uv.x / _Offset) * step(i.uv.x, _Offset);
                col += lerp(_ColorMiddle, _ColorTop, (i.uv.x - _Offset) / (1- _Offset)) * step(_Offset, i.uv.x);

            #elif _DIRECTION_V
                fixed4 col = lerp(_ColorBottom, _ColorMiddle, i.uv.y / _Offset) * step(i.uv.y, _Offset);
                col += lerp(_ColorMiddle, _ColorTop, (i.uv.y - _Offset) / (1- _Offset)) * step(_Offset, i.uv.y);
            #endif

                return col;
            }
            ENDCG
        }
    }
}
