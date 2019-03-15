using UnityEngine;
using System.Collections;

public class Engine : MonoBehaviour {
	public States state;
	public float timer;
	public Countdown countdown;
	public BgImageManager bgMan;
	public HiResScreenShots screenShotMan;
	public GameObject liveStream;
	public GameObject greenFilter;
	public GameObject bgImage;
	public GameObject finalPic;
	public GameObject outroPic;
	public GameObject idlePic;
	public GameObject crossPic;

    private float time = 0.0f;
    private float currentTime = 16; 
    private float nextActionTime = 0.0f;
    public float interpolationPeriod = 20f;


    bool cross=false;
	bool stateChanged;
	bool fadingOut;
	float startTime;
	 float sensibility;
	 float threshold;
	 Color chromaColor;

	bool showGUI;
	// Use this for initialization
	void Start () {


		bool cross=false;
		state = States.LiveStream;
		stateChanged=true;
		showGUI = false;
		sensibility = greenFilter.GetComponent<Renderer>().material.GetFloat ("_Sens");
		threshold = greenFilter.GetComponent<Renderer>().material.GetFloat("_Cutoff");
		chromaColor = greenFilter.GetComponent<Renderer>().material.GetColor("_Color");
		Debug.Log (chromaColor);
	}

	public Color GetChromaColor(){
		return greenFilter.GetComponent<Renderer>().material.GetColor("_Color");
	}

	public float GetThreshold(){
		return greenFilter.GetComponent<Renderer>().material.GetFloat("_Cutoff");
	}

	public float GetSensibility(){
		return greenFilter.GetComponent<Renderer>().material.GetFloat ("_Sens");
	}

	public void SetChromaColor(Color value){
		 chromaColor=value;
		greenFilter.GetComponent<Renderer>().material.SetColor("_Color",chromaColor);
	}
	
	public void SetThreshold(float value){
		 threshold=value;
		greenFilter.GetComponent<Renderer>().material.SetFloat("_Cutoff",threshold);

	}
	
	public void SetSensibility(float value){
		 sensibility=value;
		greenFilter.GetComponent<Renderer>().material.SetFloat ("_Sens",sensibility);
	}

    // Update is called once per frame
    void Update () {


        time += Time.deltaTime;


        

        CheckState();
		if(stateChanged)
			ChangeState();
		UpdateState ();
		if(Input.GetKeyDown(KeyCode.Space))
			showGUI=!showGUI;
		if(!showGUI && Input.GetMouseButtonUp(0))
		{
			Texture2D aux =GetScreenshot(false);
			Color cl = aux.GetPixel((int)Input.mousePosition.x,(int)Input.mousePosition.y);
			chromaColor = cl;
			Debug.Log(cl);
			UpdateParameters();
		}
		if(Input.GetKeyDown("r"))
			DoReset();
		if(Input.GetKeyDown(KeyCode.Escape)) Application.Quit();
		if(Input.GetKeyDown("z"))
		{
			cross=!cross;
			crossPic.gameObject.GetComponent<GUITexture>().enabled=cross;
		}
	}

	void DoReset(){
		greenFilter.GetComponent<Renderer>().material.SetFloat ("_Sens", 0.3f);
		sensibility = 0.3f;
		greenFilter.GetComponent<Renderer>().material.SetFloat ("_Cutoff", 0.2f);
		threshold = 0.2f;
		chromaColor = new Color (1f, 0.9813387f, 0.3235294f);
		greenFilter.GetComponent<Renderer>().material.SetColor ("_Color",chromaColor);
	}

	public void UpdateParameters(){
		greenFilter.GetComponent<Renderer>().material.SetFloat ("_Sens", sensibility);
		greenFilter.GetComponent<Renderer>().material.SetFloat ("_Cutoff", threshold);
		Debug.Log ("updating parameters!!");
		greenFilter.GetComponent<Renderer>().material.SetColor ("_Color", chromaColor);
	}

	void CheckState(){
		switch(state){
		case States.LiveStream://check for check in!
                /*
                if (time >= currentTime)
                {
                    Debug.Log(currentTime);
                    state=States.CountDown;
                    stateChanged=true;
                    time = time - currentTime;

                    // execute block of code here
                }
                */
                if (Input.GetKeyDown("x")){
				state=States.CountDown;
				stateChanged=true;
			}
                break;
		case States.CountDown:
			if(countdown.getCountdownState()){
				state=States.ShowPicture;
				stateChanged=true;


			}
			break;
		case States.ShowPicture: 
			/*if(Time.time>startTime+timer-1 && !fadingOut){
				doFadeOut(finalPic);
				fadingOut=true;
			}*/
			if(Time.time>startTime+timer){
				Debug.Log("change to live!!");
				state=States.Outro;
				stateChanged=true;
				doFadeIn(outroPic);

			}

			break;
		case States.Outro:
			if(Time.time>startTime+timer){
				state=States.LiveStream;
				stateChanged=true;
				//doFadeIn(outroPic);
			}
			if(Time.time>startTime+timer-1 && !fadingOut){
				doFadeOut(finalPic);
				doFadeOut(outroPic);
				fadingOut=true;
			}
			break;	
		}
	}

	void doFadeOut(GameObject who)
	{
		Debug.Log ("FADE OUT PIC! "+who);
		//Debug.Log(pos);
		//iTween.ScaleTo(countdownGUIS[pos].gameObject, iTween.Hash("scale", new Vector3(1, 1, 0), "time", 1));
		iTween.FadeTo(who, iTween.Hash("alpha", 0, "time", 2,"oncomplete","FadeOutDone","oncompletetarget",gameObject,"oncompleteparams",who));
	}

