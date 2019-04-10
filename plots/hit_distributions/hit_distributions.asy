import root;
import pad_layout;

string topDir = "../../";

string rp_tags[], rp_labels[], rp_sectors[];
rp_tags.push("L_2_F"); rp_labels.push("45-220-fr (pixel)"); rp_sectors.push("sector 45");
rp_tags.push("L_1_F"); rp_labels.push("45-210-fr (strip)"); rp_sectors.push("sector 45");
rp_tags.push("R_1_F"); rp_labels.push("56-210-fr (strip)"); rp_sectors.push("sector 56");
rp_tags.push("R_2_F"); rp_labels.push("56-220-fr (pixel)"); rp_sectors.push("sector 56");

string selection = "before selection";

string datasets[] = {
//	"data/alig/fill_5685/xangle_120/DS1",

//	"data/phys/fill_6348/xangle_150/SingleMuon",
//	"data/phys/fill_6349/xangle_150/SingleMuon",
//	"data/phys/fill_6355/xangle_150/SingleMuon",
	"data/phys/fill_6356/xangle_150/SingleMuon",
};

/*
TH2_x_min = 46;
TH2_x_max = 65;
TH2_y_min = -7;
TH2_y_max = +7;
*/

//----------------------------------------------------------------------------------------------------

//NewPad(false);
//label(selection);

for (int rpi : rp_tags.keys)
{
	NewPad(false);
	label("{\SetFontSizesXX " + rp_labels[rpi] + "}");
}


for (int dsi : datasets.keys)
{
	NewRow();

	//NewPad(false);
	//label("{\SetFontSizesXX " + replace(datasets[dsi], "_", "\_") + "}");

	string f = topDir + datasets[dsi] + "/distributions.root";

	for (int rpi : rp_tags.keys)
	{
		bool pixel = (find(rp_labels[rpi], "pixel") >= 0);

		NewPad("$x\ung{mm}$", "$y\ung{mm}$", axesAbove=true);
		scale(Linear, Linear, Log);

		RootObject obj = RootGetObject(f, rp_sectors[rpi] + "/" + selection + "/" + rp_tags[rpi] + "/h2_y_vs_x");
		obj.vExec("Rebin2D", 2, 2);
		draw(obj);

		/*
		real x = 51.5;
		draw((x, 7)--(x, +20), magenta, BeginArrow);
		real x = 61.5;
		draw((x, 7)--(x, +20), cyan, BeginArrow);
		*/

		if (pixel)
			limits((40, -20), (70, +20), Crop);
		else
			limits((0, -20), (30, +20), Crop);
	}
}

GShipout(vSkip = 0mm);
