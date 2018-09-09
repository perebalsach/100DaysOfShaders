Shader "100DaysOfShaders/Diamond" 
{
    Properties 
    {
        _Color("Color", Color) = (1,1,1,1)
        _TopFacesColor("Top Faces Color", Color) = (1, 1, 1, 1)
        _TopFacesIntensity("Top Light Intensity", Range(0, 1)) = 1
        [Header(Reflection Options)]
        _ReflectionIntensity("Reflection Intensity", Range(0, 1)) = 1
        _ReflectionTex("Reflection Texture", Cube) = "gray" {}
    }
    SubShader 
    {
        Blend SrcAlpha OneMinusSrcAlpha
        Tags{"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
        Pass 
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            fixed4 _Color;
            samplerCUBE _ReflectionTex;
            float _TopFacesIntensity;
            float _ReflectionIntensity;
            float4 _TopFacesColor;

            struct vertexInput

            {
                float4 vertex   :POSITION;
                float3 texcoord :TEXCOORD0;
                float3 normal   :NORMAL;
            };

            struct vertexOutput
            {
                float4 pos      :SV_POSITION;
                float3 texcoord :TEXCOORD0;
                float4 worldPos :TEXCOORD1;
                float3 normal   :NORMAL;
            };

            vertexOutput vert(vertexInput v)
            {
                vertexOutput o;
                UNITY_INITIALIZE_OUTPUT(vertexOutput, o);
                
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);

                // Calculate world space reflection vector
                float3 viewDir = WorldSpaceViewDir(v.vertex);
                float3 worldN = UnityObjectToWorldNormal(v.normal);
                o.texcoord = reflect(-viewDir, worldN);

                o.pos = UnityObjectToClipPos(v.vertex);

                o.normal = UnityObjectToWorldDir(v.normal);

                return o;
            }

            half4 frag(vertexOutput i):SV_TARGET
            {
                float4 refCol = texCUBE(_ReflectionTex, i.texcoord);
                float4 col = texCUBE(_ReflectionTex, i.texcoord) * _Color + refCol * _ReflectionIntensity;

				float faceY = dot(i.normal, float3(0, 1, 0));
                half3 topFacesColor = half3(faceY, faceY, faceY) * _TopFacesColor;

                topFacesColor = clamp(topFacesColor, 0.0, _TopFacesIntensity);
                topFacesColor += col;

                return half4(topFacesColor, 1.0);
            }
            ENDCG
        }
    }
    Fallback "Diffuse"
}
