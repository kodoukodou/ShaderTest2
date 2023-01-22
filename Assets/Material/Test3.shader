Shader "Unlit/Test3"
{
    // ����̓v���p�e�B�̓u���b�N���܂���
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            //  UnityObjectToWorldNormal �w���p�[�֐����܂ރt�@�C�����܂݂܂�
            #include "UnityCG.cginc"

            struct v2f {
            // �W���� ("texcoord") ��ԂƂ��ă��[���h��Ԗ@�����o�͂��܂�
                half3 worldNormal : TEXCOORD0;
                float4 pos : SV_POSITION;
            };

            // ���_�V�F�[�_�[: ���͂Ƃ��ăI�u�W�F�N�g��Ԗ@�������܂�
            v2f vert(float4 vertex : POSITION, float3 normal : NORMAL)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(vertex);
                // UnityCG.cginc �t�@�C���́A�@�����I�u�W�F�N�g���� 
                // ���[���h��Ԃɕϊ�����֐����܂݂܂�
                o.worldNormal = UnityObjectToWorldNormal(normal);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 c = 0;
                // �@���́Axyz ���������� 3D �x�N�g�� ; �͈͂� -1..1
                // �J���[�Ƃ��ĕ\������ɂ́A�͈͂� 0..1 �ɂ��A
                // �ԁA�΁A�� �̐����ɂ��܂��B
                c.rgb = i.worldNormal * 0.5 + 0.5;
                return c;
            }
            ENDCG
        }
    }
}
