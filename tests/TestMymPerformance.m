classdef TestMymPerformance < matlab.perftest.TestCase
    % Performance tests for representative mym database transfers.

    properties (Access = private)
        Connection
        Database
        CreatedDatabase = false
    end

    methods (TestClassSetup)
        function prepareDatabase(testCase)
            host = getenv('DJ_TEST_HOST');
            user = getenv('DJ_TEST_USER');
            password = getenv('DJ_TEST_PASSWORD');
            assert(~isempty(host) && ~isempty(user), ...
                'Set DJ_TEST_HOST and DJ_TEST_USER before running performance tests.');

            testCase.Connection = mym(-1, 'open', host, user, password, 'false');
            testCase.Database = sprintf('djtest_perf_%d_%d', ...
                mod(floor(posixtime(datetime('now')) * 1e6), 1e9), randi(1e6));
            db = testCase.Database;
            mym(testCase.Connection, ['CREATE DATABASE `' db '`']);
            testCase.CreatedDatabase = true;
            mym(testCase.Connection, ['CREATE TABLE `' db '`.`transfer` ' ...
                '(id INT PRIMARY KEY, payload LONGBLOB NOT NULL)']);

            payload = uint8(mod(0:(1024 * 1024 - 1), 251));
            mym(testCase.Connection, ['INSERT INTO `' db '`.`transfer` ' ...
                '(`id`, `payload`) VALUES (1, "{B}")'], payload);
        end
    end

    methods (TestClassTeardown)
        function removeDatabase(testCase)
            if isempty(testCase.Connection)
                return
            end
            if testCase.CreatedDatabase
                mym(testCase.Connection, ...
                    ['DROP DATABASE IF EXISTS `' testCase.Database '`']);
            end
            mym(testCase.Connection, 'close');
        end
    end

    methods (Test)
        function measureQueryRoundTrip(testCase)
            while testCase.keepMeasuring
                result = mym(testCase.Connection, 'SELECT 1 AS value');
            end
            testCase.verifyEqual(result.value, 1);
        end

        function measureRowTransfer(testCase)
            db = testCase.Database;
            while testCase.keepMeasuring
                result = mym(testCase.Connection, ...
                    ['SELECT id FROM `' db '`.`transfer`']);
            end
            testCase.verifyEqual(result.id, 1);
        end

        function measureBlobTransfer(testCase)
            db = testCase.Database;
            while testCase.keepMeasuring
                result = mym(testCase.Connection, ...
                    ['SELECT payload FROM `' db '`.`transfer`']);
            end
            testCase.verifySize(result.payload{1}, [ 1024 * 1024, 1]);
        end
    end
end
