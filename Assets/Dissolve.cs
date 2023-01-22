using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Dissolve : MonoBehaviour
{
    Material m;
    [SerializeField, Range(1.0f, 5.0f)] 
    public float speed;
    float a;

    // Start is called before the first frame update
    void Start()
    {
        m = GetComponent<Renderer>().material;
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.A))
        {
            a = -1;
        }
        a += Time.deltaTime * speed;
        m.SetFloat("_Rate", a);
    }
}
