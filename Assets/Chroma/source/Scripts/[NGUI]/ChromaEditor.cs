//#define UNITY_PRO

using UnityEngine;
using System.Collections;
using System.Xml;
using System;
using System.Collections.Generic;
using System.Xml.Serialization;
using System.IO;
using System.Text;
using System.Runtime.Serialization.Formatters.Binary;

/* 
 * ============================================
 *     Chroma Editor for Chroma Shader v2.2
 * ============================================
 */

public class ChromaEditor : MonoBehaviour {

    public KeyCode key = KeyCode.F10;
    public Renderer[] chromaOwners;
    public Camera colorPickingCamera;

    public UISprite chromaKey;
    public UISlider hueThreshold;
    public UISlider minShadeDarkness;
    public UISlider maxShadeDarkness;
    public UISlider minSaturation;
    public UISlider maxSaturation;
    public UISlider minLightness;
    public UISlider maxLightness;

    private ChromaConfig config;

    private bool visible = false;
    private bool pickingColor = false;
    private bool loaded = false;
    private bool mouseVisibility = true;
    private float savedSliderValue;

#if UNITY_PRO
    private Dictionary<PostEffectsBase, bool> cameraEffects = new Dictionary<PostEffectsBase, bool>();
#endif

    private string xmlPath;

    void Awake() {
        transform.localScale = visible ? Vector3.one : Vector3.zero;
    }

    void Start() {
        if(!colorPickingCamera) {
            colorPickingCamera = Camera.main;
        }

#if UNITY_PRO
        if (colorPickingCamera) {
            foreach (PostEffectsBase effect in colorPickingCamera.GetComponents<PostEffectsBase>()) {
                cameraEffects[effect] = effect.enabled;
            }
        }
#endif

        LoadChromaConfig();
    }

    void Update() {
        if(!loaded) {
            return;
        }

        if(Input.GetKeyUp(key)) {
            visible = !visible;
            Cursor.visible = visible ? true : mouseVisibility;
            transform.localScale = visible ? Vector3.one : Vector3.zero;

            if(!visible) {
                SaveChromaXml();
            }
        }

        if(visible) {
            UpdateChromaSettings();
        }

        if(pickingColor) {
            if(Input.GetMouseButtonDown(0)) {
                Rect viewRect = colorPickingCamera.pixelRect;
                Texture2D tex = new Texture2D((int)viewRect.width, (int)viewRect.height, TextureFormat.ARGB32, false);
                tex.ReadPixels(viewRect, 0, 0, false);
                tex.Apply(false);

                Color color = tex.GetPixel((int)Input.mousePosition.x, (int)Input.mousePosition.y);
                color.a = 1;
                chromaKey.color = color;

                pickingColor = false;
                EnableCameraEffects(true);
                hueThreshold.sliderValue = savedSliderValue;
            }
        }
    }

    private void UpdateChromaSettings() {
        if(chromaOwners.Length == 0) {
            Debug.LogWarning("There are no chroma owner objects asigned to the Chroma Editor.");
            return;
        }

        foreach(Renderer r in chromaOwners) {
            if(!r || !r.material) {
                Debug.LogWarning("There is no material attached to a shader owner.");
                continue;
            }

            r.material.SetColor("_ChromaKey", chromaKey.color);
            r.material.SetFloat("_HueThreshold", hueThreshold.sliderValue);
            r.material.SetFloat("_MinShadeDarkness", minShadeDarkness.sliderValue);
            r.material.SetFloat("_MaxShadeDarkness", maxShadeDarkness.sliderValue);
            r.material.SetFloat("_MinSaturation", minSaturation.sliderValue);
            r.material.SetFloat("_MaxSaturation", maxSaturation.sliderValue);
            r.material.SetFloat("_MinLightness", minLightness.sliderValue);
            r.material.SetFloat("_MaxLightness", maxLightness.sliderValue);
        }
    }

