import math

##########################################################
#       audio dsp processor control register map
##########################################################
address = {'ch1_bq0'   : 0x29, \
           'ch1_bq1'   : 0x2A, \
           'ch1_bq2'   : 0x2B, \
           'ch1_bq3'   : 0x2C, \
           'ch1_bq4'   : 0x2D, \
           'ch1_bq5'   : 0x2E, \
           'ch1_bq6'   : 0x2F, \
           'ch2_bq0'   : 0x30, \
           'ch2_bq1'   : 0x31, \
           'ch2_bq2'   : 0x32, \
           'ch2_bq3'   : 0x33, \
           'ch2_bq4'   : 0x34, \
           'ch2_bq5'   : 0x35, \
           'ch2_bq6'   : 0x36, \
           'drc1_eng'  : 0x3A, \
           'drc1_atk'  : 0x3B, \
           'drc1_rel'  : 0x3C, \
           'drc2_eng'  : 0x3D, \
           'drc2_atk'  : 0x3E, \
           'drc2_rel'  : 0x3F, \
           'drc1_t'    : 0x40, \
           'drc1_k'    : 0x41, \
           'drc1_o'    : 0x42, \
           'drc2_t'    : 0x43, \
           'drc2_k'    : 0x44, \
           'drc2_o'    : 0x45, \
           'ch1_do_mix': 0x51, \
           'ch2_do_mix': 0x52, \
           'ch1_di_mix': 0x53, \
           'ch2_di_mix': 0x54, \
           'ch3_di_mix': 0x55, \
           'post_scale': 0x56, \
           'pre_scale' : 0x57, \
           'ch1_bq7'   : 0x58, \
           'ch1_bq8'   : 0x59, \
           'ch4_bq0'   : 0x5A, \
           'ch4_bq1'   : 0x5B, \
           'ch2_bq7'   : 0x5C, \
           'ch2_bq8'   : 0x5D, \
           'ch3_bq0'   : 0x5E, \
           'ch4_di_mix': 0x61, \
           'i2s_config': 0x04, \
           'ch1_vol'   : 0x08, \
           'ch2_vol'   : 0x09, \
           'subch_vol' : 0x0A, \
           'vol_config': 0x0E, \
           'mch_di_sel': 0x20, \
           'ch4_di_sel': 0x21, \
           'dac_config': 0x0F, \
           'drc_config': 0x46  \
           }

i2s_porttype_dic = {'iis'   : 0, \
                    'left'  : 1, \
                    'right' : 2, \
                    'tdm'   : 3
}

i2s_bitnum_dic = {16 : 0, \
                  20 : 1, \
                  24 : 2, \
                  32 : 3
}
##########################################################
#           mul and accumulate function
##########################################################
def mla(d1, d2):
    sum = 0
    for i in range(len(d1)):
        sum += d1[i] * d2[i]
    return sum


##########################################################
#                BQ  Filter  class
##########################################################
class BQ:
    # coef default value
    coef = [1.0,0.0,0.0,0.0,0.0]
    # coef default addr
    addr = 0x0
    # class data
    di_delay = [0,0]
    do_delay = [0,0]

    def __init__(itself, index=(1,0)):
        itself.addr = address[f'ch{index[0]}_bq{index[1]}']

    def calculate(itself,din):
        data_list = [din] + itself.di_delay + itself.do_delay
        out = mla(data_list, itself.coef)
        itself.di_delay = ([din] + itself.di_delay)[:2]
        itself.do_delay = ([out] + itself.do_delay)[:2]
        return out

    def config(itself,din):
        out = []
        if not itself.coef == din:
            itself.coef = din
            addr = itself.addr
            byte_len = 4
            bpoint = 23
            data = din
            out.append((addr, byte_len, bpoint, data))
        return out

