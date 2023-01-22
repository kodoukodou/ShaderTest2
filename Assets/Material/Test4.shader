// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Unlit/Test4"
{
    Properties{
        // �}�e���A���̖@���}�b�v�e�N�X�`��
        // �f�t�H���g�̓_�~�[�� "flat surface" �@���}�b�v
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
                // ������ 3 �̃x�N�g���� 3x3 ��]�s����i�[���܂�
                //����͐ڐ����烏�[���h��Ԃɕϊ����܂�
                half3 tspace0 : TEXCOORD1; // tangent.x, bitangent.x, normal.x
                half3 tspace1 : TEXCOORD2; // tangent.y, bitangent.y, normal.y
                half3 tspace2 : TEXCOORD3; // tangent.z, bitangent.z, normal.z
                // �@���}�b�v�̃e�N�X�`�����W
                float2 uv : TEXCOORD4;
                float4 pos : SV_POSITION;
            };

            // ����ǂ́A���_�V�F�[�_�[�����_���Ƃ̐ڐ��x�N�g����K�v�Ƃ��܂��B
            //Unity �ł́A�ڐ��� .w ����������  4D �x�N�g����
            // bitangent �x�N�g���̕����������̂Ɏg�p����܂��B
            // �e�N�X�`�����W���K�v�ł��B
            v2f vert(float4 vertex : POSITION, float3 normal : NORMAL, float4 tangent : TANGENT, float2 uv : TEXCOORD0)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(vertex);
                o.worldPos = mul(unity_ObjectToWorld, vertex).xyz;
                half3 wNormal = UnityObjectToWorldNormal(normal);
                half3 wTangent = UnityObjectToWorldDir(tangent.xyz);
                // �@���Ɛڐ������킹�����̂��� bitangent ���v�Z���܂�
                half tangentSign = tangent.w * unity_WorldTransformParams.w;
                half3 wBitangent = cross(wNormal, wTangent) * tangentSign;
                // �ڐ���ԃ}�g���N�X�s����o�͂��܂�
                o.tspace0 = half3(wTangent.x, wBitangent.x, wNormal.x);
                o.tspace1 = half3(wTangent.y, wBitangent.y, wNormal.y);
                o.tspace2 = half3(wTangent.z, wBitangent.z, wNormal.z);
                o.uv = uv;
                return o;
            }

            // �V�F�[�_�[�v���p�e�B�̖@���}�b�v�e�N�X�`��
            sampler2D _BumpMap;

            fixed4 frag(v2f i) : SV_Target
            {
                // �@���}�b�v���T���v�����O���� Unity �G���R�[�f�B���O����f�R�[�h���܂� 
                half3 tnormal = UnpackNormal(tex2D(_BumpMap, i.uv));
                // �@����ڐ����烏�[���h��Ԃɕϊ����܂�
                half3 worldNormal;
                worldNormal.x = dot(i.tspace0, tnormal);
                worldNormal.y = dot(i.tspace1, tnormal);
                worldNormal.z = dot(i.tspace2, tnormal);

                // �c��͑O�̃V�F�[�_�[�Ɠ���
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