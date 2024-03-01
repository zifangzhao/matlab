cutoffFreq = 1000;  % Set cutoff frequency in Hz
samplingFreq = 44100;  % Set sampling frequency in Hz
order = 4;  % Set filter order

codegen -config coder.config('lib') -args {cutoffFreq, samplingFreq, order} butterworthFilterDesigner -o filter_coeffs