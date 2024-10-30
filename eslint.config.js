// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: Copyright (c) 2024 Rifa Achrinza
'use strict';

import js from '@eslint/js';
import eslintPluginPrettierRecommended from 'eslint-plugin-prettier/recommended';
import globals from 'globals';
import mochaPlugin from 'eslint-plugin-mocha';

export default [
  js.configs.recommended,
  eslintPluginPrettierRecommended,
  mochaPlugin.configs.flat.recommended,
  {
    files: ['**/*.js'],
    languageOptions: {
      globals: globals.node,
    },
  },
];
