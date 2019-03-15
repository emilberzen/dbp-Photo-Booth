using UnityEngine;
using System.Collections;

public class YokeMouseUtils : MonoBehaviour {
    public bool showMouseCursor=false;
	// Use this for initialization
	void Start () {
        if(Application.isEditor)
        Cursor.visible=showMouseCursor;
        else Cursor.visible = false;
	}
	
	// Update is called once per frame
	void Update () {
        if (Input.GetKeyDown("c")) {
            showMouseCursor = !showMouseCursor;
            Cursor.visible = showMouseCursor;
        }
	}
}
