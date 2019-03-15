
using UnityEngine;
using System.Collections;
using System; 
using System.Collections.Generic; 

public class HiResScreenShots : MonoBehaviour {
	public enum FileType{
		JPG,
		PNG
	};
	
	public int resWidth = 1920; 
	public int resHeight = 1080;
	public FileType outputFileType = FileType.JPG;
	public string imageNameSuffix = "";
	public string thumbnailNameSuffix = "_thumb";

	Texture2D image;
	Texture2D rotatedTexture;
	Texture2D thumbnail;

	DB server;

	void Start() {
		server = gameObject.GetComponent<DB>();
	}

	// Return the last texture that was captured
	public Texture2D LastCapture() {
		return image;
	}

	// Capture the camera's view as a Texture2D
	public void CaptureScreen() {
		RenderTexture rt = new RenderTexture(resWidth, resHeight, 24);
		GetComponent<Camera>().targetTexture = rt;
		image = new Texture2D(resWidth, resHeight,TextureFormat.RGB24, false);
		//rotatedTexture = new Texture2D(resHeight,resWidth, TextureFormat.RGB24, false);
		GetComponent<Camera>().Render();
		RenderTexture.active = rt;

		image.ReadPixels(new Rect(0, 0,resWidth, resHeight), 0, 0);

		GetComponent<Camera>().targetTexture = null;
		RenderTexture.active = null; // JC: added to avoid errors

		image.Apply();
		Destroy(rt);
	}

	// This is horrible; a method that - in just 2 lines! - does waaay
	// too many things.
	// The overly long name doesn't even explain that Bilinear() will,
	// in turn, call SaveIt() on this object!
	// In other words: Scaling a texture also implicitly writes two files
	// to disk. Wat?
	// The code paths in this thing are as twisted and impenetrable as a
	// granite octopus...
	public void ScaleThumbnail() {
		rotatedTexture = RotateTexture (image);
		thumbnail = Instantiate(rotatedTexture) as Texture2D;
		TextureScale.Bilinear(thumbnail, resHeight / 2, resWidth / 2);
	}

	// Writes the image and the thumbnail to disk and notifies the server.
	// Again, too much for one method, really.
	public void WriteImageAndThumbnailToDisk(){
		byte[] imageBytes; 
		byte[] thumbnailBytes;

		if(outputFileType == FileType.PNG) {
			imageBytes = rotatedTexture.EncodeToPNG();
			thumbnailBytes = thumbnail.EncodeToPNG();
		} else {
			imageBytes = rotatedTexture.EncodeToJPG();
			thumbnailBytes = thumbnail.EncodeToJPG();
		}

		Dictionary<string, string> paths = OutputPaths();
		Debug.Log ("saving pics");
		System.IO.File.WriteAllBytes(paths["image"], imageBytes);
		System.IO.File.WriteAllBytes(paths["thumbnail"], thumbnailBytes);

        server.POST("http://127.0.0.1:3000/new_image", paths);
    }

	// Creates (if necessary) a date-stamped directory in the app's dataPath,
	// and returns its path
	public static string OutputDirectoryPath(string date) {

		string path = string.Format("{0}/screenshots/{1}/", Application.dataPath, date);
		System.IO.Directory.CreateDirectory(path);
		return path;

		// appdata/<date>/<yyyy-MM-dd_HH-mm-ss>_image(.jpg/_thumb.jpg)
	}

	// Returns a dictionary with two keys ("image" and "thumbnail") that contain
	// the timestamped paths to be used for writing a screenshot and its thumbnail
	// to disk (and to be posted to the server)
	public Dictionary<string, string> OutputPaths() {
		Dictionary<string, string> paths = new Dictionary<string, string>();
		string date = System.DateTime.Now.ToString("yyyy-MM-dd");
		string timestamp = System.DateTime.Now.ToString("HH-mm-ss");

		string outputDirectory = OutputDirectoryPath(date);
		//string timestamp = System.DateTime.Now.ToString("yyyy-MM-dd_HH-mm-ss");

		paths.Add("image", outputDirectory +date+"_"+timestamp+ FileNameWithSuffix(imageNameSuffix));
		paths.Add("thumbnail", outputDirectory+date  + "_"+timestamp+FileNameWithSuffix(thumbnailNameSuffix));
		return paths;
	}
	
	public string FileNameWithSuffix(string suffix) {
		return suffix + (outputFileType == FileType.JPG ? ".jpg" : ".png");
	}


	Texture2D RotateTexture(Texture2D tex)
	{

		Texture2D rotImage = new Texture2D(tex.height, tex.width);

		
		for (int x = 0; x < tex.width; x++) {

			for (int y = 0; y < tex.height; y++) {
				//rotImage.SetPixel (x1, y1, Color.clear);          

				rotImage.SetPixel ( tex.height-y, x, getPixel(tex,x, y));
			}
			

			
		}
		
		rotImage.Apply();
		return rotImage;
	}
	
	private Color getPixel(Texture2D tex, float x, float y)
	{
		Color pix;
		int x1 = (int) Mathf.Floor(x);
		int y1 = (int) Mathf.Floor(y);
		
		if(x1 > tex.width || x1 < 0 ||
		   y1 > tex.height || y1 < 0) {
			pix = Color.clear;
		} else {
			pix = tex.GetPixel(x1,y1);
		}
		
		return pix;
	}
	
	private float rot_x (float angle, float x, float y) {
		float cos = Mathf.Cos(angle/180.0f*Mathf.PI);
		float sin = Mathf.Sin(angle/180.0f*Mathf.PI);
		return (x * cos + y * (-sin));
	}
	private float rot_y (float angle, float x, float y) {
		float cos = Mathf.Cos(angle/180.0f*Mathf.PI);
		float sin = Mathf.Sin(angle/180.0f*Mathf.PI);
		return (x * sin + y * cos);
	}

}	