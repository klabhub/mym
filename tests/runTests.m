% Run this from the tests directory
% Copy DJ_* environment variables to DJ_TEST_* environment variables
setenv('DJ_TEST_HOST', getenv('DJ_HOST'));
setenv('DJ_TEST_USER', getenv('DJ_USER'));
setenv('DJ_TEST_PASSWORD', getenv('DJ_PASS'));

addpath(fullfile(pwd,'..', 'distribution', mexext), '-begin');

import matlab.unittest.TestSuite
import matlab.unittest.selectors.HasName
import matlab.unittest.constraints.ContainsSubstring

% Skip TLS tests
suite = TestSuite.fromFile('Main.m');
suite = suite.selectIf(~HasName(ContainsSubstring('TestTls_')));
results = run(suite);
disp(results);