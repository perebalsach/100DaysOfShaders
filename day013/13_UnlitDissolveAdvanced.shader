Shader "100Days/13_UnlitDissolveAdvanced"
{
    Properties
    {
        _BaseTex("Texture", 2D) = "white" {} 
        _DissolveTex("Dissolve Texture", 2D) = "white" {}
        [Header(Dissolve Options)]
        [KeywordEnum(COLOR, TEX)] EDGE("Color or Texture", Float) = 0
        _DissolveEdgeTexture("Texture", 2D) = "white" {}
        _DissolveEdgeColor("Edge Color", Color) = (0.0, 0.0, 0.0, 1.0)
        _DissolvePerc("Percentage", Range(0, 1)) = 0
        _EdgeSize("Edge Size", Range(0.001, 0.99)) = 0.1
    }
    SubShader
    {
        Tags { "Queue"="Transparent" "RenderType"="Transparent" "IgnoreProjector"="True" }
        Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #pragma multi_compile EDGE_TEX EDGE_COLOR

            struct vertexInput
            {
                float4 vertex : POSITION;
                float2 uv: TEXCOORD0;
                float2 uv2: TEXCOORD1;
                float2 uv3: TEXCOORD2;
            };

            struct vertexOutput
            {
                float4 vertex : SV_POSITION;
                float2 uv: TEXCOORD0;
                float2 uv2: TEXCOORD1;
                float2 uv3: TEXCOORD2;
            };

            sampler2D _BaseTex;
            float4 _BaseTex_ST;
            sampler2D _DissolveTex;
            float4 _DissolveTex_ST;
            float _DissolvePerc;
            float _DissolveEdge;
            float _EdgeSize;
            float4 _DissolveEdgeColor;
            sampler2D _DissolveEdgeTexture;
            float4 _DissolveEdgeTexture_ST;

            vertexOutput vert (vertexInput v)
            {
                vertexOutput o;

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _BaseTex); 
                o.uv2 = TRANSFORM_TEX(v.uv, _DissolveTex); 
                o.uv3 = TRANSFORM_TEX(v.uv, _DissolveEdgeTexture); 
                return o;
            }
            
            fixed4 frag (vertexOutput i) : SV_Target
            {
                fixed3 col = tex2D(_BaseTex, i.uv);
                fixed4 dissolve = tex2D(_DissolveTex, i.uv2);
                fixed4 edgeTex = tex2D(_DissolveEdgeTexture, i.uv3);

                float dissolveAlpha  = 1 - (step(dissolve.r, _DissolvePerc));
                float dissolveAlpha2 = 1 - (step(dissolve.r, _DissolvePerc + _EdgeSize));

            #if EDGE_TEX
                col = lerp(edgeTex, col ,dissolveAlpha2);

            #elif EDGE_COLOR
                col = lerp(_DissolveEdgeColor ,col ,dissolveAlpha2);

            #endif
                return fixed4(col, dissolveAlpha);
            }
            ENDCG
        }
    }
}
