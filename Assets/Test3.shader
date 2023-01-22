Shader "Unlit/Test3"
{
    // 今回はプロパティはブロックしません
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            //  UnityObjectToWorldNormal ヘルパー関数を含むファイルを含みます
            #include "UnityCG.cginc"

            struct v2f {
            // 標準の ("texcoord") 補間としてワールド空間法線を出力します
                half3 worldNormal : TEXCOORD0;
                float4 pos : SV_POSITION;
            };

            // 頂点シェーダー: 入力としてオブジェクト空間法線も取ります
            v2f vert(float4 vertex : POSITION, float3 normal : NORMAL)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(vertex);
                // UnityCG.cginc ファイルは、法線をオブジェクトから 
                // ワールド空間に変換する関数を含みます
                o.worldNormal = UnityObjectToWorldNormal(normal);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 c = 0;
                // 法線は、xyz 成分をもつ 3D ベクトル ; 範囲は -1..1
                // カラーとして表示するには、範囲を 0..1 にし、
                // 赤、緑、青 の成分にします。
                c.rgb = i.worldNormal * 0.5 + 0.5;
                return c;
            }
            ENDCG
        }
    }
}
