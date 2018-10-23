void InitStandardDatasets(string datasets[])
{
	datasets.delete();
	datasets.push("fill_6239/xangle_150/DoubleEG");
	datasets.push("fill_6268/xangle_150/DoubleEG");
	datasets.push("fill_6287/xangle_150/DoubleEG");
	datasets.push("fill_6323/xangle_150/DoubleEG");
	datasets.push("fill_6371/xangle_150/DoubleEG");
}

//----------------------------------------------------------------------------------------------------

real GetMeanHorizontalAlignment(string rp)
{
	if (rp == "L_2_F") return -42.0;
	if (rp == "L_1_F") return -3.6;
	if (rp == "R_1_F") return -2.8;
	if (rp == "R_2_F") return -41.9;

	return 0;
}

//----------------------------------------------------------------------------------------------------

real GetMeanHorizontalRelativeAlignment(string sector)
{
	if (sector == "45") return 38.44;
	if (sector == "56") return 39.37;

	return 0;
}

//----------------------------------------------------------------------------------------------------

real GetMeanVerticalAlignment(string rp)
{
	if (rp == "L_2_F") return 2.7;
	if (rp == "L_1_F") return 4.0;
	if (rp == "R_1_F") return 4.0;
	if (rp == "R_2_F") return 2.8;

	return 0;
}

//----------------------------------------------------------------------------------------------------

real GetMeanVerticalRelativeAlignment(string sector)
{
	if (sector == "45") return -1.32;
	if (sector == "56") return -1.17;

	return 0;
}
