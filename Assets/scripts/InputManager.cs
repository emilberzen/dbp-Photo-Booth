using UnityEngine;
using System.Collections;

public class InputManager : MonoBehaviour {

	public DanceKinectManager kinectManager;


	bool showThreshold=false;

	// Use this for initialization
	void Start () {
		setActive (0);
	}
	
	// Update is called once per frame
	void Update () {
		checkInput ();
	}

	void checkInput(){
		if (Input.GetKeyUp ("1"))
			setActive (1);
		if (Input.GetKeyUp ("0"))
			setActive (0);
		if (Input.GetKeyUp ("2"))
			setActive (2);
		if (Input.GetKeyUp ("r"))
			setActive (3);
		if (Input.GetKeyUp ("n"))
			//checkInMan.setNewGame (2, 0, 0);
		if (Input.GetKeyUp ("t"))
			showThreshold=!showThreshold;
	}

	void setActive(int id){
		switch(id){
			case 0://default view
				
				break;
			case 1://live stream view
				
				break;
			case 2://dancers view
				
				break;
			case 3:

				break;
			case 4:
				break;

		}
	}

	void OnGUI(){
		if(showThreshold)
		{
			/*GUI.Label (new Rect(10, 10,250,30), "Pos Threshold"+trackMan.GetPosThreshold());
			float aux = GUI.HorizontalSlider (new Rect(10, 50,500,30),trackMan.GetPosThreshold(),0.001f,1);
			GUI.Label (new Rect(10, 100,250,30), "Ros Threshold"+trackMan.GetRotThreshold());
			float aux2 = GUI.HorizontalSlider (new Rect(10, 140,500,30),trackMan.GetRotThreshold(),1,100);
			trackMan.SetThresholds(aux,aux2);*/
		}
		/*if(GUI.Button (new Rect (10, 240, 150, 30), "start evaluation"))
			startEva();*/
	}
}
