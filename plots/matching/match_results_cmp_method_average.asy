import root;
import pad_layout;
include "../fills_samples.asy";
include "mean_shifts.asy";

string topDir = "../../";

//----------------------------------------------------------------------------------------------------

InitDataSets();

string methods[];
pen method_pens[];
methods.push("method y"); method_pens.push(blue);
//methods.push("method x"); method_pens.push(red);

string ref_template = "data_alig_fill_6228_xangle_<xangle>_DS1";

string samples[];
samples.push("DoubleEG");
samples.push("SingleMuon");
samples.push("ZeroBias");

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

for (int mi : methods.keys)
{
	pen p = method_pens[mi];
	AddToLegend(methods[mi], mCi + 3pt + p);
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
		int fill = fill_data[fdi].fill; 

		for (int mi : methods.keys)
		{
			real S1=0., Scorr=0.;

			for (int dsi : fill_data[fdi].datasets.keys)
			{
				string dataset = fill_data[fdi].datasets[dsi].tag;
				int xangle = fill_data[fdi].datasets[dsi].xangle;

				string ref_label = replace(ref_template, "<xangle>", format("%u", xangle));

				for (int smi : samples.keys)
				{
					string f = topDir + "data/phys/" + dataset + "/" + samples[smi] + "/match.root";
					RootObject obj = RootGetObject(f, ref_label + "/" + rps[rpi] + "/" + methods[mi] + "/g_results", error = false);
					if (!obj.valid)
						continue;

					real ax[] = { 0. };
					real ay[] = { 0. };
					obj.vExec("GetPoint", 0, ax, ay); real bsh = ay[0];
					obj.vExec("GetPoint", 1, ax, ay); real bsh_unc = ay[0];

					if (bsh != bsh || bsh_unc != bsh_unc)
						continue;

					if (fabs(bsh) < 0.01)
						continue;

					S1 += 1.;
					Scorr += bsh;
				}
			}
		
			if (S1 >= 1)
			{
				real x = fdi;
				real y = Scorr / S1;
				pen p = method_pens[mi];
				draw((x, y), mCi + 3pt + p);
			} 
		}
	}

	real y_cen = rp_shift_m[rpi];
	limits((-1, y_cen-1), (fill_data.length, y_cen+1), Crop);
	//xlimits(-1, fill_data.length, Crop);

	AttachLegend("{\SetFontSizesXX " + rp_labels[rpi] + "}", NW, NE);
}

//----------------------------------------------------------------------------------------------------

GShipout(hSkip=5mm, vSkip=1mm);
