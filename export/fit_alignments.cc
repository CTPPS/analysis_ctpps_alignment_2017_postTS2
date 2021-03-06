#include "../alignment_classes.h"
#include "fills_runs.h"

#include "TGraphErrors.h"
#include "TFile.h"
#include "TF1.h"

using namespace std;

//----------------------------------------------------------------------------------------------------

struct RPGraphs
{
	TGraphErrors *g_x_meth_o = NULL;
	TGraphErrors *g_x_rel;
	TGraphErrors *g_y_meth_s;

	TF1 *f_x_meth_o;
	TF1 *f_x_rel;
	TF1 *f_y_meth_s;

	void Init()
	{
		if (g_x_meth_o)
			return;

		g_x_meth_o = new TGraphErrors();
		g_x_rel = new TGraphErrors();
		g_y_meth_s = new TGraphErrors();
	}
};

//----------------------------------------------------------------------------------------------------

int main()
{
	// initialisation
	InitFillsRuns(false);
	//PrintFillRunMapping();

	string topDir = "../data/phys-version1";

	vector<string> xangles = {
		"xangle_150",
		"xangle_130",
		//"xangle_110",
	};

	vector<string> datasets = {
		"ALL"
		//"DoubleEG",
		//"SingleMuon",
		//"ZeroBias",
	};

	struct ArmData {
		string name;
		unsigned int rp_id_N, rp_id_F;
	};

	vector<ArmData> armData = {
		{ "sector 45", 3, 23 },
		{ "sector 56", 103, 123 },
	};

	vector<unsigned int> rps;
 	for (const auto &ad : armData)
	{
		rps.push_back(ad.rp_id_N);
		rps.push_back(ad.rp_id_F);
	}

	// collect data
	map<unsigned int, RPGraphs> rpGraphs;

	for (const auto &fill : fills)
	{
		for (const auto &xangle : xangles)
		{
			for (const auto &dataset : datasets)
			{
				vector<unsigned int> rpsWithMissingData;
				for (const auto &rp : rps)
				{
					bool rp_sector_45 = (rp / 100 == 0);
					unsigned int reference_fill = (rp_sector_45) ? fills_reference[fill].sector45 : fills_reference[fill].sector56;

					//printf("fill %u, RP %u --> ref fill %u\n", fill, rp, reference_fill);

					// path base
					char buf[100];
					sprintf(buf, "%s/fill_%u", topDir.c_str(), reference_fill);

					// try to get input
					string dir = string(buf) + "/" + xangle + "/" + dataset;
					signed int r = 0;

					AlignmentResultsCollection arc_x_method_o;
					r += arc_x_method_o.Load(dir + "/x_alignment_meth_o.out");

					AlignmentResultsCollection arc_x_rel;
					r += arc_x_rel.Load(dir + "/x_alignment_relative.out");

					AlignmentResultsCollection arc_y_method_s;
					r += arc_y_method_s.Load(dir + "/y_alignment_alt.out");

					// check all input available
					if (r != 0)
					{
						//printf("WARNING: some input files invailable in directory '%s'.\n", dir.c_str());
						continue;
					}

					// extract corrections
					const AlignmentResults &ar_x_method_o = arc_x_method_o["x_alignment_meth_o"];
					const AlignmentResults &ar_x_rel = arc_x_rel["x_alignment_relative_sl_fix"];
					const AlignmentResults &ar_y_method_s = arc_y_method_s["y_alignment_alt"];

					bool found = true;

					auto rit_x_method_o = ar_x_method_o.find(rp);
					if (rit_x_method_o == ar_x_method_o.end())
						found = false;

					auto rit_x_rel = ar_x_rel.find(rp);
					if (rit_x_rel == ar_x_rel.end())
						found = false;

					auto rit_y_method_s = ar_y_method_s.find(rp);
					if (rit_y_method_s == ar_y_method_s.end())
						found = false;

					if (!found)
					{
						rpsWithMissingData.push_back(rp);
						continue;
					}

					int idx = 0;

					auto &g = rpGraphs[rp];
					g.Init();

					idx = g.g_x_meth_o->GetN();
					g.g_x_meth_o->SetPoint(idx, fill, rit_x_method_o->second.sh_x);
					g.g_x_meth_o->SetPointError(idx, 0., rit_x_method_o->second.sh_x_unc);

					idx = g.g_x_rel->GetN();
					g.g_x_rel->SetPoint(idx, fill, rit_x_rel->second.sh_x);
					g.g_x_rel->SetPointError(idx, 0., 0.010);

					idx = g.g_y_meth_s->GetN();
					g.g_y_meth_s->SetPoint(idx, fill, rit_y_method_s->second.sh_y);
					g.g_y_meth_s->SetPointError(idx, 0., rit_y_method_s->second.sh_y_unc);
				}

				if (!rpsWithMissingData.empty())
				{
					printf("WARNING: some constantants missing for fill %u, xangle %s, dataset %s and RPs: ", fill, xangle.c_str(), dataset.c_str());
					for (const auto &rp : rpsWithMissingData)
						printf("%u, ", rp);
					printf("\n");
				}
			}
		}
	}

	// fit graphs
	for (auto &g : rpGraphs)
	{
		g.second.f_x_meth_o = new TF1("", "[0] + [1]*x");
		g.second.g_x_meth_o->Fit(g.second.f_x_meth_o, "Q");

		g.second.f_x_rel = (g.first < 100) ? new TF1("", "[0]") : new TF1("", "[0] + [1]*x");
		g.second.g_x_rel->Fit(g.second.f_x_rel, "Q");

		g.second.f_y_meth_s = new TF1("", "[0] + [1]*x");
		g.second.g_y_meth_s->Fit(g.second.f_y_meth_s, "Q");
	}

	// prepare output
	AlignmentResultsCollection output;

	// interpolate output
	for (const auto &fill : fills)
	{
		// process data from all RPs
		AlignmentResults ars_combined;

		for (const auto &ad : armData)
		{
			auto &d_N = rpGraphs[ad.rp_id_N];
			auto &d_F = rpGraphs[ad.rp_id_F];

			// b = mean (x_F - x_N) with no correction
			const double de_x_N = d_N.f_x_meth_o->Eval(fill);
			const double de_x_F = d_F.f_x_meth_o->Eval(fill);

			const double b = d_N.f_x_rel->Eval(fill) - d_F.f_x_rel->Eval(fill);
			double x_corr_rel = b + de_x_F - de_x_N;

			if (ad.name == "sector 45") x_corr_rel += 130E-3;
			if (ad.name == "sector 56") x_corr_rel += 110E-3;

			double y_corr_N = 0., y_corr_F = 0.;
			if (ad.name == "sector 45") y_corr_N += -0E-3, y_corr_F += +0E-3;
			if (ad.name == "sector 56") y_corr_N += -53E-3, y_corr_F += +53E-3;

			AlignmentResult ar_N(de_x_N + x_corr_rel/2., 150E-3, d_N.f_y_meth_s->Eval(fill) + y_corr_N, 150E-3);
			AlignmentResult ar_F(de_x_F - x_corr_rel/2., 150E-3, d_F.f_y_meth_s->Eval(fill) + y_corr_F, 150E-3);

			ar_N.rot_x = 3.1415927;
			ar_N.rot_z = +0.27925268;

			ars_combined[ad.rp_id_N] = ar_N;
			ars_combined[ad.rp_id_F] = ar_F;
		}

		char buf[50];
		sprintf(buf, "fill %u", fill);
		output[buf] = ars_combined;
	}

	// save results
	output.Write("fit_alignments.out");

	TFile *f_out = TFile::Open("fit_alignments.root", "recreate");

	for (auto &g : rpGraphs)
	{
		char buf[100];
		sprintf(buf, "rp %u", g.first);
		TDirectory *d_rp = f_out->mkdir(buf);
		gDirectory = d_rp;

		g.second.g_x_meth_o->Write("g_x_meth_o");
		//g.second.f_x_meth_o->Write("f_x_meth_o");

		g.second.g_x_rel->Write("g_x_rel");
		//g.second.f_x_rel->Write("f_x_rel");

		g.second.g_y_meth_s->Write("g_y_meth_s");
		//g.second.f_y_meth_s->Write("f_y_meth_s");
	}

	delete f_out;

	// clean up
	return 0;
}
