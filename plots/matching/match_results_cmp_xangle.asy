import root;
import pad_layout;
include "../fills_samples.asy";
include "mean_shifts.asy";

string topDir = "../../";

//----------------------------------------------------------------------------------------------------

InitDataSets();

string sample = "SingleMuon";

string method = "method y";

int xangles[];
string xangle_refs[];
pen xangle_pens[];
xangles.push(110); xangle_refs.push("data_alig_fill_6228_xangle_110_DS1"); xangle_pens.push(red);
xangles.push(130); xangle_refs.push("data_alig_fill_6228_xangle_130_DS1"); xangle_pens.push(blue);
xangles.push(150); xangle_refs.push("data_alig_fill_6228_xangle_150_DS1"); xangle_pens.push(heavygreen);

real xfa = 0.3;

int rp_ids[];
string rps[], rp_labels[];
real rp_shift_m[];
rp_ids.push(3); rps.push("L_2_F"); rp_labels.push("45-220-fr"); rp_shift_m.push(mean_shift_L_2_F);
rp_ids.push(2); rps.push("L_1_F"); rp_labels.push("45-210-fr"); rp_shift_m.push(mean_shift_L_1_F);
rp_ids.push(102); rps.push("R_1_F"); rp_labels.push("56-210-fr"); rp_shift_m.push(mean_shift_R_1_F);
rp_ids.push(103); rps.push("R_2_F"); rp_labels.push("56-220-fr"); rp_shift_m.push(mean_shift_R_2_F);

yTicksDef = RightTicks(0.2, 0.1);

xSizeDef = 40cm;

//----------------------------------------------------------------------------------------------------

string TickLabels(real x)
{
	if (x >=0 && x < fill_data.length)
	{
		return format("%i", fill_data[(int) x].fill);
	} else {
		return "";
	}
}

xTicksDef = LeftTicks(rotate(90)*Label(""), TickLabels, Step=1, step=0);

//----------------------------------------------------------------------------------------------------

NewPad(false, 1, 1);

AddToLegend("(" + method + ")");
AddToLegend("(" + sample + ")");

for (int xai : xangles.keys)
{
	AddToLegend(format("xangle %u", xangles[xai]), xangle_pens[xai]);
}

AttachLegend();

//----------------------------------------------------------------------------------------------------

for (int rpi : rps.keys)
{
	write(rps[rpi]);

	NewRow();

	NewPad("fill", "horizontal shift$\ung{mm}$");

	if (rp_shift_m[rpi] != 0)
	{
		real sh = rp_shift_m[rpi], unc = 0.15;
		real fill_min = -1, fill_max = fill_data.length;
		draw((fill_min, sh+unc)--(fill_max, sh+unc), black+dashed);
		draw((fill_min, sh)--(fill_max, sh), black+1pt);
		draw((fill_min, sh-unc)--(fill_max, sh-unc), black+dashed);
		draw((fill_max, sh-2*unc), invisible);
		draw((fill_max, sh+2*unc), invisible);
	}
	
	for (int fdi : fill_data.keys)
	{
		write(format("    %i", fill_data[fdi].fill));

		int fill = fill_data[fdi].fill; 
		int rp_id = rp_ids[rpi];

		for (int dsi : fill_data[fdi].datasets.keys)
		{
			string dataset = fill_data[fdi].datasets[dsi].tag;

			write("        " + dataset);
	
			mark m = mCi+3pt;
	
			for (int xai : xangles.keys)
			{
				if (fill_data[fdi].datasets[dsi].xangle != xangles[xai])
					continue;

				string f = topDir + "data/phys/" + dataset + "/" + sample + "/match.root";	
				RootObject obj = RootGetObject(f, xangle_refs[xai] + "/" + rps[rpi] + "/" + method + "/g_results", error = false);
	
				if (!obj.valid)
					continue;
	
				real ax[] = { 0. };
				real ay[] = { 0. };
				obj.vExec("GetPoint", 0, ax, ay); real bsh = ay[0];
				obj.vExec("GetPoint", 1, ax, ay); real bsh_unc = ay[0];

				if (bsh != bsh || bsh_unc != bsh_unc)
					continue;

				real x = fdi + xai * xfa / (xangles.length - 1) - xfa/2;

				bool pointValid = (fabs(bsh) > 0.01);
	
				pen p = xangle_pens[xai];
	
				if (pointValid)
				{
					draw((x, bsh), m + p);
					draw((x, bsh-bsh_unc)--(x, bsh+bsh_unc), p);
				}
			}
		}
	}

	real y_cen = rp_shift_m[rpi];
	limits((-1, y_cen-1), (fill_data.length, y_cen+1), Crop);
	//xlimits(-1, fill_data.length, Crop);

	AttachLegend("{\SetFontSizesXX " + rp_labels[rpi] + "}");
}

//----------------------------------------------------------------------------------------------------

GShipout(hSkip=5mm, vSkip=1mm);
