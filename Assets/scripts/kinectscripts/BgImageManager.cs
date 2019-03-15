using UnityEngine;
using System.Collections;
using System.IO;

public class BgImageManager : MonoBehaviour {
	public GameObject bg,fg;
	public Texture[] bgTextures;
	public Texture[] fgTextures;
	bool[] textureLoaded;
	int picId;
	bool picturesLoaded;

	public void loadPics() {
		string aux = string.Format("{0}/Backgrounds/", 
		                           Application.streamingAssetsPath) 
		                           ;

		string[] folders = System.IO.Directory.GetDirectories(@aux,"*", System.IO.SearchOption.AllDirectories);
		Debug.Log (" "+folders.Length);
		bgTextures = new Texture[folders.Length];
		fgTextures = new Texture[folders.Length];
		textureLoaded = new bool[folders.Length*2];
		for(int i =0;i<folders.Length;i++){
			string loc = "file://"+folders[i];


			StartCoroutine(LoadTexture(loc+"/bg.png",i,true));
			StartCoroutine(LoadTexture(loc+"/fg.png",i,false));
			//bgTextures[i]=(Texture)Resources.Load(loc+"/bg.png");
			//fgTextures[i]=(Texture)Resources.Load(loc+"/fg.png");
		}
	}

	public IEnumerator LoadTexture(string pictureUrl,int i, bool type) {
		WWW www = new WWW(pictureUrl);
		yield return www;
		if(www.error!=null){
			//error
			Debug.Log("error while loading texture!!"+www.error);
			textureLoaded[i]=false;
			//GameObject.Find("/Data/").SendMessage("loadingDataError");
//			GameObject.Find("/Data/").SendMessage("addEventLoaded");
		}
		else {
			//data loaded
			Debug.Log("texture loaded: "+www.texture.width+" "+www.texture.height);


			if(type){
				textureLoaded[i]=true;
				bgTextures[i] = www.texture;
			}
			else {
				textureLoaded[i+2]=true;
				fgTextures[i] = www.texture;
			}
		}
	}
	
	void Awake(){
		picturesLoaded = false;
		loadPics ();
	}
	
	// Use this for initialization
	void Start () {

	}

	void CheckIfPicturesAreLoaded() {
		bool aux=true;
		for(int i=0;i<textureLoaded.Length;i++){
			if(textureLoaded[i] == false) aux=false;
			//Debug.Log(textureLoaded[i]);
		}
		picturesLoaded = aux;
		if(picturesLoaded){
			Debug.Log ("setting new pics");
			SetNewPic();
		}
	}

	// Update is called once per frame
	void Update () {
		if(!picturesLoaded) CheckIfPicturesAreLoaded();
		if(Input.GetKeyUp("n"))
			goToNextPic();
	}

	void goToNextPic() {
		picId++;
		if(picId> bgTextures.Length-1)
			picId = 0;
		bg.GetComponent<Renderer>().material.SetTexture("_MainTex",bgTextures[picId]);
		fg.GetComponent<Renderer>().material.SetTexture("_MainTex",fgTextures[picId]);
	}

	public void SetNewPic(){

		int aux = picId;
		while(aux==picId)
			aux = (int)UnityEngine.Random.Range(0,bgTextures.Length);
		picId=aux;
		bg.GetComponent<Renderer>().material.SetTexture("_MainTex",bgTextures[picId]);
		fg.GetComponent<Renderer>().material.SetTexture("_MainTex",fgTextures[picId]);
	}

	public void SetVisible(bool status){
		bg.GetComponent<Renderer>().enabled = status;
		fg.GetComponent<Renderer>().enabled = status;
	}
}
