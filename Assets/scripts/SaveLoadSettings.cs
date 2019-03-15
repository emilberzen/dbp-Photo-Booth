using UnityEngine;
using System.Collections;
using System.IO;


public class SaveLoadSettings : MonoBehaviour {
	public Engine eng;
    bool loaded = false;

	// Use this for initialization
	void Start () {
       
        if (!File.Exists("parameters.txt"))
        {
            File.Create("parameters.txt");
            saveParamaters();


        }
        loadCamParamaters();
    }

    // Update is called once per frame
    void Update()
    {
        if (!loaded) { loadCamParamaters(); loaded = true; }
        if (Input.GetKeyDown("s")) { saveParamaters(); }
        if (Input.GetKeyDown("l")) { loadCamParamaters(); }
    }

    void saveParamaters()
    {
        FileInfo f = new FileInfo("parameters.txt");
        StreamWriter outputFile;
        outputFile = f.CreateText();

        outputFile.WriteLine(eng.GetSensibility().ToString());
        outputFile.WriteLine(eng.GetThreshold().ToString());
        outputFile.WriteLine(eng.GetChromaColor().r.ToString());
        outputFile.WriteLine(eng.GetChromaColor().g.ToString());
        outputFile.WriteLine(eng.GetChromaColor().b.ToString());
        outputFile.WriteLine(eng.timer.ToString());
        outputFile.Close();

    }

    void loadCamParamaters()
    {
        StreamReader re = File.OpenText("parameters.txt");

        //READ POSITION

        //limits
        eng.SetSensibility(float.Parse(re.ReadLine(), System.Globalization.CultureInfo.InvariantCulture.NumberFormat));
        eng.SetSensibility(Mathf.Clamp(eng.GetSensibility(), 0, 1));

        eng.SetThreshold(float.Parse(re.ReadLine(), System.Globalization.CultureInfo.InvariantCulture.NumberFormat));
        eng.SetThreshold(Mathf.Clamp(eng.GetThreshold(), 0, 1));
        Color aux = new Color();
        aux.r = float.Parse(re.ReadLine(), System.Globalization.CultureInfo.InvariantCulture.NumberFormat);
        aux.r = Mathf.Clamp(aux.r, 0, 1);

        aux.g = float.Parse(re.ReadLine(), System.Globalization.CultureInfo.InvariantCulture.NumberFormat);
        aux.g = Mathf.Clamp(aux.g, 0, 1);

        aux.b = float.Parse(re.ReadLine(), System.Globalization.CultureInfo.InvariantCulture.NumberFormat);
        aux.b = Mathf.Clamp(aux.b, 0, 1);
        eng.SetChromaColor(aux);
        eng.timer = float.Parse(re.ReadLine(), System.Globalization.CultureInfo.InvariantCulture.NumberFormat);
        eng.UpdateParameters();

    }


}
