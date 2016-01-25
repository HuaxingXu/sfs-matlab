function varargout = sound_field_mono_localwfs(X,Y,Z,xs,src,f,conf)
%SOUND_FIELD_MONO_LOCALWFS simulates a sound field for local WFS
%
%   Usage: [P,x,y,z,x0] = sound_field_mono_localwfs(X,Y,Z,xs,src,f,conf)
%
%   Input parameters:
%       X           - x-axis / m; single value or [xmin,xmax] or nD-array
%       Y           - y-axis / m; single value or [ymin,ymax] or nD-array
%       Z           - z-axis / m; single value or [zmin,zmax] or nD-array
%       xs          - position of virtual source / m
%       src         - source type of the virtual source
%                         'pw' - plane wave (xs is the direction of the
%                                plane wave in this case)
%                         'ps' - point source
%                         'fs' - focused source
%       f           - monochromatic frequency / Hz
%       conf        - configuration struct (see SFS_config)
%
%   Output parameters:
%       P           - simulated sound field
%       x           - corresponding x values / m
%       y           - corresponding y values / m
%       z           - corresponding z values / m
%       x0          - active secondary sources / m
%
%   SOUND_FIELD_MONO_WFS(X,Y,Z,xs,src,f,conf) simulates a monochromatic sound
%   field for the given source type (src) synthesized with local wave field
%   synthesis.
%
%   To plot the result use:
%   plot_sound_field(P,X,Y,Z,x0,conf);
%   or simple call the function without output argument:
%   sound_field_mono_localwfs(X,Y,Z,xs,src,f,conf)
%
%   See also: plot_sound_field, sound_field_imp_wfs, driving_function_mono_wfs

%*****************************************************************************
% Copyright (c) 2010-2016 Quality & Usability Lab, together with             *
%                         Assessment of IP-based Applications                *
%                         Telekom Innovation Laboratories, TU Berlin         *
%                         Ernst-Reuter-Platz 7, 10587 Berlin, Germany        *
%                                                                            *
% Copyright (c) 2013-2016 Institut fuer Nachrichtentechnik                   *
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
% http://github.com/sfstoolbox/sfs                      sfstoolbox@gmail.com *
%*****************************************************************************


%% ===== Checking of input  parameters ==================================
nargmin = 7;
nargmax = 7;
narginchk(nargmin,nargmax);
isargxs(xs);
isargpositivescalar(f);
isargchar(src);
isargstruct(conf);


%% ===== Configuration ==================================================
useplot = conf.plot.useplot;
loudspeakers = conf.plot.loudspeakers;
dimension = conf.dimension;
if strcmp('2D',dimension)
    greens_function = 'ls';
else
    greens_function = 'ps';
end


%% ===== Computation ====================================================
% Get the position of the loudspeakers and its activity
x0 = secondary_source_positions(conf);
% Driving function
[D, x0, xv] = driving_function_mono_localwfs(x0,xs,src,f,conf);
% Wave field
[varargout{1:min(nargout,4)}] = ...
    sound_field_mono(X,Y,Z,x0,greens_function,D,f,conf);
% Return secondary sources if desired
if nargout>=5, varargout{5}=x0; end
if nargout==6, varargout{6}=xv; end


% ===== Plotting ========================================================
% Add the virtual loudspeaker positions
if (nargout==0 || useplot) && loudspeakers
    hold on;
    tmp = conf.plot.realloudspeakers;  % cache option for loudspeaker plotting
    conf.plot.realloudspeakers = false;
    draw_loudspeakers(xv,[1 1 0],conf);
    conf.plot.realloudspeakers = tmp;
    hold off;
end
