classdef Prep < matlab.unittest.TestCase
    % Setup and teardown for tests.
    properties (Constant)
        CONN_INFO = struct(...
            'host', getenv('DJ_TEST_HOST'), ...
            'user', getenv('DJ_TEST_USER'), ...
            'password', getenv('DJ_TEST_PASSWORD'));
        % Keep all test schemas within the permitted dj* namespace.
        PREFIX = 'djtest';
    end

    methods (TestClassSetup)
        function init(testCase)
            disp('---------------INIT---------------');
            clear functions;
            feature('DefaultCharacterSet','UTF-8');

            disp(mym('version'));
        end
    end
    methods (TestClassTeardown)
        function dispose(testCase)
            disp('---------------DISP---------------');          
            curr_conn = mym(-1, 'open', testCase.CONN_INFO.host, ...
                testCase.CONN_INFO.user, testCase.CONN_INFO.password, ...
                'false');

            mym(curr_conn, 'SET FOREIGN_KEY_CHECKS=0;');
            res = mym(curr_conn, ...
                ['SELECT CAST(schema_name AS char(50)) as db ' ...
                'FROM information_schema.schemata ' ...
                'where schema_name like "' testCase.PREFIX '_%";']);
            for i = 1:length(res.db)
                mym(curr_conn, ...
                    ['DROP DATABASE ' res.db{i} ';']);
            end
            mym(curr_conn, 'SET FOREIGN_KEY_CHECKS=1;');

            mym(curr_conn, 'close');
        end
    end
end
