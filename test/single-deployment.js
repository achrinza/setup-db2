// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: Copyright (c) 2024 Rifa Achrinza
'use strict';

import * as assert from 'node:assert';
import {open} from 'ibm_db';

const DB2_DATABASE = 'mydb';
const DB2_UID = 'db2inst1';
const DB2_PASSWORD = 'password';

describe('start-db2.sh', function () {
  describe('single deployment', function () {
    var conn;

    before(function (done) {
      open(
        `DATABASE=${DB2_DATABASE};UID=${DB2_UID};PWD=${DB2_PASSWORD}`,
        function (err, data) {
          if (err) done(err);
          conn = data;
          done();
        },
      );
    });

    after(function (done) {
      conn.close(done);
    });

    it('can query sysibm.sysdummy1', function (done) {
      const expected = [{1: 1}];
      conn.query('SELECT 1 FROM sysibm.sysdummy1', (err, rows) => {
        if (err) done(err);
        assert.deepEqual(rows, expected);
        done();
      });
    });
  });
});
