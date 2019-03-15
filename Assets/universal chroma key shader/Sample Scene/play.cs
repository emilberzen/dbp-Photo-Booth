using UnityEngine;
using System.Collections;

public class play : MonoBehaviour {

	// Use this for initialization
	void Start () {
		MovieTexture mt = (MovieTexture)GetComponent<Renderer>().material.mainTexture;
		mt.loop = true;
		mt.Play();
	}
	
	// Update is called once per frame
	void Update () {
	
	}
}