    void StartPickingColor() {
        if(!colorPickingCamera) {
            Debug.LogWarning("There is no camera to start the color picking.");
            return;
        }

        EnableCameraEffects(false);
        pickingColor = true;

        savedSliderValue = hueThreshold.sliderValue;
        hueThreshold.sliderValue = 0;
    }

    void OnApplicationQuit() {
        if(visible) {
            SaveChromaXml();
        }
    }

    private void EnableCameraEffects(bool enable) {
        if(!colorPickingCamera) {
            return;
        }

#if UNITY_PRO
        foreach (PostEffectsBase effect in cameraEffects.Keys) {
            effect.enabled = enable ? cameraEffects[effect] : false;
        }
#endif
    }

    #region Chroma Config Load

    private void LoadChromaConfig() {

        string configData = PlayerPrefs.GetString("ChromaConfig", "");

        if(!String.IsNullOrEmpty(configData)) {
            try {
                XmlSerializer s = new XmlSerializer(typeof(ChromaConfig));
                byte[] encodedDataAsBytes = System.Convert.FromBase64String(configData);
                config = (ChromaConfig)s.Deserialize(new StringReader(System.Text.ASCIIEncoding.ASCII.GetString(encodedDataAsBytes)));

                chromaKey.color = config.chromaKey;
                hueThreshold.sliderValue = config.hueThreshold;
                minShadeDarkness.sliderValue = config.minShadeDarkness;
                maxShadeDarkness.sliderValue = config.maxShadeDarkness;
                minSaturation.sliderValue = config.minSaturation;
                maxSaturation.sliderValue = config.maxSaturation;
                minLightness.sliderValue = config.minLightness;
                maxLightness.sliderValue = config.maxLightness;

                Debug.Log("Chroma configuration loaded.");
            } catch(Exception e) {
                Debug.LogError(e.Message);
            }
        } else {
            chromaKey.color = Color.green;
            hueThreshold.sliderValue = 0.2f;
            minShadeDarkness.sliderValue = 0;
            maxShadeDarkness.sliderValue = 1;
            minSaturation.sliderValue = 0;
            maxSaturation.sliderValue = 1;
            minLightness.sliderValue = 0;
            maxLightness.sliderValue = 1;

            Debug.Log("Chroma default configuration loaded.");
        }

        EndLoad();
    }

    private void EndLoad() {
        loaded = true;
        UpdateChromaSettings();
        mouseVisibility = Cursor.visible;
    }

    #endregion

    #region Chroma Config Save

    private void SaveChromaXml() {
        config = new ChromaConfig();

        config.chromaKey = chromaKey.color;
        config.hueThreshold = hueThreshold.sliderValue;
        config.minShadeDarkness = minShadeDarkness.sliderValue;
        config.maxShadeDarkness = maxShadeDarkness.sliderValue;
        config.minSaturation = minSaturation.sliderValue;
        config.maxSaturation = maxSaturation.sliderValue;
        config.minLightness = minLightness.sliderValue;
        config.maxLightness = maxLightness.sliderValue;

        PlayerPrefs.SetString("ChromaConfig", config.ToString());

        Debug.Log("Chroma configuration saved.");
    }

    #endregion

    [Serializable]
    public struct ChromaConfig {
        public Color chromaKey;
        public float hueThreshold;
        public float minShadeDarkness;
        public float maxShadeDarkness;
        public float minSaturation;
        public float maxSaturation;
        public float minLightness;
        public float maxLightness;

        override public string ToString() {
            XmlSerializer s = new XmlSerializer(typeof(ChromaConfig));
            StringWriter sw = new StringWriter();
            s.Serialize(sw, this);

            byte[] toEncodeAsBytes = System.Text.ASCIIEncoding.ASCII.GetBytes(sw.ToString());
            return System.Convert.ToBase64String(toEncodeAsBytes);
        }

        private string EncodeBase64(string toEncode) {
            byte[] toEncodeAsBytes = System.Text.ASCIIEncoding.ASCII.GetBytes(toEncode);
            string returnValue = System.Convert.ToBase64String(toEncodeAsBytes);
            return returnValue;
        }
    }
}
