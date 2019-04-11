"""
 Estimate time delay using GCC-PHAT 
 Copyright (c) 2017 Yihui Xiong

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
"""

import numpy as np
import math

def gcc_phat(sig, refsig, fs=1, max_tau=None, interp=16):
    '''
    This function computes the offset between the signal sig and the reference signal refsig
    using the Generalized Cross Correlation - Phase Transform (GCC-PHAT)method.
    '''
    
    # make sure the length for the FFT is larger or equal than len(sig) + len(refsig)
    n = sig.shape[0] + refsig.shape[0]

    # Generalized Cross Correlation Phase Transform
    SIG = np.fft.rfft(sig, n=n)
    REFSIG = np.fft.rfft(refsig, n=n)
    R = SIG * np.conj(REFSIG)

    cc = np.fft.irfft(R / np.abs(R), n=(interp * n))

    max_shift = int(interp * n / 2)
    if max_tau:
        max_shift = np.minimum(int(interp * fs * max_tau), max_shift)

    cc = np.concatenate((cc[-max_shift:], cc[:max_shift+1]))

    # find max cross correlation index
    shift = np.argmax(np.abs(cc)) - max_shift

    tau = shift / float(interp * fs)
    
    return tau, cc

def get_direction(ch1, ch2, ch3, ch4):
    
    SOUND_SPEED = 343.2

    MIC_DISTANCE_4 = 0.08127
    MAX_TDOA_4 = MIC_DISTANCE_4 / float(SOUND_SPEED)

    MIC_GROUP_N = 2
    MIC_GROUP = [[0, 2], [1, 3]]
    
    tau = [0] * MIC_GROUP_N
    theta = [0] * MIC_GROUP_N
    
    sig = ch1
    refsig = ch3
    tau[0], _ = gcc_phat(sig, refsig, 16000, MAX_TDOA_4, 1)
    theta[0] = math.asin(tau[0] / MAX_TDOA_4) * 180 / math.pi
    sig = ch2
    refsig = ch4
    tau[1], _ = gcc_phat(sig, refsig, 16000, MAX_TDOA_4, 1)
    theta[1] = math.asin(tau[1] / MAX_TDOA_4) * 180 / math.pi
    
    if np.abs(theta[0]) < np.abs(theta[1]):
        if theta[1] > 0:
            best_guess = (theta[0] + 360) % 360
        else:
            best_guess = (180 - theta[0])
    else:
        if theta[0] < 0:
            best_guess = (theta[1] + 360) % 360
        else:
            best_guess = (180 - theta[1])

        best_guess = (best_guess + 90 + 180) % 360


    best_guess = (-best_guess + 120) % 360
    return best_guess
