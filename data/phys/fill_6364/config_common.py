import sys 
import os
import FWCore.ParameterSet.Config as cms

sys.path.append(os.path.relpath("../../../../../"))

from config_base import config

config.sector_45.cut_h_c = -38.57
config.sector_45.cut_v_c = 1.64

config.sector_56.cut_h_c = -39.28
config.sector_56.cut_v_c = 1.49
