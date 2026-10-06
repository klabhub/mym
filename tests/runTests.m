setenv('DJ_TEST_HOST', getenv('DJ_HOST'));
setenv('DJ_TEST_USER', getenv('DJ_USER'));
setenv('DJ_TEST_PASSWORD', getenv('DJ_PASS'));

addpath(pwd, '-begin');
addpath('tests', '-begin');
addpath(fullfile(pwd,'..', 'distribution', mexext), '-begin');

results = runtests('tests/Main.m');
disp(results);