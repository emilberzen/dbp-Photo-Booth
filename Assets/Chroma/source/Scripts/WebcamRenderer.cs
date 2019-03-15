using UnityEngine;
using System.Collections;

public class WebcamRenderer : MonoBehaviour {

    public Vector2 resolution = new Vector2(640, 480);
    public int fps = -1;
    public bool mirror = true;

    private WebCamTexture webcam;

#if UNITY_WEBPLAYER
    IEnumerator Start() {
        yield return Application.RequestUserAuthorization(UserAuthorization.WebCam);
        Init();
    }
#else
    void Start() {
        Init();
    }
#endif

    void Init() {
        //Set Plane to Screen Resolution
        float screenAspect = (float)Screen.width / (float)Screen.height;
        transform.localScale = new Vector3((mirror ? -1 : 1) * screenAspect, 1, 1);

        if(fps > 0) {
            webcam = new WebCamTexture((int)resolution.x, (int)resolution.y, fps);
        } else {
            webcam = new WebCamTexture((int)resolution.x, (int)resolution.y);
        }


        if (webcam) {
            webcam.Play();
            Debug.Log("Webcam capture started at " + webcam.width + "x" + webcam.height);

            //Set Material Properties
            GetComponent<Renderer>().material.mainTexture = webcam;

            float webcamAspect = (float)webcam.width / (float)webcam.height;

       
            if (screenAspect > webcamAspect) {
                GetComponent<Renderer>().material.mainTextureScale = new Vector2(1, webcamAspect / screenAspect);
                GetComponent<Renderer>().material.mainTextureOffset = new Vector2(0, (1f - (webcamAspect / screenAspect)) / 2f);
            } else {
                GetComponent<Renderer>().material.mainTextureScale = new Vector2(screenAspect / webcamAspect, 1);
                GetComponent<Renderer>().material.mainTextureOffset = new Vector2((1f - (screenAspect / webcamAspect)) / 2f, 0);
            }

        } else {
            Debug.LogWarning("Could not initialize a camera at " + (int)resolution.x + "x" + (int)resolution.y);
        }
    }

    void OnEnable() {
        if(webcam) {
            webcam.Play();
            GetComponent<Renderer>().material.mainTexture = webcam;
        }
    }

    void OnDisable() {
        if(webcam) {
            webcam.Stop();
        }
    }
}
