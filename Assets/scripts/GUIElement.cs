using UnityEngine;
using System.Collections;

public class GUIElement : MonoBehaviour {
    public GameObject[] fadeElements;
    public GameObject[] fadeGuiTextureElements;
    public GameObject[] fadeGuiTextElements;
    public GameObject[] activeElements;

    public float fadeTime;

    float targetAlphaValue, startAlphaValue;
    float startTime;

    bool active;
    Color color;
    Color[] colors;
    Color[] guiTextureColors;
    Color[] guiTextColors; 

	// Use this for initialization
	void Start () {
        startAlphaValue = 0;
        targetAlphaValue = 0;
        colors = new Color[fadeElements.Length];//new Color(100f / 255f, 100f / 255f, 100f / 255f, 0);
        guiTextureColors = new Color[fadeGuiTextureElements.Length];
        guiTextColors = new Color[fadeGuiTextElements.Length];

        for (int i = 0; i < fadeElements.Length; i++) {
            fadeElements[i].SetActiveRecursively(true);
            colors[i] = fadeElements[i].GetComponent<Renderer>().material.color;
            colors[i].a = 0;
            fadeElements[i].GetComponent<Renderer>().material.color = colors[i];
        }
        //textures
        for (int i = 0; i < fadeGuiTextureElements.Length; i++)
        {
            fadeGuiTextureElements[i].SetActiveRecursively(true);
            guiTextureColors[i] = fadeGuiTextureElements[i].GetComponent<GUITexture>().color;
            guiTextureColors[i].a = 0;
            fadeGuiTextureElements[i].GetComponent<GUITexture>().color = guiTextureColors[i];
        }

        //texts
        for (int i = 0; i < fadeGuiTextElements.Length; i++)
        {
            fadeGuiTextElements[i].SetActiveRecursively(true);
            guiTextColors[i] = fadeGuiTextElements[i].GetComponent<GUIText>().material.color;
            guiTextColors[i].a = 0;
            fadeGuiTextElements[i].GetComponent<GUIText>().material.color = guiTextColors[i];
        }


        //active
        for (int i = 0; i < activeElements.Length; i++)
        {
            activeElements[i].SetActiveRecursively(true);
        }
        active = false;
	}
	
	// Update is called once per frame
	void Update () {
        if (color.a != targetAlphaValue)
        {
            if (targetAlphaValue == 0)
                color.a = Mathf.Lerp(startAlphaValue, targetAlphaValue, (Time.time - startTime) / fadeTime * 2f);
            else color.a = Mathf.Lerp(startAlphaValue, targetAlphaValue, (Time.time - startTime) / fadeTime);
            //color.a = Mathf.Lerp(startAlphaValue, targetAlphaValue, (Time.time - startTime) / fadeTime);
            
            //apply color to all fadeble elements
            for (int i = 0; i < fadeElements.Length; i++)
            {
                colors[i].a = color.a;
                fadeElements[i].GetComponent<Renderer>().material.color = colors[i];
            }

            for (int i = 0; i < guiTextureColors.Length; i++)
            {
                guiTextureColors[i].a = color.a * 0.5f;
                fadeGuiTextureElements[i].GetComponent<GUITexture>().color = guiTextureColors[i];
            }

            for (int i = 0; i < fadeGuiTextElements.Length; i++)
            {
                guiTextColors[i].a = color.a;
                fadeGuiTextElements[i].GetComponent<GUIText>().material.color = guiTextColors[i];
            }
            
        }
        //transform.renderer.material.color = color;
	}

    public void setActive(bool _s)
    {
        if (!_s)
        {
            active = false;
            startTime = Time.time;
            startAlphaValue = color.a;
            targetAlphaValue = 0;
            setObjectsState(false);
        }
        if (_s)
        {
            startAlphaValue = 0;
            targetAlphaValue = 1;
            //setNewTexture();
            startTime = Time.time;
            setObjectsState(true);
            active = true;
        }

    }

    public bool getActive() {
        return active;
    }

    public void setObjectsState(bool newState) {
        for (int i = 0; i < activeElements.Length; i++)
            activeElements[i].SetActiveRecursively(newState);
    }
}
