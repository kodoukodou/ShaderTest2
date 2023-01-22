Shader "Custom/Test8"
{
    Properties
    {
        _NoiseTex("Noise",2D) = "white"{}
        _Rate("DissolveRate",Range(-1,1)) = 0
        _Color("AcidColor",Color) = (1,1,1,1)              // ’Ç‰Á
        _Threshold("DissolveThreshold",Range(0,1)) = 0.5   // ’Ç‰Á
    }
    SubShader
    {
        Tags {"Queue" = "Transparent" "RenderType" = "Transparent"}
        Blend SrcAlpha OneMinusSrcAlpha  // ’Ç‰Á
        ZWrite Off  // ’Ç‰Á

        Pass
        {
            CGPROGRAM
            sampler2D _MainTex;
            sampler2D _NoiseTex;
            FLOAT _Rate;
            fixed4 _Color;         // ’Ç‰Á
            FLOAT _Threshold;      // ’Ç‰Á
            #pragma vertex vert_img
            #pragma vertex vert
            #pragma fragment frag  
            #include "UnityCG.cginc" 

            FLOAT NoiseValue(sampler2D tex, half2 uv)
            {
                fixed4 col = tex2D(tex, uv);
                return (col.r + col.g + col.b) * 0.3333;
            }

            fixed4 frag(v2f_img i) : COLOR
            {
                fixed4 col = tex2D(_MainTex, i.uv);

                FLOAT noise = NoiseValue(_NoiseTex, i.uv);
                col.rgb = lerp(col.rgb ,1 ,step(col.a ,0));
                col = lerp(col, _Color, step(noise, _Rate + _Threshold));  // ’Ç‰Á
                col.a = lerp(1, 0, step(noise, _Rate));

                return col;
            }

            ENDCG
        }
    }
}