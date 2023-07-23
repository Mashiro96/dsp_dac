from tester import *
import os

##########################################################
#                test main here
##########################################################
tester = ADSP_TESTER()

tester.gen_input_data()
tester.config_data()
tester.gen_config_file()
tester.gen_data_file('in_data')

##########################################################
#                prepare work di
##########################################################
work_path = '../work'

if not os.path.exists(work_path):
    os.mkdir(work_path)
else:
    os.system('rm -rf {}/*'.format(work_path))

#cp makefile to work dir
os.system('cp Makefile {}/'.format(work_path))
os.system('cp list.f {}/'.format(work_path))

os.chdir(work_path)

os.system('make')