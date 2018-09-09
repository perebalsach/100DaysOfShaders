Shader "100DaysOfShaders/12_UnlitDissolve"
{
    Properties
    {
        _BaseTex("Texture", 2D) = "white" {} 
        _DissolveTex("Dissolve Texture", 2D) = "white" {}
        _DissolvePerc("Dissolve Percentage", Range(0, 1)) = 0
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
                float2 uv: TEXCOORD0;
                float2 uv2: TEXCOORD1;
            };

            struct vertexOutput
            {
                float4 vertex : SV_POSITION;
                float2 uv: TEXCOORD0;
                float2 uv2: TEXCOORD1;
            };

            sampler2D _BaseTex;
            float4 _BaseTex_ST;
            sampler2D _DissolveTex;
            float4 _DisolveTex_ST;
            float _DissolvePerc;
            float _DissolveEdge;

            vertexOutput vert (vertexInput v)
            {
                vertexOutput o;

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _BaseTex); 
                o.uv2 = TRANSFORM_TEX(v.uv, _DissolveTex); 
                return o;
            }
            
            fixed4 frag (vertexOutput i) : SV_Target
            {
                fixed3 col = tex2D(_BaseTex, i.uv);
                fixed4 dissolve = tex2D(_DissolveTex, i.uv2);

                float dissolveAlpha = 1 - (step(dissolve.r, _DissolvePerc));

                return fixed4(col, dissolveAlpha);
            }
            ENDCG
        }
    }
}