##########################################################
#            Dynamic Range Control class
##########################################################
class DRC:
    # coef default value
    pow = [1.0, 0.0]
    at = [1.0, 0.0]
    rt = [1.0, 0.0]
    threshold = -4.7337
    ratio = -0.9677
    offset = 0.0645
    # coef default addr
    eng_addr = 0x0
    atk_addr = 0x0
    rel_addr = 0x0
    t_addr   = 0x0
    k_addr   = 0x0
    r_addr   = 0x0
    # class data
    di1_delay = 0
    di2_delay = 0
    gain_delay = 1

    def __init__(itself, index=1):
        itself.eng_addr = address[f'drc{index}_eng']
        itself.atk_addr = address[f'drc{index}_atk']
        itself.rel_addr = address[f'drc{index}_rel']
        itself.t_addr = address[f'drc{index}_t']
        itself.k_addr = address[f'drc{index}_k']
        itself.o_addr = address[f'drc{index}_o']

    def pow_sel(itself,di1,di2):
        pow1 = mla([abs(di1),itself.di1_delay], itself.pow)
        pow2 = mla([abs(di2),itself.di2_delay], itself.pow)
        itself.di1_delay = pow1
        itself.di2_delay = pow2
        return (max(pow1,pow2))

    def compressor(itself, pow_out):
        db = 20 * math.log10(pow_out+1e-40)
        gain = 0
        if (db > itself.threshold):
            gain = (db - itself.threshold) * itself.ratio
        gain = 10 ** ((gain+itself.offset)/20)
        return gain   

    def gain_smooth(itself, gain):
        if (gain > itself.gain_delay):
            gain_smooth = mla([gain,itself.gain_delay], itself.rt)
        else:
            gain_smooth = mla([gain,itself.gain_delay], itself.at)
        itself.gain_delay = gain_smooth
        return gain_smooth

    def calculate(itself, di1, di2):
        pow_out = itself.pow_sel(di1, di2)
        gain = itself.compressor(pow_out)
        gain_smooth = itself.gain_smooth(gain)
        do1 = di1 * gain_smooth
        do2 = di2 * gain_smooth
        return(do1, do2)

    def config (itself,alpha_pow=1.0,alpha_at=1.0,alpha_rt=1.0, \
                threshold=-4.7337,ratio=-0.9677,offset=0.0645):
        out = []
        byte_len = 4
        bpoint = 23
        if not(itself.pow == [alpha_pow, (1.0-alpha_pow)]):
            addr = itself.eng_addr
            data = [alpha_pow, (1.0-alpha_pow)]
            out.append((addr, byte_len, bpoint, data))
            itself.pow = [alpha_pow, (1.0-alpha_pow)]
        if not(itself.at == [alpha_at, (1.0-alpha_at)]):
            addr = itself.atk_addr
            data = [alpha_at, (1.0-alpha_at)]
            out.append((addr, byte_len, bpoint, data))
            itself.at = [alpha_at, (1.0-alpha_at)]
        if not(itself.rt == [alpha_rt, (1.0-alpha_rt)]):
            addr = itself.rel_addr
            data = [alpha_rt, (1.0-alpha_rt)]
            out.append((addr, byte_len, bpoint, data))
            itself.rt = [alpha_rt, (1.0-alpha_rt)]
        if not(itself.threshold == threshold):
            addr = itself.t_addr
            data = [threshold]
            out.append((addr, byte_len, bpoint, data))
            itself.threshold = threshold
        if not(itself.ratio == ratio):
            addr = itself.k_addr
            data = [ratio]
            out.append((addr, byte_len, bpoint, data))
            itself.ratio = ratio
        if not(itself.offset == offset):
            addr = itself.o_addr
            data = [offset]
            out.append((addr, byte_len, bpoint, data))
            itself.offset = offset
        
        return out

