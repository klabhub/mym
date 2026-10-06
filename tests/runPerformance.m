% Run the mym performance tests.
%
% Required environment variables:
%   DJ_TEST_HOST, DJ_TEST_USER, DJ_TEST_PASSWORD

repoRoot = fileparts(fileparts(mfilename('fullpath')));
addpath(repoRoot, '-begin');
addpath(fullfile(repoRoot, 'tests'), '-begin');
addpath(fullfile(repoRoot, 'distribution', mexext), '-begin');

results = runperf(fullfile(repoRoot, 'tests', 'TestMymPerformance.m'));
disp(results);
