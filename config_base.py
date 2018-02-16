import FWCore.ParameterSet.Config as cms

config = cms.PSet(
    alignment_corrections = cms.PSet(
      rp_L_2_F = cms.PSet(
        de_x = cms.double(0.)
      ),
      rp_L_1_F = cms.PSet(
        de_x = cms.double(0.)
      ),
      rp_R_1_F = cms.PSet(
        de_x = cms.double(0.)
      ),
      rp_R_2_F = cms.PSet(
        de_x = cms.double(0.)
      )
    ),

    aligned = cms.bool(False),

    n_si = cms.double(4.),

    sector_45 = cms.PSet(
	  cut_h_apply = cms.bool(True),
	  cut_h_a = cms.double(-1),
	  cut_h_c = cms.double(-38.6),
	  cut_h_si = cms.double(0.2),

	  cut_v_apply = cms.bool(False),
	  cut_v_a = cms.double(-1),
	  cut_v_c = cms.double(0.9),
	  cut_v_si = cms.double(0.5)
    ),

    sector_56 = cms.PSet(
	  cut_h_apply = cms.bool(True),
	  cut_h_a = cms.double(-1),
	  cut_h_c = cms.double(-38.6),
	  cut_h_si = cms.double(0.2),

	  cut_v_apply = cms.bool(False),
	  cut_v_a = cms.double(-1),
	  cut_v_c = cms.double(0.9),
	  cut_v_si = cms.double(0.5)
    ),

    matching_1d = cms.PSet(
      reference_datasets = cms.vstring(),

      rp_L_2_F = cms.PSet(
        x_min = cms.double(0.),
        x_max = cms.double(0.),
        sh_min = cms.double(-44),
        sh_max = cms.double(-40)
      ),
      rp_L_1_F = cms.PSet(
        x_min = cms.double(0.),
        x_max = cms.double(0.),
        sh_min = cms.double(-5),
        sh_max = cms.double(-1)
      ),
      rp_R_1_F = cms.PSet(
        x_min = cms.double(0.),
        x_max = cms.double(0.),
        sh_min = cms.double(-5),
        sh_max = cms.double(-1)
      ),
      rp_R_2_F = cms.PSet(
        x_min = cms.double(0.),
        x_max = cms.double(0.),
        sh_min = cms.double(-44),
        sh_max = cms.double(-40)
      )
    )
)
