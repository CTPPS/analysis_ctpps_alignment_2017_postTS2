import sys 
import os
import FWCore.ParameterSet.Config as cms

sys.path.append(os.path.relpath("./"))
sys.path.append(os.path.relpath("../../../../../"))

from config_base import config
from input_files import input_files

config.input_files = input_files

config.aligned = True

config.sector_45.cut_h_c = 0

config.sector_45.cut_v_a = -1.07
config.sector_45.cut_v_c = 0.28

config.sector_56.cut_h_c = 0.08

config.sector_56.cut_v_a = -1.07
config.sector_56.cut_v_c = 0.18

config.sector_45.nr_x_slice_min = 2
config.sector_45.nr_x_slice_max = 18
config.sector_45.fr_x_slice_min = 2
config.sector_45.fr_x_slice_max = 19
config.sector_56.nr_x_slice_min = 2
config.sector_56.nr_x_slice_max = 15
config.sector_56.fr_x_slice_min = 2
config.sector_56.fr_x_slice_max = 15


config.x_alignment_meth_x.rp_L_2_F.x_min = 3
config.x_alignment_meth_x.rp_L_2_F.x_max = 15

config.x_alignment_meth_x.rp_L_1_F.x_min = 3
config.x_alignment_meth_x.rp_L_1_F.x_max = 15

config.x_alignment_meth_x.rp_R_1_F.x_min = 2
config.x_alignment_meth_x.rp_R_1_F.x_max = 14

config.x_alignment_meth_x.rp_R_2_F.x_min = 2
config.x_alignment_meth_x.rp_R_2_F.x_max = 14


config.x_alignment_meth_y.rp_L_2_F.x_min = 3
config.x_alignment_meth_y.rp_L_2_F.x_max = 15

config.x_alignment_meth_y.rp_L_1_F.x_min = 3
config.x_alignment_meth_y.rp_L_1_F.x_max = 15

config.x_alignment_meth_y.rp_R_1_F.x_min = 2
config.x_alignment_meth_y.rp_R_1_F.x_max = 14

config.x_alignment_meth_y.rp_R_2_F.x_min = 2
config.x_alignment_meth_y.rp_R_2_F.x_max = 14


config.x_alignment_meth_o.rp_L_2_F.x_min = 7.
config.x_alignment_meth_o.rp_L_2_F.x_max = 15.

config.x_alignment_meth_o.rp_L_1_F.x_min = 7.
config.x_alignment_meth_o.rp_L_1_F.x_max = 15.

config.x_alignment_meth_o.rp_R_1_F.x_min = 5.
config.x_alignment_meth_o.rp_R_1_F.x_max = 15.

config.x_alignment_meth_o.rp_R_2_F.x_min = 5.
config.x_alignment_meth_o.rp_R_2_F.x_max = 15.