	void doFadeIn(GameObject who)
	{
		who.GetComponent<GUITexture>().enabled = true;
		Debug.Log ("FADE IN PIC! "+who );
		//Debug.Log(pos);
		//iTween.ScaleTo(countdownGUIS[pos].gameObject, iTween.Hash("scale", new Vector3(1, 1, 0), "time", 1));
		iTween.FadeTo(who, iTween.Hash("alpha", 1, "time", 1));
	}

	public void FadeOutDone(GameObject who){
		who.GetComponent<GUITexture>().enabled = false;
	}

	public void doScreenShot(){
		//screenShotMan.doPhoto ();
		screenShotMan.CaptureScreen ();
		finalPic.GetComponent<GUITexture>().enabled=true;
		finalPic.GetComponent<GUITexture>().texture=screenShotMan.LastCapture();
	}

	public void SavePhoto(){
		screenShotMan.ScaleThumbnail();

	}

	void ChangeState(){
		Debug.Log ("New game status: " + state.ToString ());
		switch(state){
		case States.LiveStream://change to idle
			//select new random pic
			fadingOut=false;
			countdown.resetScaleCountdownGUIs();
			bgMan.SetNewPic();
			Resources.UnloadUnusedAssets();
			idlePic.GetComponent<GUITexture>().enabled=true;
			liveStream.GetComponent<Renderer>().enabled=false;
			bgMan.SetVisible(true);//.gameObject.renderer.enabled=true;
			greenFilter.gameObject.GetComponent<Renderer>().enabled=true;
			outroPic.GetComponent<GUITexture>().enabled=false;
			break;
		case States.CountDown:
			idlePic.GetComponent<GUITexture>().enabled=false;
			bgMan.SetVisible(true);
			greenFilter.gameObject.GetComponent<Renderer>().enabled=true;
			liveStream.GetComponent<Renderer>().enabled=false;
			finalPic.GetComponent<GUITexture>().enabled=false;
			countdown.startCountdown();
			break;
		case States.ShowPicture: 
			liveStream.GetComponent<Renderer>().enabled=false;
			greenFilter.gameObject.GetComponent<Renderer>().enabled=false;
			bgMan.SetVisible(false);
			finalPic.GetComponent<GUITexture>().enabled=true;
			finalPic.GetComponent<GUITexture>().color = new Color(0.5f,0.5f,0.5f,1f);
			outroPic.GetComponent<GUITexture>().color = new Color(0.5f,0.5f,0.5f,0.0f);
			finalPic.GetComponent<GUITexture>().texture = screenShotMan.LastCapture();
			outroPic.GetComponent<GUITexture>().enabled=true;
			startTime= Time.time;
			break;

		case States.Outro:
			liveStream.GetComponent<Renderer>().enabled=false;
			greenFilter.gameObject.GetComponent<Renderer>().enabled=false;
//			bgMan.gameObject.renderer.enabled=false;
			//outroPic.guiTexture.enabled=true;
			//outroPic.guiTexture.color = new Color(0.5f,0.5f,0.5f,1f);
			fadingOut=false;
			startTime= Time.time;
			break;	
	
		}
		stateChanged = false;
	}
	
	void UpdateState(){
		switch(state){
		case States.LiveStream:

			break;
		case States.CountDown:

			break;
		case States.ShowPicture:
			break;
		case States.Outro:
			break;		
		}
	}

	void OnGUI(){
		if(showGUI){

			GUI.Label (new Rect(10, 10,250,30), "Sensibility:"+sensibility);
			sensibility = GUI.HorizontalSlider (new Rect(10, 50,500,30),sensibility,0,0.9f);
			GUI.Label (new Rect(10, 100,250,30), "Cut off:"+threshold);
			threshold = GUI.HorizontalSlider (new Rect(10, 140,500,30),threshold,0,0.9f);

			GUI.Label (new Rect(10, 200,250,30), "R:"+chromaColor.r);
			chromaColor.r = GUI.HorizontalSlider (new Rect(10, 240,500,30),chromaColor.r,0,1f);
			GUI.Label (new Rect(10, 300,250,30), "G:"+chromaColor.g);
			chromaColor.g = GUI.HorizontalSlider (new Rect(10, 340,500,30),chromaColor.g,0,1f);
			GUI.Label (new Rect(10, 400,250,30), "B:"+chromaColor.b);
			chromaColor.b = GUI.HorizontalSlider (new Rect(10, 440,500,30),chromaColor.b,0,1f);
			GUI.Label (new Rect(10, 500,250,30), "timer:"+timer);
			timer= GUI.HorizontalSlider (new Rect(10, 540,500,30),timer,0,10f);
			UpdateParameters();
		}
		 
	}

    Texture2D GetScreenshot( bool argb32 )
    {
		Rect viewRect = Camera.main.pixelRect;
        Texture2D tex = new Texture2D( (int)viewRect.width, (int)viewRect.height, ( argb32 ? TextureFormat.ARGB32 : TextureFormat.RGB24 ), false );	
		RenderTexture rt = new RenderTexture((int)viewRect.width, (int)viewRect.height, 24);
		Camera.main.targetTexture = rt;
		tex = new Texture2D((int)viewRect.width, (int)viewRect.height, TextureFormat.RGB24, false);
		//thumb	= new Texture2D(resWidth, resHeight, TextureFormat.RGB24, false);
		Camera.main.Render();
		RenderTexture.active = rt;
		tex.ReadPixels(new Rect(0, 0, (int)viewRect.width, (int)viewRect.height), 0, 0);
		
		Camera.main.targetTexture = null;
		RenderTexture.active = null; // JC: added to avoid errors
		
		
		
		Destroy(rt);

			return tex;
	}
	

	public enum States{
		LiveStream,
		CountDown,
		ShowPicture,
		Outro
	}
}