##########################################################
#              Audio DSP model class
##########################################################
class ADSP:
    # coef default value
    ch1_di_mix = [1.0,0.0,0.0,1.0]
    ch1_do_mix = [1.0,0.0,0.0]
    ch1_vol = 48
    ch2_vol = 48
    subch_vol = 48
    ch3_vol_sel = 0
    ch4_vol_sel = 0
    ch1_di_sel = 0
    ch2_di_sel = 1
    ch2_di_mix = [1.0,0.0,0.0,1.0]
    ch2_do_mix = [1.0,0.0,0.0]
    pre_scale = 1.0
    post_scale = 1.0
    ch3_di_mix = [1.0, 0.0, 0.0]
    ch4_di_mix = [0.5,0.5]
    ch4_di_sel = 1
    drc1_en = 0
    drc2_en = 0
    auto_loop_en = 0
    i2s_config = [0, 0, 1]
    dac_config = [0, 0, 0]
    # coef default addr
    ch1_di_mix_addr = address['ch1_di_mix']
    ch1_do_mix_addr = address['ch1_do_mix']
    ch1_vol_addr    = address['ch1_vol']
    ch2_vol_addr    = address['ch2_vol']
    subch_vol_addr  = address['subch_vol']
    vol_config_addr = address['vol_config']
    mch_di_sel_addr = address['mch_di_sel']
    ch2_di_mix_addr = address['ch2_di_mix']
    ch2_do_mix_addr = address['ch2_do_mix']
    pre_scale_addr  = address['pre_scale']
    post_scale_addr = address['post_scale']
    ch3_di_mix_addr = address['ch3_di_mix']
    ch4_di_mix_addr = address['ch4_di_mix']
    ch4_di_sel_addr = address['ch4_di_sel']
    drc_config_addr = address['drc_config']
    i2s_config_addr = address['i2s_config']
    dac_config_addr = address['dac_config']
    # submodule init
    for i in range(1,3):
        for j in range(9):
            exec(f'ch{i}_bq{j} = BQ(({i},{j}))')
    drc1 = DRC(1)
    ch3_bq0 = BQ((3,0))
    ch4_bq0 = BQ((4,0))
    ch4_bq1 = BQ((4,1))
    drc2 = DRC(2)

    ch3_post_bq = 0.0

    def calculate(itself,di_left,di_right):
        if (itself.ch1_di_sel == 0):
            ch1_din = di_left
        elif (itself.ch1_di_sel == 1):
            ch1_din = di_right
        else:
            ch1_din = 0.0

        if (itself.ch2_di_sel == 0):
            ch2_din = di_left
        elif (itself.ch2_di_sel == 1):
            ch2_din = di_right
        else:
            ch2_din = 0.0

        ch1_post_bq0 = itself.ch1_bq0.calculate(ch1_din)

        ch1_data = mla([ch1_post_bq0,itself.ch3_post_bq], itself.ch1_di_mix[:2])
        ch1_data = itself.ch1_bq1.calculate(ch1_data)
        ch1_data = mla([di_left, ch1_data], itself.ch1_di_mix[-2:])
        
        ch1_data = itself.ch1_bq2.calculate(ch1_data)
        ch1_data = itself.ch1_bq3.calculate(ch1_data)
        ch1_data = itself.ch1_bq4.calculate(ch1_data)
        ch1_data = itself.ch1_bq5.calculate(ch1_data)
        ch1_data = itself.ch1_bq6.calculate(ch1_data)
        ch1_data = itself.ch1_bq7.calculate(ch1_data)
        ch1_post_bq7 = ch1_data
        ch1_data = itself.ch1_bq8.calculate(ch1_data)

        if (itself.auto_loop_en):
            ch1_post_bq7 = ch1_post_bq7 - ch1_data
        ch1_data = ch1_data * (10 ** ((24 - itself.ch1_vol/2)/20) )

        ch2_post_bq0 = itself.ch2_bq0.calculate(ch2_din)

        ch2_data = mla((ch2_post_bq0,itself.ch3_post_bq), itself.ch2_di_mix[:2])    
        ch2_data = itself.ch2_bq1.calculate(ch2_data)
        ch2_data = mla((di_right, ch2_data), itself.ch2_di_mix[-2:])

        ch2_data = itself.ch2_bq2.calculate(ch2_data)
        ch2_data = itself.ch2_bq3.calculate(ch2_data)
        ch2_data = itself.ch2_bq4.calculate(ch2_data)
        ch2_data = itself.ch2_bq5.calculate(ch2_data)
        ch2_data = itself.ch2_bq6.calculate(ch2_data)
        ch2_data = itself.ch2_bq7.calculate(ch2_data)
        ch2_post_bq7 = ch2_data
        ch2_data = itself.ch2_bq8.calculate(ch2_data)

        if (itself.auto_loop_en):
            ch2_post_bq7 = ch2_post_bq7 - ch2_data
        ch2_data = ch2_data * (10 ** ((24 - itself.ch2_vol/2)/20))

        if (itself.ch3_vol_sel) :
            ch3_vol = itself.subch_vol
        else :
            ch3_vol = itself.ch2_vol
        ch3_data = mla([ch2_post_bq7,ch2_post_bq0,ch1_post_bq0], itself.ch3_di_mix)   
        itself.ch3_post_bq = itself.ch3_bq0.calculate(ch3_data)
        ch3_data = itself.ch3_post_bq * (10 ** ((24 - ch3_vol/2)/20))

        if (itself.ch4_vol_sel) :
            ch4_vol = itself.subch_vol
        else :
            ch4_vol = itself.ch1_vol
        ch4_data = mla([di_left, di_right], itself.ch4_di_mix)
        if (itself.ch4_di_sel):
            ch4_data = ch1_post_bq7
        ch4_data = itself.ch4_bq0.calculate(ch4_data)
        ch4_data = itself.ch4_bq1.calculate(ch4_data)
        ch4_data = ch4_data * (10 ** ((24 - ch4_vol/2)/20))

        if (itself.drc1_en):
            (ch1_data, ch2_data) = itself.drc1.calculate(ch1_data, ch2_data)
        if (itself.drc2_en):
            (ch3_data, ch4_data) = itself.drc2.calculate(ch3_data, ch4_data)

        ch1_out = mla([ch1_data, ch2_data, ch4_data],itself.ch1_do_mix)
        ch2_out = mla([ch2_data, ch3_data, ch4_data],itself.ch2_do_mix)

        ch1_out = ch1_out * itself.pre_scale * itself.post_scale
        ch2_out = ch2_out * itself.pre_scale * itself.post_scale

        return(ch1_out, ch2_out)       
    
    def config  (itself, \
                 ch1_di_mix=[1.0,0.0,0.0,1.0], \
                 ch1_do_mix=[1.0,0.0,0.0], \
                 ch1_vol=48, \
                 ch2_vol=48, \
                 subch_vol=48, \
                 ch3_vol_sel=0, ch4_vol_sel=0, \
                 ch1_di_sel=0, ch2_di_sel=1, \
                 ch2_di_mix=[1.0,0.0,0.0,1.0], \
                 ch2_do_mix=[1.0,0.0,0.0], \
                 pre_scale=1.0, post_scale=1.0, \
                 ch3_di_mix=[1.0,0.0,0.0], \
                 ch4_di_mix=[0.5,0.5], \
                 ch4_di_sel=1, \
                 auto_loop_en=0, drc1_en=0, drc2_en=0, \
                 i2s_config=[0,0,1], \
                 dac_config=[0,0,0]
                 ):
        out = []
        if not(itself.ch1_di_mix == ch1_di_mix):
            itself.ch1_di_mix = ch1_di_mix
            addr = itself.ch1_di_mix_addr
            byte_len = 4
            bpoint = 23
            data = ch1_di_mix
            out.append((addr, byte_len, bpoint, data))
        if not(itself.ch1_do_mix == ch1_do_mix):
            itself.ch1_do_mix = ch1_do_mix
            addr = itself.ch1_do_mix_addr
            byte_len = 4
            bpoint = 23
            data = ch1_do_mix
            out.append((addr, byte_len, bpoint, data))
        if not(itself.ch1_vol == ch1_vol):
            itself.ch1_vol = ch1_vol
            addr = itself.ch1_vol_addr
            byte_len = 1
            bpoint = 0
            data = [ch1_vol]
            out.append((addr, byte_len, bpoint, data))
        if not(itself.ch2_vol == ch2_vol):
            itself.ch2_vol = ch2_vol
            addr = itself.ch2_vol_addr
            byte_len = 1
            bpoint = 0
            data = [ch2_vol]
            out.append((addr, byte_len, bpoint, data))
        if not(itself.subch_vol == subch_vol):
            itself.subch_vol = subch_vol
            addr = itself.subch_vol_addr
            byte_len = 1
            bpoint = 0
            data = [subch_vol]
            out.append((addr, byte_len, bpoint, data))
        if not([itself.ch3_vol_sel,itself.ch4_vol_sel] \
            == [ch3_vol_sel, ch4_vol_sel]):
            itself.ch3_vol_sel = ch3_vol_sel
            itself.ch4_vol_sel = ch4_vol_sel
            addr = itself.vol_config_addr
            byte_len = 1
            bpoint = 0
            data = [int(0x91 | (ch3_vol_sel << 5) | (ch4_vol_sel << 6))]
            out.append((addr, byte_len, bpoint, data))
        if not([itself.ch1_di_sel,itself.ch2_di_sel] \
            == [ch1_di_sel, ch2_di_sel]):
            itself.ch1_di_sel = ch1_di_sel
            itself.ch2_di_sel = ch2_di_sel
            addr = itself.mch_di_sel_addr
            byte_len = 4
            bpoint = 0
            data = [int(0x00007772 | (ch1_di_sel << 20) | (ch2_di_sel << 16))]
            out.append((addr, byte_len, bpoint, data))
        if not(itself.ch2_di_mix == ch2_di_mix):
            itself.ch2_di_mix = ch2_di_mix
            addr = itself.ch2_di_mix_addr
            byte_len = 4
            bpoint = 23
            data = ch2_di_mix
            out.append((addr, byte_len, bpoint, data))
        if not(itself.ch2_do_mix == ch2_do_mix):
            itself.ch2_do_mix = ch2_do_mix
            addr = itself.ch2_do_mix_addr
            byte_len = 4
            bpoint = 23
            data = ch2_do_mix
            out.append((addr, byte_len, bpoint, data))
        if not(itself.pre_scale == pre_scale):
            itself.pre_scale = pre_scale
            addr = itself.pre_scale_addr
            byte_len = 4
            bpoint = 17
            data = [pre_scale]
            out.append((addr, byte_len, bpoint, data))
        if not(itself.post_scale == post_scale):
            itself.post_scale = post_scale
            addr = itself.post_scale_addr
            byte_len = 4
            bpoint = 23
            data = [post_scale]
            out.append((addr, byte_len, bpoint, data))
        if not(itself.ch3_di_mix == ch3_di_mix):
            itself.ch3_di_mix = ch3_di_mix
            addr = itself.ch3_di_mix_addr
            byte_len = 4
            bpoint = 23
            data = ch3_di_mix
            out.append((addr, byte_len, bpoint, data))
        if not(itself.ch4_di_mix == ch4_di_mix):
            itself.ch4_di_mix = ch4_di_mix
            addr = itself.ch4_di_mix_addr
            byte_len = 4
            bpoint = 23
            data = ch4_di_mix
            out.append((addr, byte_len, bpoint, data))
        if not(itself.ch4_di_sel == ch4_di_sel):
            itself.ch4_di_sel = ch4_di_sel
            addr = itself.ch4_di_sel_addr
            byte_len = 4
            bpoint = 0
            data = [int(0x00004203 | (ch4_di_sel << 8))]
            out.append((addr, byte_len, bpoint, data))
        if not([itself.auto_loop_en,itself.drc1_en,itself.drc2_en]\
            == [auto_loop_en,drc1_en,drc2_en]):
            itself.auto_loop_en = auto_loop_en
            itself.drc1_en = drc1_en
            itself.drc2_en = drc2_en
            addr = itself.drc_config_addr
            byte_len = 4
            bpoint = 0
            data = [int((auto_loop_en << 5) | (drc2_en << 1) | drc1_en)]
            out.append((addr, byte_len, bpoint, data))
        if not(itself.i2s_config == i2s_config):
            itself.i2s_config = i2s_config
            addr = itself.i2s_config_addr
            byte_len = 1
            bpoint = 0
            data = [(i2s_config[0] << 7) | (i2s_config[1] << 4) | i2s_config[2] | (1 << 2)]
            out.append((addr, byte_len, bpoint, data))
        if not(itself.dac_config == dac_config):
            itself.dac_config = dac_config
            addr = itself.dac_config_addr
            byte_len = 1
            bpoint = 0
            data = [(dac_config[2] << 2) | (dac_config[1] << 1) | dac_config[0]]
            out.append((addr, byte_len, bpoint, data))

        return out
