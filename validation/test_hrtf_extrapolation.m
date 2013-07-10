function boolean = test_hrtf_extrapolation()
%TEST_HRTF_EXTRAPOLATION tests the HRTF extrapolation functions
%
%   Usage: boolean = test_hrtf_extrapolation()
%
%   Input parameters:
%       modus   - 0: numerical
%                 1: visual
%
%   Output parameters:
%       booelan - true or false
%
%   TEST_DRIVING_FUNCTIONS(MODUS) checks if the functions, that calculates
%   the driving functions working correctly. Therefore different wave
%   fields are simulated.

%*****************************************************************************
% Copyright (c) 2010-2013 Quality & Usability Lab, together with             *
%                         Assessment of IP-based Applications                *
%                         Deutsche Telekom Laboratories, TU Berlin           *
%                         Ernst-Reuter-Platz 7, 10587 Berlin, Germany        *
%                                                                            *
% Copyright (c) 2013      Institut fuer Nachrichtentechnik                   *
%                         Universitaet Rostock                               *
%                         Richard-Wagner-Strasse 31, 18119 Rostock           *
%                                                                            *
% This file is part of the Sound Field Synthesis-Toolbox (SFS).              *
%                                                                            *
% The SFS is free software:  you can redistribute it and/or modify it  under *
% the terms of the  GNU  General  Public  License  as published by the  Free *
% Software Foundation, either version 3 of the License,  or (at your option) *
% any later version.                                                         *
%                                                                            *
% The SFS is distributed in the hope that it will be useful, but WITHOUT ANY *
% WARRANTY;  without even the implied warranty of MERCHANTABILITY or FITNESS *
% FOR A PARTICULAR PURPOSE.                                                  *
% See the GNU General Public License for more details.                       *
%                                                                            *
% You should  have received a copy  of the GNU General Public License  along *
% with this program.  If not, see <http://www.gnu.org/licenses/>.            *
%                                                                            *
% The SFS is a toolbox for Matlab/Octave to  simulate and  investigate sound *
% field  synthesis  methods  like  wave  field  synthesis  or  higher  order *
% ambisonics.                                                                *
%                                                                            *
% http://dev.qu.tu-berlin.de/projects/sfs-toolbox       sfstoolbox@gmail.com *
%*****************************************************************************

% TODO: add mode to save data as reference data


%% ===== Checking of input  parameters ===================================
nargmin = 0;
nargmax = 0;
narginchk(nargmin,nargmax);


%% ===== Configuration ===================================================
% QU KEMAR horizontal HRTFs
disp('QU KEMAR anechoic 3m');
%conf = SFS_config_example;
conf.dimension = '2.5D';
% check if HRTF data set is available, download otherwise
basepath = get_sfs_path();
hrtf_file = [basepath '/data/HRTFs/QU_KEMAR_anechoic_3m.mat'];
if ~exist(hrtf_file,'file')
    url = ['https://dev.qu.tu-berlin.de/projects/measurements/repository/', ...
        'raw/2010-11-kemar-anechoic/mat/QU_KEMAR_anechoic_3m.mat'];
    download_file(url,hrtf_file);
end
% load HRTF data set
irs = read_irs(hrtf_file);
% extrapolation settings
conf.dimension = '2.5D';
conf.fs = 44100;
conf.c = 343;
conf.xref = [0 0 0];
conf.usetapwin = true;
conf.tapwinlen = 0.3;
conf.secondary_sources.geometry = 'circle';
conf.N = 1024;
conf.wfs.usehpre = true;
conf.wfs.hpretype = 'FIR';
conf.driving_functions = 'default';
conf.usefracdelay = false;
conf.fracdelay_method = 'resample';
conf.ir.useinterpolation = true;
% do the extrapolation
irs_pw = extrapolate_farfield_hrtfset(irs,conf);
% plot the original HRTF data set
%figure;
%title('QU KEMAR anechoic 3m');
%imagesc(degree(irs.apparent_azimuth),irs.left);
%xlabel('phi / deg');
%% plot the interplated HRTF data set
%figure;
%title('QU KEMAR anechoic extrapolated');
%imagesc(degree(irs_pw.apparent_azimuth),irs_pw.left);
%xlabel('phi / deg');