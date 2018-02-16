import sys 
import os
import FWCore.ParameterSet.Config as cms

sys.path.append(os.path.relpath("../../../../../"))

from config_base import config

config.sector_45.cut_h_c = -38.56
config.sector_45.cut_v_c = 1.63

config.sector_56.cut_h_c = -39.29
config.sector_56.cut_v_c = 1.45
