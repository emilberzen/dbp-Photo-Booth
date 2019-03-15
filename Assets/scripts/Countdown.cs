using UnityEngine;
using System.Collections;

public class Countdown : MonoBehaviour
{
    public float time=4.5f;
    float startTime;
    float now;
    float endTime;
    public string startMessage;
	public Engine engineMan;
    public HiResScreenShots screenShots;
    public GUITexture[] countdownGUIS;
//    public SoundManager sound;
    GUIText countDownGui;
    bool isActive = false;
    bool done;
    Color defaultColor;
    int lastCount = -1;

	// Use this for initialization
	void Start () {
        countDownGui = (GUIText)gameObject.GetComponent("GUIText");
        defaultColor = countdownGUIS[0].color;
        //defaultColor.a = 0;
        resetScaleCountdownGUIs();
        reset();
	}

    public void resetScaleCountdownGUIs() {
        for (int i = 0; i < countdownGUIS.Length; i++) {
            countdownGUIS[i].transform.gameObject.SetActiveRecursively(true);
            countdownGUIS[i].transform.localScale = new Vector3(0, 0, 0);
            
            countdownGUIS[i].color = defaultColor;
        }
    }

    void reset()
    {
        //countDownGui.text = "60";
        done = false;
      
    }

	// Update is called once per frame
	void Update () {
        if(isActive)
        {
            now = Time.time;
            if (now < endTime - 1 )//&& now > endTime - 4)
            {
                int aux = (int)(endTime - now);
                if (lastCount != aux)
                {
                    int aux2 = (Mathf.Clamp((3- aux), 0, 3));
                    doCountDownGUIAnim(aux2);
                    //sound.PlayCountDown();
                    lastCount = aux;
                }
            }
            else if (now < endTime && now > endTime - 0.8f)
            {
                //countDownGui.text = startMessage;
                //int aux = 3;
                if (lastCount != 3)
                {
					engineMan.doScreenShot();
					Vector3 aux = new Vector3(1,1,1);
					countdownGUIS[3].transform.localScale=aux;
					doFadeOut();
                    //sound.PlayStart();
                    lastCount = 3;
                    done = true;
                }

            }
            else if (now >= endTime)
            {
                
                //reset();
                isActive = false;
            }
        }
	}

    public bool getCountdownState() {
        return done;
    }

	void doFadeOut()
	{
		//Debug.Log(pos);
		//iTween.ScaleTo(countdownGUIS[pos].gameObject, iTween.Hash("scale", new Vector3(1, 1, 0), "time", 1));
		iTween.FadeTo(countdownGUIS[3].gameObject, iTween.Hash("alpha", 0, "time", 2,"oncomplete","FadeOutDone","oncompletetarget",gameObject));
	}

	public void FadeOutDone(){
		engineMan.SavePhoto();
        //screenShots.ScaleThumbnail();

    }

    void doCountDownGUIAnim(int pos) {
        
        if (iTween.Count(countdownGUIS[pos].gameObject) == 0)
        {
            //Debug.Log(pos);
            iTween.ScaleTo(countdownGUIS[pos].gameObject, iTween.Hash("scale", new Vector3(1, 1, 0), "time", 1));
            iTween.FadeTo(countdownGUIS[pos].gameObject, iTween.Hash("alpha", 0, "time", 1));
        }
    }

    public void startCountdown() {
        lastCount = -1;
        endTime = Time.time +time;
        //Debug.Log("end time: " +Time.time+" "+endTime);
        done = false;
        isActive = true;
    }
}
