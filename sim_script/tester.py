import json
import os
import struct
import matplotlib as plt
from adsp_model import *

def data_tran(din, bp=23):
    data = int(din * 2**bp)
    return data

##########################################################
#             main tester class
##########################################################

class ADSP_TESTER:
    adsp_test = ADSP()
    in_data  = []
    conf_data = []
    ref_data  = []
    out_data  = []
    config_path = './adsp_config.json'
    work_path = './'
    frame = 0

#   generate input data from list
    def gen_input_data(itself):
        with open(itself.config_path, 'r') as f:
            config = json.load(f)
        amp = config['input_config']['Amp']
        frame = config['input_config']['frame']
        itself.frame = frame
        for i in range(frame):
            out = amp * math.sin(float(i/frame) * 2 * math.pi)
            out = data_tran(out)
            itself.in_data.append(out)
            itself.in_data.append(out)

#   generate config data from config.json
    def config_data(itself):
        conf_data = []
        with open(itself.config_path, 'r') as f:
            config = json.load(f)

        string = 'conf_data += itself.adsp_test.config('
        ilt = 0
        for i in config['global_config']:
            if not ilt == 0:
                string += ', '
            tmp = i + ' = ' + str(config['global_config'][i])
            string += tmp
            ilt += 1
        string += ')'
        exec(string)

        for i in config['bq_config']:
            string = 'conf_data += itself.adsp_test.' + i + '.config(' \
                   + str(config['bq_config'][i]) + ')'
            exec(string)

        for i in config['drc_config']:
            string = 'conf_data += itself.adsp_test.' + i + '.config('
            ilt = 0
            for j in config['drc_config'][i]:
                if not ilt == 0:
                    string += ', '
                tmp = j + ' = ' + str(config['drc_config'][i][j])
                string += tmp
                ilt += 1
            string += ')'
            exec(string)

        itself.conf_data = conf_data
        return itself.conf_data

#   generate config.txt for rtl simulation
    def gen_config_file(itself):
        with open(itself.work_path+'config.txt', 'w+') as f:
            if itself.conf_data:
                for config in itself.conf_data:
                    dlen = config[1] * len(config[3]) + 1
                    f.write('{}\n'.format(dlen))
                    addr = int(config[0])
                    f.write('{}\n'.format(addr))
                    for d in config[3]:
                        if config[1] == 1:
                            f.write('{}\n'.format(d))
                        if config[1] == 4:
                            d = data_tran(d, config[2])
                            for part in range(4):
                                tmp = d % (2 ** 8)
                                f.write('{}\n'.format(tmp))
                                d >> 8


#   generate in_data.txt/ref_data.txt/out_data.txt for rtl simulation
    def gen_data_file(itself, dtype, length=0):
        if(dtype == 'ref_data'):
            data_list = itself.ref_data
        elif(dtype == 'in_data'):
            data_list = itself.in_data
        elif(dtype == 'out_data'):
            data_list = itself.out_data
        else:
            assert(0)
        if (length == 0):
            dlen = len(data_list)
        else:
            dlen = length
        fpath = itself.work_path + dtype + '.txt'
        with open(fpath , 'w+') as f:
            for i in range(dlen):
                f.write(str(data_list[i]) + '\n')