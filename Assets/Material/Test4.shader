// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Unlit/Test4"
{
    Properties{
        // マテリアルの法線マップテクスチャ
        // デフォルトはダミーの "flat surface" 法線マップ
        _BumpMap("Normal Map", 2D) = "bump" {}
    }

    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct v2f {
                float3 worldPos : TEXCOORD0;
                // これらの 3 つのベクトルは 3x3 回転行列を格納します
                //それは接線からワールド空間に変換します
                half3 tspace0 : TEXCOORD1; // tangent.x, bitangent.x, normal.x
                half3 tspace1 : TEXCOORD2; // tangent.y, bitangent.y, normal.y
                half3 tspace2 : TEXCOORD3; // tangent.z, bitangent.z, normal.z
                // 法線マップのテクスチャ座標
                float2 uv : TEXCOORD4;
                float4 pos : SV_POSITION;
            };

            // こんどは、頂点シェーダーも頂点ごとの接線ベクトルを必要とします。
            //Unity では、接線は .w 成分を持つ  4D ベクトルで
            // bitangent ベクトルの方向を示すのに使用されます。
            // テクスチャ座標も必要です。
            v2f vert(float4 vertex : POSITION, float3 normal : NORMAL, float4 tangent : TANGENT, float2 uv : TEXCOORD0)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(vertex);
                o.worldPos = mul(unity_ObjectToWorld, vertex).xyz;
                half3 wNormal = UnityObjectToWorldNormal(normal);
                half3 wTangent = UnityObjectToWorldDir(tangent.xyz);
                // 法線と接線を合わせたものから bitangent を計算します
                half tangentSign = tangent.w * unity_WorldTransformParams.w;
                half3 wBitangent = cross(wNormal, wTangent) * tangentSign;
                // 接線空間マトリクス行列を出力します
                o.tspace0 = half3(wTangent.x, wBitangent.x, wNormal.x);
                o.tspace1 = half3(wTangent.y, wBitangent.y, wNormal.y);
                o.tspace2 = half3(wTangent.z, wBitangent.z, wNormal.z);
                o.uv = uv;
                return o;
            }

            // シェーダープロパティの法線マップテクスチャ
            sampler2D _BumpMap;

            fixed4 frag(v2f i) : SV_Target
            {
                // 法線マップをサンプリングして Unity エンコーディングからデコードします 
                half3 tnormal = UnpackNormal(tex2D(_BumpMap, i.uv));
                // 法線を接線からワールド空間に変換します
                half3 worldNormal;
                worldNormal.x = dot(i.tspace0, tnormal);
                worldNormal.y = dot(i.tspace1, tnormal);
                worldNormal.z = dot(i.tspace2, tnormal);

                // 残りは前のシェーダーと同じ
                half3 worldViewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
                half3 worldRefl = reflect(-worldViewDir, worldNormal);
                half4 skyData = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, worldRefl);
                half3 skyColor = DecodeHDR(skyData, unity_SpecCube0_HDR);
                fixed4 c = 0;
                c.rgb = skyColor;
                return c;
            }
            ENDCG
        }
    }
}